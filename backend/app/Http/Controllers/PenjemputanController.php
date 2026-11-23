<?php

namespace App\Http\Controllers;

use App\Models\GajiKurir;
use App\Models\JenisSampah;
use App\Models\Penjemputan;
use App\Models\PenjemputanDetail;
use App\Models\Riwayat;
use App\Models\Transaksi;
use App\Models\User;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

/**
 * ALUR PENJEMPUTAN (satu sumber kebenaran: database)
 *
 *  Nasabah  : store()              -> DIAJUKAN
 *  Mitra    : tugaskanKurir()      -> DITERIMA        (kurir ditugaskan)
 *  Kurir    : updateStatus()       -> DALAM PROSES    (menuju lokasi)
 *  Kurir    : laporTimbangan()     -> DIJEMPUT        (sudah ditimbang, menunggu dibayar mitra)
 *  Mitra    : selesaiPenjemputan() -> SELESAI         (saldo nasabah bertambah)
 *  Nasabah  : beriPenilaian()      (hanya setelah SELESAI, sekali saja)
 *  Mitra    : bayarGajiKurir()     (Rp 15.000 per tugas SELESAI)
 */
class PenjemputanController extends Controller
{
    use ApiResponse;

    private const GAJI_PER_TUGAS = 15000;
    private const STATUS_AKTIF_KURIR = ['DITERIMA', 'DALAM PROSES', 'DIJEMPUT'];

    private function isMitra(User $u): bool
    {
        return in_array($u->role, ['mitra', 'admin'], true);
    }

    private function dengan(): array
    {
        return ['details.jenisSampah', 'user:id,nama,no_hp,alamat', 'kurir:id,nama,no_hp,kendaraan,plat_nomor'];
    }

    /** Boleh melihat order ini? (pemilik, kurir yang ditugaskan, mitra, admin) */
    private function bolehLihat(User $u, Penjemputan $p): bool
    {
        return $this->isMitra($u)
            || $p->user_id === $u->id
            || ($u->role === 'kurir' && $p->kurir_id === $u->id);
    }

    // 1. AJUKAN PENJEMPUTAN BARU (khusus nasabah)
    public function store(Request $request)
    {
        $user = $request->user();
        if ($user->role !== 'nasabah') {
            return $this->errorResponse('Hanya nasabah yang dapat mengajukan penjemputan', 403);
        }

        $validator = Validator::make($request->all(), [
            'tanggal' => 'required|date|after_or_equal:today',
            'sesi' => 'required|in:PAGI,SIANG,SORE',
            'lokasi' => 'required|string|max:255',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'catatan' => 'nullable|string',
            'items' => 'required|array|min:1',
            'items.*.jenis_sampah_id' => 'required|exists:jenis_sampahs,id',
            'items.*.berat_estimasi' => 'required|numeric|min:0.1',
        ]);

        if ($validator->fails()) {
            return $this->errorResponse('Validasi gagal', 422, $validator->errors());
        }

        try {
            $penjemputan = DB::transaction(function () use ($request, $user) {
                $penjemputan = Penjemputan::create([
                    'user_id' => $user->id,
                    'tanggal' => $request->tanggal,
                    'sesi' => $request->sesi,
                    'lokasi' => $request->lokasi,
                    'latitude' => $request->latitude,
                    'longitude' => $request->longitude,
                    'status' => 'DIAJUKAN',
                    'catatan' => $request->catatan,
                    'total_berat' => 0,
                    'total_harga' => 0,
                ]);

                $totalBerat = 0;
                $totalHarga = 0;

                foreach ($request->items as $item) {
                    $jenis = JenisSampah::find($item['jenis_sampah_id']);
                    $berat = (float) $item['berat_estimasi'];
                    $subtotal = $berat * $jenis->harga_per_kg;

                    PenjemputanDetail::create([
                        'penjemputan_id' => $penjemputan->id,
                        'jenis_sampah_id' => $jenis->id,
                        'berat_estimasi' => $berat,
                        'harga_per_kg' => $jenis->harga_per_kg,
                        'subtotal' => $subtotal,
                    ]);

                    $totalBerat += $berat;
                    $totalHarga += $subtotal;
                }

                $penjemputan->update(['total_berat' => $totalBerat, 'total_harga' => $totalHarga]);

                Riwayat::create([
                    'user_id' => $user->id,
                    'aktivitas' => 'Ajukan Penjemputan',
                    'referensi_type' => 'penjemputan',
                    'referensi_id' => $penjemputan->id,
                    'deskripsi' => 'Pengajuan jemput sampah ±' . $totalBerat . ' kg ke ' . $request->lokasi,
                ]);

                return $penjemputan->load($this->dengan());
            });

            return $this->successResponse($penjemputan, 'Penjemputan berhasil diajukan', 201);
        } catch (\Exception $e) {
            return $this->errorResponse('Gagal membuat penjemputan: ' . $e->getMessage(), 500);
        }
    }

    // 2. LIST PENJEMPUTAN — isi menyesuaikan role pemanggil
    //    nasabah: miliknya | kurir: yang ditugaskan padanya | mitra/admin: semua
    public function index(Request $request)
    {
        $user = $request->user();

        $query = Penjemputan::with($this->dengan())->orderBy('created_at', 'desc');

        if ($user->role === 'nasabah') {
            $query->where('user_id', $user->id);
        } elseif ($user->role === 'kurir') {
            $query->where('kurir_id', $user->id);
        }
        // mitra & admin: tanpa filter

        if ($request->filled('status')) {
            $query->whereIn('status', explode(',', $request->query('status')));
        }

        return $this->successResponse($query->get(), 'Daftar penjemputan berhasil diambil');
    }

    // 3. DETAIL PENJEMPUTAN
    public function show(Request $request, $id)
    {
        $penjemputan = Penjemputan::with($this->dengan())->find($id);

        if (!$penjemputan || !$this->bolehLihat($request->user(), $penjemputan)) {
            return $this->errorResponse('Penjemputan tidak ditemukan', 404);
        }

        return $this->successResponse($penjemputan, 'Detail penjemputan berhasil diambil');
    }

    // 4. UPDATE STATUS — kurir hanya boleh DITERIMA -> DALAM PROSES; mitra/admin bebas (kecuali loncat ke SELESAI)
    public function updateStatus(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'status' => 'required|in:DITERIMA,DALAM PROSES,DIJEMPUT,DIBATALKAN',
        ]);
        if ($validator->fails()) {
            return $this->errorResponse('Validasi gagal', 422, $validator->errors());
        }

        $user = $request->user();
        $penjemputan = Penjemputan::find($id);
        if (!$penjemputan || !$this->bolehLihat($user, $penjemputan)) {
            return $this->errorResponse('Penjemputan tidak ditemukan', 404);
        }

        if (in_array($penjemputan->status, ['SELESAI', 'DIBATALKAN'], true)) {
            return $this->errorResponse('Penjemputan sudah ' . $penjemputan->status . ', status tidak dapat diubah', 400);
        }

        if ($user->role === 'kurir') {
            if ($request->status !== 'DALAM PROSES' || $penjemputan->status !== 'DITERIMA') {
                return $this->errorResponse('Kurir hanya dapat memulai penjemputan yang sudah ditugaskan', 403);
            }
        } elseif ($user->role === 'nasabah') {
            return $this->errorResponse('Nasabah tidak dapat mengubah status. Gunakan fitur batal.', 403);
        }

        $penjemputan->update(['status' => $request->status]);

        return $this->successResponse($penjemputan->load($this->dengan()), 'Status berhasil diupdate');
    }

    // 5. BATALKAN PENJEMPUTAN (nasabah pemilik, selama masih DIAJUKAN)
    public function batal(Request $request, $id)
    {
        $penjemputan = Penjemputan::where('id', $id)->where('user_id', $request->user()->id)->first();

        if (!$penjemputan) {
            return $this->errorResponse('Penjemputan tidak ditemukan', 404);
        }
        if ($penjemputan->status !== 'DIAJUKAN') {
            return $this->errorResponse('Hanya penjemputan dengan status DIAJUKAN yang bisa dibatalkan', 400);
        }

        $penjemputan->update(['status' => 'DIBATALKAN']);

        return $this->successResponse($penjemputan, 'Penjemputan berhasil dibatalkan');
    }

    // 6. MITRA MENUGASKAN KURIR (DIAJUKAN -> DITERIMA)
    public function tugaskanKurir(Request $request, $id)
    {
        if (!$this->isMitra($request->user())) {
            return $this->errorResponse('Hanya mitra yang dapat menugaskan kurir', 403);
        }

        $validator = Validator::make($request->all(), [
            'kurir_id' => 'required|integer',
            'catatan' => 'nullable|string',
        ]);
        if ($validator->fails()) {
            return $this->errorResponse('Validasi gagal', 422, $validator->errors());
        }

        $kurir = User::where('id', $request->kurir_id)->where('role', 'kurir')->first();
        if (!$kurir) {
            return $this->errorResponse('Kurir tidak ditemukan', 404);
        }

        $penjemputan = Penjemputan::find($id);
        if (!$penjemputan) {
            return $this->errorResponse('Penjemputan tidak ditemukan', 404);
        }
        if ($penjemputan->status !== 'DIAJUKAN') {
            return $this->errorResponse('Hanya permintaan berstatus DIAJUKAN yang dapat ditugaskan', 400);
        }

        $penjemputan->update([
            'kurir_id' => $kurir->id,
            'status' => 'DITERIMA',
            'catatan' => $request->filled('catatan') ? $request->catatan : $penjemputan->catatan,
        ]);

        Riwayat::create([
            'user_id' => $penjemputan->user_id,
            'aktivitas' => 'Kurir Ditugaskan',
            'referensi_type' => 'penjemputan',
            'referensi_id' => $penjemputan->id,
            'deskripsi' => 'Permintaan jemput Anda diterima. Kurir ' . $kurir->nama . ' akan menjemput.',
        ]);

        return $this->successResponse($penjemputan->load($this->dengan()), 'Tugas penjemputan berhasil diteruskan ke kurir!');
    }

    // 7. KURIR MELAPORKAN HASIL TIMBANGAN (DITERIMA/DALAM PROSES -> DIJEMPUT)
    //    Jika 'items' dikirim ([{jenis_sampah_id, berat_aktual}]) total dihitung ulang oleh server
    //    memakai harga katalog; jika tidak, total dari klien dipakai dengan batas wajar.
    public function laporTimbangan(Request $request, $id)
    {
        $user = $request->user();
        // Kurir melaporkan tugasnya sendiri; mitra/admin boleh melaporkan atas nama kurir (mis. kurir tanpa HP)
        if (!in_array($user->role, ['kurir', 'mitra', 'admin'], true)) {
            return $this->errorResponse('Anda tidak berhak melaporkan timbangan', 403);
        }

        $validator = Validator::make($request->all(), [
            'total_berat' => 'required|numeric|min:0.1',
            'total_harga' => 'required|numeric|min:0',
            'items' => 'nullable|array',
        ]);
        if ($validator->fails()) {
            return $this->errorResponse('Validasi gagal', 422, $validator->errors());
        }

        $q = Penjemputan::where('id', $id);
        if ($user->role === 'kurir') {
            $q->where('kurir_id', $user->id);
        }
        $penjemputan = $q->first();
        if (!$penjemputan) {
            return $this->errorResponse('Penjemputan tidak ditemukan atau bukan tugas Anda', 404);
        }
        if (!in_array($penjemputan->status, ['DITERIMA', 'DALAM PROSES'], true)) {
            return $this->errorResponse('Timbangan hanya dapat dilaporkan untuk tugas yang sedang berjalan', 400);
        }

        $totalBerat = (float) $request->total_berat;
        $totalHarga = (float) $request->total_harga;

        try {
            DB::transaction(function () use ($request, $penjemputan, &$totalBerat, &$totalHarga) {
                $items = collect($request->input('items', []))
                    ->filter(fn ($i) => isset($i['jenis_sampah_id'], $i['berat_aktual']) && (float) $i['berat_aktual'] > 0);

                if ($items->isNotEmpty()) {
                    $totalBerat = 0;
                    $totalHarga = 0;
                    foreach ($items as $item) {
                        $jenis = JenisSampah::find($item['jenis_sampah_id']);
                        if (!$jenis) {
                            continue;
                        }
                        $berat = (float) $item['berat_aktual'];
                        $subtotal = $berat * $jenis->harga_per_kg;

                        PenjemputanDetail::updateOrCreate(
                            ['penjemputan_id' => $penjemputan->id, 'jenis_sampah_id' => $jenis->id],
                            ['berat_aktual' => $berat, 'harga_per_kg' => $jenis->harga_per_kg, 'subtotal' => $subtotal]
                        );
                        $totalBerat += $berat;
                        $totalHarga += $subtotal;
                    }
                } else {
                    // Batas wajar: nominal tidak boleh melebihi berat x harga katalog tertinggi
                    $hargaMax = (float) JenisSampah::max('harga_per_kg');
                    if ($hargaMax > 0 && $totalHarga > $totalBerat * $hargaMax) {
                        throw new \InvalidArgumentException('Total harga tidak wajar untuk berat yang dilaporkan');
                    }
                }

                $penjemputan->update([
                    'status' => 'DIJEMPUT',
                    'total_berat' => $totalBerat,
                    'total_harga' => $totalHarga,
                ]);
            });
        } catch (\InvalidArgumentException $e) {
            return $this->errorResponse($e->getMessage(), 422);
        }

        return $this->successResponse(
            $penjemputan->fresh($this->dengan()),
            'Hasil timbangan berhasil dilaporkan ke Mitra. Menunggu pembayaran dari Mitra.'
        );
    }

    // 8. MITRA MEMBAYAR NASABAH (DIJEMPUT -> SELESAI)
    //    Nominal & berat diambil dari data timbangan di database, BUKAN dari request,
    //    sehingga tidak bisa dimanipulasi dari klien. Idempoten: tidak bisa dibayar dua kali.
    public function selesaiPenjemputan(Request $request, $id)
    {
        if (!$this->isMitra($request->user())) {
            return $this->errorResponse('Hanya mitra yang dapat membayar nasabah', 403);
        }

        try {
            $hasil = DB::transaction(function () use ($id) {
                $penjemputan = Penjemputan::with('user')->lockForUpdate()->find($id);

                if (!$penjemputan) {
                    return ['error' => ['Penjemputan tidak ditemukan', 404]];
                }
                if ($penjemputan->status === 'SELESAI') {
                    return ['error' => ['Penjemputan ini sudah dibayar sebelumnya', 409]];
                }
                if ($penjemputan->status !== 'DIJEMPUT') {
                    return ['error' => ['Pembayaran hanya bisa dilakukan setelah kurir melaporkan timbangan', 400]];
                }

                $nasabah = $penjemputan->user;
                $totalSaldo = (float) $penjemputan->total_harga;
                $totalBerat = (float) $penjemputan->total_berat;
                $poin = (int) floor($totalSaldo / 1000);

                $nasabah->increment('saldo', $totalSaldo);
                $nasabah->increment('poin_hijau', $poin);
                $nasabah->increment('total_sampah', $totalBerat);

                Transaksi::create([
                    'user_id' => $nasabah->id,
                    'tipe' => 'masuk',
                    'nominal' => $totalSaldo,
                    'keterangan' => 'Hasil Jemput Sampah Terpilah (' . $totalBerat . ' kg)',
                    'referensi_type' => 'penjemputan',
                    'referensi_id' => $penjemputan->id,
                ]);

                Riwayat::create([
                    'user_id' => $nasabah->id,
                    'aktivitas' => 'Jemput Sampah Selesai',
                    'referensi_type' => 'penjemputan',
                    'referensi_id' => $penjemputan->id,
                    'deskripsi' => 'Penjemputan seberat ' . $totalBerat . ' kg selesai. Saldo Rp '
                        . number_format($totalSaldo, 0, ',', '.') . ' berhasil ditambahkan.',
                ]);

                $penjemputan->update(['status' => 'SELESAI', 'dibayar_at' => now()]);

                $nasabah->refresh();

                return ['ok' => [
                    'penjemputan_id' => $penjemputan->id,
                    'nasabah_id' => $nasabah->id,
                    'nasabah_nama' => $nasabah->nama,
                    'saldo_baru' => (float) $nasabah->saldo,
                    'poin_baru' => (int) $nasabah->poin_hijau,
                    'total_berat' => $totalBerat,
                    'total_saldo' => $totalSaldo,
                ]];
            });
        } catch (\Exception $e) {
            return $this->errorResponse('Gagal memproses pembayaran: ' . $e->getMessage(), 500);
        }

        if (isset($hasil['error'])) {
            return $this->errorResponse($hasil['error'][0], $hasil['error'][1]);
        }

        return $this->successResponse($hasil['ok'], 'Penjemputan selesai dan saldo berhasil dikirim ke dompet nasabah!');
    }

    // 9. NASABAH MEMBERI PENILAIAN KE KURIR (sekali per order, hanya setelah SELESAI)
    public function beriPenilaian(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'rating' => 'required|numeric|min:1|max:5',
            'ulasan' => 'nullable|string|max:500',
            'tags' => 'nullable|array',
        ]);
        if ($validator->fails()) {
            return $this->errorResponse('Validasi gagal', 422, $validator->errors());
        }

        $penjemputan = Penjemputan::with('kurir')
            ->where('id', $id)->where('user_id', $request->user()->id)->first();

        if (!$penjemputan) {
            return $this->errorResponse('Penjemputan tidak ditemukan', 404);
        }
        if ($penjemputan->status !== 'SELESAI') {
            return $this->errorResponse('Penilaian hanya bisa diberikan setelah penjemputan selesai', 400);
        }
        if ($penjemputan->rating !== null) {
            return $this->errorResponse('Penjemputan ini sudah Anda nilai', 409);
        }

        $rating = round((float) $request->rating, 1);
        $poinKurir = (int) round($rating * 10); // 5 bintang = +50 poin kinerja

        DB::transaction(function () use ($penjemputan, $request, $rating, $poinKurir) {
            $penjemputan->update(['rating' => $rating, 'ulasan' => $request->ulasan]);
            if ($penjemputan->kurir) {
                $penjemputan->kurir->increment('poin_hijau', $poinKurir);
            }
        });

        return $this->successResponse([
            'penjemputan_id' => $penjemputan->id,
            'rating' => $rating,
            'poin_diterima_kurir' => $poinKurir,
            'pesan' => 'Terima kasih atas penilaian Anda! Kurir mendapatkan +' . $poinKurir . ' poin kinerja.',
        ], 'Penilaian berhasil dikirim');
    }

    // 10. DAFTAR KURIR + PERFORMA + GAJI (untuk layar mitra)
    public function daftarKurir(Request $request)
    {
        $data = User::where('role', 'kurir')->orderBy('nama')->get()->map(function (User $k) {
            $selesai = Penjemputan::where('kurir_id', $k->id)->where('status', 'SELESAI');
            $tugasSelesai = (clone $selesai)->count();
            $totalKg = (float) (clone $selesai)->sum('total_berat');
            $ulasan = Penjemputan::where('kurir_id', $k->id)->whereNotNull('rating');
            $sedangJalan = Penjemputan::where('kurir_id', $k->id)
                ->whereIn('status', self::STATUS_AKTIF_KURIR)->exists();

            $gajiDibayar = (float) GajiKurir::where('kurir_id', $k->id)->sum('nominal');
            $gajiAkumulasi = max(0, $tugasSelesai * self::GAJI_PER_TUGAS - $gajiDibayar);

            return [
                'id' => $k->id,
                'nama' => $k->nama,
                'no_hp' => $k->no_hp,
                'armada' => 'ARM-' . str_pad((string) $k->id, 2, '0', STR_PAD_LEFT),
                'kendaraan' => trim(($k->kendaraan ?: 'Belum diisi') . ($k->plat_nomor ? " ({$k->plat_nomor})" : '')),
                'rating' => $ulasan->count() ? round((float) (clone $ulasan)->avg('rating'), 1) : 0,
                'total_ulasan' => $ulasan->count(),
                'poin_kinerja' => (int) $k->poin_hijau,
                'tugas_selesai' => $tugasSelesai,
                'total_kg' => $totalKg,
                'gaji_akumulasi' => (int) $gajiAkumulasi,
                'status' => $sedangJalan ? 'Sedang Menjemput' : 'Siap Ditugaskan',
                'status_gaji' => $gajiAkumulasi > 0 ? 'Siap Dicairkan' : 'Lunas Terbayar',
            ];
        })->values();

        return $this->successResponse($data, 'Daftar kurir berhasil diambil');
    }

    // 10b. MITRA MENDAFTARKAN AKUN KURIR BARU (kurir tidak mendaftar sendiri dari halaman register)
    public function tambahKurir(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nama' => 'required|string|max:100',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|string|min:6',
            'no_hp' => 'nullable|string|max:20',
            'kendaraan' => 'nullable|string|max:100',
            'plat_nomor' => 'nullable|string|max:20',
        ]);
        if ($validator->fails()) {
            return $this->errorResponse('Validasi gagal', 422, $validator->errors());
        }

        $username = \Illuminate\Support\Str::slug($request->nama, '') ?: 'kurir';
        while (User::where('username', $username)->exists()) {
            $username .= rand(10, 99);
        }

        $kurir = User::create([
            'nama' => $request->nama,
            'username' => $username,
            'email' => $request->email,
            'password' => $request->password, // di-hash otomatis oleh cast 'hashed'
            'role' => 'kurir',
            'saldo' => 0,
            'poin_hijau' => 0,
            'total_sampah' => 0,
            'no_hp' => $request->no_hp,
            'kendaraan' => $request->kendaraan,
            'plat_nomor' => $request->plat_nomor,
        ]);

        return $this->successResponse(
            ['id' => $kurir->id, 'nama' => $kurir->nama, 'email' => $kurir->email, 'username' => $kurir->username],
            'Akun kurir berhasil dibuat',
            201
        );
    }

    // 11. MITRA MEMBAYAR GAJI KURIR (nominal dibatasi sebesar gaji yang belum dibayar)
    public function bayarGajiKurir(Request $request)
    {
        $mitra = $request->user();
        if (!$this->isMitra($mitra)) {
            return $this->errorResponse('Hanya mitra yang dapat membayar gaji kurir', 403);
        }

        $validator = Validator::make($request->all(), [
            'kurir_id' => 'required|integer',
            'nominal' => 'required|numeric|min:1000',
            'periode' => 'nullable|string|max:50',
        ]);
        if ($validator->fails()) {
            return $this->errorResponse('Validasi gagal', 422, $validator->errors());
        }

        $kurir = User::where('id', $request->kurir_id)->where('role', 'kurir')->first();
        if (!$kurir) {
            return $this->errorResponse('Kurir tidak ditemukan', 404);
        }

        $nominal = (float) $request->nominal;

        $hasil = DB::transaction(function () use ($kurir, $mitra, $nominal, $request) {
            // kunci baris kurir agar dua pembayaran bersamaan tidak lolos
            $kurir = User::lockForUpdate()->find($kurir->id);

            $tugasSelesai = Penjemputan::where('kurir_id', $kurir->id)->where('status', 'SELESAI')->count();
            $gajiDibayar = (float) GajiKurir::where('kurir_id', $kurir->id)->sum('nominal');
            $terutang = $tugasSelesai * self::GAJI_PER_TUGAS - $gajiDibayar;

            if ($nominal > $terutang) {
                return ['error' => 'Nominal melebihi gaji yang belum dibayar (Rp ' . number_format(max(0, $terutang), 0, ',', '.') . ')'];
            }

            $gaji = GajiKurir::create([
                'kurir_id' => $kurir->id,
                'dibayar_oleh' => $mitra->id,
                'nominal' => $nominal,
                'periode' => $request->periode ?? 'Mingguan',
            ]);

            // Masuk ke saldo komisi kurir (yang bisa ditarik lewat /mitra/tarik-saldo)
            $kurir->increment('saldo', $nominal);

            Transaksi::create([
                'user_id' => $kurir->id,
                'tipe' => 'masuk',
                'nominal' => $nominal,
                'keterangan' => 'Gaji kurir periode ' . $gaji->periode,
                'referensi_type' => 'gaji_kurir',
                'referensi_id' => $gaji->id,
            ]);

            return ['gaji' => $gaji];
        });

        if (isset($hasil['error'])) {
            return $this->errorResponse($hasil['error'], 400);
        }

        return $this->successResponse([
            'kurir_id' => $kurir->id,
            'nominal' => $nominal,
            'periode' => $hasil['gaji']->periode,
            'status' => 'LUNAS',
            'tanggal_bayar' => $hasil['gaji']->created_at->toDateTimeString(),
        ], 'Gaji kurir armada berhasil dibayarkan oleh Mitra!');
    }
}

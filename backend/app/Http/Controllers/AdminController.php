<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\JenisSampah;
use App\Models\Penjemputan;
use App\Models\Transaksi;
use App\Models\Riwayat;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class AdminController extends Controller
{
    use ApiResponse;

    // 1. DASHBOARD RINGKASAN
    public function dashboard()
    {
        $totalTonaseKg = (float) (Penjemputan::where('status', 'SELESAI')->sum('total_berat') ?? 0);
        $totalTonaseTon = round($totalTonaseKg / 1000, 1);
        $totalOrderSelesai = Penjemputan::where('status', 'SELESAI')->count();
        $totalWargaAktif = User::where('role', 'nasabah')->count();
        $totalKurir = User::whereIn('role', ['kurir', 'mitra'])->count();

        $pendingCount = Transaksi::where('tipe', 'keluar')
            ->where('referensi_type', 'penarikan')
            ->where('status', 'PENDING')
            ->count();

        // Aktivitas 7 hari terakhir (kg sampah selesai per hari)
        $hari = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
        $weekly = [];
        for ($i = 6; $i >= 0; $i--) {
            $tgl = now()->subDays($i);
            $kg = (float) Penjemputan::where('status', 'SELESAI')
                ->whereDate('dibayar_at', $tgl->toDateString())
                ->sum('total_berat');
            $weekly[] = ['day' => $hari[$tgl->dayOfWeek], 'value' => $kg];
        }
        $max = collect($weekly)->max('value');
        foreach ($weekly as &$w) {
            $w['peak'] = $max > 0 && $w['value'] === $max;
        }
        unset($w);

        return $this->successResponse([
            'metrics' => [
                'total_sampah' => "{$totalTonaseTon} Ton",
                'total_sampah_kg' => $totalTonaseKg,
                'order_selesai' => $totalOrderSelesai,
                'nasabah_aktif' => $totalWargaAktif,
                'kurir_armada' => $totalKurir,
            ],
            'pending_penarikan_count' => $pendingCount,
            'weekly_activity' => $weekly,
        ], 'Data ringkasan admin berhasil dimuat');
    }

    // 2. KATALOG & HARGA SAMPAH
    public function sampah()
    {
        $sampah = JenisSampah::all();
        return $this->successResponse($sampah, 'Data katalog harga berhasil diambil');
    }

    public function updateSampah(Request $request, $id)
    {
        $sampah = JenisSampah::find($id);
        if (!$sampah) {
            return $this->errorResponse('Jenis sampah tidak ditemukan', 404);
        }

        $validator = Validator::make($request->all(), [
            'harga_per_kg' => 'required|numeric|min:0',
        ]);

        if ($validator->fails()) {
            return $this->errorResponse('Validasi gagal', 422, $validator->errors());
        }

        $sampah->update([
            'harga_per_kg' => $request->harga_per_kg,
        ]);

        return $this->successResponse($sampah, "Harga {$sampah->nama} berhasil diperbarui");
    }

    public function batchUpdateSampah(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'items' => 'required|array|min:1',
            'items.*.id' => 'required|integer',
            'items.*.harga_per_kg' => 'required|numeric|min:0',
        ]);
        if ($validator->fails()) {
            return $this->errorResponse('Validasi gagal', 422, $validator->errors());
        }

        $items = $request->input('items', []);
        foreach ($items as $item) {
            if (isset($item['id']) && isset($item['harga_per_kg'])) {
                JenisSampah::where('id', $item['id'])->update([
                    'harga_per_kg' => $item['harga_per_kg'],
                ]);
            }
        }
        return $this->successResponse(null, 'Seluruh harga katalog berhasil disinkronisasi & diterbitkan!');
    }

    // 3. KEUANGAN & PENARIKAN SALDO
    public function penarikan()
    {
        $base = fn () => Transaksi::with('user:id,nama,no_hp,email')
            ->where('tipe', 'keluar')
            ->where('referensi_type', 'penarikan');

        $pending = $base()->where('status', 'PENDING')->orderBy('created_at', 'asc')->get();
        $riwayat = $base()->whereIn('status', ['DISETUJUI', 'DITOLAK', 'SELESAI'])
            ->orderBy('updated_at', 'desc')->limit(30)->get();

        $totalCairHariIni = (float) Transaksi::where('tipe', 'keluar')
            ->where('referensi_type', 'penarikan')
            ->whereIn('status', ['DISETUJUI', 'SELESAI'])
            ->whereDate('updated_at', today())
            ->sum('nominal');

        return $this->successResponse([
            'total_cair_hari_ini' => $totalCairHariIni,
            'rekening_escrow' => 'Bank Mandiri Giro Escrow',
            'pending_requests' => $pending,
            'riwayat_requests' => $riwayat,
        ], 'Data antrean verifikasi saldo berhasil diambil');
    }

    public function approvePenarikan(Request $request, $id)
    {
        $hasil = DB::transaction(function () use ($id) {
            $trx = Transaksi::lockForUpdate()->find($id);

            if (!$trx || $trx->referensi_type !== 'penarikan') {
                return ['error' => ['Data penarikan tidak ditemukan', 404]];
            }
            if ($trx->status !== 'PENDING') {
                return ['error' => ['Penarikan ini sudah diproses (' . $trx->status . ')', 409]];
            }

            $trx->update(['status' => 'DISETUJUI']);

            Riwayat::create([
                'user_id' => $trx->user_id,
                'aktivitas' => 'Penarikan Disetujui',
                'referensi_type' => 'penarikan',
                'referensi_id' => $trx->id,
                'deskripsi' => 'Penarikan Rp ' . number_format($trx->nominal, 0, ',', '.') . ' telah disetujui dan ditransfer.',
            ]);

            return ['ok' => $trx];
        });

        if (isset($hasil['error'])) {
            return $this->errorResponse($hasil['error'][0], $hasil['error'][1]);
        }

        return $this->successResponse($hasil['ok'], 'Penarikan dana berhasil disetujui & ditransfer.');
    }

    public function rejectPenarikan(Request $request, $id)
    {
        $hasil = DB::transaction(function () use ($id) {
            $trx = Transaksi::lockForUpdate()->find($id);

            if (!$trx || $trx->referensi_type !== 'penarikan') {
                return ['error' => ['Data penarikan tidak ditemukan', 404]];
            }
            // Mencegah saldo dikembalikan berkali-kali / setelah disetujui
            if ($trx->status !== 'PENDING') {
                return ['error' => ['Penarikan ini sudah diproses (' . $trx->status . ')', 409]];
            }

            $trx->update(['status' => 'DITOLAK']);
            User::where('id', $trx->user_id)->increment('saldo', $trx->nominal);

            Riwayat::create([
                'user_id' => $trx->user_id,
                'aktivitas' => 'Penarikan Ditolak',
                'referensi_type' => 'penarikan',
                'referensi_id' => $trx->id,
                'deskripsi' => 'Penarikan Rp ' . number_format($trx->nominal, 0, ',', '.') . ' ditolak. Saldo dikembalikan.',
            ]);

            return ['ok' => $trx];
        });

        if (isset($hasil['error'])) {
            return $this->errorResponse($hasil['error'][0], $hasil['error'][1]);
        }

        return $this->successResponse($hasil['ok'], 'Penarikan dana ditolak dan saldo telah dikembalikan ke nasabah.');
    }

    // 4. MANAJEMEN PENGGUNA
    public function users(Request $request)
    {
        $query = User::query();

        if ($request->filled('role')) {
            $query->where('role', $request->role);
        }

        if ($request->filled('search')) {
            $search = trim($request->search);
            $query->where(function ($q) use ($search) {
                $q->where('nama', 'like', "%{$search}%")
                  ->orWhere('email', 'like', "%{$search}%")
                  ->orWhere('no_hp', 'like', "%{$search}%");
            });
        }

        $users = $query->orderBy('created_at', 'desc')
            ->get(['id', 'nama', 'username', 'email', 'no_hp', 'role', 'saldo', 'poin_hijau', 'total_sampah', 'created_at']);
        return $this->successResponse($users, 'Data pengguna berhasil diambil');
    }
}

<?php

namespace App\Http\Controllers;

use App\Models\Penjemputan;
use App\Models\Transaksi;
use App\Models\Riwayat;
use App\Models\SetoranSampah;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class DashboardController extends Controller
{
    use ApiResponse;

    // 1. DASHBOARD (Ringkasan Beranda)
    public function index(Request $request)
    {
        $user = $request->user();

        // Hitung jumlah penjemputan berdasarkan status
        $totalPenjemputan = Penjemputan::where('user_id', $user->id)->count();
        $penjemputanAktif = Penjemputan::where('user_id', $user->id)
            ->whereIn('status', ['DIAJUKAN', 'DITERIMA', 'DALAM PROSES', 'DIJEMPUT'])
            ->count();
        $penjemputanSelesai = Penjemputan::where('user_id', $user->id)
            ->where('status', 'SELESAI')
            ->count();

        // Hitung total transaksi
        $totalTransaksiMasuk = Transaksi::where('user_id', $user->id)
            ->where('tipe', 'masuk')
            ->sum('nominal');
        $totalTransaksiKeluar = Transaksi::where('user_id', $user->id)
            ->where('tipe', 'keluar')
            ->sum('nominal');

        // Hitung total sampah terkumpul
        $totalSampahSetoran = SetoranSampah::where('user_id', $user->id)->sum('berat') ?? 0;
        $totalSampahJemput = Penjemputan::where('user_id', $user->id)
            ->where('status', 'SELESAI')
            ->sum('total_berat') ?? 0;
        $totalSampah = max((float) ($user->total_sampah ?? 0), (float) ($totalSampahSetoran + $totalSampahJemput));

        $totalSetoran = SetoranSampah::where('user_id', $user->id)->count() + $penjemputanSelesai;

        return $this->successResponse([
            // Top-level keys untuk fleksibilitas mobile client
            'saldo' => (float) $user->saldo,
            'poin' => (int) $user->poin_hijau,
            'total_sampah' => (float) $totalSampah,
            'user' => [
                'id' => $user->id,
                'nama' => $user->nama,
                'username' => $user->username,
                'email' => $user->email,
                'no_hp' => $user->no_hp,
                'alamat' => $user->alamat,
                'saldo' => (float) $user->saldo,
                'poin_hijau' => (int) $user->poin_hijau,
                'total_sampah' => (float) $totalSampah,
            ],
            'statistik' => [
                'total_penjemputan' => $totalPenjemputan,
                'penjemputan_aktif' => $penjemputanAktif,
                'penjemputan_selesai' => $penjemputanSelesai,
                'total_setoran' => $totalSetoran,
                'total_transaksi_masuk' => $totalTransaksiMasuk,
                'total_transaksi_keluar' => $totalTransaksiKeluar,
                'total_sampah' => (float) $totalSampah,
            ],
        ], 'Data dashboard berhasil diambil');
    }

    // 2. RIWAYAT AKTIVITAS
    public function aktivitas(Request $request)
    {
        $user = $request->user();

        $riwayat = Riwayat::where('user_id', $user->id)
            ->orderBy('created_at', 'desc')
            ->limit(20)
            ->get();

        return $this->successResponse($riwayat, 'Riwayat aktivitas berhasil diambil');
    }

    // 3. INFO SALDO + RIWAYAT TRANSAKSI
    public function saldo(Request $request)
    {
        $user = $request->user();

        $transaksi = Transaksi::where('user_id', $user->id)
            ->orderBy('created_at', 'desc')
            ->limit(50)
            ->get();

        return $this->successResponse([
            'saldo' => (float) $user->saldo,
            'poin_hijau' => (int) $user->poin_hijau,
            'transaksi' => $transaksi,
        ], 'Info saldo berhasil diambil');
    }

    // 4. PENARIKAN SALDO (TARIK SALDO)
    public function tarikSaldo(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nominal' => 'required|numeric|min:10000',
            'metode' => 'required|string|max:100',
            'catatan' => 'nullable|string|max:255',
        ]);

        if ($validator->fails()) {
            return $this->errorResponse('Validasi gagal', 422, $validator->errors());
        }

        $user = $request->user();
        $nominal = (float) $request->nominal;

        try {
            $cukup = DB::transaction(function () use ($user, $nominal, $request) {
                // Kunci baris user agar dua penarikan bersamaan tidak membuat saldo minus
                $fresh = \App\Models\User::lockForUpdate()->find($user->id);
                if ((float) $fresh->saldo < $nominal) {
                    return false;
                }

                // Kurangi saldo
                $fresh->decrement('saldo', $nominal);

                // Catat transaksi keluar — menunggu verifikasi admin
                Transaksi::create([
                    'user_id' => $user->id,
                    'tipe' => 'keluar',
                    'nominal' => $nominal,
                    'keterangan' => "Penarikan Saldo via {$request->metode}",
                    'referensi_type' => 'penarikan',
                    'referensi_id' => null,
                    'status' => 'PENDING',
                ]);

                // Catat riwayat aktivitas
                Riwayat::create([
                    'user_id' => $user->id,
                    'aktivitas' => 'Penarikan Saldo',
                    'referensi_type' => 'penarikan',
                    'referensi_id' => null,
                    'deskripsi' => "Penarikan saldo sebesar Rp " . number_format($nominal, 0, ',', '.') . " melalui {$request->metode}",
                ]);

                return true;
            });

            if (!$cukup) {
                return $this->errorResponse('Saldo tidak mencukupi untuk melakukan penarikan', 400);
            }

            $user->refresh();

            return $this->successResponse([
                'saldo' => (float) $user->saldo,
                'poin_hijau' => (int) $user->poin_hijau,
            ], 'Penarikan saldo berhasil diproses');
        } catch (\Exception $e) {
            return $this->errorResponse('Gagal melakukan penarikan saldo: ' . $e->getMessage(), 500);
        }
    }

    // 5. DASHBOARD KHUSUS MITRA / KURIR (data nyata dari database)
    public function mitraDashboard(Request $request)
    {
        $user = $request->user();
        $isKurir = $user->role === 'kurir';

        // Kurir melihat tugasnya sendiri; mitra/admin melihat seluruh operasional
        $orders = Penjemputan::query();
        if ($isKurir) {
            $orders->where('kurir_id', $user->id);
        }

        $selesai = (clone $orders)->where('status', 'SELESAI');
        $totalSelesai = (clone $selesai)->count();
        $totalKg = (float) (clone $selesai)->sum('total_berat');

        $hariIniSelesai = (clone $selesai)->whereDate('dibayar_at', today())->count();
        $hariIniTotal = (clone $orders)->whereDate('tanggal', today())->count();

        $pendapatanHariIni = (float) Transaksi::where('user_id', $user->id)
            ->where('tipe', 'masuk')->whereDate('created_at', today())->sum('nominal');
        $komisiBulanIni = (float) Transaksi::where('user_id', $user->id)
            ->where('tipe', 'masuk')->whereMonth('created_at', now()->month)
            ->whereYear('created_at', now()->year)->sum('nominal');

        $rating = Penjemputan::where('kurir_id', $user->id)->whereNotNull('rating');
        $saldo = (float) $user->saldo;

        return $this->successResponse([
            'user' => [
                'id' => $user->id,
                'nama' => $user->nama,
                'username' => $user->username,
                'email' => $user->email,
                'no_hp' => $user->no_hp,
                'role' => $user->role,
                'foto_profil' => $user->foto_profil ?? '',
                'saldo' => $saldo,
            ],
            'mitra' => [
                'id_armada' => 'ARM-' . str_pad((string) $user->id, 2, '0', STR_PAD_LEFT) . ' Ternate',
                'rating' => $rating->count() ? round((float) $rating->avg('rating'), 1) : 0,
                'total_ulasan' => $rating->count(),
                'status_online' => true,
                'kendaraan' => $user->kendaraan ?: 'Belum diisi',
                'plat_nomor' => $user->plat_nomor ?: '-',
                'kapasitas_maks' => '80 Kg',
                'timbangan' => [
                    'nama' => 'Timbangan Gantung Digital SC-04',
                    'terhubung' => true,
                    'baterai' => 98,
                    'kalibrasi' => 'Otomatis Aktif',
                ],
                'target_harian' => [
                    'selesai' => $hariIniSelesai,
                    'total' => $hariIniTotal,
                ],
                'pendapatan' => [
                    'hari_ini' => $pendapatanHariIni,
                    'bonus' => 0,
                    'saldo_siap_tarik' => $saldo,
                ],
                'statistik_bulanan' => [
                    'total_selesai' => $totalSelesai,
                    'total_kg' => $totalKg,
                    'total_komisi' => $komisiBulanIni,
                ],
                // permintaan yang menunggu tindakan (badge di layar mitra)
                'antrean' => [
                    'menunggu_penugasan' => $isKurir ? 0 : Penjemputan::where('status', 'DIAJUKAN')->count(),
                    'menunggu_pembayaran' => $isKurir ? 0 : Penjemputan::where('status', 'DIJEMPUT')->count(),
                    'tugas_aktif' => $isKurir
                        ? Penjemputan::where('kurir_id', $user->id)->whereIn('status', ['DITERIMA', 'DALAM PROSES'])->count()
                        : 0,
                ],
            ],
        ], 'Data dashboard mitra berhasil diambil');
    }

    // 6. PENARIKAN KOMISI / GAJI (kurir & mitra) — hanya dari saldo yang benar-benar ada
    public function tarikSaldoMitra(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nominal' => 'required|numeric|min:10000',
            'metode' => 'required|string',
            'nomor_tujuan' => 'required|string',
        ]);

        if ($validator->fails()) {
            return $this->errorResponse('Validasi gagal', 422, $validator->errors());
        }

        $nominal = (float) $request->nominal;

        $sisa = DB::transaction(function () use ($request, $nominal) {
            $user = \App\Models\User::lockForUpdate()->find($request->user()->id);

            if ((float) $user->saldo < $nominal) {
                return null;
            }

            $user->decrement('saldo', $nominal);

            Transaksi::create([
                'user_id' => $user->id,
                'tipe' => 'keluar',
                'nominal' => $nominal,
                'keterangan' => "Penarikan Komisi Kurir via {$request->metode} ({$request->nomor_tujuan})",
                'referensi_type' => 'penarikan_komisi',
                'referensi_id' => null,
            ]);

            Riwayat::create([
                'user_id' => $user->id,
                'aktivitas' => 'Tarik Komisi Kurir',
                'referensi_type' => 'penarikan_komisi',
                'referensi_id' => null,
                'deskripsi' => "Penarikan komisi Rp " . number_format($nominal, 0, ',', '.') . " ke {$request->metode} ({$request->nomor_tujuan})",
            ]);

            return (float) $user->fresh()->saldo;
        });

        if ($sisa === null) {
            return $this->errorResponse('Saldo komisi tidak mencukupi', 400);
        }

        return $this->successResponse([
            'sisa_saldo' => $sisa,
            'nominal_ditarik' => $nominal,
            'metode' => $request->metode,
            'nomor_tujuan' => $request->nomor_tujuan,
        ], 'Pencairan komisi kurir berhasil diproses!');
    }
}

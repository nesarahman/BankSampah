<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Transaksi;
use App\Models\Riwayat;
use App\Models\JenisSampah;
use App\Models\DropPoint;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // Nonaktifkan foreign key checks untuk truncate aman
        DB::statement('SET FOREIGN_KEY_CHECKS=0;');
        User::truncate(); 
        Transaksi::truncate();
        Riwayat::truncate();
        JenisSampah::truncate();
        DropPoint::truncate();
        DB::statement('SET FOREIGN_KEY_CHECKS=1;');

        // 1. Jenis Sampah
        $sampah1 = JenisSampah::create([
            'nama' => 'Kertas & Karton',
            'kategori' => 'Kertas',
            'harga_per_kg' => 3000,
            'deskripsi' => 'Kardus cokelat, kertas HVS, koran, dan majalah dalam kondisi kering.',
        ]);

        $sampah2 = JenisSampah::create([
            'nama' => 'Plastik Daur Ulang',
            'kategori' => 'Plastik',
            'harga_per_kg' => 4200,
            'deskripsi' => 'Botol PET bening, gelas plastik PP, jerigen HDPE bersih tanpa cairan.',
        ]);

        $sampah3 = JenisSampah::create([
            'nama' => 'Logam & Kaleng',
            'kategori' => 'Logam',
            'harga_per_kg' => 7500,
            'deskripsi' => 'Kaleng minuman aluminium, besi scrap, tembaga, dan seng.',
        ]);

        $sampah4 = JenisSampah::create([
            'nama' => 'Minyak Jelantah (UCO)',
            'kategori' => 'Organik',
            'harga_per_kg' => 6500,
            'deskripsi' => 'Minyak goreng bekas dalam wadah/jerigen tertutup tanpa endapan air/bumbu.',
        ]);

        // 2. Drop Point Bank Sampah
        DropPoint::create([
            'nama' => 'Bank Sampah Jati Metro',
            'alamat' => 'Jl. Jati Lurus No. 88, Ternate Selatan',
            'latitude' => 0.7712000,
            'longitude' => 127.3789000,
            'jam_buka' => '08:00:00',
            'jam_tutup' => '17:00:00',
            'kontak' => '081234567891',
        ]);

        DropPoint::create([
            'nama' => 'REGREEN Eco Hub Kalumata',
            'alamat' => 'Jl. Revolusi No. 42, Kalumata, Ternate Selatan',
            'latitude' => 0.7654000,
            'longitude' => 127.3654000,
            'jam_buka' => '08:00:00',
            'jam_tutup' => '17:00:00',
            'kontak' => '081234567892',
        ]);

        DropPoint::create([
            'nama' => 'Bank Sampah Gamalama',
            'alamat' => 'Area Pusat Pasar Gamalama, Ternate Tengah',
            'latitude' => 0.7891000,
            'longitude' => 127.3821000,
            'jam_buka' => '09:00:00',
            'jam_tutup' => '16:00:00',
            'kontak' => '081234567893',
        ]);

        // 3. User Nasabah Utama (Untuk Presentasi / Demo)
        $user1 = User::create([
            'nama' => 'Rizky Pratama',
            'username' => 'rizkypratama',
            'email' => 'nesa@regreen.com',
            'password' => Hash::make('password123'),
            'role' => 'nasabah',
            'saldo' => 348500,
            'poin_hijau' => 1420,
            'total_sampah' => 124.5,
            'no_hp' => '081234567890',
            'alamat' => 'Jl. Merdeka No. 45, Ternate',
        ]);

        Transaksi::create([
            'user_id' => $user1->id,
            'tipe' => 'masuk',
            'nominal' => 348500,
            'keterangan' => 'Setoran Sampah Terpilah',
            'referensi_type' => 'setoran',
            'referensi_id' => null,
        ]);

        Riwayat::create([
            'user_id' => $user1->id,
            'aktivitas' => 'Setor Sampah',
            'referensi_type' => 'setoran',
            'referensi_id' => null,
            'deskripsi' => 'Setor sampah terpilah seberat 124.5 kg ke Drop Point Ternate',
        ]);

        // 4. User Nasabah Baru (Saldo 0 untuk uji coba)
        User::create([
            'nama' => 'User Baru',
            'username' => 'userbaru',
            'email' => 'baru@regreen.com',
            'password' => Hash::make('password123'),
            'role' => 'nasabah',
            'saldo' => 0,
            'poin_hijau' => 0,
            'total_sampah' => 0,
            'no_hp' => '089876543210',
            'alamat' => 'Jl. Revolusi No. 12, Ternate',
        ]);

        // 5. Mitra (pengelola bank sampah) — menerima permintaan, menugaskan kurir, membayar nasabah & gaji kurir
        User::create([
            'nama' => 'Mitra Bank Sampah Makugasa',
            'username' => 'mitramakugasa',
            'email' => 'mitra@regreen.com',
            'password' => Hash::make('password123'),
            'role' => 'mitra',
            'saldo' => 0,
            'poin_hijau' => 0,
            'total_sampah' => 0,
            'no_hp' => '081245966300',
            'alamat' => 'Kel. Kayu Merah, Ternate',
        ]);

        // 6. Kurir (armada penjemputan) — hanya mengerjakan tugas yang ditugaskan mitra
        $kurirDemo = [
            ['Ahmad Fauzi', 'ahmadkurir', 'kurir@regreen.com', '081245966332', 'Honda Supra X 125 Box', 'DG 4582 KT'],
            ['Rizal Umar', 'rizalkurir', 'kurir2@regreen.com', '081245966333', 'Roda Tiga Viar Kargo', 'DG 3190 KB'],
            ['Fikram Hasan', 'fikramkurir', 'kurir3@regreen.com', '081245966334', 'Yamaha Jupiter MX Box', 'DG 5512 KC'],
        ];
        foreach ($kurirDemo as [$nama, $username, $email, $hp, $kendaraan, $plat]) {
            User::create([
                'nama' => $nama,
                'username' => $username,
                'email' => $email,
                'password' => Hash::make('password123'),
                'role' => 'kurir',
                'saldo' => 0,
                'poin_hijau' => 0,
                'total_sampah' => 0,
                'no_hp' => $hp,
                'alamat' => 'Ternate',
                'kendaraan' => $kendaraan,
                'plat_nomor' => $plat,
            ]);
        }
    }
}

# Perubahan REGREEN — alur Nasabah -> Mitra -> Kurir (tahap 1)

Salin isi folder `backend/` dan `mobile/lib/` ke proyek masing-masing (timpa file yang sama).

## Backend (Laravel)
1. `php artisan migrate`   (migrasi baru: role `mitra`, tabel `gaji_kurirs`, kolom rating/status penarikan/kendaraan)
2. Akun lama role `kurir` yang sebenarnya pemilik bank sampah: ubah jadi mitra
   `php artisan tinker` -> `User::where('email','EMAIL_ANDA')->update(['role'=>'mitra']);`
   (JANGAN pakai `db:seed` bila admin sudah dibuat lewat tinker: seeder memang menghapus tabel users)
3. Cek rute: `php artisan route:list --path=api`

## Mobile (Flutter)
`flutter pub get` lalu jalankan ulang (hot restart). Tidak ada paket baru.

## Alur & role
- nasabah : ajukan jemput, nilai kurir, tarik saldo
- mitra   : lihat permintaan, tugaskan kurir, bayar nasabah, bayar gaji kurir, daftarkan kurir (POST /mitra/kurir)
- kurir   : lihat tugas miliknya, mulai jemput, laporkan timbangan
- admin   : dashboard, katalog harga, setujui/tolak penarikan, daftar pengguna

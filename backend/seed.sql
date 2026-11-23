-- =====================================================================
--  REGREEN - Data awal (demo). Semua password akun: password123
--  Jalankan SETELAH schema.sql
-- =====================================================================
USE regreen_banksampah;
-- Bersihkan data lama (urutan anak -> induk agar tidak melanggar relasi)
DELETE FROM gaji_kurirs;
DELETE FROM riwayats;
DELETE FROM transaksis;
DELETE FROM setoran_sampahs;
DELETE FROM penjemputan_details;
DELETE FROM penjemputans;
DELETE FROM drop_points;
DELETE FROM jenis_sampahs;
DELETE FROM users;

-- Users: 1 admin, 1 mitra, 3 kurir, 2 nasabah
INSERT INTO users (id,nama,username,email,password,role,saldo,poin_hijau,total_sampah,no_hp,alamat,kendaraan,plat_nomor,created_at,updated_at) VALUES
(1,'Administrator REGREEN','admin','admin@regreen.com','$2y$12$5hZDTt7QmdF9cWHgZgtVBevfyEvbT7KY1qwqFknbbPNHcq/MLN0mu','admin',0,0,0,'081200000000','Ternate',NULL,NULL,NOW(),NOW()),
(2,'Mitra Bank Sampah Makugasa','mitramakugasa','mitra@regreen.com','$2y$12$5hZDTt7QmdF9cWHgZgtVBevfyEvbT7KY1qwqFknbbPNHcq/MLN0mu','mitra',0,0,0,'081245966300','Kel. Kayu Merah, Ternate',NULL,NULL,NOW(),NOW()),
(3,'Ahmad Fauzi','ahmadkurir','kurir@regreen.com','$2y$12$5hZDTt7QmdF9cWHgZgtVBevfyEvbT7KY1qwqFknbbPNHcq/MLN0mu','kurir',0,0,0,'081245966332','Ternate','Honda Supra X 125 Box','DG 4582 KT',NOW(),NOW()),
(4,'Rizal Umar','rizalkurir','kurir2@regreen.com','$2y$12$5hZDTt7QmdF9cWHgZgtVBevfyEvbT7KY1qwqFknbbPNHcq/MLN0mu','kurir',0,0,0,'081245966333','Ternate','Roda Tiga Viar Kargo','DG 3190 KB',NOW(),NOW()),
(5,'Fikram Hasan','fikramkurir','kurir3@regreen.com','$2y$12$5hZDTt7QmdF9cWHgZgtVBevfyEvbT7KY1qwqFknbbPNHcq/MLN0mu','kurir',0,0,0,'081245966334','Ternate','Yamaha Jupiter MX Box','DG 5512 KC',NOW(),NOW()),
(6,'Rizky Pratama','rizkypratama','nesa@regreen.com','$2y$12$5hZDTt7QmdF9cWHgZgtVBevfyEvbT7KY1qwqFknbbPNHcq/MLN0mu','nasabah',348500,1420,124.50,'081234567890','Jl. Merdeka No. 45, Ternate',NULL,NULL,NOW(),NOW()),
(7,'User Baru','userbaru','baru@regreen.com','$2y$12$5hZDTt7QmdF9cWHgZgtVBevfyEvbT7KY1qwqFknbbPNHcq/MLN0mu','nasabah',0,0,0,'089876543210','Jl. Revolusi No. 12, Ternate',NULL,NULL,NOW(),NOW());

INSERT INTO jenis_sampahs (id,nama,kategori,harga_per_kg,deskripsi,created_at,updated_at) VALUES
(1,'Kertas & Karton','Kertas',3000,'Kardus cokelat, kertas HVS, koran, dan majalah dalam kondisi kering.',NOW(),NOW()),
(2,'Plastik Daur Ulang','Plastik',4200,'Botol PET bening, gelas plastik PP, jerigen HDPE bersih tanpa cairan.',NOW(),NOW()),
(3,'Logam & Kaleng','Logam',7500,'Kaleng minuman aluminium, besi scrap, tembaga, dan seng.',NOW(),NOW()),
(4,'Minyak Jelantah (UCO)','Organik',6500,'Minyak goreng bekas dalam wadah/jerigen tertutup tanpa endapan air/bumbu.',NOW(),NOW());

INSERT INTO drop_points (id,mitra_id,nama,alamat,latitude,longitude,jam_buka,jam_tutup,kontak,created_at,updated_at) VALUES
(1,2,'Bank Sampah Jati Metro','Jl. Jati Lurus No. 88, Ternate Selatan',0.7712000,127.3789000,'08:00:00','17:00:00','081234567891',NOW(),NOW()),
(2,2,'REGREEN Eco Hub Kalumata','Jl. Revolusi No. 42, Kalumata, Ternate Selatan',0.7654000,127.3654000,'08:00:00','17:00:00','081234567892',NOW(),NOW()),
(3,2,'Bank Sampah Gamalama','Area Pusat Pasar Gamalama, Ternate Tengah',0.7891000,127.3821000,'09:00:00','16:00:00','081234567893',NOW(),NOW());

-- Contoh alur penjemputan lengkap (nasabah 6 -> mitra 2 -> kurir 3)
INSERT INTO penjemputans (id,user_id,kurir_id,tanggal,sesi,lokasi,status,total_berat,total_harga,catatan,rating,ulasan,dibayar_at,created_at,updated_at) VALUES
(1,6,3,CURDATE(),'Pagi (08:00-11:00)','Jl. Merdeka No. 45, Ternate','SELESAI',8.00,31200,'Sampah sudah dipilah',4.5,'Kurir ramah dan tepat waktu',NOW(),NOW(),NOW()),
(2,7,NULL,CURDATE(),'Siang (13:00-15:00)','Jl. Revolusi No. 12, Ternate','DIAJUKAN',0,0,NULL,NULL,NULL,NULL,NOW(),NOW());

INSERT INTO penjemputan_details (penjemputan_id,jenis_sampah_id,berat_estimasi,berat_aktual,harga_per_kg,subtotal,created_at,updated_at) VALUES
(1,1,3.00,3.00,3000,9000,NOW(),NOW()),
(1,2,5.00,5.00,4200,21000,NOW(),NOW()),
(2,3,2.00,NULL,7500,0,NOW(),NOW());

INSERT INTO setoran_sampahs (user_id,drop_point_id,jenis_sampah_id,berat,harga_per_kg,subtotal,status,created_at,updated_at) VALUES
(6,1,3,10.00,7500,75000,'SELESAI',NOW(),NOW());

INSERT INTO transaksis (user_id,tipe,nominal,keterangan,referensi_type,referensi_id,status,created_at,updated_at) VALUES
(6,'masuk',31200,'Pembayaran penjemputan #1','penjemputan',1,'SELESAI',NOW(),NOW()),
(6,'masuk',75000,'Setoran Sampah Terpilah','setoran',1,'SELESAI',NOW(),NOW()),
(6,'keluar',50000,'Penarikan saldo','penarikan',NULL,'PENDING',NOW(),NOW());

INSERT INTO riwayats (user_id,aktivitas,referensi_type,referensi_id,deskripsi,created_at,updated_at) VALUES
(6,'Ajukan Penjemputan','penjemputan',1,'Mengajukan penjemputan sampah',NOW(),NOW()),
(6,'Setor Sampah','setoran',1,'Setor 10 kg logam ke Bank Sampah Jati Metro',NOW(),NOW()),
(7,'Ajukan Penjemputan','penjemputan',2,'Mengajukan penjemputan sampah',NOW(),NOW());

INSERT INTO gaji_kurirs (kurir_id,dibayar_oleh,nominal,periode,created_at,updated_at) VALUES
(3,2,350000,'Mingguan',NOW(),NOW());

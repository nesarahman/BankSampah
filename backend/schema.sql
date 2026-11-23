-- =====================================================================
--  REGREEN - Bank Sampah  |  Skema Database (MySQL / MariaDB)
--  Peran (users.role): nasabah | mitra (pemilik bank sampah) | kurir | admin
--  Disusun mengikuti migrasi Laravel di backend/database/migrations
-- =====================================================================

CREATE DATABASE IF NOT EXISTS regreen_banksampah
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE regreen_banksampah;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS gaji_kurirs, riwayats, transaksis, setoran_sampahs,
  penjemputan_details, penjemputans, drop_points, jenis_sampahs,
  personal_access_tokens, password_reset_tokens, sessions, users;
SET FOREIGN_KEY_CHECKS = 1;

-- ---------------------------------------------------------------------
-- 1. USERS  (nasabah, mitra, kurir, admin dalam satu tabel, dibedakan role)
-- ---------------------------------------------------------------------
CREATE TABLE users (
  id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nama           VARCHAR(255) NOT NULL,
  username       VARCHAR(255) NOT NULL,
  email          VARCHAR(255) NOT NULL,
  password       VARCHAR(255) NOT NULL,
  role           ENUM('nasabah','kurir','mitra','admin') NOT NULL DEFAULT 'nasabah',
  saldo          DECIMAL(12,2) NOT NULL DEFAULT 0,      -- saldo rupiah
  poin_hijau     INT NOT NULL DEFAULT 0,
  total_sampah   DECIMAL(10,2) NOT NULL DEFAULT 0,      -- total kg yang pernah disetor (nasabah)
  login_attempts INT NOT NULL DEFAULT 0,                -- kunci akun 5 menit setelah 3x gagal
  locked_until   TIMESTAMP NULL,
  no_hp          VARCHAR(255) NULL,
  alamat         TEXT NULL,
  foto_profil    VARCHAR(255) NULL,
  kendaraan      VARCHAR(255) NULL,                     -- khusus kurir
  plat_nomor     VARCHAR(255) NULL,                     -- khusus kurir
  google_id      VARCHAR(255) NULL,
  remember_token VARCHAR(100) NULL,
  created_at     TIMESTAMP NULL,
  updated_at     TIMESTAMP NULL,
  PRIMARY KEY (id),
  UNIQUE KEY users_username_unique (username),
  UNIQUE KEY users_email_unique (email),
  UNIQUE KEY users_google_id_unique (google_id),
  KEY users_role_index (role)
) ENGINE=InnoDB;

CREATE TABLE password_reset_tokens (
  email      VARCHAR(255) NOT NULL,
  token      VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NULL,
  PRIMARY KEY (email)
) ENGINE=InnoDB;

CREATE TABLE sessions (
  id            VARCHAR(255) NOT NULL,
  user_id       BIGINT UNSIGNED NULL,
  ip_address    VARCHAR(45) NULL,
  user_agent    TEXT NULL,
  payload       LONGTEXT NOT NULL,
  last_activity INT NOT NULL,
  PRIMARY KEY (id),
  KEY sessions_user_id_index (user_id),
  KEY sessions_last_activity_index (last_activity)
) ENGINE=InnoDB;

CREATE TABLE personal_access_tokens (      -- token login Laravel Sanctum
  id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  tokenable_type VARCHAR(255) NOT NULL,
  tokenable_id   BIGINT UNSIGNED NOT NULL,
  name           TEXT NOT NULL,
  token          VARCHAR(64) NOT NULL,
  abilities      TEXT NULL,
  last_used_at   TIMESTAMP NULL,
  expires_at     TIMESTAMP NULL,
  created_at     TIMESTAMP NULL,
  updated_at     TIMESTAMP NULL,
  PRIMARY KEY (id),
  UNIQUE KEY personal_access_tokens_token_unique (token),
  KEY personal_access_tokens_tokenable_index (tokenable_type, tokenable_id),
  KEY personal_access_tokens_expires_at_index (expires_at)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 2. MASTER DATA
-- ---------------------------------------------------------------------
CREATE TABLE jenis_sampahs (
  id           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nama         VARCHAR(255) NOT NULL,
  kategori     VARCHAR(255) NOT NULL,
  harga_per_kg DECIMAL(10,2) NOT NULL,        -- diatur admin
  deskripsi    TEXT NULL,
  created_at   TIMESTAMP NULL,
  updated_at   TIMESTAMP NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE drop_points (
  id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  mitra_id   BIGINT UNSIGNED NULL,             -- TAMBAHAN: pemilik bank sampah (users.role = mitra)
  nama       VARCHAR(255) NOT NULL,
  alamat     TEXT NOT NULL,
  latitude   DECIMAL(10,7) NOT NULL,
  longitude  DECIMAL(10,7) NOT NULL,
  jam_buka   TIME NOT NULL,
  jam_tutup  TIME NOT NULL,
  kontak     VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  PRIMARY KEY (id),
  CONSTRAINT drop_points_mitra_fk FOREIGN KEY (mitra_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 3. PENJEMPUTAN  (nasabah mengajukan -> mitra menugaskan kurir -> kurir
--    menjemput & menimbang -> mitra membayar nasabah -> nasabah menilai)
-- ---------------------------------------------------------------------
CREATE TABLE penjemputans (
  id           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id      BIGINT UNSIGNED NOT NULL,       -- nasabah pemohon
  kurir_id     BIGINT UNSIGNED NULL,           -- kurir yang ditugaskan mitra
  tanggal      DATE NOT NULL,
  sesi         VARCHAR(255) NOT NULL,
  lokasi       VARCHAR(255) NOT NULL,
  latitude     DECIMAL(10,7) NULL,
  longitude    DECIMAL(10,7) NULL,
  status       ENUM('DIAJUKAN','DITERIMA','DALAM PROSES','DIJEMPUT','SELESAI','DIBATALKAN') NOT NULL DEFAULT 'DIAJUKAN',
  total_berat  DECIMAL(8,2) NOT NULL DEFAULT 0,
  total_harga  DECIMAL(12,2) NOT NULL DEFAULT 0,
  catatan      TEXT NULL,
  rating       DECIMAL(2,1) NULL,              -- penilaian nasabah ke kurir
  ulasan       TEXT NULL,
  dibayar_at   TIMESTAMP NULL,
  created_at   TIMESTAMP NULL,
  updated_at   TIMESTAMP NULL,
  PRIMARY KEY (id),
  KEY penjemputans_status_index (status),
  CONSTRAINT penjemputans_user_fk  FOREIGN KEY (user_id)  REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT penjemputans_kurir_fk FOREIGN KEY (kurir_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE penjemputan_details (
  id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  penjemputan_id  BIGINT UNSIGNED NOT NULL,
  jenis_sampah_id BIGINT UNSIGNED NOT NULL,
  berat_estimasi  DECIMAL(8,2) NOT NULL DEFAULT 0,
  berat_aktual    DECIMAL(8,2) NULL,           -- hasil timbangan kurir
  harga_per_kg    DECIMAL(10,2) NOT NULL DEFAULT 0,
  subtotal        DECIMAL(12,2) NOT NULL DEFAULT 0,
  created_at      TIMESTAMP NULL,
  updated_at      TIMESTAMP NULL,
  PRIMARY KEY (id),
  CONSTRAINT pjd_penjemputan_fk FOREIGN KEY (penjemputan_id)  REFERENCES penjemputans(id)  ON DELETE CASCADE,
  CONSTRAINT pjd_jenis_fk       FOREIGN KEY (jenis_sampah_id) REFERENCES jenis_sampahs(id)  ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 4. SETORAN LANGSUNG KE DROP POINT
-- ---------------------------------------------------------------------
CREATE TABLE setoran_sampahs (
  id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id         BIGINT UNSIGNED NOT NULL,    -- nasabah
  drop_point_id   BIGINT UNSIGNED NOT NULL,
  jenis_sampah_id BIGINT UNSIGNED NOT NULL,
  berat           DECIMAL(8,2) NOT NULL,
  harga_per_kg    DECIMAL(10,2) NOT NULL,
  subtotal        DECIMAL(12,2) NOT NULL,
  status          ENUM('PENDING','SELESAI') NOT NULL DEFAULT 'PENDING',
  created_at      TIMESTAMP NULL,
  updated_at      TIMESTAMP NULL,
  PRIMARY KEY (id),
  CONSTRAINT setoran_user_fk  FOREIGN KEY (user_id)         REFERENCES users(id)         ON DELETE CASCADE,
  CONSTRAINT setoran_dp_fk    FOREIGN KEY (drop_point_id)   REFERENCES drop_points(id)   ON DELETE CASCADE,
  CONSTRAINT setoran_jenis_fk FOREIGN KEY (jenis_sampah_id) REFERENCES jenis_sampahs(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 5. KEUANGAN & LOG
-- ---------------------------------------------------------------------
CREATE TABLE transaksis (                     -- mutasi saldo & penarikan (disetujui admin)
  id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id        BIGINT UNSIGNED NOT NULL,
  tipe           ENUM('masuk','keluar') NOT NULL,
  nominal        DECIMAL(12,2) NOT NULL,
  keterangan     VARCHAR(255) NOT NULL,
  referensi_type VARCHAR(255) NULL,            -- 'penjemputan' | 'setoran' | 'penarikan' ...
  referensi_id   BIGINT UNSIGNED NULL,
  status         VARCHAR(20) NOT NULL DEFAULT 'SELESAI',   -- PENDING | DISETUJUI | DITOLAK | SELESAI
  created_at     TIMESTAMP NULL,
  updated_at     TIMESTAMP NULL,
  PRIMARY KEY (id),
  KEY transaksis_status_index (status),
  CONSTRAINT transaksis_user_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE riwayats (                       -- log aktivitas pengguna
  id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id        BIGINT UNSIGNED NOT NULL,
  aktivitas      VARCHAR(255) NOT NULL,
  referensi_type VARCHAR(255) NULL,
  referensi_id   BIGINT UNSIGNED NULL,
  deskripsi      TEXT NULL,
  created_at     TIMESTAMP NULL,
  updated_at     TIMESTAMP NULL,
  PRIMARY KEY (id),
  CONSTRAINT riwayats_user_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE gaji_kurirs (                    -- gaji kurir dibayar oleh mitra
  id           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  kurir_id     BIGINT UNSIGNED NOT NULL,
  dibayar_oleh BIGINT UNSIGNED NULL,          -- mitra
  nominal      DECIMAL(12,2) NOT NULL,
  periode      VARCHAR(255) NOT NULL DEFAULT 'Mingguan',
  created_at   TIMESTAMP NULL,
  updated_at   TIMESTAMP NULL,
  PRIMARY KEY (id),
  CONSTRAINT gaji_kurir_fk   FOREIGN KEY (kurir_id)     REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT gaji_pembayar_fk FOREIGN KEY (dibayar_oleh) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 6. VIEW BANTU (opsional, untuk laporan per peran)
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_nasabah AS
  SELECT id, nama, username, email, no_hp, alamat, saldo, poin_hijau, total_sampah, created_at
  FROM users WHERE role = 'nasabah';

CREATE OR REPLACE VIEW v_mitra AS
  SELECT id, nama, username, email, no_hp, alamat, created_at
  FROM users WHERE role = 'mitra';

CREATE OR REPLACE VIEW v_kurir AS
  SELECT u.id, u.nama, u.username, u.email, u.no_hp, u.kendaraan, u.plat_nomor,
         COUNT(p.id) AS total_tugas,
         SUM(p.status = 'SELESAI') AS tugas_selesai,
         ROUND(AVG(p.rating), 1) AS rata_rating
  FROM users u LEFT JOIN penjemputans p ON p.kurir_id = u.id
  WHERE u.role = 'kurir' GROUP BY u.id;

CREATE OR REPLACE VIEW v_penjemputan_lengkap AS
  SELECT p.id, p.tanggal, p.sesi, p.status, p.total_berat, p.total_harga, p.rating,
         n.nama AS nasabah, k.nama AS kurir, p.lokasi
  FROM penjemputans p
  JOIN users n ON n.id = p.user_id
  LEFT JOIN users k ON k.id = p.kurir_id;

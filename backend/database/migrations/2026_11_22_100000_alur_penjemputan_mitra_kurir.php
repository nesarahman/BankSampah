<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // 1. Role baru: 'mitra' (pemilik/pengelola bank sampah). 'kurir' tetap armada penjemput.
        if (DB::getDriverName() === 'mysql') {
            DB::statement("ALTER TABLE users MODIFY role ENUM('nasabah','kurir','mitra','admin') NOT NULL DEFAULT 'nasabah'");
        }

        // 2. Data armada kurir
        Schema::table('users', function (Blueprint $table) {
            $table->string('kendaraan')->nullable()->after('foto_profil');
            $table->string('plat_nomor')->nullable()->after('kendaraan');
        });

        // 3. Penilaian nasabah ke kurir disimpan di penjemputan (1 order = 1 penilaian)
        Schema::table('penjemputans', function (Blueprint $table) {
            $table->decimal('rating', 2, 1)->nullable()->after('catatan');
            $table->text('ulasan')->nullable()->after('rating');
            $table->timestamp('dibayar_at')->nullable()->after('ulasan');
        });

        // 4. Status penarikan saldo (PENDING -> DISETUJUI / DITOLAK). Data lama dianggap SELESAI.
        Schema::table('transaksis', function (Blueprint $table) {
            $table->string('status', 20)->default('SELESAI')->after('referensi_id');
        });

        // 5. Pembayaran gaji kurir oleh mitra
        Schema::create('gaji_kurirs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('kurir_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('dibayar_oleh')->nullable()->constrained('users')->onDelete('set null');
            $table->decimal('nominal', 12, 2);
            $table->string('periode')->default('Mingguan');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('gaji_kurirs');

        Schema::table('transaksis', function (Blueprint $table) {
            $table->dropColumn('status');
        });
        Schema::table('penjemputans', function (Blueprint $table) {
            $table->dropColumn(['rating', 'ulasan', 'dibayar_at']);
        });
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn(['kendaraan', 'plat_nomor']);
        });

        if (DB::getDriverName() === 'mysql') {
            DB::statement("UPDATE users SET role = 'kurir' WHERE role = 'mitra'");
            DB::statement("ALTER TABLE users MODIFY role ENUM('nasabah','kurir','admin') NOT NULL DEFAULT 'nasabah'");
        }
    }
};

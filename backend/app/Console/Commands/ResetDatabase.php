<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\Artisan;
use PDO;

class ResetDatabase extends Command
{
    protected $signature = 'regreen:reset-db';
    protected $description = 'Reset dan perbaiki database db_regreen dari error 1932 table engine';

    public function handle()
    {
        $host = config('database.connections.mysql.host', '127.0.0.1');
        $port = config('database.connections.mysql.port', '3306');
        $username = config('database.connections.mysql.username', 'root');
        $password = config('database.connections.mysql.password', '');
        $database = config('database.connections.mysql.database', 'db_regreen');

        $this->info("1. Menghubungkan ke MySQL di $host:$port...");
        try {
            $pdo = new PDO("mysql:host=$host;port=$port", $username, $password, [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            ]);

            $this->info("2. Menghapus database lama yang korup ($database)...");
            $pdo->exec("DROP DATABASE IF EXISTS `$database`");

            $this->info("3. Membuat database baru yang bersih ($database)...");
            $pdo->exec("CREATE DATABASE `$database` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");

            $this->info("Database $database berhasil dibuat ulang dan bersih!");
        } catch (\Exception $e) {
            $this->error("Gagal terhubung atau mereset database: " . $e->getMessage());
            return 1;
        }

        $this->info("4. Menjalankan migrasi tabel...");
        $exitCode = Artisan::call('migrate', ['--force' => true]);
        $this->line(Artisan::output());

        if ($exitCode !== 0) {
            $this->error("Migrasi gagal.");
            return 1;
        }

        $this->info("5. Mengisi data awal (seeder)...");
        Artisan::call('db:seed', ['--force' => true]);
        $this->line(Artisan::output());

        $this->info("SELESAI! Database db_regreen siap digunakan tanpa error.");
        return 0;
    }
}

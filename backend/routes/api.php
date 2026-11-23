<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\SampahController;
use App\Http\Controllers\DropPointController;
use App\Http\Controllers\PenjemputanController;
use App\Http\Controllers\SetoranController;
use App\Http\Controllers\AdminController;

// PUBLIC ROUTES
Route::post('/register', [AuthController::class, 'register'])->name('register');
Route::post('/login', [AuthController::class, 'login'])->name('login');
Route::post('/auth/google', [AuthController::class, 'googleLogin'])->name('auth.google');

Route::get('/sampah', [SampahController::class, 'index']);
Route::get('/sampah/{id}', [SampahController::class, 'show']);
Route::get('/drop-points', [DropPointController::class, 'index']);
Route::get('/drop-points/{id}', [DropPointController::class, 'show']);

// PROTECTED ROUTES
Route::middleware('auth:sanctum')->group(function () {
    // Auth
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/profile', [AuthController::class, 'profile']);
    Route::put('/profile', [AuthController::class, 'updateProfile']);
    
    // Dashboard
    Route::get('/dashboard', [DashboardController::class, 'index']);
    Route::get('/aktivitas', [DashboardController::class, 'aktivitas']);
    Route::get('/saldo', [DashboardController::class, 'saldo']);
    Route::post('/saldo/tarik', [DashboardController::class, 'tarikSaldo']);
    Route::middleware('role:kurir,mitra,admin')->group(function () {
        Route::get('/mitra/dashboard', [DashboardController::class, 'mitraDashboard']);
    });
    Route::middleware('role:kurir,mitra')->group(function () {
        Route::post('/mitra/tarik-saldo', [DashboardController::class, 'tarikSaldoMitra']);
    });

    // Penjemputan (Alur Nasabah -> Mitra -> Kurir)
    Route::post('/penjemputan', [PenjemputanController::class, 'store']);
    Route::get('/penjemputan', [PenjemputanController::class, 'index']);
    Route::get('/penjemputan/{id}', [PenjemputanController::class, 'show']);
    Route::put('/penjemputan/{id}/status', [PenjemputanController::class, 'updateStatus']);
    Route::post('/penjemputan/{id}/tugaskan-kurir', [PenjemputanController::class, 'tugaskanKurir']);
    Route::post('/penjemputan/{id}/lapor-timbangan', [PenjemputanController::class, 'laporTimbangan']);
    Route::post('/penjemputan/{id}/selesai', [PenjemputanController::class, 'selesaiPenjemputan']);
    Route::post('/penjemputan/{id}/bayar-nasabah', [PenjemputanController::class, 'selesaiPenjemputan']);
    Route::post('/penjemputan/{id}/beri-penilaian', [PenjemputanController::class, 'beriPenilaian']);
    Route::put('/penjemputan/{id}/batal', [PenjemputanController::class, 'batal']);
    // Khusus mitra (pengelola bank sampah) & admin
    Route::middleware('role:mitra,admin')->group(function () {
        Route::get('/mitra/kurir', [PenjemputanController::class, 'daftarKurir']);
        Route::post('/mitra/kurir', [PenjemputanController::class, 'tambahKurir']);
        Route::post('/mitra/bayar-gaji-kurir', [PenjemputanController::class, 'bayarGajiKurir']);
    });

    // SETORAN
    Route::post('/setoran', [SetoranController::class, 'store'])->middleware('role:mitra,admin');
    Route::get('/setoran', [SetoranController::class, 'index']);

    // ADMIN ROUTES (Protected by auth:sanctum + admin middleware)
    Route::middleware('admin')->prefix('admin')->group(function () {
        Route::get('/dashboard', [AdminController::class, 'dashboard']);
        Route::get('/sampah', [AdminController::class, 'sampah']);
        Route::put('/sampah/{id}', [AdminController::class, 'updateSampah']);
        Route::post('/sampah/batch-update', [AdminController::class, 'batchUpdateSampah']);
        Route::get('/penarikan', [AdminController::class, 'penarikan']);
        Route::post('/penarikan/{id}/approve', [AdminController::class, 'approvePenarikan']);
        Route::post('/penarikan/{id}/reject', [AdminController::class, 'rejectPenarikan']);
        Route::get('/users', [AdminController::class, 'users']);
    });
});
<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    use ApiResponse;

    // 1. REGISTER
    public function register(Request $request)
    {
        // Trim string inputs sebelum validasi
        $request->merge([
            'nama' => $request->filled('nama') ? trim($request->nama) : null,
            'username' => $request->filled('username') ? trim($request->username) : null,
            'email' => $request->filled('email') ? strtolower(trim($request->email)) : null,
            'no_hp' => $request->filled('no_hp') ? trim($request->no_hp) : null,
        ]);

        $validator = Validator::make($request->all(), [
            'nama' => 'required|string|max:255',
            'username' => 'nullable|string|max:50|unique:users,username',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|string|min:6',
            'no_hp' => 'required|string|max:20|unique:users,no_hp',
        ], [
            'nama.required' => 'Nama lengkap wajib diisi.',
            'email.required' => 'Email wajib diisi.',
            'email.email' => 'Format email tidak valid.',
            'email.unique' => 'Email ini sudah terdaftar. Silakan gunakan email lain atau login.',
            'username.unique' => 'Username ini sudah digunakan. Silakan pilih username lain.',
            'password.required' => 'Kata sandi wajib diisi.',
            'password.min' => 'Kata sandi minimal 6 karakter.',
            'no_hp.required' => 'Nomor HP/WhatsApp wajib diisi.',
            'no_hp.unique' => 'Nomor HP/WhatsApp ini sudah terdaftar. Silakan gunakan nomor lain atau login.',
        ]);

        if ($validator->fails()) {
            return $this->errorResponse('Validasi gagal', 422, $validator->errors());
        }

        // Gunakan username yang dikirim dari Flutter, atau generate dari nama depan email
        $usernameName = $request->filled('username') ? $request->username : explode('@', $request->email)[0];

        // Pastikan unik jika generated otomatis
        if (User::where('username', $usernameName)->exists()) {
            $usernameName = $usernameName . '_' . rand(100, 999);
        }

        // Hanya izinkan nasabah, kurir, dan mitra. Admin TIDAK BISA didaftarkan dari sini!
        $userRole = in_array($request->role, ['nasabah', 'kurir', 'mitra'], true)
            ? $request->role
            : 'nasabah';

        $user = User::create([
            'nama' => $request->nama,
            'username' => $usernameName,
            'email' => $request->email,
            'password' => $request->password, // Otomatis di-hash oleh cast 'password' => 'hashed' di User model
            'role' => $userRole,
            'saldo' => 0,
            'poin_hijau' => 0,
            'total_sampah' => 0,
            'no_hp' => $request->no_hp,
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return $this->successResponse([
            'user' => $user,
            'token' => $token,
        ], 'Registrasi berhasil', 201);
    }

    // 2. LOGIN (Mendukung Email, Username, atau Nomor WhatsApp / HP)
    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|string',
            'password' => 'required|string',
        ], [
            'email.required' => 'Email atau Nomor WhatsApp wajib diisi.',
            'password.required' => 'Kata sandi wajib diisi.',
        ]);

        if ($validator->fails()) {
            return $this->errorResponse('Validasi gagal', 422, $validator->errors());
        }

        // Trim input agar tidak gagal karena spasi di awal/akhir
        $loginInput = trim($request->email);

        // Cari berdasarkan Email, Username, ATAU Nomor HP
        $user = User::where('email', $loginInput)
            ->orWhere('username', $loginInput)
            ->orWhere('no_hp', $loginInput)
            ->first();

        // Cek apakah user ada
        if (!$user) {
            return $this->errorResponse('Email, username, atau nomor HP tidak terdaftar', 401);
        }

        // Cek apakah akun sedang terkunci karena 3x gagal password
        if ($user->isLocked()) {
            $minutesLeft = max(1, (int) ceil(now()->diffInSeconds($user->locked_until) / 60));
            return $this->errorResponse(
                "Akun terkunci sementara karena 3 kali salah kata sandi. Silakan coba lagi dalam {$minutesLeft} menit atau gunakan Lupa Kata Sandi.",
                429
            );
        }

        // Cek apakah akun terdaftar via Google dan mencoba login manual
        if (!empty($user->google_id) && !Hash::check($request->password, $user->password)) {
            return $this->errorResponse(
                'Akun ini terdaftar lewat Google. Silakan masuk menggunakan tombol "Masuk dengan Google".',
                401
            );
        }

        // Cek password
        if (!Hash::check($request->password, $user->password)) {
            $user->incrementLoginAttempts(); 
            $user->refresh(); 
            
            $remainingAttempts = max(0, 3 - $user->login_attempts);
            
            if ($user->login_attempts >= 3) {
                return $this->errorResponse(
                    'Akun terkunci 5 menit karena 3 kali salah kata sandi. Silakan gunakan Lupa Kata Sandi.',
                    429
                );
            }

            return $this->errorResponse(
                "Kata sandi salah. Sisa percobaan: {$remainingAttempts}",
                401
            );
        }

        // Login Berhasil -> Reset counter percobaan
        $user->resetLoginAttempts();
        $token = $user->createToken('auth_token')->plainTextToken;

        return $this->successResponse([
            'user' => $user,
            'token' => $token,
        ], 'Login berhasil');
    }

    // 3. LOGOUT
    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();
        return $this->successResponse(null, 'Logout berhasil');
    }

    // 4. GET PROFILE
    public function profile(Request $request)
    {
        return $this->successResponse($request->user(), 'Data profil berhasil diambil');
    }

    // 5. UPDATE PROFILE
    public function updateProfile(Request $request)
    {
        $user = $request->user();

        $validator = Validator::make($request->all(), [
            'nama' => 'sometimes|string|max:255',
            'username' => 'sometimes|string|max:50|unique:users,username,' . $user->id,
            'no_hp' => 'nullable|string|max:20',
            'alamat' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return $this->errorResponse('Validasi gagal', 422, $validator->errors());
        }

        $user->update($request->only(['nama', 'username', 'no_hp', 'alamat']));
        return $this->successResponse($user, 'Profil berhasil diupdate');
    }

    // 6. LOGIN / REGISTER DENGAN GOOGLE
    public function googleLogin(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'nama' => 'required|string|max:255',
            'foto_profil' => 'nullable|string',
            'google_id' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return $this->errorResponse('Data Google tidak valid', 422, $validator->errors());
        }

        // Cek apakah user dengan email ini sudah ada di database
        $user = User::where('email', $request->email)->first();

        if ($user) {
            // Jika sudah ada, update foto profil atau google_id jika belum ada
            if ($request->filled('foto_profil')) {
                $user->foto_profil = $request->foto_profil;
            }
            if ($request->filled('google_id')) {
                $user->google_id = $request->google_id;
            }
            $user->save();
        } else {
            // Jika akun belum pernah ada, buat baru otomatis dari profil Google
            $baseUsername = explode('@', $request->email)[0];
            $username = $baseUsername;
            if (User::where('username', $username)->exists()) {
                $username = $baseUsername . '_' . rand(100, 999);
            }

            $user = User::create([
                'nama' => $request->nama,
                'username' => $username,
                'email' => $request->email,
                'password' => Hash::make(\Illuminate\Support\Str::random(24)),
                'role' => 'nasabah',
                'saldo' => 0,
                'poin_hijau' => 0,
                'total_sampah' => 0,
                'foto_profil' => $request->foto_profil,
                'google_id' => $request->google_id ?? ('google_' . uniqid()),
            ]);
        }

        // Reset login counter
        $user->resetLoginAttempts();

        // Buat token autentikasi Sanctum
        $token = $user->createToken('google_token')->plainTextToken;

        return $this->successResponse([
            'user' => $user,
            'token' => $token,
        ], 'Login dengan Google berhasil');
    }
}
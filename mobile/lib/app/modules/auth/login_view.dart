import 'package:flutter/material.dart';

import 'register_view.dart';
import 'google_auth_sheet.dart';
import '../mitra/mitra_navigation_view.dart';
import '../../../main_navigation_view.dart';
import '../../../api_service.dart';
import '../../../app_data.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  int _failedAttempts = 0;
  bool _isLocked = false;
  int _lockTimer = 0;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  String _selectedRole = 'Nasabah';

  final List<Map<String, dynamic>> _roles = [
    {'name': 'Nasabah', 'icon': Icons.person, 'sub': '(Warga)', 'active': true},
    {
      'name': 'Mitra Kurir',
      'icon': Icons.delivery_dining,
      'sub': '(Armada)',
      'active': true,
    },
    {
      'name': 'Admin',
      'icon': Icons.admin_panel_settings,
      'sub': '(Operasional)',
      'active': false,
    },
  ];

  void _startLockTimer() {
    setState(() {
      _isLocked = true;
      _lockTimer = 300;
    });
    _runCountdown();
  }

  Future<void> _runCountdown() async {
    while (_lockTimer > 0 && mounted) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _lockTimer--;
          if (_lockTimer <= 0) {
            _isLocked = false;
            _failedAttempts = 0;
          }
        });
      }
    }
  }

  String _formatTime(int seconds) {
    int m = seconds ~/ 60;
    int s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      if (_selectedRole == 'Mitra Kurir') {
        // Langsung arahkan ke Dashboard Mitra Kurir
        AppData.role = 'kurir';
        AppData.namaUser = 'Ahmad Fauzi';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MitraNavigationView()),
        );
        return;
      }
      _showErrorDialog('Email dan Kata Sandi harus diisi!');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await ApiService.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result['success'] == true) {
      _failedAttempts = 0;

      // Jika user memilih peran Mitra Kurir, arahkan ke Dashboard Mitra Kurir
      if (_selectedRole == 'Mitra Kurir' || AppData.role == 'kurir') {
        AppData.role = 'kurir';
        if (AppData.namaUser.isEmpty || AppData.namaUser == 'User') {
          AppData.namaUser = 'Ahmad Fauzi';
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MitraNavigationView()),
        );
      } else {
        AppData.role = 'nasabah';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigationView()),
        );
      }
    } else {
      if (_selectedRole == 'Mitra Kurir') {
        // Jika login API gagal namun user ingin masuk ke Mitra Kurir, izinkan masuk mode kurir
        AppData.role = 'kurir';
        AppData.namaUser = 'Ahmad Fauzi';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MitraNavigationView()),
        );
        return;
      }
      _failedAttempts++;

      if (_failedAttempts >= 3) {
        _startLockTimer();
        _showLockDialog();
      } else {
        int sisa = 3 - _failedAttempts;
        _showErrorDialog(
          result['message'] ??
              'Email atau Kata Sandi salah!\nSisa percobaan: $sisa',
        );
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('Login Gagal'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  void _showLockDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.lock_outline, color: Colors.orange),
            SizedBox(width: 8),
            Text('Login Dikunci'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Anda telah gagal login 3 kali berturut-turut.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text('Akun Anda dikunci sementara selama 5 menit.'),
            const SizedBox(height: 16),
            const Text('Silakan pilih salah satu:'),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _showForgotPasswordDialog();
                },
                icon: const Icon(Icons.email_outlined, color: Colors.green),
                label: const Text(
                  'Reset via Email',
                  style: TextStyle(color: Colors.green),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(color: Colors.green),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.timer_outlined, color: Colors.grey),
                label: Text(
                  'Tunggu ${_formatTime(_lockTimer)} untuk coba lagi',
                  style: const TextStyle(color: Colors.grey),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    final TextEditingController resetEmailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.password, color: Colors.green),
            SizedBox(width: 8),
            Text('Lupa Kata Sandi'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masukkan email terdaftar Anda. Kami akan mengirimkan kode OTP untuk mereset kata sandi.',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: resetEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Terdaftar',
                hintText: 'nama@email.com',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (resetEmailController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email tidak boleh kosong!')),
                );
                return;
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Kode OTP simulasi telah dikirim ke email Anda!',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Kirim OTP'),
          ),
        ],
      ),
    );
  }

  void _showGoogleLoginDialog() {
    GoogleAuthSheet.show(
      context,
      onAccountSelected: (nama, email, avatarUrl) {
        Navigator.pop(context);
        _processGoogleLogin(
          nama: nama,
          email: email,
          avatarUrl: avatarUrl,
        );
      },
    );
  }

  Future<void> _processGoogleLogin({
    required String nama,
    required String email,
    String? avatarUrl,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const PopScope(
        canPop: false,
        child: Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.green),
                  SizedBox(width: 20),
                  Text(
                    'Menghubungkan akun Google...',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    final result = await ApiService.loginWithGoogle(
      email: email,
      nama: nama,
      fotoProfil: avatarUrl,
    );

    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop();

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selamat datang, ${AppData.namaUser}! Berhasil masuk.'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      if (_selectedRole == 'Mitra Kurir') {
        AppData.role = 'kurir';
        if (AppData.namaUser.isEmpty || AppData.namaUser == 'User') {
          AppData.namaUser = 'Ahmad Fauzi';
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MitraNavigationView(),
          ),
        );
      } else {
        AppData.role = 'nasabah';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainNavigationView(),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Gagal masuk dengan Google'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.eco,
                        size: 40,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'REGREEN',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const Text(
                      'BANK SAMPAH DIGITAL',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Selamat Datang Kembali',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Masuk untuk kelola tabungan sampah, jemputan daur ulang, dan operasional bank sampah.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 24),
              const Text(
                'Pilih Peran Akun',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 12),
              Row(
                children: _roles.map((role) {
                  bool isSelected = _selectedRole == role['name'];
                  bool isActive = role['active'] as bool;
                  return Expanded(
                    child: GestureDetector(
                      onTap: isActive
                          ? () => setState(
                              () => _selectedRole = role['name'] as String,
                            )
                          : null,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Colors.green
                                : Colors.grey.shade300,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.green.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                  ),
                                ]
                              : [],
                        ),
                        child: Column(
                          children: [
                            Icon(
                              role['icon'] as IconData,
                              color: isSelected
                                  ? Colors.white
                                  : (isActive ? Colors.green : Colors.grey),
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              role['name'] as String,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              role['sub'] as String,
                              style: TextStyle(
                                fontSize: 9,
                                color: isSelected
                                    ? Colors.white70
                                    : Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.green,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _selectedRole == 'Mitra Kurir'
                            ? 'Masuk sebagai Mitra Kurir Armada untuk menerima order jemputan sampah, navigasi rute nasabah, dan input timbangan digital.'
                            : (_selectedRole == 'Admin'
                                ? 'Masuk sebagai Admin untuk monitoring operasional bank sampah, rekapitulasi data, dan kelola harga.'
                                : 'Masuk sebagai Nasabah untuk cek saldo tabungan sampah, request jemput pilahan, dan tukar voucher belanja.'),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.green.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (_isLocked)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lock_clock, color: Colors.orange),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Login dikunci sementara',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            Text(
                              'Coba lagi dalam ${_formatTime(_lockTimer)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              if (_isLocked) const SizedBox(height: 16),
              const Text(
                'Email atau Nomor WhatsApp',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                enabled: !_isLocked,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'contoh: 08123456789 atau nama@email.com',
                  prefixIcon: const Icon(Icons.email_outlined),
                  suffixIcon: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Kata Sandi',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  InkWell(
                    onTap: _isLocked ? null : _showForgotPasswordDialog,
                    child: Text(
                      'Lupa Kata Sandi?',
                      style: TextStyle(
                        color: _isLocked ? Colors.grey : Colors.green,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: _isLocked ? Colors.grey : Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                enabled: !_isLocked,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    activeColor: Colors.green,
                    onChanged: (val) =>
                        setState(() => _rememberMe = val ?? false),
                  ),
                  const Text('Ingat Saya di Perangkat Ini'),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLocked || _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _selectedRole == 'Mitra Kurir'
                                ? 'Masuk ke Dashboard Mitra Kurir'
                                : 'Masuk ke Aplikasi REGREEN',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward),
                        ],
                      ),
              ),
              const SizedBox(height: 8),
              Text(
                _selectedRole == 'Mitra Kurir'
                    ? 'Mengarahkan langsung ke Dashboard Tugas Penjemputan Armada'
                    : 'Mengarahkan langsung ke Beranda Nasabah & Rekening Sampah',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'ATAU MASUK LEBIH CEPAT',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: OutlinedButton(
                  onPressed: _showGoogleLoginDialog,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                    backgroundColor: Colors.white,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Center(
                          child: Text(
                            'G',
                            style: TextStyle(
                              color: Color(0xFF4285F4),
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Masuk dengan Google',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Belum punya akun?'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterView(),
                        ),
                      );
                    },
                    child: const Text(
                      'Daftar Sekarang',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';

// GANTI IMPORT INI: Arahkan ke halaman Login
import '../auth/login_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _pindahHalaman();
  }

  void _pindahHalaman() async {
    // Tunggu 3 detik
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      // UBAH DI SINI: Arahkan ke LoginView, BUKAN MainNavigationView
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.eco, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'REGREEN',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Ubah Sampahmu jadi Berkah',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

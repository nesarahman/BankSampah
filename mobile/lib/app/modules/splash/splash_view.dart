import 'package:flutter/material.dart';

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

    // NANTI: Setelah Fatika membuat halaman Login, aktifkan kode di bawah ini:
    // Navigator.pushReplacementNamed(context, '/login');

    // ATAU jika tidak pakai named route:
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green, // Sesuaikan dengan warna desain REGREEN
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.eco,
              size: 80,
              color: Colors.white,
            ), // Tambah icon daun biar keren
            const SizedBox(height: 20),
            const Text(
              'REGREEN',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Ubah Sampahmu jadi Berkah',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

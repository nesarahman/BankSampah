import 'package:flutter/material.dart'; // import material design

import '../auth/login_view.dart'; // import halaman login

// buat statefulwidget biar bisa jalanin timer
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  // fungsi ini jalan pertama kali pas halaman dibuka
  @override
  void initState() {
    super.initState();
    _pindahHalaman(); // panggil fungsi pindah halaman
  }

  // fungsi async buat nunggu waktu
  void _pindahHalaman() async {
    // delay 3 detik buat efek loading
    await Future.delayed(const Duration(seconds: 3));

    // cek apakah halaman masih aktif biar gak error
    if (mounted) {
      // pindah halaman dan hapus splash dari memori (biar gak bisa di-back)
      Navigator.pushReplacement(
        context,
        // tujuan pindah ke halaman login
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    }
  }

  // fungsi buat bangun tampilan UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // kerangka dasar halaman
      backgroundColor: const Color(
        0xFF2E7D32,
      ), // setting warna background hijau
      body: Center(
        // posisi konten di tengah layar
        child: Column(
          // susunan konten vertikal (atas ke bawah)
          mainAxisAlignment: MainAxisAlignment.center, // tengah secara vertikal
          children: const [
            Icon(
              Icons.eco,
              size: 80,
              color: Colors.white,
            ), // icon daun/logo ukuran 80
            SizedBox(height: 20), // kasih jarak kosong 20 pixel

            Text(
              // teks nama aplikasi
              'REGREEN',
              style: TextStyle(
                fontSize: 32, // ukuran font 32
                fontWeight: FontWeight.bold, // font tebal
                color: Colors.white, // warna font putih
                letterSpacing: 1.2, // kasih jarak antar huruf
              ),
            ),
            SizedBox(height: 10), // kasih jarak kosong 10 pixel

            Text(
              // teks slogan
              'Ubah Sampahmu jadi Berkah',
              // font 16, warna putih agak transparan
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            SizedBox(height: 40), // kasih jarak kosong 40 pixel
            // loading bulat warna putih, ketebalan 3
            CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
          ],
        ),
      ),
    );
  }
}

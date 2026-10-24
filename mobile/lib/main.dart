// 1. IMPORT PACKAGE: Mengambil library dasar Material Design dari Flutter
import 'package:flutter/material.dart';

// 2. IMPORT HALAMAN PERTAMA: Memanggil file Splash Screen yang sudah dibuat
import 'app/modules/splash/splash_view.dart';

// (Opsional) Import untuk halaman selanjutnya, disiapkan untuk masa depan:
// import 'app/modules/auth/login_view.dart';
// import 'app/modules/main_navigation_view.dart';

// 3. FUNGSI MAIN: Ini adalah "Entry Point" atau titik masuk utama aplikasi.
// Saat aplikasi dijalankan, Dart akan selalu mencari dan menjalankan fungsi 'main' ini terlebih dahulu.
void main() {
  // runApp() memerintahkan Flutter untuk merender widget yang kita berikan ke layar.
  runApp(const MyApp());
}

// 4. CLASS MyApp: Widget root (akar) dari seluruh aplikasi kita.
// Kita gunakan StatelessWidget karena konfigurasi dasar aplikasi ini tidak berubah-ubah (statis).
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 5. MATERIALAPP: Widget utama yang menyediakan semua fitur Material Design
    // (seperti navigasi, tema, dan routing) untuk seluruh aplikasi.
    return MaterialApp(
      // Judul aplikasi (muncul di task manager HP atau tab browser)
      title: 'REGREEN',

      // 6. DEBUG BANNER: Sangat penting untuk presentasi!
      // Menghilangkan pita "DEBUG" berwarna merah di pojok kanan atas layar
      // agar aplikasi terlihat seperti produk produksi yang profesional.
      debugShowCheckedModeBanner: false,

      // Mengatur warna dan gaya default untuk SELURUH aplikasi.
      theme: ThemeData(
        primarySwatch: Colors.green, // Warna utama brand REGREEN (Hijau)
        useMaterial3: true, // Menggunakan standar desain Material Design 3 (terbaru & modern)
      ),

      //HALAMAN PERTAMA (HOME): Menentukan widget apa yang muncul pertama kali
      // saat aplikasi dibuka. Di sini kita arahkan ke Splash Screen.
      home: const SplashView(),

      // 9. NAMED ROUTES (PERSIAPAN MASA DEPAN):
      // Ini adalah cara terbaik mengelola navigasi di aplikasi besar.
      // Kita beri nama jalur (route), jadi nanti tinggal panggil Navigator.pushNamed(context, '/login').
      // Saya biarkan dikomentari dulu sebagai bukti kita paham konsep routing yang scalable.
      // routes: {
      //   '/login': (context) => const LoginView(),
      //   '/main': (context) => const MainNavigationView(),
      // },
    );
  }
}

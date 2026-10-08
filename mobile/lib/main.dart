import 'package:flutter/material.dart';

import 'app/modules/splash/splash_view.dart';

// Nanti kalau halaman Login sudah dibuat Fatika, import di sini:
// import 'app/modules/login/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REGREEN',
      debugShowCheckedModeBanner:
          false, // Hilangkan banner debug di pojok kanan atas
      theme: ThemeData(
        primarySwatch: Colors.green, // Tema warna utama REGREEN
        useMaterial3: true,
      ),
      home: const SplashView(), // Halaman pertama yang muncul
      // Nanti kalau mau pakai Named Route, buka komentar di bawah ini:
      // routes: {
      //   '/login': (context) => const LoginView(),
      //   '/home': (context) => const HomeView(),
      // },
    );
  }
}

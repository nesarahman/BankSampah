import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Pastikan path import ini sesuai dengan lokasi file splash_view.dart kakak
// Jika file ada di lib/app/modules/splash/splash_view.dart, gunakan path ini:
import 'app/modules/splash/splash_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Pakai GetMaterialApp karena kita pakai GetX
      title: 'REGREEN',
      debugShowCheckedModeBanner:
          false, // Hilangkan banner "DEBUG" di pojok kanan atas
      theme: ThemeData(
        colorSchemeSeed: Colors.green, // Tema warna hijau sesuai REGREEN
        useMaterial3: true,
      ),
      home: const SplashView(), // <--- INI KUNCINYA! Memanggil Splash Screen
    );
  }
}

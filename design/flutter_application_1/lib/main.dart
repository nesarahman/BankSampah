import 'package:flutter/material.dart';
import 'core/app_routes.dart';
import 'core/app_theme.dart';

void main() {
  runApp(const ReGreenApp());
}

class ReGreenApp extends StatelessWidget {
  const ReGreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReGreen Bank Sampah',

      // Tema aplikasi
      theme: AppTheme.theme,

      // Halaman pertama
      initialRoute: AppRoutes.login,

      // Daftar navigasi halaman
      routes: AppRoutes.routes,
    );
  }
}
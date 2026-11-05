// File: lib/app_data.dart

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class AppData {
  // Data Saldo & Poin
  static int saldoTersedia = 0;
  static int poinHijau = 0;
  static String totalSampah = '0 kg';

  // Token & User Info
  static String token = '';
  static String namaUser = '';
  static String username = '';
  static String emailUser = '';
  static String noHp = '';
  static String role = '';
  static String fotoProfil = '';

  // Data Khusus Mitra Kurir (Armada)
  static String idArmada = 'ARM-03 Ternate Selatan';
  static String kendaraan = 'Honda Supra X 125';
  static String platNomor = 'DG 4582 KT';
  static String kapasitasMaks = '80 Kg';
  static double ratingKurir = 4.9;
  static int totalUlasanKurir = 148;
  static int targetSelesai = 8;
  static int targetTotal = 12;
  static int pendapatanHariIni = 145000;
  static int bonusInsentif = 25000;
  static int saldoMitra = 380500;
  static bool isMitraOnline = true;
  static String statusTimbangan = 'SC-04 Bluetooth Terhubung';
  static int bateraiTimbangan = 98;

  // URL API (Bisa di-override jika perlu IP custom)
  static String _customBaseUrl = '';

  // Secara otomatis mendeteksi:
  // - Emulator Android: http://10.0.2.2:8000/api
  // - Web / Windows Desktop / Mac / Linux: http://127.0.0.1:8000/api
  // - Jika diset manual: menggunakan URL yang diset
  static String get baseUrl {
    if (_customBaseUrl.isNotEmpty) return _customBaseUrl;
    if (kIsWeb) return 'http://127.0.0.1:8000/api';
    try {
      if (Platform.isAndroid) return 'http://10.0.2.2:8000/api';
    } catch (_) {}
    return 'http://127.0.0.1:8000/api';
  }

  static set baseUrl(String url) {
    _customBaseUrl = url;
  }

  // Format angka ribuan (e.g. 348500 -> 348.500)
  static String formatAngka(int nilai) {
    final s = nilai.abs().toString();
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
      b.write(s[i]);
    }
    return (nilai < 0 ? '-' : '') + b.toString();
  }

  // Reset data (untuk logout)
  static void reset() {
    saldoTersedia = 0;
    poinHijau = 0;
    totalSampah = '0 kg';
    token = '';
    namaUser = '';
    username = '';
    emailUser = '';
    noHp = '';
    role = '';
    fotoProfil = '';
  }
}

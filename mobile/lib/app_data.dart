// File: lib/app_data.dart

class AppData {
  // Data Saldo & Poin
  static int saldoTersedia = 0;
  static int poinHijau = 0;
  static String totalSampah = '0 kg';

  // Token & User Info
  static String token = '';
  static String namaUser = '';
  static String emailUser = '';

  // URL API (GANTI SESUAI KONDISI)
  // Untuk emulator Android: pakai 10.0.2.2
  // Untuk HP fisik: pakai IP WiFi laptop (cek dengan ipconfig)
  // Untuk demo di laptop: pakai 127.0.0.1
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // Format angka ribuan
  static String formatAngka(int nilai) {
    final s = nilai.abs().toString();
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
      b.write(s[i]);
    }
    return b.toString();
  }

  // Reset data (untuk logout)
  static void reset() {
    saldoTersedia = 0;
    poinHijau = 0;
    totalSampah = '0 kg';
    token = '';
    namaUser = '';
    emailUser = '';
  }
}

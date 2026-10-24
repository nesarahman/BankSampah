// File: lib/api_service.dart

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'app_data.dart';

class ApiService {
  // LOGIN
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final url = Uri.parse('${AppData.baseUrl}/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Simpan token & data user
        AppData.token = data['token'];
        AppData.namaUser = data['user']['nama'] ?? 'User';
        AppData.emailUser = data['user']['email'] ?? email;
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login gagal'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Koneksi ke server gagal'};
    }
  }

  // GET DASHBOARD (Saldo, Poin, dll)
  static Future<Map<String, dynamic>> getDashboard() async {
    final url = Uri.parse('${AppData.baseUrl}/dashboard');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${AppData.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // ✅ Update AppData dengan data dari API
        AppData.saldoTersedia = (data['data']['saldo'] ?? 0).toInt();
        AppData.poinHijau = (data['data']['poin'] ?? 0).toInt();

        // Handle total_sampah (bisa decimal)
        var totalSampah = data['data']['total_sampah'] ?? 0;
        AppData.totalSampah = '$totalSampah kg';

        // Simpan nama user jika ada
        if (data['data']['user'] != null) {
          AppData.namaUser = data['data']['user']['nama'] ?? 'User';
        }

        return {'success': true, 'data': data['data']};
      } else {
        return {'success': false, 'message': 'Gagal mengambil data'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Koneksi ke server gagal'};
    }
  }
}

// File: lib/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'app_data.dart';

class ApiService {
  // Helper konversi angka aman (bisa handle int, double, String "348500.00", dll)
  static int _parseInt(dynamic val) {
    if (val == null) return 0;
    if (val is int) return val;
    if (val is double) return val.toInt();
    if (val is String) {
      final parsedDouble = double.tryParse(val);
      if (parsedDouble != null) return parsedDouble.toInt();
      final parsedInt = int.tryParse(val);
      if (parsedInt != null) return parsedInt;
    }
    return 0;
  }

  // 1. LOGIN
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final url = Uri.parse('${AppData.baseUrl}/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('DEBUG LOGIN RESPONSE: ${response.statusCode} - ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Laravel successResponse membungkus payload di dalam 'data'
        final Map<String, dynamic> resData =
            (data is Map<String, dynamic> &&
                    data.containsKey('data') &&
                    data['data'] is Map<String, dynamic>)
                ? data['data'] as Map<String, dynamic>
                : (data is Map<String, dynamic> ? data : <String, dynamic>{});

        // Simpan token untuk request protected berikutnya
        AppData.token = resData['token']?.toString() ??
            data['token']?.toString() ??
            '';

        final user = resData['user'] ?? data['user'];
        if (user is Map<String, dynamic>) {
          AppData.namaUser = user['nama']?.toString() ?? 'User';
          AppData.username = user['username']?.toString() ?? '';
          AppData.emailUser = user['email']?.toString() ?? email;
          AppData.noHp = user['no_hp']?.toString() ?? '';
          AppData.role = user['role']?.toString() ?? 'nasabah';
          AppData.fotoProfil = user['foto_profil']?.toString() ?? '';
          AppData.saldoTersedia = _parseInt(user['saldo']);
          AppData.poinHijau =
              _parseInt(user['poin_hijau'] ?? user['poin']);

          final rawSampah = user['total_sampah'] ?? '0';
          AppData.totalSampah = rawSampah.toString().endsWith('kg')
              ? rawSampah.toString()
              : '$rawSampah kg';
        }

        return {'success': true, 'data': resData};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login gagal',
        };
      }
    } catch (e) {
      print('DEBUG LOGIN ERROR: $e');
      return {
        'success': false,
        'message': 'Koneksi ke server gagal. Cek backend & URL API: $e',
      };
    }
  }

  // 1b. LOGIN / REGISTER WITH GOOGLE
  static Future<Map<String, dynamic>> loginWithGoogle({
    required String email,
    required String nama,
    String? fotoProfil,
    String? googleId,
  }) async {
    final url = Uri.parse('${AppData.baseUrl}/auth/google');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'nama': nama,
          'foto_profil': fotoProfil,
          'google_id': googleId,
        }),
      );

      print('DEBUG GOOGLE LOGIN RESPONSE: ${response.statusCode} - ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = (data is Map<String, dynamic> &&
                data.containsKey('data') &&
                data['data'] is Map<String, dynamic>)
            ? data['data'] as Map<String, dynamic>
            : (data is Map<String, dynamic> ? data : <String, dynamic>{});

        AppData.token = resData['token']?.toString() ??
            data['token']?.toString() ??
            '';

        final user = resData['user'] ?? data['user'];
        if (user is Map<String, dynamic>) {
          AppData.namaUser = user['nama']?.toString() ?? nama;
          AppData.username = user['username']?.toString() ?? '';
          AppData.emailUser = user['email']?.toString() ?? email;
          AppData.noHp = user['no_hp']?.toString() ?? '';
          AppData.role = user['role']?.toString() ?? 'nasabah';
          AppData.fotoProfil = user['foto_profil']?.toString() ?? fotoProfil ?? '';
          AppData.saldoTersedia = _parseInt(user['saldo']);
          AppData.poinHijau = _parseInt(user['poin_hijau'] ?? user['poin']);

          final rawSampah = user['total_sampah'] ?? '0';
          AppData.totalSampah = rawSampah.toString().endsWith('kg')
              ? rawSampah.toString()
              : '$rawSampah kg';
        }

        return {
          'success': true,
          'message': data['message'] ?? 'Login berhasil',
          'data': resData,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login Google gagal',
        };
      }
    } catch (e) {
      print('DEBUG GOOGLE LOGIN ERROR: $e');
      return {
        'success': false,
        'message': 'Koneksi ke backend gagal: $e',
      };
    }
  }

  // 2. REGISTER
  static Future<Map<String, dynamic>> register({
    required String nama,
    required String username,
    required String email,
    required String password,
    required String noHp,
    required String role,
  }) async {
    final url = Uri.parse('${AppData.baseUrl}/register');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'nama': nama,
          'username': username,
          'email': email,
          'password': password,
          'password_confirmation': password,
          'no_hp': noHp,
          'role': role,
        }),
      );

      print('DEBUG REGISTER RESPONSE: ${response.statusCode} - ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'Registrasi berhasil',
        };
      } else {
        String msg = data['message'] ?? 'Registrasi gagal';
        if (data is Map && data.containsKey('errors') && data['errors'] is Map) {
          final errs = data['errors'] as Map;
          if (errs.isNotEmpty) {
            final firstVal = errs.values.first;
            if (firstVal is List && firstVal.isNotEmpty) {
              msg = firstVal.first.toString();
            } else if (firstVal is String) {
              msg = firstVal;
            }
          }
        }
        return {
          'success': false,
          'message': msg,
        };
      }
    } catch (e) {
      print('DEBUG REGISTER ERROR: $e');
      return {
        'success': false,
        'message': 'Koneksi ke server gagal. Cek URL/Port.',
      };
    }
  }

  // 3. GET DASHBOARD (Ambil Saldo, Poin, Total Sampah, User, Statistik)
  static Future<Map<String, dynamic>> getDashboard() async {
    final url = Uri.parse('${AppData.baseUrl}/dashboard');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${AppData.token}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('DEBUG DASHBOARD RESPONSE: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final raw = jsonDecode(response.body);
        final data = (raw is Map<String, dynamic> &&
                raw.containsKey('data') &&
                raw['data'] is Map<String, dynamic>)
            ? raw['data'] as Map<String, dynamic>
            : (raw as Map<String, dynamic>);

        final user = data['user'] is Map<String, dynamic>
            ? data['user'] as Map<String, dynamic>
            : null;

        // Update AppData secara real-time dari data backend
        AppData.saldoTersedia =
            _parseInt(data['saldo'] ?? user?['saldo']);
        AppData.poinHijau =
            _parseInt(data['poin'] ?? user?['poin_hijau'] ?? user?['poin']);

        var totalSampah =
            data['total_sampah'] ?? user?['total_sampah'] ?? '0';
        AppData.totalSampah = totalSampah.toString().endsWith('kg')
            ? totalSampah.toString()
            : '$totalSampah kg';

        if (user != null) {
          AppData.namaUser = user['nama']?.toString() ?? AppData.namaUser;
          AppData.emailUser = user['email']?.toString() ?? AppData.emailUser;
          AppData.noHp = user['no_hp']?.toString() ?? AppData.noHp;
          AppData.username = user['username']?.toString() ?? AppData.username;
          AppData.role = user['role']?.toString() ?? AppData.role;
          if (user['foto_profil'] != null && user['foto_profil'].toString().isNotEmpty) {
            AppData.fotoProfil = user['foto_profil'].toString();
          }
        }

        return {'success': true, 'data': data};
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Sesi telah berakhir, silakan login kembali',
        };
      } else {
        return {'success': false, 'message': 'Gagal mengambil data dashboard'};
      }
    } catch (e) {
      print('DEBUG DASHBOARD ERROR: $e');
      return {'success': false, 'message': 'Koneksi ke server gagal: $e'};
    }
  }

  // 4. GET SALDO & TRANSAKSI
  static Future<Map<String, dynamic>> getSaldo() async {
    final url = Uri.parse('${AppData.baseUrl}/saldo');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${AppData.token}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final raw = jsonDecode(response.body);
        final data = (raw is Map<String, dynamic> &&
                raw.containsKey('data') &&
                raw['data'] is Map<String, dynamic>)
            ? raw['data'] as Map<String, dynamic>
            : (raw as Map<String, dynamic>);

        AppData.saldoTersedia = _parseInt(data['saldo']);
        AppData.poinHijau = _parseInt(data['poin_hijau']);

        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': 'Gagal mengambil data saldo'};
      }
    } catch (e) {
      print('DEBUG GET SALDO ERROR: $e');
      return {'success': false, 'message': 'Koneksi ke server gagal: $e'};
    }
  }

  // 5. TARIK SALDO KE BACKEND
  static Future<Map<String, dynamic>> tarikSaldo({
    required int nominal,
    required String metode,
    String catatan = '',
  }) async {
    final url = Uri.parse('${AppData.baseUrl}/saldo/tarik');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${AppData.token}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'nominal': nominal,
          'metode': metode,
          'catatan': catatan,
        }),
      );

      print('DEBUG TARIK SALDO RESPONSE: ${response.statusCode} - ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = (data is Map<String, dynamic> &&
                data.containsKey('data') &&
                data['data'] is Map<String, dynamic>)
            ? data['data'] as Map<String, dynamic>
            : data as Map<String, dynamic>;

        if (resData.containsKey('saldo')) {
          AppData.saldoTersedia = _parseInt(resData['saldo']);
        } else {
          AppData.saldoTersedia -= nominal;
          if (AppData.saldoTersedia < 0) AppData.saldoTersedia = 0;
        }

        return {
          'success': true,
          'message': data['message'] ?? 'Penarikan berhasil diproses',
          'data': resData,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Penarikan gagal',
        };
      }
    } catch (e) {
      print('DEBUG TARIK SALDO ERROR: $e');
      return {
        'success': false,
        'message': 'Koneksi ke server gagal: $e',
      };
    }
  }

  // 6. LOGOUT
  static Future<void> logout() async {
    try {
      final url = Uri.parse('${AppData.baseUrl}/logout');
      await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${AppData.token}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
    } catch (e) {
      print('DEBUG LOGOUT ERROR: $e');
    } finally {
      AppData.reset();
    }
  }

  // 7. GET KATALOG SAMPAH
  static Future<List<Map<String, dynamic>>> getSampah() async {
    final url = Uri.parse('${AppData.baseUrl}/sampah');
    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data['data'] ?? data;
        if (list is List) {
          return List<Map<String, dynamic>>.from(list);
        }
      }
    } catch (e) {
      print('DEBUG GET SAMPAH ERROR: $e');
    }
    return [];
  }

  // 8. GET DROP POINTS
  static Future<List<Map<String, dynamic>>> getDropPoints() async {
    final url = Uri.parse('${AppData.baseUrl}/drop-points');
    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data['data'] ?? data;
        if (list is List) {
          return List<Map<String, dynamic>>.from(list);
        }
      }
    } catch (e) {
      print('DEBUG GET DROP POINTS ERROR: $e');
    }
    return [];
  }

  // 9. AJUKAN PENJEMPUTAN BARU
  static Future<Map<String, dynamic>> ajukanPenjemputan({
    required String tanggal,
    required String sesi,
    required String lokasi,
    required int jenisSampahId,
    required double berat,
    String catatan = '',
  }) async {
    final url = Uri.parse('${AppData.baseUrl}/penjemputan');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${AppData.token}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'tanggal': tanggal,
          'sesi': sesi,
          'lokasi': lokasi,
          'catatan': catatan,
          'items': [
            {
              'jenis_sampah_id': jenisSampahId,
              'berat_estimasi': berat,
            }
          ],
        }),
      );

      print('DEBUG AJUKAN PENJEMPUTAN: ${response.statusCode} - ${response.body}');
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'Penjemputan berhasil diajukan',
          'data': data['data'] ?? data,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal mengajukan penjemputan',
        };
      }
    } catch (e) {
      print('DEBUG AJUKAN PENJEMPUTAN ERROR: $e');
      return {'success': false, 'message': 'Koneksi ke server gagal: $e'};
    }
  }

  // 10. GET RIWAYAT PENJEMPUTAN
  static Future<List<Map<String, dynamic>>> getRiwayatPenjemputan() async {
    final url = Uri.parse('${AppData.baseUrl}/penjemputan');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${AppData.token}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data['data'] ?? data;
        if (list is List) {
          return List<Map<String, dynamic>>.from(list);
        }
      }
    } catch (e) {
      print('DEBUG GET RIWAYAT ERROR: $e');
    }
    return [];
  }

  // 11. UPDATE PROFILE
  static Future<Map<String, dynamic>> updateProfile({
    required String nama,
    String? noHp,
    String? alamat,
  }) async {
    final url = Uri.parse('${AppData.baseUrl}/profile');
    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer ${AppData.token}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'nama': nama,
          if (noHp != null && noHp.isNotEmpty) 'no_hp': noHp,
          if (alamat != null && alamat.isNotEmpty) 'alamat': alamat,
        }),
      );

      print('DEBUG UPDATE PROFILE: ${response.statusCode} - ${response.body}');
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final resData = (data is Map<String, dynamic> &&
                data.containsKey('data') &&
                data['data'] is Map<String, dynamic>)
            ? data['data'] as Map<String, dynamic>
            : (data as Map<String, dynamic>);

        AppData.namaUser = resData['nama']?.toString() ?? nama;
        if (noHp != null) AppData.noHp = noHp;

        return {
          'success': true,
          'message': data['message'] ?? 'Profil berhasil diperbarui',
          'data': resData,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal memperbarui profil',
        };
      }
    } catch (e) {
      print('DEBUG UPDATE PROFILE ERROR: $e');
      return {'success': false, 'message': 'Koneksi ke server gagal: $e'};
    }
  }

  // 12. SELESAIKAN PENJEMPUTAN & KIRIM SALDO KE NASABAH
  static Future<Map<String, dynamic>> selesaiPenjemputan({
    required dynamic id,
    required double totalBerat,
    required double totalSaldo,
    List<Map<String, dynamic>>? items,
  }) async {
    final cleanId = id.toString().replaceAll('REG-', '');
    final url = Uri.parse('${AppData.baseUrl}/penjemputan/$cleanId/selesai');
    try {
      final response = await http.post(
        url,
        headers: {
          if (AppData.token.isNotEmpty) 'Authorization': 'Bearer ${AppData.token}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'total_berat': totalBerat,
          'total_saldo': totalSaldo,
          'items': items ?? [],
        }),
      );

      print('DEBUG SELESAI PENJEMPUTAN: ${response.statusCode} - ${response.body}');
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'Penjemputan selesai & saldo berhasil dikirim!',
          'data': data['data'] ?? data,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal memproses penjemputan',
        };
      }
    } catch (e) {
      print('DEBUG SELESAI PENJEMPUTAN ERROR: $e');
      return {'success': false, 'message': 'Koneksi ke backend gagal: $e'};
    }
  }

  // 13. DASHBOARD KHUSUS MITRA KURIR
  static Future<Map<String, dynamic>> getMitraDashboard() async {
    final url = Uri.parse('${AppData.baseUrl}/mitra/dashboard');
    try {
      final response = await http.get(
        url,
        headers: {
          if (AppData.token.isNotEmpty) 'Authorization': 'Bearer ${AppData.token}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final data = body['data'] ?? body;

        final user = data['user'];
        if (user is Map<String, dynamic>) {
          if (user['nama'] != null && user['nama'].toString().isNotEmpty) {
            AppData.namaUser = user['nama'].toString();
          }
          if (user['email'] != null) AppData.emailUser = user['email'].toString();
          if (user['no_hp'] != null) AppData.noHp = user['no_hp'].toString();
          if (user['foto_profil'] != null) AppData.fotoProfil = user['foto_profil'].toString();
        }

        final mitra = data['mitra'];
        if (mitra is Map<String, dynamic>) {
          if (mitra['id_armada'] != null) AppData.idArmada = mitra['id_armada'].toString();
          if (mitra['kendaraan'] != null) AppData.kendaraan = mitra['kendaraan'].toString();
          if (mitra['plat_nomor'] != null) AppData.platNomor = mitra['plat_nomor'].toString();
          if (mitra['kapasitas_maks'] != null) AppData.kapasitasMaks = mitra['kapasitas_maks'].toString();
          if (mitra['rating'] != null) AppData.ratingKurir = (mitra['rating'] as num).toDouble();
          if (mitra['total_ulasan'] != null) AppData.totalUlasanKurir = _parseInt(mitra['total_ulasan']);
          if (mitra['status_online'] != null) AppData.isMitraOnline = mitra['status_online'] as bool;

          if (mitra['target_harian'] is Map) {
            AppData.targetSelesai = _parseInt(mitra['target_harian']['selesai']);
            AppData.targetTotal = _parseInt(mitra['target_harian']['total']);
          }

          if (mitra['pendapatan'] is Map) {
            AppData.pendapatanHariIni = _parseInt(mitra['pendapatan']['hari_ini']);
            AppData.bonusInsentif = _parseInt(mitra['pendapatan']['bonus']);
            AppData.saldoMitra = _parseInt(mitra['pendapatan']['saldo_siap_tarik']);
          }
        }

        return {'success': true, 'data': data};
      }
      return {'success': false, 'message': 'Gagal mengambil dashboard mitra'};
    } catch (e) {
      print('DEBUG MITRA DASHBOARD ERROR: $e');
      return {'success': false, 'message': 'Koneksi error: $e'};
    }
  }

  // 14. TARIK SALDO KOMISI MITRA KURIR
  static Future<Map<String, dynamic>> tarikSaldoMitra({
    required int nominal,
    required String metode,
    required String nomorTujuan,
  }) async {
    final url = Uri.parse('${AppData.baseUrl}/mitra/tarik-saldo');
    try {
      final response = await http.post(
        url,
        headers: {
          if (AppData.token.isNotEmpty) 'Authorization': 'Bearer ${AppData.token}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'nominal': nominal,
          'metode': metode,
          'nomor_tujuan': nomorTujuan,
        }),
      );

      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        AppData.saldoMitra = (AppData.saldoMitra - nominal).clamp(0, 999999999);
        return {
          'success': true,
          'message': body['message'] ?? 'Penarikan berhasil diproses!',
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Penarikan gagal',
        };
      }
    } catch (e) {
      print('DEBUG TARIK SALDO MITRA ERROR: $e');
      return {'success': false, 'message': 'Koneksi backend gagal: $e'};
    }
  }
}

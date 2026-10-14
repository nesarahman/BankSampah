class AuthStore {
  // Penyimpanan akun sementara selama aplikasi berjalan.
  static final Map<String, Map<String, String>> _accounts = {};

  static bool register({
    required String nama,
    required String email,
    required String password,
    String? noHp,
    String role = 'Nasabah',
  }) {
    final key = email.trim().toLowerCase();

    if (_accounts.containsKey(key)) {
      return false; // Email sudah terdaftar
    }

    _accounts[key] = {
      'nama': nama,
      'password': password,
      'noHp': noHp ?? '',
      'role': role,
    };

    return true;
  }

  // Mengembalikan data akun jika berhasil, null jika gagal
  static Map<String, String>? login({
    required String email,
    required String password,
  }) {
    final key = email.trim().toLowerCase();
    final account = _accounts[key];

    if (account != null && account['password'] == password) {
      return account; // Login berhasil
    }

    return null; // Login gagal
  }
}

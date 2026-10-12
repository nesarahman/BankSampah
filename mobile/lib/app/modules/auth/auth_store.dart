
class AuthStore {
  // Penyimpanan akun sementara selama aplikasi berjalan.
  static final Map<String, Map<String, String>> _accounts = {};

  static bool register({
    required String nama,
    required String email,
    required String password,
  }) {
    final key = email.trim().toLowerCase();

    if (_accounts.containsKey(key)) {
      return false;
    }

    _accounts[key] = {
      'nama': nama,
      'password': password,
    };

    return true;
  }

  static bool login({
    required String email,
    required String password,
  }) {
    final key = email.trim().toLowerCase();
    final account = _accounts[key];

    return account != null && account['password'] == password;
  }
}

import 'package:flutter/material.dart';
import '../auth/login_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  static const Color _green = Color(0xFF2E7D32);

  // TODO: ganti data contoh ini dengan data user asli (login/API)
  static const String _nama = 'Nama Pengguna';
  static const String _email = 'nama@email.com';
  static const String _noHp = '0812-3456-7890';
  static const int _poin = 1250;
  static const double _totalKg = 36.5;
  static const int _totalSetoran = 12;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: _green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildStats(),
            const SizedBox(height: 16),
            _buildInfoCard(),
            const SizedBox(height: 16),
            _buildMenu(context),
            const SizedBox(height: 16),
            _buildLogoutButton(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Bagian atas: foto, nama, email
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      decoration: const BoxDecoration(
        color: _green,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 48,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 44,
                  backgroundColor: Color(0xFFE8F5E9),
                  child: Icon(Icons.person, size: 52, color: _green),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.edit, size: 16, color: _green),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            _nama,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            _email,
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Tiga kotak statistik
  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _statItem(Icons.stars, '$_poin', 'Poin'),
          const SizedBox(width: 12),
          _statItem(Icons.scale, '$_totalKg kg', 'Total Sampah'),
          const SizedBox(width: 12),
          _statItem(Icons.local_shipping, '$_totalSetoran', 'Setoran'),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: _green, size: 26),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Informasi akun
  Widget _buildInfoCard() {
    return _card(
      title: 'Informasi Akun',
      children: const [
        _InfoRow(icon: Icons.person_outline, label: 'Nama', value: _nama),
        _InfoRow(icon: Icons.email_outlined, label: 'Email', value: _email),
        _InfoRow(icon: Icons.phone_outlined, label: 'No. HP', value: _noHp),
      ],
    );
  }

  // Daftar menu
  Widget _buildMenu(BuildContext context) {
    return _card(
      title: 'Pengaturan',
      children: [
        _MenuTile(
          icon: Icons.edit_outlined,
          title: 'Edit Profil',
          onTap: () => _showSoon(context, 'Edit Profil'),
        ),
        _MenuTile(
          icon: Icons.location_on_outlined,
          title: 'Alamat Penjemputan',
          onTap: () => _showSoon(context, 'Alamat Penjemputan'),
        ),
        _MenuTile(
          icon: Icons.lock_outline,
          title: 'Ubah Kata Sandi',
          onTap: () => _showSoon(context, 'Ubah Kata Sandi'),
        ),
        _MenuTile(
          icon: Icons.help_outline,
          title: 'Bantuan',
          onTap: () => _showSoon(context, 'Bantuan'),
        ),
        _MenuTile(
          icon: Icons.info_outline,
          title: 'Tentang REGREEN',
          onTap: () => showAboutDialog(
            context: context,
            applicationName: 'REGREEN',
            applicationVersion: '1.0.0',
            applicationLegalese: 'Aplikasi Bank Sampah',
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _confirmLogout(context),
          icon: const Icon(Icons.logout, color: Colors.red),
          label: const Text('Keluar', style: TextStyle(color: Colors.red)),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: const BorderSide(color: Colors.red),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _card({required String title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  void _showSoon(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name belum tersedia')),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // tutup dialog
              // TODO (opsional): hapus data sesi/user di AuthStore jika ada
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginView()),
                (route) => false, // hapus semua halaman sebelumnya
              );
            },
            child: const Text('Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: ProfileView._green, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: ProfileView._green),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
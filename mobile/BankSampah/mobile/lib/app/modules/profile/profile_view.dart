import 'package:flutter/material.dart';

import '../auth/login_view.dart';
import '../mitra/mitra_navigation_view.dart';
import '../../../api_service.dart';
import '../../../app_data.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  static const Color _green = Color(0xFF2E7D32);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    await ApiService.getDashboard();
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final nama = AppData.namaUser.isNotEmpty ? AppData.namaUser : 'Pengguna REGREEN';
    final email = AppData.emailUser.isNotEmpty ? AppData.emailUser : 'user@regreen.com';
    final noHp = AppData.noHp.isNotEmpty ? AppData.noHp : '-';
    final poin = AppData.poinHijau;
    final totalSampah = AppData.totalSampah;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: ProfileView._green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadProfile,
        color: ProfileView._green,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildHeader(nama, email),
              const SizedBox(height: 16),
              _buildStats(poin, totalSampah),
              const SizedBox(height: 16),
              _buildInfoCard(nama, email, noHp),
              const SizedBox(height: 16),
              _buildMenu(context),
              const SizedBox(height: 16),
              _buildLogoutButton(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Bagian atas: foto, nama, email
  Widget _buildHeader(String nama, String email) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      decoration: const BoxDecoration(
        color: ProfileView._green,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 44,
                  backgroundColor: const Color(0xFFE8F5E9),
                  backgroundImage: AppData.fotoProfil.isNotEmpty
                      ? NetworkImage(AppData.fotoProfil)
                      : null,
                  child: AppData.fotoProfil.isEmpty
                      ? const Icon(Icons.person, size: 52, color: ProfileView._green)
                      : null,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () => _showEditProfileDialog(context),
                  child: const CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.edit, size: 16, color: ProfileView._green),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            nama,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Tiga kotak statistik
  Widget _buildStats(int poin, String totalSampah) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _statItem(Icons.stars, '$poin', 'Poin'),
          const SizedBox(width: 12),
          _statItem(Icons.scale, totalSampah, 'Total Sampah'),
          const SizedBox(width: 12),
          _statItem(Icons.account_balance_wallet, 'Rp ${AppData.formatAngka(AppData.saldoTersedia)}', 'Saldo'),
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
            Icon(icon, color: ProfileView._green, size: 26),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
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
  Widget _buildInfoCard(String nama, String email, String noHp) {
    return _card(
      title: 'Informasi Akun',
      children: [
        _InfoRow(icon: Icons.person_outline, label: 'Nama', value: nama),
        if (AppData.username.isNotEmpty)
          _InfoRow(icon: Icons.alternate_email, label: 'Username', value: '@${AppData.username}'),
        _InfoRow(icon: Icons.email_outlined, label: 'Email', value: email),
        _InfoRow(icon: Icons.phone_outlined, label: 'No. HP', value: noHp),
      ],
    );
  }

  // Daftar menu
  Widget _buildMenu(BuildContext context) {
    return _card(
      title: 'Pengaturan',
      children: [
        _MenuTile(
          icon: Icons.two_wheeler,
          title: 'Mode Mitra Kurir (Armada Penjemputan)',
          onTap: () {
            AppData.role = 'kurir';
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MitraNavigationView()),
            );
          },
        ),
        _MenuTile(
          icon: Icons.edit_outlined,
          title: 'Edit Profil',
          onTap: () => _showEditProfileDialog(context),
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

  void _showEditProfileDialog(BuildContext context) {
    final namaC = TextEditingController(text: AppData.namaUser);
    final noHpC = TextEditingController(text: AppData.noHp);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Profil'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaC,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noHpC,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor HP',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (namaC.text.trim().isEmpty) return;
              Navigator.pop(ctx);
              final res = await ApiService.updateProfile(
                nama: namaC.text.trim(),
                noHp: noHpC.text.trim(),
              );
              if (!context.mounted) return;
              if (res['success'] == true) {
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profil berhasil diperbarui'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(res['message'] ?? 'Gagal memperbarui profil'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: ProfileView._green),
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
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
            onPressed: () async {
              Navigator.pop(ctx); // tutup dialog
              await ApiService.logout();
              if (!context.mounted) return;
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

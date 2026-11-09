import 'package:flutter/material.dart';
import '../auth/login_view.dart';
import '../../../main_navigation_view.dart';
import '../../../api_service.dart';
import '../../../app_data.dart';

class MitraProfilView extends StatefulWidget {
  const MitraProfilView({super.key});

  @override
  State<MitraProfilView> createState() => _MitraProfilViewState();
}

class _MitraProfilViewState extends State<MitraProfilView> {
  static const primaryGreen = Color(0xFF2E7D32);

  void _showEditKendaraanDialog() {
    final kendaraanC = TextEditingController(text: AppData.kendaraan);
    final platC = TextEditingController(text: AppData.platNomor);
    final kapasitasC = TextEditingController(text: AppData.kapasitasMaks);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Edit Informasi Kendaraan Armada'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: kendaraanC,
              decoration: const InputDecoration(labelText: 'Merk & Tipe Kendaraan', prefixIcon: Icon(Icons.two_wheeler)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: platC,
              decoration: const InputDecoration(labelText: 'Nomor Plat Polisi', prefixIcon: Icon(Icons.badge_outlined)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: kapasitasC,
              decoration: const InputDecoration(labelText: 'Kapasitas Muatan Box', prefixIcon: Icon(Icons.inventory_2_outlined)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                AppData.kendaraan = kendaraanC.text.trim();
                AppData.platNomor = platC.text.trim();
                AppData.kapasitasMaks = kapasitasC.text.trim();
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✓ Data kendaraan armada berhasil diperbarui!'), backgroundColor: primaryGreen),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showTimbanganModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Perangkat Timbangan Digital', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.bluetooth_connected, color: primaryGreen, size: 28),
              title: const Text('SC-04 Bluetooth Scale (Aktif)'),
              subtitle: const Text('Baterai: 98% • Akurasi 0.1 Kg • Siap lapangan'),
              trailing: const Text('98%', style: TextStyle(fontWeight: FontWeight.bold, color: primaryGreen, fontSize: 16)),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✓ Kalibrasi SC-04 Bluetooth sukses (0.00 Kg).'), backgroundColor: primaryGreen),
                  );
                },
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text('Uji Kalibrasi / Nol-kan Timbangan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, padding: const EdgeInsets.symmetric(vertical: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCSDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Pusat Bantuan & CS Kurir', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.headset_mic, color: primaryGreen),
              title: const Text('Dispatch Pusat Operasional REGREEN'),
              subtitle: const Text('0812-4596-6332 (Siaga 07:00 - 18:00 WIT)'),
              trailing: const Icon(Icons.phone, color: primaryGreen),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Menghubungi Dispatch Pusat Operasional REGREEN...'), backgroundColor: primaryGreen),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat, color: primaryGreen),
              title: const Text('WhatsApp Hotline Penjemputan'),
              subtitle: const Text('Laporkan kendala rute, timbangan, atau nasabah'),
              trailing: const Icon(Icons.open_in_new, color: primaryGreen),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Membuka WhatsApp Hotline Penjemputan...'), backgroundColor: primaryGreen),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar Akun Mitra?'),
        content: const Text('Anda akan keluar dari akun kurir dan harus masuk kembali untuk menerima order jemputan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ApiService.logout();
              AppData.reset();
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Ya, Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final driverName = AppData.namaUser.isNotEmpty ? AppData.namaUser : 'Ahmad Fauzi';
    final idArmada = AppData.idArmada.isNotEmpty ? AppData.idArmada : 'ARM-03 Ternate Selatan';
    final email = AppData.emailUser.isNotEmpty ? AppData.emailUser : 'kurir@regreen.com';
    final noHp = AppData.noHp.isNotEmpty ? AppData.noHp : '081245966332';
    final avatarUrl = AppData.fotoProfil.isNotEmpty
        ? AppData.fotoProfil
        : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7),
      appBar: AppBar(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Profil Mitra Kurir', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HEADER PROFIL KURIR
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              decoration: const BoxDecoration(
                color: primaryGreen,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(avatarUrl),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.verified, color: primaryGreen, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    driverName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'ID Armada: $idArmada',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    '$email • $noHp',
                    style: const TextStyle(color: Colors.white60, fontSize: 11),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${AppData.ratingKurir} (${AppData.totalUlasanKurir} ulasan kepuasan)',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 2. KENDARAAN ARMADA (Clickable to Edit)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InkWell(
                onTap: _showEditKendaraanDialog,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Informasi Kendaraan & Muatan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text('Edit >', style: TextStyle(color: primaryGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.two_wheeler, color: primaryGreen, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppData.kendaraan, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                Text('Plat: ${AppData.platNomor} • STNK Aktif', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                Text('Box Muatan Khusus (${AppData.kapasitasMaks})', style: const TextStyle(fontSize: 11, color: primaryGreen, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 3. HARDWARE & PERANGKAT TIMBANGAN (Clickable)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InkWell(
                onTap: _showTimbanganModal,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.bluetooth_connected, color: primaryGreen, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Timbangan Gantung Digital SC-04', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            Text('Bluetooth Otomatis • Baterai 98%', style: TextStyle(fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('Aktif', style: TextStyle(color: primaryGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 4. MENU PENGATURAN & SWITCH PERAN
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.people_outline, color: primaryGreen),
                      title: const Text('Beralih ke Mode Nasabah (Warga)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      subtitle: const Text('Kelola tabungan sampah pribadi Anda', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () {
                        AppData.role = 'nasabah';
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const MainNavigationView()),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.support_agent, color: Colors.black87),
                      title: const Text('Bantuan & CS Operasional Kurir', style: TextStyle(fontSize: 13)),
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: _showCSDialog,
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text('Keluar Akun (Logout)', style: TextStyle(fontSize: 13, color: Colors.red, fontWeight: FontWeight.bold)),
                      trailing: const Icon(Icons.chevron_right, color: Colors.red),
                      onTap: _showLogoutDialog,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

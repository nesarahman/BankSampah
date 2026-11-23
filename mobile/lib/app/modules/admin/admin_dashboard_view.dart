import 'package:flutter/material.dart';
import '../auth/login_view.dart';
import '../../../app_data.dart';
import '../../../api_service.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminDashboardView(),
    ),
  );
}

class AdminDashboardView extends StatefulWidget {
  final Function(int)? onTabChange;
  final bool showBottomNav;

  const AdminDashboardView({
    super.key,
    this.onTabChange,
    this.showBottomNav = false,
  });

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  int _selectedIndex = 0;
  String _totalSampah = '48.6 Ton';
  String _orderSelesai = '1.842';
  String _nasabahAktif = '4.280';
  String _kurirArmada = '24 Unit';

  @override
  void initState() {
    super.initState();
    _fetchDashboard();
  }

  Future<void> _fetchDashboard() async {
    final res = await ApiService.getAdminDashboard();
    if (res['success'] == true && res['data'] != null && mounted) {
      final metrics = res['data']['metrics'];
      if (metrics != null) {
        setState(() {
          if (metrics['total_sampah'] != null) _totalSampah = metrics['total_sampah'].toString();
          if (metrics['order_selesai'] != null) _orderSelesai = metrics['order_selesai'].toString();
          if (metrics['nasabah_aktif'] != null) _nasabahAktif = metrics['nasabah_aktif'].toString();
          if (metrics['kurir_armada'] != null) _kurirArmada = '${metrics['kurir_armada']} Unit';
        });
      }
    }
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar dari Admin?'),
        content: const Text('Apakah Anda yakin ingin keluar dari sesi Administrator?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              AppData.reset();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginView()),
                (route) => false,
              );
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  void _showArmadaDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.two_wheeler, color: Color(0xFF2E7D32), size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Monitoring Armada Ternate (Live)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.motorcycle, color: Color(0xFF2E7D32)),
              title: Text('ARM-01 • Ahmad Fauzi (DG 4582 KT)'),
              subtitle: Text('Rute: Ternate Tengah (Beban 72%) • Online'),
              trailing: Icon(Icons.check_circle, color: Colors.green, size: 18),
            ),
            const ListTile(
              leading: Icon(Icons.motorcycle, color: Colors.orange),
              title: Text('ARM-02 • Pak Ruslan (DG 3192 KT)'),
              subtitle: Text('Rute: Ternate Selatan (Beban 95% - Penuh) • Sibuk'),
              trailing: Icon(Icons.warning, color: Colors.orange, size: 18),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF2E7D32);
    const Color bgLight = Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: bgLight,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. HEADER / APP BAR
                  _buildHeader(primaryGreen),
                  const SizedBox(height: 16),

                  // 2. CARD PROFIL ADMIN
                  _buildAdminProfileCard(primaryGreen),
                  const SizedBox(height: 16),

                  // 3. BANNER PERINGATAN
                  _buildWarningBanner(),
                  const SizedBox(height: 20),

                  // 4. METRIK OPERASIONAL
                  _buildSectionTitle(
                    title: 'Metrik Operasional',
                    subtitle: 'Pembaruan: Real-time',
                  ),
                  const SizedBox(height: 12),
                  _buildMetricsGrid(primaryGreen),
                  const SizedBox(height: 20),

                  // 5. AKSES CEPAT PENGELOLAAN
                  _buildSectionTitle(
                    title: 'Akses Cepat Pengelolaan',
                    subtitle: 'Semua Menu',
                    isButton: true,
                  ),
                  const SizedBox(height: 12),
                  _buildQuickAccessGrid(primaryGreen),
                  const SizedBox(height: 20),

                  // 6. AKTIVITAS MINGGUAN
                  _buildWeeklyActivityCard(primaryGreen),
                  const SizedBox(height: 20),

                  // 7. DISTRIBUSI ARMADA
                  _buildFleetDistributionCard(primaryGreen),
                  const SizedBox(height: 80), // space untuk bottom nav
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: widget.showBottomNav ? _buildBottomNav(primaryGreen) : null,
    );
  }

  // ============================================================
  // 1. HEADER
  // ============================================================
  Widget _buildHeader(Color primaryGreen) {
    return Row(
      children: [
        const Text(
          'REGREEN Admin',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF121C2C)),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: primaryGreen.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'SUPERADMIN',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: primaryGreen),
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.red, size: 20),
          tooltip: 'Keluar',
          onPressed: _confirmLogout,
        ),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: primaryGreen.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.person, color: primaryGreen, size: 20),
        ),
      ],
    );
  }

  // ============================================================
  // 2. CARD PROFIL ADMIN
  // ============================================================
  Widget _buildAdminProfileCard(Color primaryGreen) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.shield, color: primaryGreen, size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Admin Ternate..',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'SUPERADMIN',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD4A017),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.circle, size: 8, color: Color(0xFF2E7D32)),
                        SizedBox(width: 4),
                        Text(
                          'Sistem Operasional Online',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Text(
                '3',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 3. BANNER PERINGATAN
  // ============================================================
  Widget _buildWarningBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFCDD2), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Color(0xFFD32F2F),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Tindakan Diperlukan Segera',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'KRITIS',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD32F2F),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  '• 3 permohonan penarikan saldo belum diproses >2 jam.',
                  style: TextStyle(fontSize: 11, color: Colors.black87),
                ),
                SizedBox(height: 2),
                Text(
                  '• 2 armada kargo (TR-04, TR-07) mendekati kapasitas 95%.',
                  style: TextStyle(fontSize: 11, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================
  Widget _buildSectionTitle({
    required String title,
    required String subtitle,
    bool isButton = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        isButton
            ? TextButton(
                onPressed: () {},
                child: Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF2E7D32),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : Text(
                subtitle,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
      ],
    );
  }

  // ============================================================
  // 4. METRIK OPERASIONAL (GRID 2x2)
  // ============================================================
  Widget _buildMetricsGrid(Color primaryGreen) {
    final List<Map<String, dynamic>> metrics = [
      {
        'icon': Icons.recycling,
        'badge': '+14%',
        'value': _totalSampah,
        'label': 'Sampah Terkumpul',
      },
      {
        'icon': Icons.local_shipping,
        'badge': 'Selesai',
        'value': _orderSelesai,
        'label': 'Order Jemput Berhasil',
      },
      {
        'icon': Icons.groups,
        'badge': '+38 baru',
        'value': _nasabahAktif,
        'label': 'Nasabah Warga Aktif',
      },
      {
        'icon': Icons.two_wheeler,
        'badge': '22 Jalan',
        'value': _kurirArmada,
        'label': 'Kurir Motor Kargo',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.4,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final m = metrics[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(m['icon'], color: primaryGreen, size: 20),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      m['badge'],
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                m['value'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                m['label'],
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // 5. AKSES CEPAT PENGELOLAAN (GRID 2x2)
  // ============================================================
  Widget _buildQuickAccessGrid(Color primaryGreen) {
    final List<Map<String, dynamic>> menus = [
      {
        'label': 'Hari ini',
        'labelColor': primaryGreen,
        'title': 'Kelola Harga Sampah',
        'desc': 'Katalog harga beli per kg & update harian',
        'action': 'Buka Katalog >',
      },
      {
        'label': '3 Pending',
        'labelColor': Colors.red,
        'title': 'Verifikasi Tarik Saldo',
        'desc': 'Pencairan kas nasabah & transfer bank',
        'action': 'Proses Klaim >',
      },
      {
        'label': '4.3k User',
        'labelColor': Colors.grey,
        'title': 'Manajemen Pengguna',
        'desc': 'Data nasabah terverifikasi & akun kurir',
        'action': 'Kelola Akun >',
      },
      {
        'label': 'Live GPS',
        'labelColor': primaryGreen,
        'title': 'Monitoring Armada',
        'desc': 'Radar rute penjemputan real-time Ternate',
        'action': 'Pantau Map >',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.15,
      ),
      itemCount: menus.length,
      itemBuilder: (context, index) {
        final m = menus[index];
        return InkWell(
          onTap: () {
            if (index == 0) {
              widget.onTabChange?.call(1);
            } else if (index == 1) {
              widget.onTabChange?.call(2);
            } else if (index == 2) {
              widget.onTabChange?.call(3);
            } else if (index == 3) {
              _showArmadaDialog();
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: (m['labelColor'] as Color).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    m['label'],
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: m['labelColor'],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  m['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Text(
                    m['desc'],
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  m['action'],
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // 6. AKTIVITAS MINGGUAN
  // ============================================================
  Widget _buildWeeklyActivityCard(Color primaryGreen) {
    final List<Map<String, dynamic>> chartData = [
      {'day': 'Sen', 'value': 180},
      {'day': 'Sel', 'value': 210},
      {'day': 'Rab', 'value': 195},
      {'day': 'Kam', 'value': 220},
      {'day': 'Jum', 'value': 240},
      {'day': 'Sab', 'value': 312, 'peak': true},
      {'day': 'Min', 'value': 150},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aktivitas Mingguan',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Rata-rata 260 penjemputan/hari',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Puncak: Sabtu',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              '312 Order',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF2E7D32),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // BAR CHART
          SizedBox(
            height: 130,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: chartData.map((d) {
                final isPeak = d['peak'] == true;
                final height = (d['value'] as int) / 312 * 100;
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (isPeak)
                        const Text(
                          '312',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        )
                      else
                        const SizedBox(height: 14),
                      const SizedBox(height: 4),
                      Container(
                        height: height,
                        width: 18,
                        decoration: BoxDecoration(
                          color: isPeak
                              ? primaryGreen
                              : primaryGreen.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        d['day'],
                        style: TextStyle(
                          fontSize: 10,
                          color: isPeak ? primaryGreen : Colors.grey[600],
                          fontWeight: isPeak
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: primaryGreen.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Color(0xFF2E7D32),
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Target minggu terjual 108%',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Detail Log',
                  style: TextStyle(
                    color: Color(0xFF2E7D32),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 7. DISTRIBUSI ARMADA
  // ============================================================
  Widget _buildFleetDistributionCard(Color primaryGreen) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Distribusi Armada Ternate',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '14 Zona Aktif',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Map_icon.svg/240px-Map_icon.svg.png',
                ),
                fit: BoxFit.cover,
                opacity: 0.3,
              ),
            ),
            child: Stack(
              children: [
                // Pin lokasi
                Positioned(
                  top: 40,
                  left: 60,
                  child: Icon(Icons.location_on, color: primaryGreen, size: 28),
                ),
                Positioned(
                  top: 70,
                  left: 140,
                  child: Icon(Icons.location_on, color: Colors.red, size: 28),
                ),
                Positioned(
                  top: 30,
                  left: 200,
                  child: Icon(Icons.location_on, color: primaryGreen, size: 24),
                ),
                // Banner bawah
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.circle, size: 8, color: Colors.red),
                        SizedBox(width: 6),
                        Text(
                          'Ternate Tengah & Selatan: Beban Tinggi',
                          style: TextStyle(fontSize: 10, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 8. BOTTOM NAVIGATION BAR
  // ============================================================
  Widget _buildBottomNav(Color primaryGreen) {
    final List<Map<String, dynamic>> items = [
      {'icon': Icons.dashboard, 'label': 'Ringkasan'},
      {'icon': Icons.local_shipping, 'label': 'Penjemputan'},
      {'icon': Icons.account_balance_wallet, 'label': 'Keuangan'},
      {'icon': Icons.settings, 'label': 'Konfigurasi'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (i) {
            final isActive = i == _selectedIndex;
            return Expanded(
              child: InkWell(
                onTap: () => setState(() => _selectedIndex = i),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            items[i]['icon'],
                            color: isActive ? primaryGreen : Colors.grey,
                            size: 22,
                          ),
                          if (i == 2) // titik merah notifikasi di Keuangan
                            Positioned(
                              right: -4,
                              top: -2,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        items[i]['label'],
                        style: TextStyle(
                          fontSize: 10,
                          color: isActive ? primaryGreen : Colors.grey,
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

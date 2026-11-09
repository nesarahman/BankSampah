import 'package:flutter/material.dart';
import 'mitra_navigasi_view.dart';
import '../../../api_service.dart';
import '../../../app_data.dart';

class MitraTugasView extends StatefulWidget {
  const MitraTugasView({super.key});

  @override
  State<MitraTugasView> createState() => _MitraTugasViewState();
}

class _MitraTugasViewState extends State<MitraTugasView> {
  static const primaryGreen = Color(0xFF2E7D32);
  bool isOnline = true;
  bool _isLoading = false;

  List<Map<String, dynamic>> orderMasuk = [
    {
      'id': 'REG-8902',
      'nama': 'Ibu Salma Latif',
      'jenis': 'Kardus Box & Botol PET Bening',
      'berat': '~18.5 kg',
      'jarak': '1.2 km (4 mnt)',
      'alamat': 'Jl. Cengkeh No. 14, Gamalama (Dekat Pasar...)',
      'rute': 'Rute tercepat via Jl. Ahmad Yani',
      'prioritas': 'Prioritas Baru',
      'prioritasColor': Color(0xFFE8F5E9),
      'prioritasTextColor': Color(0xFF2E7D32),
      'estimasiItem': [
        {'nama': 'Kardus Box', 'berat': '~15 kg', 'catatan': 'Tersortir Rapi', 'icon': Icons.inventory_2_outlined},
        {'nama': 'PET Bening', 'berat': '~4 kg', 'catatan': 'Bersih & Pipih', 'icon': Icons.local_drink_outlined},
      ],
      'catatanKhusus': 'Kardus sudah diikat tali rafia di teras depan samping garasi, botol plastik bersih tanpa tutup dalam karung terpisah.',
      'patokan': 'Depan Musholla Al-Muhajirin, pagar hitam',
      'telepon': '081245966332',
    },
    {
      'id': 'REG-8903',
      'nama': 'Pak Ruslan Taher',
      'jenis': 'Kaleng Aluminium & Besi Tipis',
      'berat': '~34.0 kg',
      'jarak': '2.8 km (9 mnt)',
      'alamat': 'Kompleks Bastiong Permai Blok C2',
      'rute': 'Rute via Jl. Raya Bastiong',
      'prioritas': '5 Menit Lalu',
      'prioritasColor': Color(0xFFFFF3E0),
      'prioritasTextColor': Color(0xFFE65100),
      'estimasiItem': [
        {'nama': 'Kaleng Aluminium', 'berat': '~20 kg', 'catatan': 'Dibersihkan', 'icon': Icons.science_outlined},
        {'nama': 'Besi Tipis', 'berat': '~14 kg', 'catatan': 'Terpisah', 'icon': Icons.hardware_outlined},
      ],
      'catatanKhusus': 'Barang sudah ditumpuk dekat gerbang utama komplek, siap angkut.',
      'patokan': 'Blok C2 No. 15, pagar hijau',
      'telepon': '081234567890',
    },
    {
      'id': 'REG-8904',
      'nama': 'Siti Rahma',
      'jenis': 'Minyak Jelantah (UCO Jeriken)',
      'berat': '~10 L (9 kg)',
      'jarak': '3.4 km',
      'alamat': 'Jl. Revolusi, Kalumata',
      'rute': 'Rute via Jl. Pantai Kalumata',
      'prioritas': 'Limbah Cair',
      'prioritasColor': Color(0xFFE0F2F1),
      'prioritasTextColor': Color(0xFF00796B),
      'estimasiItem': [
        {'nama': 'Minyak Jelantah (UCO)', 'berat': '~10 L', 'catatan': 'Dalam 2 Jeriken', 'icon': Icons.water_drop_outlined},
      ],
      'catatanKhusus': 'Minyak jelantah sudah disaring, dalam jeriken 5L tertutup rapat.',
      'patokan': 'Sebelah Toko Berkah Kalumata',
      'telepon': '082199887766',
    },
  ];

  @override
  void initState() {
    super.initState();
    isOnline = AppData.isMitraOnline;
    _fetchMitraDashboard();
  }

  Future<void> _fetchMitraDashboard() async {
    setState(() => _isLoading = true);
    await ApiService.getMitraDashboard();
    if (mounted) {
      setState(() {
        _isLoading = false;
        isOnline = AppData.isMitraOnline;
      });
    }
  }

  void _toggleOnlineStatus() {
    setState(() {
      isOnline = !isOnline;
      AppData.isMitraOnline = isOnline;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isOnline ? Icons.check_circle : Icons.pause_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              isOnline
                  ? 'Status ONLINE: Siap menerima order jemputan sampah!'
                  : 'Status OFFLINE: Mode istirahat diaktifkan.',
            ),
          ],
        ),
        backgroundColor: isOnline ? primaryGreen : Colors.grey.shade800,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _terimaOrder(int index) {
    final order = orderMasuk[index];
    setState(() {
      orderMasuk.removeAt(index);
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MitraNavigasiView(orderData: order),
      ),
    );
  }

  void _showTolakDialog(int index) {
    final order = orderMasuk[index];
    String selectedReason = 'Muatan Armada Penuh';
    final reasons = [
      'Muatan Armada Penuh',
      'Jarak Terlalu Jauh',
      'Ada Kendala Kendaraan',
      'Waktu Jemput Tidak Sesuai',
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.orange),
              SizedBox(width: 8),
              Text('Tolak Order Ini?'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order #${order['id']} dari ${order['nama']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text('Pilih alasan penolakan:', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 8),
              ...reasons.map((r) => RadioListTile<String>(
                    title: Text(r, style: const TextStyle(fontSize: 13)),
                    value: r,
                    groupValue: selectedReason,
                    activeColor: primaryGreen,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    onChanged: (val) {
                      if (val != null) setDialogState(() => selectedReason = val);
                    },
                  )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  orderMasuk.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Order #${order['id']} ditolak: $selectedReason'),
                    backgroundColor: Colors.grey.shade800,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Tolak Order', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showRincianPendapatan() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Rincian Pendapatan Hari Ini', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const Divider(),
            _buildRincianItem('Komisi Dasar (${AppData.targetSelesai} Jemputan Selesai)', 'Rp ${AppData.formatAngka(AppData.pendapatanHariIni - AppData.bonusInsentif)}'),
            _buildRincianItem('Bonus Insentif Tonase (>50 kg)', '+Rp 25.000', isGreen: true),
            _buildRincianItem('Tips Sukarela Nasabah', 'Rp 0'),
            const Divider(),
            _buildRincianItem('Total Bersih Hari Ini', 'Rp ${AppData.formatAngka(AppData.pendapatanHariIni)}', isBold: true),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _showTarikSaldoDialog();
                },
                style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, padding: const EdgeInsets.symmetric(vertical: 12)),
                child: const Text('Tarik Komisi Sekarang', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRincianItem(String label, String value, {bool isGreen = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isGreen ? primaryGreen : (isBold ? Colors.black : Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }

  void _showTarikSaldoDialog() {
    final nominalController = TextEditingController(text: '50000');
    final rekeningController = TextEditingController(text: '081245966332');
    String selectedMetode = 'DANA';
    final metodeList = ['DANA', 'GoPay', 'OVO', 'BCA', 'Mandiri', 'BRI'];
    bool isWithdrawing = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.account_balance_wallet, color: primaryGreen),
              SizedBox(width: 8),
              Text('Tarik Komisi Kurir'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Saldo Siap Tarik: Rp ${AppData.formatAngka(AppData.saldoMitra)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: primaryGreen, fontSize: 13),
                ),
                const SizedBox(height: 14),
                const Text('Nominal Penarikan (Rp):', style: TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 4),
                TextField(
                  controller: nominalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: 'Rp ',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Metode Pencairan:', style: TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: selectedMetode,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: metodeList
                      .map((m) => DropdownMenuItem(value: m, child: Text(m, style: const TextStyle(fontSize: 13))))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setModalState(() => selectedMetode = val);
                  },
                ),
                const SizedBox(height: 12),
                const Text('Nomor Rekening / E-Wallet:', style: TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 4),
                TextField(
                  controller: rekeningController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isWithdrawing ? null : () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: isWithdrawing
                  ? null
                  : () async {
                      final nominal = int.tryParse(nominalController.text.replaceAll('.', '').trim()) ?? 0;
                      if (nominal < 10000) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Minimal penarikan adalah Rp 10.000')),
                        );
                        return;
                      }

                      setModalState(() => isWithdrawing = true);
                      final res = await ApiService.tarikSaldoMitra(
                        nominal: nominal,
                        metode: selectedMetode,
                        nomorTujuan: rekeningController.text.trim(),
                      );

                      if (!context.mounted) return;
                      Navigator.pop(ctx);
                      setState(() {});

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(res['message'] ?? 'Penarikan berhasil diproses!'),
                          backgroundColor: res['success'] == true ? primaryGreen : Colors.red,
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
              child: isWithdrawing
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Cairkan Sekarang', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Pemberitahuan Kurir', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const Divider(),
            _buildNotifTile(
              icon: Icons.local_shipping,
              color: primaryGreen,
              title: 'Order Prioritas Baru!',
              desc: 'Ibu Salma Latif meminta penjemputan sampah kardus di Gamalama.',
              time: 'Baru saja',
            ),
            _buildNotifTile(
              icon: Icons.monetization_on,
              color: Colors.orange,
              title: 'Bonus Insentif Harian Aktif',
              desc: 'Kumpulkan 4 penjemputan lagi untuk klaim bonus Rp 25.000.',
              time: '1 jam lalu',
            ),
            _buildNotifTile(
              icon: Icons.bluetooth_connected,
              color: Colors.blue,
              title: 'Timbangan SC-04 Terhubung',
              desc: 'Baterai 98%. Siap melakukan penimbangan akurat di lapangan.',
              time: '3 jam lalu',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotifTile({
    required IconData icon,
    required Color color,
    required String title,
    required String desc,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text(time, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(fontSize: 12, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTimbanganDiagnostic() {
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
                const Text('Diagnostik Hardware Timbangan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.bluetooth_connected, color: primaryGreen, size: 30),
              title: const Text('SC-04 Digital Hanging Scale', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: const Text('Status: Terhubung via BLE • Kalibrasi Otomatis Aktif'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(6)),
                child: const Text('Siap Pakai', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFF5F7F5), borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: const [
                        Icon(Icons.battery_charging_full, color: primaryGreen),
                        SizedBox(height: 4),
                        Text('Baterai 98%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text('Tahan ~16 Jam', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFF5F7F5), borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: const [
                        Icon(Icons.scale, color: primaryGreen),
                        SizedBox(height: 4),
                        Text('Sensitivitas 0.1 Kg', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text('Maks Muat 150 Kg', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✓ Timbangan berhasil di-Nol-kan (Tare Reset 0.00 Kg).'),
                      backgroundColor: primaryGreen,
                    ),
                  );
                },
                icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
                label: const Text('Nol-kan Timbangan (Tare / Kalibrasi Ulang)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, padding: const EdgeInsets.symmetric(vertical: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPetaPreview(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.map_outlined, color: primaryGreen),
            const SizedBox(width: 8),
            Text('Rute: ${order['nama']}'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 130,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFC8E6C9)),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.navigation, color: primaryGreen, size: 36),
                    const SizedBox(height: 6),
                    Text(
                      'Peta GPS Terkoneksi (${order['jarak']})',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: primaryGreen),
                    ),
                    Text(order['rute'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text('Alamat: ${order['alamat']}', style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Text('Patokan: ${order['patokan']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MitraNavigasiView(orderData: order)),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
            child: const Text('Buka Navigasi', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final driverName = AppData.namaUser.isNotEmpty ? AppData.namaUser : 'Ahmad Fauzi';
    final idArmada = AppData.idArmada.isNotEmpty ? AppData.idArmada : 'ARM-03 Ternate Selatan';
    final avatarUrl = AppData.fotoProfil.isNotEmpty
        ? AppData.fotoProfil
        : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.eco, color: primaryGreen, size: 20),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'REGREEN',
                  style: TextStyle(
                    color: primaryGreen,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Mitra Kurir Armada',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.black87),
                onPressed: _showNotificationSheet,
              ),
              Positioned(
                right: 12,
                top: 12,
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
          Padding(
            padding: const EdgeInsets.only(right: 14.0, left: 2.0),
            child: InkWell(
              onTap: _toggleOnlineStatus,
              child: CircleAvatar(
                radius: 17,
                backgroundColor: isOnline ? const Color(0xFFE8F5E9) : Colors.grey.shade200,
                child: Icon(
                  Icons.two_wheeler,
                  color: isOnline ? primaryGreen : Colors.grey,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchMitraDashboard,
        color: primaryGreen,
        child: Column(
          children: [
            if (_isLoading)
              const LinearProgressIndicator(color: primaryGreen, minHeight: 2),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              // 1. KURIR STATUS CARD
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: primaryGreen, width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 22,
                            backgroundImage: NetworkImage(avatarUrl),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      driverName,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.verified, color: primaryGreen, size: 16),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 14),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${AppData.ratingKurir} (${AppData.totalUlasanKurir} ulasan)  •  $idArmada',
                                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Status Online Switch & Badge (Clickable)
                        InkWell(
                          onTap: _toggleOnlineStatus,
                          borderRadius: BorderRadius.circular(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isOnline ? const Color(0xFFE8F5E9) : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isOnline ? primaryGreen : Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      isOnline ? 'ONLINE' : 'OFFLINE',
                                      style: TextStyle(
                                        color: isOnline ? primaryGreen : Colors.grey.shade700,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      isOnline ? Icons.check : Icons.close,
                                      color: isOnline ? primaryGreen : Colors.grey.shade700,
                                      size: 13,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isOnline ? '● Siap Terima' : '○ Istirahat',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isOnline ? primaryGreen : Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Target Harian: ${AppData.targetSelesai}/${AppData.targetTotal} Selesai. Dapatkan bonus Rp 25.000 jika mencapai 12 jemputan!',
                            ),
                            backgroundColor: primaryGreen,
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Target Jemputan Hari Ini',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${AppData.targetSelesai}/${AppData.targetTotal} Selesai',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: primaryGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: (AppData.targetSelesai / AppData.targetTotal).clamp(0.0, 1.0),
                              backgroundColor: Colors.grey[200],
                              valueColor: const AlwaysStoppedAnimation<Color>(primaryGreen),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 2. KARTU PENDAPATAN BERSIH HARI INI
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: primaryGreen.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
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
                          'PENDAPATAN BERSIH HARI INI',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        InkWell(
                          onTap: _showRincianPendapatan,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Rincian >',
                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          'Rp ${AppData.formatAngka(AppData.pendapatanHariIni)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '+Rp ${AppData.formatAngka(AppData.bonusInsentif)} Bonus',
                            style: const TextStyle(color: Color(0xFFC8E6C9), fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Dua Sub-Card di dalam pendapatan
                    Row(
                      children: [
                        // Sub-card Kiri: Bonus Tonase
                        Expanded(
                          child: InkWell(
                            onTap: _showRincianPendapatan,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Bonus Insentif Tonase',
                                    style: TextStyle(color: Colors.white70, fontSize: 10),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '+Rp ${AppData.formatAngka(AppData.bonusInsentif)}',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  const Text(
                                    '@Capaian > 50 kg',
                                    style: TextStyle(color: Colors.white54, fontSize: 9),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Sub-card Kanan: Saldo Siap Tarik
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Saldo Siap Tarik',
                                  style: TextStyle(color: Colors.white70, fontSize: 10),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Rp ${AppData.formatAngka(AppData.saldoMitra)}',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                SizedBox(
                                  width: double.infinity,
                                  height: 24,
                                  child: ElevatedButton(
                                    onPressed: _showTarikSaldoDialog,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: primaryGreen,
                                      padding: EdgeInsets.zero,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: const Text(
                                      'Tarik Saldo',
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 3. DAFTAR ORDER MASUK
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Order Masuk',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${orderMasuk.length} Tersedia',
                          style: TextStyle(color: Colors.red.shade700, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      Icon(Icons.navigation, size: 12, color: primaryGreen),
                      SizedBox(width: 4),
                      Text('Radius 5 km', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (orderMasuk.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Center(
                    child: Column(
                      children: const [
                        Icon(Icons.done_all, color: primaryGreen, size: 36),
                        SizedBox(height: 8),
                        Text('Semua Order Telah Diproses!', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Nyalakan status ONLINE untuk menerima order berikutnya.', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ),
                )
              else
                ...List.generate(orderMasuk.length, (index) {
                  final order = orderMasuk[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
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
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: order['prioritasColor'],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.bolt, size: 12, color: order['prioritasTextColor']),
                                  const SizedBox(width: 2),
                                  Text(
                                    order['prioritas'],
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: order['prioritasTextColor'],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.navigation, size: 12, color: primaryGreen),
                                const SizedBox(width: 2),
                                Text(
                                  order['jarak'],
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.recycling, color: primaryGreen, size: 24),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        order['nama'],
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                      Text(
                                        order['berat'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 13,
                                          color: primaryGreen,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    order['jenis'],
                                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined, size: 13, color: Colors.grey),
                                      const SizedBox(width: 2),
                                      Expanded(
                                        child: Text(
                                          order['alamat'],
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.alt_route, size: 12, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  order['rute'],
                                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () => _showPetaPreview(order),
                              child: Row(
                                children: const [
                                  Text('Peta ', style: TextStyle(fontSize: 11, color: primaryGreen, fontWeight: FontWeight.bold)),
                                  Icon(Icons.open_in_new, size: 12, color: primaryGreen),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _showTolakDialog(index),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.grey.shade300),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                ),
                                child: const Text('✕ Tolak', style: TextStyle(color: Colors.black54, fontSize: 13)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton.icon(
                                onPressed: () => _terimaOrder(index),
                                icon: const Icon(Icons.check, size: 16, color: Colors.white),
                                label: const Text('Terima Order', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryGreen,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),

              const SizedBox(height: 10),

              // 4. BANNER TIMBANGAN DIGITAL SIAP (Clickable)
              InkWell(
                onTap: _showTimbanganDiagnostic,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFC8E6C9)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: primaryGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.scale, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Timbangan Digital Siap? (SC-04 Bluetooth)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: primaryGreen,
                              ),
                            ),
                            Text(
                              'Baterai 98% • Ketuk untuk kalibrasi / tes koneksi.',
                              style: TextStyle(fontSize: 11, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: primaryGreen),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    ],
  ),
),
);
  }
}

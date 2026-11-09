import 'package:flutter/material.dart';
import 'kurir_navigasi_page.dart';

class KurirDashboardPage extends StatefulWidget {
  const KurirDashboardPage({super.key});

  @override
  State<KurirDashboardPage> createState() => _KurirDashboardPageState();
}

class _KurirDashboardPageState extends State<KurirDashboardPage> {
  bool isOnline = true;
  int targetSelesai = 8;
  int targetTotal = 12;
  double pendapatanBersih = 145000;
  int _currentNavIndex = 0;

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

  void _terimaOrder(int index) {
    final order = orderMasuk[index];
    setState(() {
      orderMasuk.removeAt(index);
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KurirNavigasiPage(orderData: order),
      ),
    );
  }

  void _tolakOrder(int index) {
    final order = orderMasuk[index];
    setState(() {
      orderMasuk.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order #${order['id']} (${order['nama']}) telah ditolak.'),
        backgroundColor: Colors.grey.shade800,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF2E7D32);

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
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tidak ada notifikasi baru.')),
                  );
                },
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
            child: CircleAvatar(
              radius: 17,
              backgroundColor: const Color(0xFFE8F5E9),
              child: const Icon(Icons.two_wheeler, color: primaryGreen, size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                        child: const CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  'Ahmad Fauzi',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(Icons.verified, color: primaryGreen, size: 16),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: const [
                                Icon(Icons.star, color: Colors.amber, size: 14),
                                Text(
                                  ' 4.9 (148 ulasan)  •  Ternate...',
                                  style: TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Status Online Switch & Badge
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() => isOnline = !isOnline);
                            },
                            child: Container(
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
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Target Jemputan Hari Ini',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$targetSelesai/$targetTotal Selesai',
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
                      value: targetSelesai / targetTotal,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(primaryGreen),
                      minHeight: 6,
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
                      Container(
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
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      const Text(
                        'Rp 145.000',
                        style: TextStyle(
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
                        child: const Text(
                          '+Rp 25.000 Bonus',
                          style: TextStyle(color: Color(0xFFC8E6C9), fontSize: 10, fontWeight: FontWeight.bold),
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
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Bonus Insentif Tonase',
                                style: TextStyle(color: Colors.white70, fontSize: 10),
                              ),
                              SizedBox(height: 2),
                              Text(
                                '+Rp 25.000',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Text(
                                '@Capaian > 50 kg',
                                style: TextStyle(color: Colors.white54, fontSize: 9),
                              ),
                            ],
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
                              const Text(
                                'Rp 380.500',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                width: double.infinity,
                                height: 24,
                                child: ElevatedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Penarikan saldo kurir diproses ke rekening bank Anda.')),
                                    );
                                  },
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
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${orderMasuk.length} Tersedia',
                        style: const TextStyle(
                          color: Color(0xFFC62828),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Icon(Icons.near_me, size: 13, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      'Radius 5 km',
                      style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (orderMasuk.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: const [
                    Icon(Icons.check_circle_outline, size: 48, color: primaryGreen),
                    SizedBox(height: 12),
                    Text(
                      'Semua Order Telah Diterima!',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Menunggu order penjemputan baru di sekitar Anda...',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              )
            else
              ...List.generate(orderMasuk.length, (index) {
                final item = orderMasuk[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
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
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Card: Prioritas & Jarak
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: item['prioritasColor'] as Color,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  item['prioritas'] == 'Prioritas Baru'
                                      ? Icons.flash_on
                                      : (item['prioritas'] == 'Limbah Cair' ? Icons.water_drop : Icons.schedule),
                                  size: 11,
                                  color: item['prioritasTextColor'] as Color,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  item['prioritas'],
                                  style: TextStyle(
                                    color: item['prioritasTextColor'] as Color,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.navigation, size: 12, color: Colors.grey),
                              const SizedBox(width: 3),
                              Text(
                                item['jarak'],
                                style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item['berat'],
                                  style: const TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // User Info & Jenis Sampah
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: const Color(0xFFE8F5E9),
                            child: const Icon(Icons.recycling, color: primaryGreen, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['nama'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item['jenis'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.location_on, size: 13, color: Colors.grey),
                                    const SizedBox(width: 3),
                                    Expanded(
                                      child: Text(
                                        item['alamat'],
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

                      const SizedBox(height: 8),

                      // Rute Cepat Info
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F8E9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.alt_route, size: 14, color: primaryGreen),
                                const SizedBox(width: 6),
                                Text(
                                  item['rute'] ?? 'Rute tercepat via jalan utama',
                                  style: const TextStyle(fontSize: 11, color: primaryGreen, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const Row(
                              children: [
                                Text('Peta', style: TextStyle(fontSize: 11, color: primaryGreen, fontWeight: FontWeight.bold)),
                                Icon(Icons.arrow_outward, size: 12, color: primaryGreen),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const Divider(height: 16),

                      // Tombol Aksi: Tolak & Terima Order
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _tolakOrder(index),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey.shade700,
                                side: BorderSide(color: Colors.grey.shade300),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.close, size: 14),
                                  SizedBox(width: 4),
                                  Text('Tolak', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () => _terimaOrder(index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryGreen,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check, size: 16, color: Colors.white),
                                  SizedBox(width: 6),
                                  Text(
                                    'Terima Order',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
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
                );
              }),

            const SizedBox(height: 8),

            // 4. BANNER TIMBANGAN DIGITAL SIAP
            Container(
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
                          'Timbangan Digital Siap?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: primaryGreen,
                          ),
                        ),
                        Text(
                          'Pastikan baterai timbangan gantung terisi penuh sebelum jalan.',
                          style: TextStyle(fontSize: 11, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() => _currentNavIndex = index);
          if (index == 2) {
            // Mode Kembali ke Nasabah / Profil
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profil Kurir Ahmad Fauzi • ID: ARM-03 Ternate'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        selectedItemColor: primaryGreen,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Tugas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

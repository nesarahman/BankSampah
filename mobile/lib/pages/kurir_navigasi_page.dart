import 'package:flutter/material.dart';
import 'kurir_timbang_page.dart';

class KurirNavigasiPage extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const KurirNavigasiPage({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF2E7D32);
    final orderId = orderData['id'] ?? 'REG-8902';
    final namaNasabah = orderData['nama'] ?? 'Rizky Pratama';
    final alamat = orderData['alamat'] ?? 'Jl. Revolusi No. 42, Kel. Kalumata, Kota Ternate Selatan';
    final patokan = orderData['patokan'] ?? 'Depan Musholla Al-Muhajirin, pagar hitam';
    final catatan = orderData['catatanKhusus'] ??
        'Kardus sudah diikat tali rafia di teras depan samping garasi, botol plastik bersih tanpa tutup dalam karung terpisah.';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.eco, color: primaryGreen, size: 18),
            ),
            const SizedBox(width: 8),
            const Text(
              'REGREEN',
              style: TextStyle(
                color: primaryGreen,
                fontWeight: FontWeight.w900,
                fontSize: 18,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 14.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFE8F5E9),
              child: Icon(Icons.two_wheeler, color: primaryGreen, size: 18),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Subheader: Rute Aktif & Badge Status
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.near_me, size: 14, color: primaryGreen),
                    const SizedBox(width: 4),
                    Text(
                      'Rute Aktif #$orderId',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      CircleAvatar(radius: 3, backgroundColor: primaryGreen),
                      SizedBox(width: 4),
                      Text(
                        'Menuju Lokasi Nasabah',
                        style: TextStyle(
                          fontSize: 10,
                          color: primaryGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Peta & Navigasi Visual
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // MAP CARD WITH INTERACTIVE GRAPHIC
                  Container(
                    height: 220,
                    width: double.infinity,
                    color: const Color(0xFFE8F0E8),
                    child: Stack(
                      children: [
                        // Background Grid Map Simulation
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _MapRoutePainter(),
                          ),
                        ),

                        // Motor Icon "Posisi Anda"
                        Positioned(
                          left: 40,
                          bottom: 50,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: primaryGreen,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryGreen.withOpacity(0.4),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.two_wheeler, color: Colors.white, size: 18),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                                ),
                                child: const Text(
                                  'Posisi Anda',
                                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Target Destination Pin
                        Positioned(
                          right: 40,
                          top: 40,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2E7D32),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryGreen.withOpacity(0.4),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.location_on, color: Colors.white, size: 18),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                                ),
                                child: Text(
                                  namaNasabah,
                                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Recenter Compass Button
                        Positioned(
                          right: 16,
                          bottom: 16,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                            ),
                            child: const Icon(Icons.my_location, color: primaryGreen, size: 18),
                          ),
                        ),

                        // Top Floating ETA Info Box
                        Positioned(
                          top: 12,
                          left: 14,
                          right: 14,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8F5E9),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'A',
                                          style: TextStyle(
                                            color: primaryGreen,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          '1.4 km • 6 mnt',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          'Perkiraan Tiba 10:24 WIT',
                                          style: TextStyle(fontSize: 10, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Membuka rute di aplikasi Google Maps GPS...')),
                                    );
                                  },
                                  icon: const Icon(Icons.map_outlined, size: 14, color: primaryGreen),
                                  label: const Text(
                                    'Buka Maps',
                                    style: TextStyle(fontSize: 11, color: primaryGreen, fontWeight: FontWeight.bold),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: primaryGreen),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // DETAILS CONTENT SECTION
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. STEPPER PROGRES PENJEMPUTAN
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Progres Penjemputan',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              'Tahap 2 dari 3',
                              style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildStepItem(
                              icon: Icons.check,
                              title: 'Menuju Lokasi',
                              isActive: true,
                              isDone: true,
                            ),
                            Expanded(child: Container(height: 2, color: primaryGreen)),
                            _buildStepItem(
                              icon: Icons.location_on,
                              title: 'Tiba di Rumah',
                              isActive: true,
                              isDone: false,
                            ),
                            Expanded(child: Container(height: 2, color: Colors.grey.shade300)),
                            _buildStepItem(
                              icon: Icons.scale,
                              title: 'Timbang Sampah',
                              isActive: false,
                              isDone: false,
                            ),
                          ],
                        ),

                        const Divider(height: 24),

                        // 2. CUSTOMER CARD
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 22,
                              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150'),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    namaNasabah,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const SizedBox(height: 2),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F5E9),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      '★ Eco Hero • Warga Teladan',
                                      style: TextStyle(color: primaryGreen, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Tombol Telepon & Chat
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Menghubungi ${orderData['telepon'] ?? '081245966332'}...')),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE8F5E9),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.phone, color: primaryGreen, size: 20),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Membuka WhatsApp ke $namaNasabah...')),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: primaryGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.chat, color: Colors.white, size: 20),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // 3. ALAMAT PENJEMPUTAN
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAF9),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.location_on_outlined, size: 14, color: primaryGreen),
                                  SizedBox(width: 4),
                                  Text(
                                    'Alamat Penjemputan',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                alamat,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Patokan: $patokan',
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // 4. CATATAN KHUSUS NASABAH
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFDE7),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFFF59D)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.chat_bubble_outline, size: 13, color: Color(0xFFF57F17)),
                                  SizedBox(width: 4),
                                  Text(
                                    'CATATAN KHUSUS NASABAH',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFF57F17),
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '"$catatan"',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.black87,
                                  fontStyle: FontStyle.italic,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // 5. ESTIMASI SAMPAH DIJEMPUT
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Estimasi Sampah Dijemput',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '2 Kategori',
                              style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey.shade200),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.inventory_2_outlined, color: primaryGreen, size: 24),
                                    SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Kardus Box', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                        Text('~15 kg', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                                        Text('Tersortir Rapi', style: TextStyle(fontSize: 9, color: Colors.grey)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey.shade200),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.local_drink_outlined, color: primaryGreen, size: 24),
                                    SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('PET Bening', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                        Text('~4 kg', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                                        Text('Bersih & Pipih', style: TextStyle(fontSize: 9, color: Colors.grey)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // 6. ACTION BUTTON: SAYA SUDAH TIBA DI LOKASI
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => KurirTimbangPage(orderData: orderData),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryGreen,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.location_on, size: 18, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Saya Sudah Tiba di Lokasi',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Kendala Penjemputan?',
                              style: TextStyle(fontSize: 11, color: Colors.grey, decoration: TextDecoration.underline),
                            ),
                            Text(
                              'Kurir Armada T-03',
                              style: TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildStepItem({
    required IconData icon,
    required String title,
    required bool isActive,
    required bool isDone,
  }) {
    const primaryGreen = Color(0xFF2E7D32);

    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone || isActive ? primaryGreen : Colors.grey.shade200,
          ),
          child: Icon(
            icon,
            size: 16,
            color: isDone || isActive ? Colors.white : Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 9,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? primaryGreen : Colors.grey,
          ),
        ),
      ],
    );
  }
}

// Custom Painter untuk simulasi garis peta rute melengkung
class _MapRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2E7D32)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(60, size.height - 70);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.2,
      size.width - 60,
      60,
    );

    // Gambar garis jalan halus
    canvas.drawPath(path, paint);

    // Garis titik-titik putih di tengah jalan
    final dashPaint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, dashPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

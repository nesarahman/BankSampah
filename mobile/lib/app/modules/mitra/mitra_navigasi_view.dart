import 'package:flutter/material.dart';
import 'mitra_timbang_view.dart';
import '../../../app_data.dart';

class MitraNavigasiView extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const MitraNavigasiView({super.key, required this.orderData});

  static const primaryGreen = Color(0xFF2E7D32);

  void _showMapsSheet(BuildContext context) {
    final alamat = orderData['alamat'] ?? 'Jl. Revolusi No. 42, Kel. Kalumata, Kota Ternate Selatan';
    final patokan = orderData['patokan'] ?? 'Depan Musholla Al-Muhajirin, pagar hitam';

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
                const Text('Navigasi Rute GPS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.location_on, color: primaryGreen, size: 28),
              title: Text(alamat, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: Text('Patokan: $patokan\nEstimasi Rute: 1.4 km • 6 menit via Jl. Ahmad Yani', style: const TextStyle(fontSize: 11)),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Mengarahkan rute langsung ke aplikasi Google Maps GPS...'),
                      backgroundColor: primaryGreen,
                    ),
                  );
                },
                icon: const Icon(Icons.directions, color: Colors.white),
                label: const Text('Mulai Navigasi di Google Maps', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, padding: const EdgeInsets.symmetric(vertical: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCallDialog(BuildContext context) {
    final nama = orderData['nama'] ?? 'Nasabah';
    final telepon = orderData['telepon'] ?? '081245966332';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.phone, color: primaryGreen),
            SizedBox(width: 8),
            Text('Hubungi Nasabah'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Panggil $nama?', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Nomor Telepon: $telepon', style: const TextStyle(fontSize: 13, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Melakukan panggilan telepon ke $telepon ($nama)...'),
                  backgroundColor: primaryGreen,
                ),
              );
            },
            icon: const Icon(Icons.call, size: 16, color: Colors.white),
            label: const Text('Panggil Sekarang', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
          ),
        ],
      ),
    );
  }

  void _showWhatsAppDialog(BuildContext context) {
    final nama = orderData['nama'] ?? 'Nasabah';
    final telepon = orderData['telepon'] ?? '081245966332';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.chat, color: primaryGreen),
            SizedBox(width: 8),
            Text('Kirim Pesan WhatsApp'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kirim konfirmasi kedatangan ke $nama?', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(8)),
              child: Text(
                'Halo $nama, saya kurir REGREEN (${AppData.namaUser.isNotEmpty ? AppData.namaUser : "Ahmad Fauzi"}) sedang menuju lokasi penjemputan sampah Anda. Perkiraan tiba ~6 menit lagi.',
                style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Membuka chat WhatsApp ke $nama ($telepon)...'),
                  backgroundColor: primaryGreen,
                ),
              );
            },
            icon: const Icon(Icons.send, size: 16, color: Colors.white),
            label: const Text('Kirim WhatsApp', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
          ),
        ],
      ),
    );
  }

  void _showKendalaSheet(BuildContext context) {
    final kendalaList = [
      'Nasabah tidak berada di lokasi / rumah tutup',
      'Alamat penjemputan sulit diakses kendaraan',
      'Jenis/berat sampah tidak sesuai keterangan',
      'Kendala armada (ban kempes / mogok)',
      'Hubungi Pusat Komando Operasional REGREEN',
    ];

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
                const Text('Laporkan Kendala Penjemputan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const Divider(),
            ...kendalaList.map(
              (k) => ListTile(
                dense: true,
                leading: const Icon(Icons.report_problem_outlined, color: Colors.orange, size: 20),
                title: Text(k, style: const TextStyle(fontSize: 13)),
                trailing: const Icon(Icons.chevron_right, size: 18),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Laporan kendala dicatat: $k. CS sedang menghubungi Anda.'),
                      backgroundColor: Colors.orange.shade800,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

          // Scrollable Map & Order Details
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ROUTE GPS MAP PREVIEW
                  Container(
                    height: 220,
                    width: double.infinity,
                    color: const Color(0xFFE1E8E1),
                    child: Stack(
                      children: [
                        // Stylized Map Background
                        CustomPaint(
                          size: const Size(double.infinity, 220),
                          painter: _MapGridPainter(),
                        ),

                        // Route Polyline representation
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _RoutePolylinePainter(),
                          ),
                        ),

                        // Courier Icon Pin (Start)
                        Positioned(
                          left: 48,
                          bottom: 50,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: primaryGreen,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
                                  ],
                                ),
                                child: const Icon(Icons.two_wheeler, color: Colors.white, size: 18),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                                ),
                                child: const Text(
                                  'Posisi Anda',
                                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: primaryGreen),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Customer Pin (Destination)
                        Positioned(
                          right: 48,
                          top: 40,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
                                  ],
                                ),
                                child: const Icon(Icons.location_on, color: Colors.white, size: 18),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                                ),
                                child: Text(
                                  namaNasabah,
                                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Recenter Button
                        Positioned(
                          right: 16,
                          bottom: 16,
                          child: InkWell(
                            onTap: () => _showMapsSheet(context),
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
                                  onPressed: () => _showMapsSheet(context),
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

                        // 2. CUSTOMER CARD (Clickable Call & WhatsApp)
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
                            // Tombol Telepon & Chat (Clickable)
                            InkWell(
                              onTap: () => _showCallDialog(context),
                              borderRadius: BorderRadius.circular(20),
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
                            InkWell(
                              onTap: () => _showWhatsAppDialog(context),
                              borderRadius: BorderRadius.circular(20),
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
                        InkWell(
                          onTap: () => _showMapsSheet(context),
                          child: Container(
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
                                      'Alamat Penjemputan (Ketuk untuk rute)',
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  alamat,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.flag_outlined, size: 12, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        'Patokan: $patokan',
                                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

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
                                  Icon(Icons.note_alt_outlined, size: 14, color: Color(0xFFF57F17)),
                                  SizedBox(width: 4),
                                  Text(
                                    'CATATAN KHUSUS NASABAH',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFF57F17),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '"$catatan"',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black87,
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
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              '2 Kategori',
                              style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
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
                                  builder: (context) => MitraTimbangView(orderData: orderData),
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

                        // Kendala Penjemputan? (Clickable)
                        InkWell(
                          onTap: () => _showKendalaSheet(context),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Kendala Penjemputan?',
                                  style: TextStyle(fontSize: 11, color: Colors.grey, decoration: TextDecoration.underline),
                                ),
                                Text(
                                  AppData.idArmada.isNotEmpty ? AppData.idArmada : 'Kurir Armada T-03',
                                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
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
            color: isDone || isActive ? Colors.white : Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isDone || isActive ? FontWeight.bold : FontWeight.normal,
            color: isDone || isActive ? primaryGreen : Colors.grey,
          ),
        ),
      ],
    );
  }
}

// Custom Painter for Map Grid background simulation
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD0DDD0)
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.width; i += 30) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 30) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom Painter for Route Polyline simulation
class _RoutePolylinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(60, 150);
    path.quadraticBezierTo(size.width * 0.4, 180, size.width * 0.5, 110);
    path.quadraticBezierTo(size.width * 0.6, 50, size.width - 60, 60);

    final borderPaint = Paint()
      ..color = const Color(0xFF1B5E20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final polylinePaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, borderPaint);
    canvas.drawPath(path, polylinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

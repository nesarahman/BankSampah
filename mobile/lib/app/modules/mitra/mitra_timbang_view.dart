import 'package:flutter/material.dart';
import '../../../api_service.dart';
import '../../../app_data.dart';

class MitraTimbangView extends StatefulWidget {
  final Map<String, dynamic> orderData;

  const MitraTimbangView({super.key, required this.orderData});

  @override
  State<MitraTimbangView> createState() => _MitraTimbangViewState();
}

class _MitraTimbangViewState extends State<MitraTimbangView> {
  static const primaryGreen = Color(0xFF2E7D32);

  double beratKardus = 14.8;
  double beratBotol = 4.2;
  final double hargaKardus = 3000;
  final double hargaBotol = 4200;

  bool _isSubmitting = false;
  int _extraPhotoCount = 2;

  Future<void> _handleSelesaikan(double totalBerat, double totalSaldo) async {
    setState(() => _isSubmitting = true);

    final orderId = widget.orderData['id'] ?? '8902';
    await ApiService.selesaiPenjemputan(
      id: orderId,
      totalBerat: totalBerat,
      totalSaldo: totalSaldo,
      items: [
        {'nama': 'Kardus & Karton Tebal', 'berat': beratKardus, 'subtotal': (beratKardus * hargaKardus).toInt()},
        {'nama': 'Botol Plastik PET Bersih', 'berat': beratBotol, 'subtotal': (beratBotol * hargaBotol).toInt()},
      ],
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    _showSuccessDialog(totalBerat, totalSaldo);
  }

  void _showSuccessDialog(double totalBerat, double totalSaldo) {
    final namaNasabah = widget.orderData['nama'] ?? 'Rizky Pratama';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: primaryGreen, size: 54),
            ),
            const SizedBox(height: 16),
            const Text(
              'Penjemputan Selesai!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Saldo sebesar Rp ${_formatCurrency(totalSaldo)} berhasil dikirimkan langsung ke dompet nasabah $namaNasabah.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAF9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text('Total Timbangan', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      Text('${totalBerat.toStringAsFixed(1)} Kg', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  Container(width: 1, height: 28, color: Colors.grey.shade300),
                  Column(
                    children: const [
                      Text('Bonus Poin Hijau', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      Text('+62 Poin', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: primaryGreen)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx); // tutup dialog
                  Navigator.pop(context); // kembali dari timbang
                  Navigator.pop(context); // kembali dari navigasi ke tugas
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Kembali ke Dashboard Kurir', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditBeratDialog(String nama, double currentVal, ValueChanged<double> onSaved) {
    final c = TextEditingController(text: currentVal.toStringAsFixed(1));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Edit Berat: $nama', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: c,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Berat Timbangan (Kg)',
            suffixText: 'Kg',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              final val = double.tryParse(c.text.trim()) ?? currentVal;
              onSaved(val < 0 ? 0 : val);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showStrukWhatsApp(double totalBerat, double totalSaldo) {
    final namaNasabah = widget.orderData['nama'] ?? 'Rizky Pratama';
    final orderId = widget.orderData['id'] ?? 'REG-8902';
    final kurir = AppData.namaUser.isNotEmpty ? AppData.namaUser : 'Ahmad Fauzi';

    final textStruk = '''
*STRUK DIGITAL PENJEMPUTAN REGREEN*
----------------------------------------
No. Order : #$orderId
Nasabah   : $namaNasabah
Kurir     : $kurir (${AppData.idArmada})
Waktu     : ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} WIT

*RINCIAN TIMBANGAN:*
1. Kardus & Karton Tebal : ${beratKardus.toStringAsFixed(1)} Kg @ Rp 3.000 = Rp ${_formatCurrency(beratKardus * hargaKardus)}
2. Botol PET Bening      : ${beratBotol.toStringAsFixed(1)} Kg @ Rp 4.200 = Rp ${_formatCurrency(beratBotol * hargaBotol)}
----------------------------------------
*TOTAL BERAT  : ${totalBerat.toStringAsFixed(1)} Kg*
*TOTAL SALDO  : Rp ${_formatCurrency(totalSaldo)}*
*BONUS POIN   : +62 POIN HIJAU*
----------------------------------------
_Saldo telah langsung masuk ke dompet aplikasi REGREEN Anda._
Terima kasih telah berkontribusi menjaga kelestarian bumi Ternate! 🌱
''';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                const Text('Pratinjau Struk Digital WhatsApp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const Divider(),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F8E9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFC8E6C9)),
              ),
              child: SelectableText(
                textStruk,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 11, height: 1.4),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Struk berhasil disalin & dikirim ke WhatsApp $namaNasabah!'),
                      backgroundColor: primaryGreen,
                    ),
                  );
                },
                icon: const Icon(Icons.share, color: Colors.white, size: 18),
                label: const Text('Kirim Struk ke WhatsApp Nasabah', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, padding: const EdgeInsets.symmetric(vertical: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Tambah Bukti Foto Lapangan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: primaryGreen),
              title: const Text('Ambil Foto dengan Kamera'),
              onTap: () {
                Navigator.pop(ctx);
                setState(() => _extraPhotoCount++);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✓ Foto bukti lapangan berhasil ditambahkan!'), backgroundColor: primaryGreen),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: primaryGreen),
              title: const Text('Pilih dari Galeri Foto'),
              onTap: () {
                Navigator.pop(ctx);
                setState(() => _extraPhotoCount++);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✓ Foto dari galeri berhasil diunggah!'), backgroundColor: primaryGreen),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static String _formatCurrency(double val) {
    return val.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    double subtotalKardus = beratKardus * hargaKardus;
    double subtotalBotol = beratBotol * hargaBotol;
    double totalBerat = beratKardus + beratBotol;
    double totalSaldo = subtotalKardus + subtotalBotol;
    final orderId = widget.orderData['id'] ?? 'REG-8902';
    final namaNasabah = widget.orderData['nama'] ?? 'Rizky Pratama';

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. ORDER & PAYOUT HEADER
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: primaryGreen, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ORDER AKTIF • #$orderId',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          namaNasabah,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Metode Payout\nSaldo Dompet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 2. STEP TRACKER
            Row(
              children: [
                _buildStepperBadge(step: '1', title: 'Tiba', isDone: true, isActive: false),
                Expanded(child: Container(height: 2, color: primaryGreen)),
                _buildStepperBadge(step: '2', title: 'Timbang', isDone: false, isActive: true),
                Expanded(child: Container(height: 2, color: Colors.grey.shade300)),
                _buildStepperBadge(step: '3', title: 'Selesai', isDone: false, isActive: false),
              ],
            ),

            const SizedBox(height: 16),

            // 3. BLUETOOTH SCALE CONNECTED BANNER (Interactive Tare)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.bluetooth_connected, color: primaryGreen, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Timbangan Digital Portabel Terhubung',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'SC-04 Bluetooth • Kalibrasi Otomatis Aktif',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('✓ Timbangan digital SC-04 Bluetooth sinkron & kalibrasi ulang.'),
                          backgroundColor: primaryGreen,
                        ),
                      );
                    },
                    icon: const Icon(Icons.sync, size: 18, color: primaryGreen),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 4. HASIL TIMBANGAN DI TEMPAT
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Hasil Timbangan di Tempat',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  '2 Jenis Material',
                  style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Card Material 1: Kardus & Karton Tebal
            _buildItemTimbangCard(
              namaSampah: 'Kardus & Karton Tebal',
              hargaLabel: 'Rp 3.000 / Kg',
              berat: beratKardus,
              subtotal: subtotalKardus,
              icon: Icons.inventory_2_outlined,
              onChanged: (val) => setState(() => beratKardus = val < 0 ? 0 : val),
              onTapEdit: () => _showEditBeratDialog(
                'Kardus & Karton',
                beratKardus,
                (val) => setState(() => beratKardus = val),
              ),
            ),

            const SizedBox(height: 10),

            // Card Material 2: Botol Plastik PET Bersih
            _buildItemTimbangCard(
              namaSampah: 'Botol Plastik PET Bersih',
              hargaLabel: 'Rp 4.200 / Kg',
              berat: beratBotol,
              subtotal: subtotalBotol,
              icon: Icons.local_drink_outlined,
              onChanged: (val) => setState(() => beratBotol = val < 0 ? 0 : val),
              onTapEdit: () => _showEditBeratDialog(
                'Botol Plastik PET',
                beratBotol,
                (val) => setState(() => beratBotol = val),
              ),
            ),

            const SizedBox(height: 16),

            // 5. FOTO BUKTI LAPANGAN
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Foto Bukti Lapangan',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  '$_extraPhotoCount Wajib Terisi',
                  style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Photo Slots
            Row(
              children: [
                // Bukti 1: Layar Timbangan Digital
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                      color: const Color(0xFF1E2822),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.scale, color: Colors.white70, size: 28),
                              const SizedBox(height: 4),
                              Text(
                                '${totalBerat.toStringAsFixed(1)} KG',
                                style: const TextStyle(
                                  color: Color(0xFF81C784),
                                  fontFamily: 'monospace',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text('LED SCALE DISPLAY', style: TextStyle(color: Colors.white54, fontSize: 8)),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 6,
                          left: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: primaryGreen,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('✓ Terverifikasi', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Positioned(
                          bottom: 4,
                          left: 6,
                          right: 6,
                          child: Container(
                            color: Colors.black45,
                            padding: const EdgeInsets.all(2),
                            child: Text(
                              'Layar Timbangan Digital\n${totalBerat.toStringAsFixed(1)} Kg tercatat',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white, fontSize: 8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Bukti 2: Tumpukan di Tempat
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                      color: const Color(0xFFECEFF1),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.archive_outlined, color: Colors.brown, size: 32),
                              SizedBox(height: 4),
                              Text(
                                'Kardus & Botol',
                                style: TextStyle(color: Colors.black87, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              Text('Tersusun Rapi di Teras', style: TextStyle(color: Colors.grey, fontSize: 8)),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 6,
                          left: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: primaryGreen,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('✓ Siap Muat', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Positioned(
                          bottom: 4,
                          left: 6,
                          right: 6,
                          child: Container(
                            color: Colors.black45,
                            padding: const EdgeInsets.all(2),
                            child: const Text(
                              'Tumpukan di Tempat\nRapi & Terpilah',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Tombol Tambah Foto Bukti (Clickable)
            OutlinedButton.icon(
              onPressed: _showPhotoOptions,
              icon: const Icon(Icons.camera_alt_outlined, size: 16, color: primaryGreen),
              label: const Text('Tambah Foto Bukti Tambahan (+ Kamera)', style: TextStyle(fontSize: 11, color: primaryGreen, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade300),
                minimumSize: const Size(double.infinity, 38),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),

            const SizedBox(height: 16),

            // 6. KALKULASI INSTAN CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primaryGreen.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.calculate_outlined, color: Colors.white70, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'KALKULASI INSTAN',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Total Berat: ${totalBerat.toStringAsFixed(1)} Kg',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Total Saldo Masuk Dompet Nasabah:',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Rp ${_formatCurrency(totalSaldo)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: const [
                      Icon(Icons.shield_outlined, color: Color(0xFFC8E6C9), size: 12),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Saldo akan langsung terakumulasi ke aplikasi nasabah secara instan tanpa potongan biaya admin.',
                          style: TextStyle(color: Color(0xFFC8E6C9), fontSize: 9.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 7. SELESAIKAN PENJEMPUTAN BUTTON (Clickable with loading)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : () => _handleSelesaikan(totalBerat, totalSaldo),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check, size: 18, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Selesaikan Penjemputan & Kirim Saldo',
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

            const SizedBox(height: 10),

            // 8. CETAK / BAGIKAN STRUK WHATSAPP (Clickable)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showStrukWhatsApp(totalBerat, totalSaldo),
                icon: const Icon(Icons.share_outlined, size: 16, color: primaryGreen),
                label: const Text(
                  'Cetak / Bagikan Struk Digital WhatsApp',
                  style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: primaryGreen),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  static Widget _buildStepperBadge({
    required String step,
    required String title,
    required bool isDone,
    required bool isActive,
  }) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone || isActive ? primaryGreen : Colors.grey.shade300,
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : Text(
                    step,
                    style: TextStyle(
                      color: isDone || isActive ? Colors.white : Colors.grey.shade600,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isDone || isActive ? FontWeight.bold : FontWeight.normal,
            color: isDone || isActive ? primaryGreen : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildItemTimbangCard({
    required String namaSampah,
    required String hargaLabel,
    required double berat,
    required double subtotal,
    required IconData icon,
    required ValueChanged<double> onChanged,
    required VoidCallback onTapEdit,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: primaryGreen, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      namaSampah,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Text(
                      'Harga Resmi: $hargaLabel',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.bluetooth, size: 10, color: primaryGreen),
                    SizedBox(width: 2),
                    Text(
                      'Terkoneksi',
                      style: TextStyle(color: primaryGreen, fontSize: 9, fontWeight: FontWeight.bold),
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
              // Stepper Kontrol Berat
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      final newVal = (berat - 0.5);
                      onChanged(newVal < 0 ? 0 : newVal);
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Center(
                        child: Text('-', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onTapEdit,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      child: Text(
                        '${berat.toStringAsFixed(1)} KG',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => onChanged(berat + 0.5),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Center(
                        child: Text('+', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
              // Subtotal
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Subtotal', style: TextStyle(fontSize: 9, color: Colors.grey)),
                  Text(
                    'Rp ${_formatCurrency(subtotal)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: primaryGreen),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

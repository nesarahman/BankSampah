import 'package:flutter/material.dart';
import '../api_service.dart';

class KurirTimbangPage extends StatefulWidget {
  final Map<String, dynamic> orderData;

  const KurirTimbangPage({super.key, required this.orderData});

  @override
  State<KurirTimbangPage> createState() => _KurirTimbangPageState();
}

class _KurirTimbangPageState extends State<KurirTimbangPage> {
  double beratKardus = 14.8;
  double beratBotol = 4.2;
  double hargaKardus = 3000;
  double hargaBotol = 4200;

  static const primaryGreen = Color(0xFF2E7D32);
  bool _isSubmitting = false;

  Future<void> _handleSelesaikan(double totalBerat, double totalSaldo) async {
    setState(() => _isSubmitting = true);

    // Kirim data ke backend agar saldo dan poin nasabah bertambah otomatis
    await ApiService.selesaiPenjemputan(
      id: widget.orderData['id'] ?? '1',
      totalBerat: totalBerat,
      totalSaldo: totalSaldo,
      items: [
        {'nama': 'Kardus & Karton Tebal', 'berat': beratKardus, 'subtotal': beratKardus * hargaKardus},
        {'nama': 'Botol Plastik PET Bersih', 'berat': beratBotol, 'subtotal': beratBotol * hargaBotol},
      ],
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    _showSuccessDialog(totalBerat, totalSaldo);
  }

  void _showSuccessDialog(double totalBerat, double totalSaldo) {
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
              'Saldo sebesar Rp ${_formatCurrency(totalSaldo)} berhasil dikirimkan langsung ke dompet nasabah ${widget.orderData['nama'] ?? 'Rizky Pratama'}.',
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
                  Navigator.pop(context); // kembali dari navigasi ke dashboard
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
            // 1. ORDER AKTIF BANNER
            Container(
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

            // 3. BLUETOOTH SCALE CONNECTED BANNER
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
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
                        const SnackBar(content: Text('Timbangan digital SC-04 terkalibrasi ulang.')),
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
            ),

            const SizedBox(height: 16),

            // 5. FOTO BUKTI LAPANGAN (2 Wajib Terisi)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Foto Bukti Lapangan',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                Text(
                  '2 Wajib Terisi',
                  style: TextStyle(fontSize: 10, color: primaryGreen, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                // Bukti 1: Layar Timbangan
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                      color: const Color(0xFF263238),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.scale, color: Colors.white70, size: 30),
                              SizedBox(height: 4),
                              Text(
                                '14.80 KG',
                                style: TextStyle(
                                  color: Color(0xFF00E676),
                                  fontFamily: 'monospace',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('LED SCALE DISPLAY', style: TextStyle(color: Colors.white54, fontSize: 8)),
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
                            child: const Text(
                              'Layar Timbangan Digital\n14.8 Kg tercatat',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 8),
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

            // Tombol Tambah Foto Bukti
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Kamera foto bukti lapangan dibuka...')),
                );
              },
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

            // 7. SELESAIKAN PENJEMPUTAN BUTTON
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

            // 8. CETAK / BAGIKAN STRUK WHATSAPP
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Struk penjemputan Rp ${_formatCurrency(totalSaldo)} telah dikirim ke WhatsApp nasabah!'),
                      backgroundColor: primaryGreen,
                    ),
                  );
                },
                icon: const Icon(Icons.share_outlined, size: 16, color: primaryGreen),
                label: const Text(
                  'Cetak / Bagikan Struk Digital WhatsApp',
                  style: TextStyle(color: primaryGreen, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: primaryGreen),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: const Color(0xFFE8F5E9),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStepperBadge({
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
                ? const Icon(Icons.check, size: 13, color: Colors.white)
                : Text(
                    step,
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.grey.shade700,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? primaryGreen : (isDone ? Colors.black87 : Colors.grey),
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
    required Function(double) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
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
              Row(
                children: [
                  Icon(icon, color: primaryGreen, size: 20),
                  const SizedBox(width: 8),
                  Column(
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
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.bolt, color: primaryGreen, size: 10),
                    Text(
                      'Terkoneksi',
                      style: TextStyle(color: primaryGreen, fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Counter [-] 14.8 KG [+]
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => onChanged(berat - 0.5),
                      icon: const Icon(Icons.remove, size: 16),
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      padding: EdgeInsets.zero,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '${berat.toStringAsFixed(1)} KG',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    IconButton(
                      onPressed: () => onChanged(berat + 0.5),
                      icon: const Icon(Icons.add, size: 16),
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              // Subtotal Text
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Subtotal', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  Text(
                    'Rp ${_formatCurrency(subtotal)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
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

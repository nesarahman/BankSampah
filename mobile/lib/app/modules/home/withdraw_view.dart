import 'package:flutter/material.dart';

import '../../../api_service.dart';
import '../../../app_data.dart';

class WithdrawView extends StatefulWidget {
  const WithdrawView({super.key});

  @override
  State<WithdrawView> createState() => _WithdrawViewState();
}

class _WithdrawViewState extends State<WithdrawView> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedMethod = 'Transfer Bank';
  final List<String> _methods = [
    'Transfer Bank',
    'E-Wallet (Dana/OVO)',
    'Pulsa',
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Tarik Saldo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Card Saldo - Terhubung ke AppData & Backend
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Saldo Tersedia',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${AppData.formatAngka(AppData.saldoTersedia)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Minimum penarikan: Rp 10.000',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),

            // Form Tarik Saldo
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nominal Penarikan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Masukkan nominal (Rp)',
                      prefixText: 'Rp ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Pilih Nominal Cepat',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['10000', '25000', '50000', '100000'].map((
                      amount,
                    ) {
                      final formatted = AppData.formatAngka(int.parse(amount));
                      return GestureDetector(
                        onTap: () => _amountController.text = formatted,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Text(
                            'Rp $formatted',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Metode Penarikan
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Metode Penarikan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._methods.map((method) {
                    return RadioListTile<String>(
                      title: Text(method, style: const TextStyle(fontSize: 13)),
                      value: method,
                      groupValue: _selectedMethod,
                      activeColor: const Color(0xFF2E7D32),
                      onChanged: (value) {
                        setState(() => _selectedMethod = value!);
                      },
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tombol Konfirmasi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final raw = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
                    final jumlah = int.tryParse(raw) ?? 0;

                    if (jumlah <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Masukkan nominal penarikan'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    if (jumlah < 10000) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Minimal penarikan adalah Rp 10.000'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    if (jumlah > AppData.saldoTersedia) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Saldo Anda tidak mencukupi'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    _showConfirmationDialog(context, jumlah);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Tarik Saldo Sekarang',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, int jumlahTarik) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Konfirmasi Penarikan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Anda akan menarik saldo sebesar:'),
            const SizedBox(height: 8),
            Text(
              'Rp ${AppData.formatAngka(jumlahTarik)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Metode: $_selectedMethod',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _prosesPenarikan(context, jumlahTarik);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
            ),
            child: const Text('Konfirmasi'),
          ),
        ],
      ),
    );
  }

  Future<void> _prosesPenarikan(BuildContext context, int jumlahTarik) async {
    // Tampilkan loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
      ),
    );

    final res = await ApiService.tarikSaldo(
      nominal: jumlahTarik,
      metode: _selectedMethod,
    );

    if (!mounted) return;
    Navigator.pop(context); // Tutup loading dialog

    if (res['success'] == true) {
      setState(() {}); // Update tampilan saldo di withdraw view
      _showSuccessDialog(context, jumlahTarik);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['message'] ?? 'Penarikan gagal diproses'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessDialog(BuildContext context, int jumlahTarik) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green[800],
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Penarikan Berhasil!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Saldo Rp ${AppData.formatAngka(jumlahTarik)} akan diproses dalam 1x24 jam.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx); // Tutup dialog sukses
                  Navigator.pop(context, true); // Kembali ke Beranda dan minta refresh saldo
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                ),
                child: const Text('Selesai'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

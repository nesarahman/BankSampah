import 'package:flutter/material.dart';
import 'pemilik_data.dart';
import '../../../api_service.dart';

const _bg = Color(0xFFF7F8FF);
const _dark = Color(0xFF1B5E20);
const _green = Color(0xFF2E7D32);
const _mintSoft = Color(0xFFCFF5CF);
const _blueSoft = Color(0xFFDCE4FA);
const _blueIcon = Color(0xFF3B4A6B);
const _ink = Color(0xFF1A1C24);

class PemilikGajiKurirView extends StatefulWidget {
  const PemilikGajiKurirView({super.key});

  @override
  State<PemilikGajiKurirView> createState() => _PemilikGajiKurirViewState();
}

class _PemilikGajiKurirViewState extends State<PemilikGajiKurirView> {
  void _prosesBayarGaji(int kurirIndex) {
    final d = PemilikData.I;
    final k = d.kurirList[kurirIndex];
    final nominal = k['gajiAkumulasi'] as int;

    if (nominal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gaji ${k['nama']} sudah lunas terbayar.'),
          backgroundColor: Colors.grey.shade800,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: _mintSoft, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.payments_outlined, color: _green, size: 22),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text('Slip Pembayaran Gaji Kurir', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${k['nama']} (${k['armada']})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Text('${k['kendaraan']}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            const Divider(height: 20),
            _barisRincian('Total Tugas Selesai', '${k['tugasSelesai']} Penjemputan'),
            _barisRincian('Total Muatan Masuk Gudang', '${k['totalKg']} Kg'),
            _barisRincian('Rating Kinerja Nasabah', '${k['rating']} ⭐ (${k['totalUlasan']} Ulasan)'),
            _barisRincian('Poin Kinerja Armada', '${k['poinKinerja']} Poin'),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Gaji Ditransfer:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(rp(nominal), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: _green)),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Catatan: Gaji dibayarkan langsung oleh Mitra Bank Sampah secara terpisah dari poin kinerja nasabah.',
              style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _green),
            onPressed: () async {
              final error = await d.bayarGajiKurir(k, nominal.toDouble());
              if (!mounted) return;
              Navigator.pop(ctx);
              if (error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(error), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating),
                );
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('✓ Gaji ${rp(nominal)} berhasil dibayarkan ke ${k['nama']}!'),
                  backgroundColor: _green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Konfirmasi Bayar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _barisRincian(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _ink)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: PemilikData.I,
      builder: (context, _) {
        final d = PemilikData.I;
        final list = d.kurirList;
        final totalGajiSemua = list.fold<int>(0, (a, b) => a + (b['gajiAkumulasi'] as int));

        return Scaffold(
          backgroundColor: _bg,
          appBar: AppBar(
            backgroundColor: _green,
            foregroundColor: Colors.white,
            elevation: 0,
            title: const Text('Manajemen Kurir & Penggajian', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              // 1. KARTU REKAP GAJI ARMADA
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: _green.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.badge_outlined, color: Colors.white70, size: 18),
                        SizedBox(width: 8),
                        Text('PENGGAJIAN ARMADA KURIR', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(rp(totalGajiSemua), style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    const Text('Total estimasi komisi/gaji kurir siap dibayarkan minggu ini', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.white, size: 16),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Kurir TIDAK menerima uang dari nasabah. Gaji dan komisi penjemputan dibayarkan penuh oleh Mitra Bank Sampah.',
                              style: TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 2. DAFTAR KURIR ARMADA
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Daftar Kurir Armada', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: _ink)),
                  Text('${list.length} Kurir Aktif', style: const TextStyle(fontSize: 12, color: _green, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),

              ...List.generate(list.length, (i) {
                final k = list[i];
                final nominal = k['gajiAkumulasi'] as int;
                final isLunas = nominal <= 0;

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: cardDeco(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(color: _mintSoft, borderRadius: BorderRadius.circular(14)),
                            child: const Icon(Icons.two_wheeler, color: _green, size: 26),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(k['nama'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _ink)),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: _blueSoft, borderRadius: BorderRadius.circular(6)),
                                      child: Text(k['armada'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _blueIcon)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(k['kendaraan'], style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isLunas ? Colors.grey.shade100 : _mintSoft,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isLunas ? 'Lunas' : 'Siap Dicairkan',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isLunas ? Colors.grey : _green,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _miniMetrik('Rating Nasabah', '${k['rating']} ⭐', '${k['totalUlasan']} ulasan'),
                          const SizedBox(width: 8),
                          _miniMetrik('Poin Kinerja', '${k['poinKinerja']} Pts', 'Reward Nasabah'),
                          const SizedBox(width: 8),
                          _miniMetrik('Tugas Jemput', '${k['tugasSelesai']} Order', '${k['totalKg']} kg'),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Akumulasi Gaji/Komisi:', style: TextStyle(fontSize: 11, color: Colors.grey)),
                              Text(rp(nominal), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isLunas ? Colors.grey : _green)),
                            ],
                          ),
                          ElevatedButton.icon(
                            onPressed: isLunas ? null : () => _prosesBayarGaji(i),
                            icon: const Icon(Icons.send, size: 14, color: Colors.white),
                            label: const Text('Bayar Gaji Kurir', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _green,
                              disabledBackgroundColor: Colors.grey.shade300,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _miniMetrik(String label, String value, String sub) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: _ink)),
            Text(sub, style: const TextStyle(fontSize: 9, color: Colors.grey), overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

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

class PemilikSetoranView extends StatefulWidget {
  const PemilikSetoranView({super.key});

  @override
  State<PemilikSetoranView> createState() => _PemilikSetoranViewState();
}

class _PemilikSetoranViewState extends State<PemilikSetoranView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // DIALOG 1: MITRA MENUGASKAN KURIR (Langkah 3)
  void _tampilkanDialogTugaskanKurir(int permintaanIndex) {
    final d = PemilikData.I;
    final p = d.permintaanNasabah[permintaanIndex];
    int selectedKurirIndex = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tugaskan Kurir Armada', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: _ink)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const Divider(),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nasabah: ${p['nasabah']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('${p['alamat']} • Sesi ${p['sesi']}', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                    Text('Muatan: ${p['komoditas']} (~${p['beratEstimasi']} kg)', style: const TextStyle(fontSize: 12, color: _green, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('Pilih Kurir Armada Mitra:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: _ink)),
              const SizedBox(height: 8),

              ...List.generate(d.kurirList.length, (ki) {
                final k = d.kurirList[ki];
                final isSelected = selectedKurirIndex == ki;

                return InkWell(
                  onTap: () => setS(() => selectedKurirIndex = ki),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? _mintSoft : Colors.white,
                      border: Border.all(color: isSelected ? _green : Colors.grey.shade300, width: isSelected ? 1.5 : 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: isSelected ? _green : Colors.grey.shade200,
                          child: Icon(Icons.two_wheeler, color: isSelected ? Colors.white : Colors.grey.shade700, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${k['nama']} (${k['armada']})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              Text('${k['kendaraan']} • ${k['rating']} ⭐ (${k['poinKinerja']} Pts)', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                          child: Text(k['status'], style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: k['status'].contains('Siap') ? _green : Colors.orange.shade800)),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final kurirTerpilih = d.kurirList[selectedKurirIndex];
                    final error = await d.tugaskanKurir(p, kurirTerpilih);
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
                        content: Text('✓ Tugas berhasil diteruskan ke kurir ${kurirTerpilih['nama']} (${kurirTerpilih['armada']})!'),
                        backgroundColor: _green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.send, color: Colors.white),
                  label: const Text('Kirim Tugas ke Kurir', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // DIALOG 2: MITRA MEMBAYAR NASABAH (Langkah 7)
  void _tampilkanDialogBayarNasabah(int setoranIndex) {
    final d = PemilikData.I;
    final s = d.setoranMenungguBayar[setoranIndex];
    final nominal = s['totalBayar'] as int;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: _mintSoft, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.account_balance_wallet, color: _green, size: 22),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text('Konfirmasi Pembayaran Nasabah', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nasabah: ${s['nasabah']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Text('Kurir Penimbang: ${s['kurir']} (${s['armada']})', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
            const Divider(height: 20),
            _baris('Hasil Timbangan:', '${s['beratAktual']} Kg'),
            _baris('Rincian Sampah:', '${s['rincian']}'),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Nominal Dibayar Mitra:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(rp(nominal), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: _green)),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: _mintSoft, borderRadius: BorderRadius.circular(10)),
              child: const Row(
                children: [
                  Icon(Icons.verified_user, color: _green, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Sesuai sistem: Pembayaran dilakukan oleh Mitra ke dompet Nasabah (Kurir tidak memegang uang).',
                      style: TextStyle(fontSize: 11, color: _dark),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _green),
            onPressed: () async {
              final nasabahNama = s['nasabah'] as String;
              final error = await d.bayarNasabah(s);
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
                  content: Text('✓ Berhasil! ${rp(nominal)} telah dibayarkan ke saldo $nasabahNama. Sampah masuk ke stok gudang.'),
                  backgroundColor: _green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Bayar Nasabah & Terima', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _baris(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _ink)),
          ),
        ],
      ),
    );
  }

  // DIALOG 3: DROP-OFF LANGSUNG NASABAH KE GUDANG
  void _setorNasabahLangsung(BuildContext context) {
    final d = PemilikData.I;
    int ni = 0;
    String kom = d.harga.keys.first;
    final c = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) {
          final kg = double.tryParse(c.text.trim().replaceAll(',', '.')) ?? 0;
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Setor Langsung di Gudang'),
            content: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                DropdownButtonFormField<int>(
                  value: ni,
                  decoration: const InputDecoration(labelText: 'Nasabah Terdaftar'),
                  items: List.generate(d.nasabah[d.unit].length, (i) => DropdownMenuItem(value: i, child: Text('${d.nasabah[d.unit][i]['nama']}'))),
                  onChanged: (v) => setS(() => ni = v ?? ni),
                ),
                DropdownButtonFormField<String>(
                  value: kom,
                  decoration: const InputDecoration(labelText: 'Komoditas'),
                  items: d.harga.keys.map((k) => DropdownMenuItem(value: k, child: Text('$k • ${rp(d.harga[k]!)}/kg'))).toList(),
                  onChanged: (v) => setS(() => kom = v ?? kom),
                ),
                TextField(
                  controller: c,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Berat Timbangan', suffixText: 'kg'),
                  onChanged: (_) => setS(() {}),
                ),
                const SizedBox(height: 10),
                Text('Masuk saldo nasabah: ${rp(kg * (d.harga[kom] ?? 0))}', style: const TextStyle(color: _green, fontWeight: FontWeight.bold, fontSize: 13)),
              ]),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: _green),
                onPressed: () {
                  if (kg <= 0) return;
                  d.setorNasabah(ni, kom, kg);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Setoran ${kg.toStringAsFixed(1)} kg $kom dicatat ke saldo nasabah.'), backgroundColor: _green));
                },
                child: const Text('Catat', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: PemilikData.I,
      builder: (context, _) {
        final d = PemilikData.I;
        final totalPermintaan = d.totalPermintaanBaru;
        final totalSetoran = d.totalMenungguBayar;

        return Scaffold(
          backgroundColor: _bg,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text('Pusat Penjemputan & Setoran Mitra', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: _ink)),
            bottom: TabBar(
              controller: _tabController,
              labelColor: _green,
              unselectedLabelColor: Colors.grey,
              indicatorColor: _green,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Permintaan Nasabah'),
                      if (totalPermintaan > 0) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                          child: Text('$totalPermintaan', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Timbangan Kurir'),
                      if (totalSetoran > 0) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Colors.orange.shade800, borderRadius: BorderRadius.circular(10)),
                          child: Text('$totalSetoran', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _setorNasabahLangsung(context),
            backgroundColor: _green,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Setor Mandiri di Gudang', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              // TAB 1: PERMINTAAN DARI NASABAH (Menunggu Mitra Meneruskan ke Kurir)
              _buildTabPermintaanNasabah(d),

              // TAB 2: LAPORAN TIMBANGAN KURIR (Menunggu Pembayaran dari Mitra)
              _buildTabSetoranKurir(d),
            ],
          ),
        );
      },
    );
  }

  // TAB 1 WIDGET
  Widget _buildTabPermintaanNasabah(PemilikData d) {
    final list = d.permintaanNasabah;

    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mark_email_read_outlined, size: 56, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text('Belum ada permintaan penjemputan baru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 4),
            Text('Permintaan jual sampah dari nasabah akan masuk ke sini.', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
      itemCount: list.length,
      itemBuilder: (context, i) {
        final p = list[i];
        final isDitugaskan = p['status'] == 'DITUGASKAN';

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: cardDeco(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: _blueSoft, borderRadius: BorderRadius.circular(8)),
                    child: Text(p['id'], style: const TextStyle(color: _blueIcon, fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDitugaskan ? _mintSoft : const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isDitugaskan ? 'Kurir Menuju Lokasi' : 'Permintaan Baru',
                      style: TextStyle(
                        color: isDitugaskan ? _green : const Color(0xFFE65100),
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: _mintSoft,
                    child: Text('${p['nasabah']}'.substring(0, 1), style: const TextStyle(color: _green, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p['nasabah'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _ink)),
                        Text('Kontak: ${p['hp']}', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  Text(p['waktu'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
              const Divider(height: 20),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: _green),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text('${p['alamat']} (Sesi: ${p['sesi']})', style: const TextStyle(fontSize: 12, color: _ink)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.inventory_2_outlined, size: 16, color: _blueIcon),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text('${p['komoditas']} • Estimasi ~${p['beratEstimasi']} kg (${rp(p['estimasiNilai'])})',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _ink)),
                  ),
                ],
              ),
              if (p['catatan'] != null) ...[
                const SizedBox(height: 6),
                Text('Catatan nasabah: "${p['catatan']}"', style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.grey)),
              ],
              const SizedBox(height: 14),

              if (isDitugaskan) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: _mintSoft, borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      const Icon(Icons.two_wheeler, color: _green, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tugas diteruskan ke kurir: ${p['kurir']} (${p['armada']})',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: _dark),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _tampilkanDialogTugaskanKurir(i),
                    icon: const Icon(Icons.two_wheeler, color: Colors.white, size: 18),
                    label: const Text('Tugaskan ke Kurir', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  // TAB 2 WIDGET
  Widget _buildTabSetoranKurir(PemilikData d) {
    final list = d.setoranMenungguBayar;

    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.done_all, size: 56, color: _green),
            const SizedBox(height: 12),
            const Text('Semua timbangan kurir telah selesai dibayar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 4),
            Text('Hasil penimbangan kurir di lapangan akan muncul di sini untuk dibayar.', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
      itemCount: list.length,
      itemBuilder: (context, i) {
        final s = list[i];
        final nominal = s['totalBayar'] as int;

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: cardDeco(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: _mintSoft, borderRadius: BorderRadius.circular(8)),
                    child: Text(s['id'], style: const TextStyle(color: _green, fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      'Menunggu Pembayaran Mitra',
                      style: TextStyle(color: Colors.orange.shade800, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: _blueSoft, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.two_wheeler, color: _blueIcon, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Kurir: ${s['kurir']} (${s['armada']})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: _ink)),
                        Text('Nasabah: ${s['nasabah']} • ${s['hp']}', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                      ],
                    ),
                  ),
                  Text(s['waktu'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
              const Divider(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Hasil Timbangan Kurir:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text('${s['beratAktual']} Kg', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: _ink)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Rincian:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Expanded(
                          child: Text('${s['rincian']}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 11, color: _ink)),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Yang Harus Dibayar Mitra:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text(rp(nominal), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: _green)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _tampilkanDialogBayarNasabah(i),
                  icon: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 18),
                  label: const Text('Bayar Saldo Nasabah & Terima Stok', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _green,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

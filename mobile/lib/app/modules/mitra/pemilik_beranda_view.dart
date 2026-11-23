import 'package:flutter/material.dart';
import 'pemilik_data.dart';
import 'mitra_tugas_view.dart';
import 'pemilik_gaji_kurir_view.dart';
import '../../../app_data.dart';

const _bg = Color(0xFFF7F8FF);
const _dark = Color(0xFF1B5E20);
const _green = Color(0xFF2E7D32);
const _mint = Color(0xFF8CEB8C);
const _mintSoft = Color(0xFFCFF5CF);
const _blueSoft = Color(0xFFDCE4FA);
const _blueIcon = Color(0xFF3B4A6B);
const _lavender = Color(0xFFE6EBFA);
const _ink = Color(0xFF1A1C24);
const _muted = Color(0xFF5F6670);
const _glass = Color(0x33FFFFFF);

String _ribuan(num v) {
  final s = v.round().abs().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return b.toString();
}

class PemilikBerandaView extends StatelessWidget {
  final ValueChanged<int>? onSwitchTab;
  const PemilikBerandaView({super.key, this.onSwitchTab});

  IconData _ikon(String k) {
    switch (k) {
      case 'Kardus Box':
        return Icons.inventory_2_outlined;
      case 'Plastik PET':
        return Icons.local_drink_outlined;
      case 'Kaleng Aluminium':
        return Icons.science_outlined;
      case 'Minyak Jelantah':
        return Icons.water_drop_outlined;
      default:
        return Icons.hardware_outlined;
    }
  }

  void _editHarga(BuildContext context, String k) {
    final c = TextEditingController(text: '${PemilikData.I.harga[k]}');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Harga $k'),
        content: TextField(
          controller: c,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            prefixText: 'Rp ',
            suffixText: '/ kg',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _green),
            onPressed: () {
              final v = int.tryParse(c.text.trim()) ?? 0;
              if (v <= 0) return;
              PemilikData.I.setHarga(k, v);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Harga $k diperbarui: Rp ${_ribuan(v)}/kg. Nasabah & kurir melihat harga baru.'),
                  backgroundColor: _green,
                ),
              );
            },
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _setorNasabah(BuildContext context) {
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
            title: const Text('Setor Langsung Nasabah'),
            content: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                DropdownButtonFormField<int>(
                  value: ni,
                  decoration: const InputDecoration(labelText: 'Pilih Nasabah'),
                  items: List.generate(
                    d.nasabah[d.unit].length,
                    (i) => DropdownMenuItem(value: i, child: Text('${d.nasabah[d.unit][i]['nama']}')),
                  ),
                  onChanged: (v) => setS(() => ni = v ?? ni),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: kom,
                  decoration: const InputDecoration(labelText: 'Komoditas Sampah'),
                  items: d.harga.keys
                      .map((k) => DropdownMenuItem(value: k, child: Text('$k • Rp ${_ribuan(d.harga[k]!)}/kg')))
                      .toList(),
                  onChanged: (v) => setS(() => kom = v ?? kom),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: c,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Berat Timbangan', suffixText: 'kg'),
                  onChanged: (_) => setS(() {}),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: _mintSoft, borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Masuk Saldo Nasabah:', style: TextStyle(fontSize: 12, color: _dark)),
                      Text(
                        'Rp ${_ribuan(kg * (d.harga[kom] ?? 0))}',
                        style: const TextStyle(color: _green, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: _green),
                onPressed: () {
                  if (kg <= 0) return;
                  if (kg > d.sisaKapasitas) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Kapasitas gudang tidak cukup. Sisa ${d.sisaKapasitas.toStringAsFixed(0)} kg.'),
                        backgroundColor: Colors.orange.shade800,
                      ),
                    );
                    return;
                  }
                  d.setorNasabah(ni, kom, kg);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Setoran ${kg.toStringAsFixed(1)} kg $kom dicatat ke saldo nasabah.'),
                      backgroundColor: _green,
                    ),
                  );
                },
                child: const Text('Catat Masuk', style: TextStyle(color: Colors.white)),
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
        final u = d.unitAktif;
        final stok = d.stok[d.unit];
        final pakai = (d.totalStok / d.kapasitas[d.unit]).clamp(0.0, 1.0);
        final status = pakai > 0.85 ? 'Hampir Penuh' : (pakai > 0.5 ? 'Tersedia' : 'Sangat Luang');

        final tombol = ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        );

        final displayName = AppData.namaUser.isNotEmpty ? AppData.namaUser : 'Mitra Pengepul';

        return Scaffold(
          backgroundColor: _bg,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                // 1. HEADER BRAND & AVATAR
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.eco, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REGREEN',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                            color: _green,
                          ),
                        ),
                        Text(
                          'Gudang Mitra',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            height: 1.1,
                            color: _ink,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _mintSoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.storefront, color: _green, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${u['singkat']}',
                            style: const TextStyle(
                              color: _green,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.notifications_none, color: _ink, size: 26),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => onSwitchTab?.call(3),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFCFE8CF),
                          border: Border.all(color: Colors.white, width: 2),
                          image: AppData.fotoProfil.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(AppData.fotoProfil),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: AppData.fotoProfil.isEmpty
                            ? const Icon(Icons.person, size: 24, color: _green)
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // 2. GREETING & LOKASI
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 16, color: _ink),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  '${u['lokasi']}'.toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.4,
                                    color: _ink,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Halo, $displayName! 👋',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: _ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFCFE8CF),
                            border: Border.all(color: _mint, width: 3),
                            image: AppData.fotoProfil.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(AppData.fotoProfil),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: AppData.fotoProfil.isEmpty
                              ? const Icon(Icons.storefront, size: 32, color: _green)
                              : null,
                        ),
                        Transform.translate(
                          offset: const Offset(0, -10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _mint,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Mitra Pengepul 🏬',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: _dark,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // 3. PILIHAN UNIT BANK SAMPAH / GUDANG
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(d.units.length, (i) {
                      final sel = d.unit == i;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(d.units[i]['singkat']!),
                          selected: sel,
                          selectedColor: _green,
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: sel ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          onSelected: (_) => d.pilihUnit(i),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 14),

                // 4. KARTU BESAR HIJAU: ESTIMASI NILAI STOK & KAPASITAS GUDANG
                ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF4A9A55), Color(0xFF2B6F36)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -40,
                          bottom: -50,
                          child: Container(
                            width: 180,
                            height: 180,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0x14FFFFFF),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Expanded(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.warehouse_outlined,
                                          size: 20,
                                          color: Colors.white70,
                                        ),
                                        SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            'TOTAL NILAI STOK GUDANG',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.8,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _glass,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.inventory_2_outlined,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          status,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Rp ${_ribuan(d.nilaiStok)}',
                                  style: const TextStyle(
                                    fontSize: 44,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: _glass,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.recycling, size: 20, color: Colors.white),
                                        const SizedBox(width: 10),
                                        const Expanded(
                                          child: Text(
                                            'Kapasitas Muatan Gudang',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '${d.totalStok.toStringAsFixed(0)} / ${d.kapasitas[d.unit].toStringAsFixed(0)} kg',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: pakai,
                                        minHeight: 6,
                                        backgroundColor: Colors.white24,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          pakai > 0.85 ? Colors.orangeAccent : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => onSwitchTab?.call(1),
                                      icon: const Icon(Icons.arrow_upward, size: 18),
                                      label: const Text('Terima Setoran'),
                                      style: tombol.copyWith(
                                        backgroundColor: const WidgetStatePropertyAll(Colors.white),
                                        foregroundColor: const WidgetStatePropertyAll(_dark),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => _setorNasabah(context),
                                      icon: const Icon(Icons.add_circle_outline, size: 18),
                                      label: const Text('Setor Nasabah'),
                                      style: tombol.copyWith(
                                        backgroundColor: const WidgetStatePropertyAll(_glass),
                                        foregroundColor: const WidgetStatePropertyAll(Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (d.totalPermintaanBaru > 0 || d.totalMenungguBayar > 0) ...[
                  const SizedBox(height: 14),
                  if (d.totalPermintaanBaru > 0)
                    InkWell(
                      onTap: () => onSwitchTab?.call(1),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFFFB74D)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.notifications_active, color: Color(0xFFE65100), size: 22),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Ada ${d.totalPermintaanBaru} permintaan penjemputan nasabah baru! Ketuk untuk tugaskan ke kurir armada.',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFE65100)),
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFFE65100)),
                          ],
                        ),
                      ),
                    ),
                  if (d.totalMenungguBayar > 0) ...[
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => onSwitchTab?.call(1),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: _mintSoft,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: _mint),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.account_balance_wallet, color: _green, size: 22),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Ada ${d.totalMenungguBayar} hasil timbangan kurir menunggu pembayaran dari Mitra ke nasabah!',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _dark),
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 14, color: _green),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],

                const SizedBox(height: 24),

                // 5. LAYANAN CEPAT (4 KARTU BESAR SESUAI CONTOH)
                const Row(
                  children: [
                    Text(
                      'Layanan Cepat',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: _ink,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Ternate Aktif',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _Layanan(
                      Icons.local_shipping_outlined,
                      'Terima\nSetoran',
                      _mintSoft,
                      _green,
                      () => onSwitchTab?.call(1),
                    ),
                    const SizedBox(width: 10),
                    _Layanan(
                      Icons.add_task,
                      'Setor\nNasabah',
                      _blueSoft,
                      _blueIcon,
                      () => _setorNasabah(context),
                    ),
                    const SizedBox(width: 10),
                    _Layanan(
                      Icons.groups_outlined,
                      'Kelola\nNasabah',
                      _blueSoft,
                      _blueIcon,
                      () => onSwitchTab?.call(2),
                    ),
                    const SizedBox(width: 10),
                    _Layanan(
                      Icons.two_wheeler,
                      'Armada\nKurir',
                      _mintSoft,
                      _green,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MitraTugasView()),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 6. BANNER EDUKASI / OPERASIONAL ARMADA
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MitraTugasView()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _mintSoft,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.two_wheeler, size: 14, color: _green),
                                      SizedBox(width: 4),
                                      Text(
                                        'ARMADA PENJEMPUTAN AKTIF',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: _green,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Pantau Penjemputan Sampah Lapangan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: _ink,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Koordinasi armada kurir di Ternate dan pantau setoran sampah nasabah yang sedang menuju gudang.',
                                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3E5F5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.navigation_outlined, color: Colors.purple, size: 28),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 7. STOK & HARGA BELI KOMODITAS
                Row(
                  children: [
                    const Icon(Icons.inventory_2_outlined, color: _green, size: 22),
                    const SizedBox(width: 8),
                    const Text(
                      'Stok & Harga Beli Komoditas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: _ink,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Ketuk harga untuk ubah',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                ...stok.entries.map((e) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0F1A1C24),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: _mintSoft,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(_ikon(e.key), color: _green, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.key,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: _ink,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${e.value.toStringAsFixed(1)} kg di gudang',
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () => _editHarga(context, e.key),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: _mintSoft,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Rp ${_ribuan(d.harga[e.key] ?? 0)}/kg',
                                    style: const TextStyle(
                                      color: _green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.edit, size: 14, color: _green),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------- Layanan Cepat Item
class _Layanan extends StatelessWidget {
  const _Layanan(this.icon, this.label, this.tile, this.warnaIcon, this.onTap);
  final IconData icon;
  final String label;
  final Color tile;
  final Color warnaIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            child: Column(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: tile,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: warnaIcon, size: 26),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    color: _ink,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

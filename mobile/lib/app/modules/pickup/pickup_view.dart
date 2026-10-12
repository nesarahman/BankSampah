import 'package:flutter/material.dart';

const _bg = Color(0xFFF7F8FF);
const _dark = Color(0xFF1B5E20);
const _green = Color(0xFF2E7D32);
const _mint = Color(0xFF8CEB8C);
const _blueSoft = Color(0xFFDCE4FA);
const _blueIcon = Color(0xFF3B4A6B);
const _lavender = Color(0xFFE6EBFA);
const _ink = Color(0xFF1A1C24);
const _muted = Color(0xFF5F6670);
const _garis = Color(0xFFE0E3EC);

const _namaHari = ['SENIN', 'SELASA', 'RABU', 'KAMIS', 'JUMAT', 'SABTU', 'MINGGU'];
const _namaBulan = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
];

String _ribuan(int v) {
  final s = v.abs().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return b.toString();
}

String _rp(int v) => 'Rp ${_ribuan(v)}';

BoxDecoration _kartu([Color warna = Colors.white]) => BoxDecoration(
      color: warna,
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(color: Color(0x0F1A1C24), blurRadius: 12, offset: Offset(0, 4)),
      ],
    );

class _Kategori {
  const _Kategori(this.nama, this.harga, this.icon);
  final String nama;
  final int harga; // per kg
  final IconData icon;
}

class _Sesi {
  const _Sesi(this.label, this.icon);
  final String label;
  final IconData icon;
}

class PickupView extends StatefulWidget {
  const PickupView({super.key, this.onTabSelected, this.showBottomNav = true});

  /// Index tab: 0 Beranda, 1 Jemput, 2 Katalog, 3 Riwayat, 4 Drop Point.
  /// Kalau Bottom Navigation sudah ada di tempat lain, pakai
  /// PickupView(showBottomNav: false) supaya tidak dobel.
  final ValueChanged<int>? onTabSelected;
  final bool showBottomNav;

  @override
  State<PickupView> createState() => _PickupViewState();
}

class _PickupViewState extends State<PickupView> {
  // DUMMY DATA (nanti dari API)
  static const _kategoriList = [
    _Kategori('Kertas & Karton', 3000, Icons.description_outlined),
    _Kategori('Plastik Daur Ulang', 4200, Icons.local_drink_outlined),
    _Kategori('Logam & Kaleng', 7500, Icons.inventory_2_outlined),
    _Kategori('Jelantah & Kaca', 5000, Icons.water_drop_outlined),
  ];
  static const _sesiList = [
    _Sesi('Pagi (09:00 - 12:00)', Icons.wb_sunny_outlined),
    _Sesi('Sore (14:00 - 17:00)', Icons.wb_twilight),
  ];
  static const _namaTab = ['Beranda', 'Jemput', 'Katalog', 'Riwayat', 'Drop Point'];
  static const _ikonTab = [
    Icons.eco_outlined,
    Icons.local_shipping_outlined,
    Icons.recycling,
    Icons.receipt_long_outlined,
    Icons.location_on_outlined,
  ];
  static const int _minBerat = 2;
  static const int _maxBerat = 500;

  late final List<DateTime> _hari = List.generate(7, (i) {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day).add(Duration(days: i + 1));
  });

  int _kategori = 0;
  int _berat = 15;
  int _tanggal = 0;
  int _sesi = 0;
  final _catatan = TextEditingController();

  int get _estimasi => _berat * _kategoriList[_kategori].harga;

  @override
  void dispose() {
    _catatan.dispose();
    super.dispose();
  }

  void _ubahBerat(int delta) {
    setState(() => _berat = (_berat + delta).clamp(_minBerat, _maxBerat).toInt());
  }

  void _pindahTab(int i) {
    if (i == 1) return;
    if (widget.onTabSelected != null) {
      widget.onTabSelected!(i);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_namaTab[i]}: navigasi belum tersambung')),
      );
    }
  }

  void _jemput() {
    final k = _kategoriList[_kategori];
    final d = _hari[_tanggal];
    final catatan = _catatan.text.trim();
    // TODO (integrasi API): kirim ke POST /api/penjemputan
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pengajuan Terkirim'),
        content: Text(
          '${k.nama} • $_berat kg\n'
          'Estimasi ${_rp(_estimasi)}\n'
          '${_namaHari[d.weekday - 1]}, ${d.day} ${_namaBulan[d.month - 1]} • '
          '${_sesiList[_sesi].label}\n'
          'Jl. Revolusi No. 42, Kalumata, Ternate'
          '${catatan.isEmpty ? '' : '\nCatatan: $catatan'}',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      bottomNavigationBar: widget.showBottomNav
          ? BottomNavigationBar(
              currentIndex: 1,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: _green,
              unselectedItemColor: _ink,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              onTap: _pindahTab,
              items: [
                for (var i = 0; i < _namaTab.length; i++)
                  BottomNavigationBarItem(icon: Icon(_ikonTab[i]), label: _namaTab[i]),
              ],
            )
          : null,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            const _TopBar(),
            const SizedBox(height: 14),
            _headerLangkah(),
            const SizedBox(height: 20),
            _bagianKategori(),
            const SizedBox(height: 20),
            _bagianBerat(),
            const SizedBox(height: 16),
            _bagianEstimasi(),
            const SizedBox(height: 24),
            _bagianJadwal(),
            const SizedBox(height: 24),
            _bagianLokasi(),
            const SizedBox(height: 24),
            _bagianCatatan(),
            const SizedBox(height: 24),
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _jemput,
                icon: const Icon(Icons.local_shipping_outlined),
                label: const Text('Jemput Sekarang'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _dark,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  textStyle:
                      const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Gratis biaya penjemputan mitra untuk bobot di atas 10 kg',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: _muted),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------- Langkah & judul
  Widget _headerLangkah() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _mint,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.eco_outlined, size: 14, color: _dark),
              SizedBox(width: 4),
              Text('LANGKAH 1 DARI 2',
                  style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w800, color: _dark)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Formulir Jemput Sampah',
                      style: TextStyle(
                          fontSize: 26, fontWeight: FontWeight.w700, color: _ink)),
                  SizedBox(height: 2),
                  Text('Konversikan sampah terpilah menjadi saldo bernilai',
                      style: TextStyle(fontSize: 13, color: _muted)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration:
                  const BoxDecoration(shape: BoxShape.circle, color: _blueSoft),
              child: const Text('50%',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w800, color: _green)),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: const LinearProgressIndicator(
            value: 0.5,
            minHeight: 8,
            backgroundColor: _blueSoft,
            valueColor: AlwaysStoppedAnimation(_dark),
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------------------- Kategori
  Widget _bagianKategori() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _JudulBagian(
          icon: Icons.category_outlined,
          teks: '1. Pilih Kategori Sampah',
          kanan: 'Bisa pilih 1 kategori utama',
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _kategoriList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: 120,
          ),
          itemBuilder: (_, i) {
            final k = _kategoriList[i];
            final aktif = i == _kategori;
            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => setState(() => _kategori = i),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: _kartu(aktif ? _mint : Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: aktif ? Colors.white : _blueSoft,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(k.icon,
                              size: 22, color: aktif ? _green : _blueIcon),
                        ),
                        if (aktif)
                          Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: _dark),
                            child: const Icon(Icons.check,
                                size: 14, color: Colors.white),
                          ),
                      ],
                    ),
                    const Spacer(),
                    Text(k.nama,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: aktif ? _dark : _ink)),
                    const SizedBox(height: 2),
                    Text('${_rp(k.harga)} / kg',
                        style: TextStyle(
                            fontSize: 12, color: aktif ? _dark : _muted)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ------------------------------------------------------------------ Berat
  Widget _bagianBerat() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _kartu(),
      child: Column(
        children: [
          const _JudulBagian(
            icon: Icons.hourglass_empty,
            teks: '2. Perkiraan Berat Sampah',
            kanan: 'Min. 2 kg',
            kananRedup: true,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
            decoration: BoxDecoration(
              color: _lavender,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _BulatBtn(icon: Icons.remove, onTap: () => _ubahBerat(-1)),
                    const SizedBox(width: 20),
                    Text('$_berat',
                        style: const TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w800,
                            color: _dark)),
                    const SizedBox(width: 4),
                    const Padding(
                      padding: EdgeInsets.only(top: 14),
                      child: Text('KG',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: _blueIcon)),
                    ),
                    const SizedBox(width: 20),
                    _BulatBtn(
                        icon: Icons.add, terisi: true, onTap: () => _ubahBerat(1)),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final d in const [1, 5, 10])
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => _ubahBerat(d),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('+$d kg',
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _ink)),
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
    );
  }

  // --------------------------------------------------------------- Estimasi
  Widget _bagianEstimasi() {
    final k = _kategoriList[_kategori];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _mint,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.payments_outlined, size: 20, color: _green),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text('Estimasi Saldo Masuk',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700, color: _dark)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('${_rp(k.harga)} / kg',
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w700, color: _dark)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Total Perkiraan:',
                  style: TextStyle(fontSize: 14, color: _dark)),
              const Spacer(),
              Text(_rp(_estimasi),
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.w800, color: _dark)),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, size: 16, color: _dark),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Harga final akan ditimbang ulang secara presisi oleh '
                  'kurir REGREEN di lokasi Anda.',
                  style: TextStyle(fontSize: 12, color: _dark),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------- Jadwal
  Widget _bagianJadwal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _JudulBagian(
          icon: Icons.calendar_today_outlined,
          teks: '3. Jadwal Penjemputan',
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 88,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _hari.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final d = _hari[i];
              final aktif = i == _tanggal;
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => setState(() => _tanggal = i),
                child: Container(
                  width: 96,
                  decoration: _kartu(aktif ? _mint : Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_namaHari[d.weekday - 1],
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: aktif ? _dark : _muted)),
                      Text('${d.day}',
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: _ink)),
                      Text(_namaBulan[d.month - 1],
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: aktif ? _dark : _muted)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            for (var i = 0; i < _sesiList.length; i++) ...[
              if (i > 0) const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => setState(() => _sesi = i),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: _kartu(i == _sesi ? _mint : Colors.white),
                    child: Column(
                      children: [
                        Icon(_sesiList[i].icon,
                            color: i == _sesi ? _dark : _blueIcon),
                        const SizedBox(height: 6),
                        Text(_sesiList[i].label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: i == _sesi ? _dark : _ink)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  // ----------------------------------------------------------------- Lokasi
  Widget _bagianLokasi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _JudulBagian(
          icon: Icons.location_on_outlined,
          teks: '4. Lokasi Penjemputan',
          kanan: 'Ubah Titik',
          onKananTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pemilih lokasi (peta) menyusul')),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: _kartu(),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _blueSoft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.home_outlined, color: _blueIcon),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _lavender,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('Rumah Utama',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: _green)),
                        ),
                        const SizedBox(height: 4),
                        const Text('Jl. Revolusi No. 42',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: _ink)),
                        const Text('Kel. Kalumata, Kota Ternate, Maluku Utara',
                            style: TextStyle(fontSize: 12, color: _muted)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Placeholder peta. Ganti dengan Google Maps / flutter_map.
              Container(
                height: 110,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8ED1D6), Color(0xFFB5E3E0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(color: Color(0x33000000), blurRadius: 6),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.red),
                      SizedBox(width: 4),
                      Text('Pin Terpilih Akurat',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _ink)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------- Catatan
  Widget _bagianCatatan() {
    OutlineInputBorder garis(Color warna, [double lebar = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: warna, width: lebar),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _JudulBagian(
          icon: Icons.edit_note,
          teks: '5. Catatan Tambahan Petugas',
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _catatan,
          minLines: 3,
          maxLines: 4,
          decoration: InputDecoration(
            hintText:
                'cth. Sampah kardus sudah diikat rapi di teras depan pagar hitam.',
            hintStyle: const TextStyle(color: _muted, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(14),
            border: garis(_garis),
            enabledBorder: garis(_garis),
            focusedBorder: garis(_green, 1.5),
          ),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------ Widget kecil
class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
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
            Text('REGREEN',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: _green)),
            Text('Jemput Sampah',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                    color: _ink)),
          ],
        ),
        const Spacer(),
        const Icon(Icons.notifications_none, color: _ink, size: 26),
        const SizedBox(width: 12),
        // Foto profil: ganti dengan Image.asset(...) bila sudah ada.
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFCFE8CF),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(Icons.person, size: 24, color: _green),
        ),
      ],
    );
  }
}

class _JudulBagian extends StatelessWidget {
  const _JudulBagian({
    required this.icon,
    required this.teks,
    this.kanan,
    this.kananRedup = false,
    this.onKananTap,
  });

  final IconData icon;
  final String teks;
  final String? kanan;
  final bool kananRedup;
  final VoidCallback? onKananTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: _green),
        const SizedBox(width: 8),
        Expanded(
          child: Text(teks,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w600, color: _ink)),
        ),
        if (kanan != null)
          InkWell(
            onTap: onKananTap,
            child: Text(kanan!,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: kananRedup ? _muted : _green)),
          ),
      ],
    );
  }
}

class _BulatBtn extends StatelessWidget {
  const _BulatBtn({
    required this.icon,
    required this.onTap,
    this.terisi = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool terisi;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: terisi ? _dark : Colors.white,
        ),
        child: Icon(icon, color: terisi ? Colors.white : _ink, size: 26),
      ),
    );
  }
}
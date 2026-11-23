import 'package:flutter/material.dart';
import '../../../app_data.dart';
import 'pemilik_data.dart';

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

BoxDecoration _kartu() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(20),
  boxShadow: const [
    BoxShadow(color: Color(0x0F1A1C24), blurRadius: 12, offset: Offset(0, 4)),
  ],
);

class MitraPengepulView extends StatefulWidget {
  const MitraPengepulView({super.key});

  @override
  State<MitraPengepulView> createState() => _MitraPengepulViewState();
}

class _MitraPengepulViewState extends State<MitraPengepulView> {
  final ScrollController _scrollController = ScrollController();
  String _selectedWilayah = 'Semua';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Filter khusus dari kolom status operasional
  bool _filterHanyaGudangLuang = false;

  // Simulasi muatan saat ini di box motor kargo kurir
  double _muatanKargoSaatIni = 42.5; // dalam Kg
  final double _kapasitasMaksKargo = 60.0;

  final List<Map<String, dynamic>> _daftarBankSampah = [
    {
      'id': 'BSI-01',
      'namaBank': 'Bank Sampah Induk Gamalama',
      'pemilik': 'H. Mahmud Suleman',
      'wilayah': 'Ternate Tengah',
      'alamat': 'Jl. Cengkeh No. 28, Kel. Gamalama',
      'jarak': '1.2 km • 4 mnt',
      'kapasitasGudang': 0.65,
      'statusKapasitas': 'Tersedia',
      'komoditas': ['Kardus Box', 'Plastik PET', 'Kaleng Aluminium'],
      'jamBuka': '08:00 - 17:00 WIT',
      'telepon': '081244556677',
    },
    {
      'id': 'BSU-02',
      'namaBank': 'Pengepul Mitra Bastiong Bersaudara',
      'pemilik': 'Ibu Hj. Safia Albaar',
      'wilayah': 'Ternate Selatan',
      'alamat': 'Kawasan Pelabuhan Bastiong No. 11',
      'jarak': '2.9 km • 8 mnt',
      'kapasitasGudang': 0.40,
      'statusKapasitas': 'Sangat Luang',
      'komoditas': ['Minyak Jelantah', 'Besi Tipis', 'Kardus'],
      'jamBuka': '07:30 - 18:00 WIT',
      'telepon': '082199001122',
    },
    {
      'id': 'BSU-03',
      'namaBank': 'Lapak Daur Ulang Mandiri Kalumata',
      'pemilik': 'Bpk. Fikram Abdurrahman',
      'wilayah': 'Ternate Selatan',
      'alamat': 'Jl. Raya Kalumata Puncak No. 5',
      'jarak': '3.5 km • 10 mnt',
      'kapasitasGudang': 0.88,
      'statusKapasitas': 'Hampir Penuh',
      'komoditas': ['Plastik Campur', 'Kertas Arsip', 'Botol Kaca'],
      'jamBuka': '08:00 - 16:30 WIT',
      'telepon': '085233445566',
    },
    {
      'id': 'BSU-04',
      'namaBank': 'Bank Sampah Unit Dufa-Dufa Hijau',
      'pemilik': 'Ibu Nurlaila Karim',
      'wilayah': 'Ternate Utara',
      'alamat': 'Jl. Sultan Babullah, Kel. Dufa-Dufa',
      'jarak': '4.8 km • 13 mnt',
      'kapasitasGudang': 0.50,
      'statusKapasitas': 'Tersedia',
      'komoditas': ['Plastik PET', 'Kardus Box', 'Elektronik'],
      'jamBuka': '08:00 - 17:00 WIT',
      'telepon': '081377889900',
    },
  ];

  int get _totalMitra => _daftarBankSampah.length;

  int get _gudangLuangCount => _daftarBankSampah.where((b) {
        final cap = (b['kapasitasGudang'] as num?)?.toDouble() ?? 0.0;
        return cap < 0.85;
      }).length;

  String get _idArmadaAktif =>
      AppData.idArmada.isNotEmpty ? AppData.idArmada : 'ARM-03';

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredList {
    return _daftarBankSampah.where((item) {
      if (_filterHanyaGudangLuang) {
        final cap = (item['kapasitasGudang'] as num?)?.toDouble() ?? 0.0;
        if (cap >= 0.85) return false;
      }

      final matchWilayah =
          _selectedWilayah == 'Semua' || item['wilayah'] == _selectedWilayah;
      final query = _searchQuery.toLowerCase().trim();
      if (query.isEmpty) return matchWilayah;

      final namaBank = item['namaBank']?.toString().toLowerCase() ?? '';
      final pemilik = item['pemilik']?.toString().toLowerCase() ?? '';
      final alamat = item['alamat']?.toString().toLowerCase() ?? '';
      final komoditasList = (item['komoditas'] as List<dynamic>? ?? [])
          .map((e) => e.toString().toLowerCase())
          .join(' ');

      final matchSearch = namaBank.contains(query) ||
          pemilik.contains(query) ||
          alamat.contains(query) ||
          komoditasList.contains(query);
      return matchWilayah && matchSearch;
    }).toList();
  }

  void _scrollToBankList() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        460,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  // =========================================================================
  // FUNGSI AKSI 4 KOLOM STATUS OPERASIONAL
  // =========================================================================

  /// 1. Kolom 1: 4 Titik Mitra -> Tampilkan seluruh titik dan reset filter
  void _onTapTitikMitra() {
    setState(() {
      _filterHanyaGudangLuang = false;
      _selectedWilayah = 'Semua';
      _searchQuery = '';
      _searchController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Menampilkan seluruh $_totalMitra Titik Bank Sampah & Pengepul di Kota Ternate.'),
        backgroundColor: _green,
        duration: const Duration(seconds: 2),
      ),
    );
    _scrollToBankList();
  }

  /// 2. Kolom 2: 3 Gudang Luang -> Filter hanya yang gudangnya masih luang (< 85%)
  void _onTapGudangLuang() {
    setState(() {
      _filterHanyaGudangLuang = !_filterHanyaGudangLuang;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _filterHanyaGudangLuang
              ? 'Filter Aktif: Menampilkan $_gudangLuangCount bank sampah dengan gudang luang (<85%).'
              : 'Filter Dinonaktifkan: Menampilkan semua status kapasitas gudang.',
        ),
        backgroundColor: _filterHanyaGudangLuang ? _green : _dark,
        duration: const Duration(seconds: 2),
      ),
    );
    _scrollToBankList();
  }

  /// 3. Kolom 3: Kargo 42.5 Kg -> Kelola muatan motor kargo
  void _onTapKargo() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) {
          final pct = (_muatanKargoSaatIni / _kapasitasMaksKargo).clamp(0.0, 1.0);
          final sisa = _kapasitasMaksKargo - _muatanKargoSaatIni;

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.local_shipping, color: _green, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Kelola Muatan Motor Kargo',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: _ink,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAF9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Muatan Saat Ini:', style: TextStyle(fontSize: 13, color: _muted)),
                          Text(
                            '${_muatanKargoSaatIni.toStringAsFixed(1)} Kg',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                              color: _green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Kapasitas Tersisa:', style: TextStyle(fontSize: 13, color: _muted)),
                          Text(
                            '${sisa.toStringAsFixed(1)} Kg (Maks ${_kapasitasMaksKargo.toInt()} Kg)',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: _ink),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: pct,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            pct > 0.85 ? Colors.orangeAccent : _green,
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sesuaikan Timbangan Muatan (Simulasi Penjemputan):',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _ink),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _muatanKargoSaatIni = (_muatanKargoSaatIni + 5.0).clamp(0.0, _kapasitasMaksKargo);
                          });
                          setS(() {});
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: _green),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('+5 Kg', style: TextStyle(color: _green, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _muatanKargoSaatIni = (_muatanKargoSaatIni + 10.0).clamp(0.0, _kapasitasMaksKargo);
                          });
                          setS(() {});
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: _green),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('+10 Kg', style: TextStyle(color: _green, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _muatanKargoSaatIni = (_muatanKargoSaatIni - 10.0).clamp(0.0, _kapasitasMaksKargo);
                          });
                          setS(() {});
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red.shade400),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text('-10 Kg', style: TextStyle(color: Colors.red.shade600, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _muatanKargoSaatIni = 0.0;
                          });
                          setS(() {});
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Muatan box kargo berhasil dikosongkan (0 Kg).'),
                              backgroundColor: _green,
                            ),
                          );
                        },
                        icon: const Icon(Icons.refresh, size: 16, color: Colors.orange),
                        label: const Text('Reset 0 Kg', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Colors.orange),
                          shape: const StadiumBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          if (_filteredList.isNotEmpty) {
                            _showSetorMuatanSheet(_filteredList.first);
                          }
                        },
                        icon: const Icon(Icons.unarchive_outlined, color: Colors.white, size: 18),
                        label: const Text(
                          'Setor ke Bank Sampah',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _green,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: const StadiumBorder(),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 4. Kolom 4: Armada ARM-03 -> Info dan pemilihan armada kurir
  void _onTapArmada() {
    final listArmada = [
      {
        'id': 'ARM-01',
        'nama': 'ARM-01 Ternate',
        'wilayah': 'Ternate Utara',
        'tipe': 'Motor Roda Tiga Viar 150cc',
        'nopol': 'DG 4581 KM',
        'kapasitas': '60 Kg',
      },
      {
        'id': 'ARM-02',
        'nama': 'ARM-02 Ternate',
        'wilayah': 'Ternate Tengah',
        'tipe': 'Motor Roda Tiga Viar 200cc',
        'nopol': 'DG 3922 KN',
        'kapasitas': '75 Kg',
      },
      {
        'id': 'ARM-03',
        'nama': 'ARM-03 Ternate',
        'wilayah': 'Ternate Selatan',
        'tipe': 'Motor Roda Tiga Viar Karya',
        'nopol': 'DG 5104 KP',
        'kapasitas': '60 Kg',
      },
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.two_wheeler, color: _green, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Pilih Armada Motor Kargo',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: _ink,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const Divider(height: 20),
            const Text(
              'Pilih unit armada motor kargo yang sedang Anda kendarai hari ini:',
              style: TextStyle(fontSize: 12, color: _muted),
            ),
            const SizedBox(height: 12),
            ...listArmada.map((arm) {
              final isAktif = _idArmadaAktif == arm['id'] || _idArmadaAktif == arm['nama'];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: isAktif ? _mintSoft.withValues(alpha: 0.4) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isAktif ? _green : Colors.grey.shade300,
                    width: isAktif ? 1.5 : 1,
                  ),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isAktif ? _green : Colors.grey.shade200,
                    child: Icon(
                      Icons.two_wheeler,
                      color: isAktif ? Colors.white : Colors.grey.shade700,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    '${arm['nama']} (${arm['wilayah']})',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isAktif ? _green : _ink,
                    ),
                  ),
                  subtitle: Text(
                    '${arm['tipe']} • ${arm['nopol']}\nKapasitas Maks: ${arm['kapasitas']}',
                    style: const TextStyle(fontSize: 11, color: _muted),
                  ),
                  trailing: isAktif
                      ? const Icon(Icons.check_circle, color: _green)
                      : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
                  onTap: () {
                    setState(() {
                      AppData.idArmada = arm['id']!;
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Armada operasional berhasil disetel ke: ${arm['nama']}'),
                        backgroundColor: _green,
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // MODAL BOTTOM SHEET NAVIGASI GPS & KONFIRMASI SETOR MUATAN
  // =========================================================================

  void _showNavigasiPengepul(Map<String, dynamic> bank) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Rute ke Lokasi Bank Sampah',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: _ink,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const Divider(height: 24),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _mintSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.storefront, color: _green, size: 26),
              ),
              title: Text(
                bank['namaBank']?.toString() ?? 'Bank Sampah',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: _ink,
                ),
              ),
              subtitle: Text(
                'Pengelola: ${bank['pemilik']}\n${bank['alamat']} (${bank['jarak']})',
                style: const TextStyle(fontSize: 12, color: _muted),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Membuka rute GPS menuju ${bank['namaBank']}...',
                      ),
                      backgroundColor: _green,
                    ),
                  );
                },
                icon: const Icon(Icons.directions, color: Colors.white),
                label: const Text(
                  'Mulai Navigasi GPS Sekarang',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const StadiumBorder(),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSetorMuatanSheet(Map<String, dynamic> bank) {
    if (_muatanKargoSaatIni <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Muatan kargo Anda saat ini kosong (0 Kg).'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Konfirmasi Setor Muatan Kargo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: _ink,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const Divider(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAF9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tujuan Penyetoran:',
                    style: TextStyle(fontSize: 11, color: _muted),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    bank['namaBank']?.toString() ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: _ink,
                    ),
                  ),
                  Text(
                    'Pemilik/Pengelola: ${bank['pemilik']}',
                    style: const TextStyle(fontSize: 12, color: _green, fontWeight: FontWeight.w600),
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Muatan Kargo Anda:',
                        style: TextStyle(fontSize: 13, color: _ink),
                      ),
                      Text(
                        '${_muatanKargoSaatIni.toStringAsFixed(1)} Kg',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                          color: _green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Armada Kurir:',
                        style: TextStyle(fontSize: 12, color: _muted),
                      ),
                      Text(
                        _idArmadaAktif,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: _ink,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '*Pastikan timbangan ulang bersama pemilik bank sampah telah sesuai sebelum menekan tombol konfirmasi.',
              style: TextStyle(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: _muted,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final beratDisetor = _muatanKargoSaatIni;
                  Navigator.pop(ctx);
                  setState(() {
                    _muatanKargoSaatIni = 0.0;
                  });
                  _showSuccessSetorDialog(bank, beratDisetor);
                },
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 20,
                ),
                label: const Text(
                  'Serahkan & Catat ke Gudang Mitra',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const StadiumBorder(),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessSetorDialog(Map<String, dynamic> bank, double berat) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: _mintSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inventory_2,
                color: _green,
                size: 50,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Muatan Berhasil Disetor!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: _ink),
            ),
            const SizedBox(height: 8),
            Text(
              'Sebanyak ${berat.toStringAsFixed(1)} Kg muatan sampah telah diserahkan kepada ${bank['pemilik']} (${bank['namaBank']}). Kapasitas box motor kargo Anda kini kembali kosong (0 Kg).',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: _muted),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _green,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                ),
                child: const Text(
                  'Selesai',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final persentaseMuatan =
        (_muatanKargoSaatIni / _kapasitasMaksKargo).clamp(0.0, 1.0);
    final filtered = _filteredList;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            // 1. TOP HEADER (BRAND & AVATAR & BACK BUTTON)
            Row(
              children: [
                if (Navigator.canPop(context))
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: _ink, size: 20),
                      onPressed: () => Navigator.pop(context),
                      tooltip: 'Kembali',
                    ),
                  ),
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
                      'Jaringan Mitra',
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
                  child: const Row(
                    children: [
                      Icon(Icons.hub_outlined, color: _green, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Ternate Aktif',
                        style: TextStyle(
                          color: _green,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
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
              ],
            ),
            const SizedBox(height: 14),

            // 2. SAPAAN & LOKASI
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 16, color: _ink),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'KOTA TERNATE, MALUKU UTARA',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.4,
                                color: _ink,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Bank Sampah & Pengepul Mitra 👋',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: _ink,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // 3. HERO GRAND CARD (IDENTIK DENGAN UKURAN & PROPORSI BERANDA HOME_VIEW)
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
                                      Icons.local_shipping_outlined,
                                      size: 20,
                                      color: Colors.white70,
                                    ),
                                    SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        'MUATAN BOX MOTOR KARGO',
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
                                      Icons.speed_outlined,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${(persentaseMuatan * 100).toStringAsFixed(0)}% Terisi',
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '${_muatanKargoSaatIni.toStringAsFixed(1)} Kg',
                                  style: const TextStyle(
                                    fontSize: 44,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '/ ${_kapasitasMaksKargo.toStringAsFixed(0)} Kg Maks',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
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
                            child: Row(
                              children: [
                                const Icon(Icons.inventory_2, size: 20, color: Colors.white),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Text(
                                    'Sisa Kapasitas Box Tersedia',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${(_kapasitasMaksKargo - _muatanKargoSaatIni).toStringAsFixed(1)} Kg',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: persentaseMuatan,
                              backgroundColor: Colors.white24,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                persentaseMuatan > 0.85
                                    ? Colors.orangeAccent
                                    : const Color(0xFF8CEB8C),
                              ),
                              minHeight: 8,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    if (filtered.isNotEmpty) {
                                      _showSetorMuatanSheet(filtered.first);
                                    }
                                  },
                                  icon: const Icon(Icons.unarchive_outlined, size: 18),
                                  label: const Text('Setor Muatan'),
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: const StadiumBorder(),
                                    backgroundColor: Colors.white,
                                    foregroundColor: _dark,
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _muatanKargoSaatIni = 0.0;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Muatan box kargo direset menjadi 0 Kg.'),
                                        backgroundColor: _green,
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.refresh, size: 18),
                                  label: const Text('Kosongkan Box'),
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: const StadiumBorder(),
                                    backgroundColor: _glass,
                                    foregroundColor: Colors.white,
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
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

            const SizedBox(height: 24),

            // 4. RINGKASAN STATUS OPERASIONAL (KINI 100% INTERAKTIF DAPAT DIKLIK)
            Row(
              children: [
                const Text(
                  'Status Operasional',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _ink,
                  ),
                ),
                const Spacer(),
                Text(
                  _filterHanyaGudangLuang ? 'Gudang Luang Aktif' : 'Ternate Aktif',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _filterHanyaGudangLuang ? Colors.orange.shade800 : _green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                // KOLOM 1: 4 Titik Mitra -> Klik untuk reset filter & lihat semua titik
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _onTapTitikMitra,
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                        decoration: BoxDecoration(
                          color: (!_filterHanyaGudangLuang && _selectedWilayah == 'Semua')
                              ? Colors.white
                              : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: (!_filterHanyaGudangLuang && _selectedWilayah == 'Semua' && _searchQuery.isEmpty)
                                ? _green
                                : Colors.grey.shade200,
                            width: (!_filterHanyaGudangLuang && _selectedWilayah == 'Semua' && _searchQuery.isEmpty) ? 1.5 : 1,
                          ),
                          boxShadow: const [
                            BoxShadow(color: Color(0x0A1A1C24), blurRadius: 8, offset: Offset(0, 3)),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _mintSoft,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.storefront, color: _green, size: 22),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$_totalMitra Titik\nMitra',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: _ink,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // KOLOM 2: 3 Gudang Luang -> Klik untuk filter bank sampah yang gudangnya luang
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _onTapGudangLuang,
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                        decoration: BoxDecoration(
                          color: _filterHanyaGudangLuang ? _mintSoft.withValues(alpha: 0.35) : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: _filterHanyaGudangLuang ? _green : Colors.grey.shade200,
                            width: _filterHanyaGudangLuang ? 2 : 1,
                          ),
                          boxShadow: const [
                            BoxShadow(color: Color(0x0A1A1C24), blurRadius: 8, offset: Offset(0, 3)),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _filterHanyaGudangLuang ? _green : _blueSoft,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.warehouse,
                                color: _filterHanyaGudangLuang ? Colors.white : _blueIcon,
                                size: 22,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$_gudangLuangCount Gudang\nLuang',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: _filterHanyaGudangLuang ? _green : _ink,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // KOLOM 3: Kargo Kg -> Klik untuk buka lembar kelola & timbang muatan kargo
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _onTapKargo,
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: const [
                            BoxShadow(color: Color(0x0A1A1C24), blurRadius: 8, offset: Offset(0, 3)),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _mintSoft,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.local_shipping, color: _green, size: 22),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Kargo\n${_muatanKargoSaatIni.toStringAsFixed(0)} Kg',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: _ink,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // KOLOM 4: Armada -> Klik untuk ganti atau lihat detail armada kurir
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _onTapArmada,
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: const [
                            BoxShadow(color: Color(0x0A1A1C24), blurRadius: 8, offset: Offset(0, 3)),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _lavender,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.two_wheeler, color: _green, size: 22),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Armada\n$_idArmadaAktif',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: _ink,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 5. PENCARIAN & FILTER WILAYAH
            TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Cari nama bank sampah, pemilik, atau komoditas...',
                hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: _green),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: _green, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 12),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  'Semua',
                  'Ternate Tengah',
                  'Ternate Selatan',
                  'Ternate Utara',
                ].map((wilayah) {
                  final isSelected = _selectedWilayah == wilayah;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      showCheckmark: false,
                      label: Text(
                        wilayah,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : _ink,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: _green,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? _green : Colors.grey.shade300,
                        ),
                      ),
                      onSelected: (_) => setState(() => _selectedWilayah = wilayah),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // 6. DAFTAR KARTU BANK SAMPAH (FULL WIDTH DENGAN PROPORSI KARTU AKTIVITAS HOME_VIEW)
            Row(
              children: [
                const Icon(Icons.hub_outlined, color: _green, size: 22),
                const SizedBox(width: 8),
                Text(
                  _filterHanyaGudangLuang
                      ? 'Bank Sampah Gudang Luang (<85%)'
                      : 'Titik Konsolidasi Bank Sampah',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _ink,
                  ),
                ),
                const Spacer(),
                Text(
                  '${filtered.length} Tersedia',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (filtered.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                decoration: _kartu(),
                child: Column(
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tidak ada bank sampah ditemukan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _filterHanyaGudangLuang
                          ? 'Tidak ada gudang dengan kapasitas luang di wilayah ini.'
                          : 'Coba ubah kata kunci pencarian atau filter wilayah.',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _filterHanyaGudangLuang = false;
                          _selectedWilayah = 'Semua';
                          _searchQuery = '';
                          _searchController.clear();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _green,
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text('Reset Semua Filter'),
                    ),
                  ],
                ),
              )
            else
              ...filtered.map((bank) {
                final double cap =
                    (bank['kapasitasGudang'] as num?)?.toDouble() ?? 0.5;
                final bool hampirPenuh = cap >= 0.85;

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(20),
                  decoration: _kartu(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: hampirPenuh
                                  ? Colors.orange.shade50
                                  : _mintSoft,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Gudang ${(cap * 100).toInt()}% • ${bank['statusKapasitas']}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: hampirPenuh
                                    ? Colors.orange.shade800
                                    : _green,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.near_me,
                                size: 14,
                                color: _green,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                bank['jarak']?.toString() ?? '',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _ink,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: _mintSoft,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.storefront,
                              color: _green,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bank['namaBank']?.toString() ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: _ink,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Pengelola: ${bank['pemilik']}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: _green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${bank['alamat']} • Jam Buka: ${bank['jamBuka']}',
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: _muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Tag Komoditas
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: (bank['komoditas'] as List<dynamic>? ?? [])
                            .map((kom) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F4F0),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Text(
                              kom.toString(),
                              style: const TextStyle(
                                fontSize: 11,
                                color: _ink,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const Divider(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _showNavigasiPengepul(bank),
                              icon: const Icon(
                                Icons.map_outlined,
                                size: 18,
                                color: _green,
                              ),
                              label: const Text(
                                'Rute Lokasi',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: _green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: _green, width: 1.5),
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed: () => _showSetorMuatanSheet(bank),
                              icon: const Icon(
                                Icons.unarchive_outlined,
                                size: 18,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Setor Muatan Kargo',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _green,
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                elevation: 0,
                              ),
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../api_service.dart';

const kGreen = Color(0xFF2E7D32);
const kBg = Color(0xFFF7F8FF);
const kSoft = Color(0xFFE8F5E9);

String rp(num v) {
  final s = v.round().abs().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return 'Rp $b';
}

BoxDecoration cardDeco() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: const [
        BoxShadow(color: Color(0x0F1A1C24), blurRadius: 10, offset: Offset(0, 3)),
      ],
    );

PreferredSizeWidget pemilikAppBar() => AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: kSoft, borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.eco, color: kGreen, size: 20),
        ),
        const SizedBox(width: 8),
        const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('REGREEN', style: TextStyle(color: kGreen, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 0.5)),
          Text('Mitra Pengelola Bank Sampah', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w500)),
        ]),
      ]),
    );

class PemilikData extends ChangeNotifier {
  PemilikData._();
  static final I = PemilikData._();

  final units = const [
    {'nama': 'Bank Sampah Makugasa', 'lokasi': 'Kel. Kayu Merah, Ternate', 'tipe': 'Bank Sampah', 'singkat': 'Makugasa'},
    {'nama': 'Bank Sampah Kel. Kalumata', 'lokasi': 'Kel. Kalumata, Ternate', 'tipe': 'Bank Sampah', 'singkat': 'Kalumata'},
    {'nama': 'TPS 3R Ake Tubo', 'lokasi': 'Kota Ternate', 'tipe': 'TPS 3R', 'singkat': 'Ake Tubo'},
  ];
  final kapasitas = const [1200.0, 900.0, 3000.0];
  int unit = 0;

  final Map<String, int> harga = {
    'Kardus Box': 3000,
    'Plastik PET': 5000,
    'Kaleng Aluminium': 7500,
    'Minyak Jelantah': 6500,
    'Besi Tipis': 2500,
  };

  final List<Map<String, double>> stok = [
    {'Kardus Box': 420, 'Plastik PET': 180, 'Kaleng Aluminium': 95},
    {'Plastik PET': 260, 'Minyak Jelantah': 120, 'Kardus Box': 150},
    {'Kardus Box': 610, 'Plastik PET': 340, 'Besi Tipis': 210, 'Kaleng Aluminium': 130},
  ];

  // ==== DATA DARI SERVER (database = sumber kebenaran, diisi oleh muat()) ====
  // Permintaan nasabah yang aktif: DIAJUKAN (belum ada kurir) / DITUGASKAN (kurir sedang jalan)
  final List<Map<String, dynamic>> permintaanNasabah = [];
  // Kurir sudah menimbang, menunggu mitra membayar nasabah
  final List<Map<String, dynamic>> setoranMenungguBayar = [];
  // Armada kurir beserta performa & gaji
  final List<Map<String, dynamic>> kurirList = [];

  bool isLoading = false;
  String? errorMuat;

  // Setoran legacy kompatibilitas
  final List<List<Map<String, dynamic>>> setoran = [
    [
      {'id': 'STR-101', 'kurir': 'Ahmad Fauzi', 'armada': 'ARM-03', 'asal': 'Ibu Salma Latif • Gamalama', 'komoditas': 'Kardus Box', 'berat': 15.0, 'eta': '± 6 mnt'},
    ],
    [],
    [],
  ];

  final List<List<Map<String, dynamic>>> nasabah = [
    [
      {'nama': 'Ibu Salma Latif', 'hp': '081245966332', 'saldo': 128500, 'kg': 86.0},
      {'nama': 'Pak Budi Santoso', 'hp': '081340011223', 'saldo': 82500, 'kg': 18.2},
      {'nama': 'Siti Rahma', 'hp': '082199887766', 'saldo': 78000, 'kg': 12.0},
    ],
    [
      {'nama': 'Pak Ruslan Taher', 'hp': '081234567890', 'saldo': 210000, 'kg': 64.0},
      {'nama': 'Ibu Rahmawati', 'hp': '085240022334', 'saldo': 45000, 'kg': 9.5},
    ],
    [
      {'nama': 'Kantor Dinas LH', 'hp': '082188770011', 'saldo': 135000, 'kg': 45.0},
    ],
  ];

  Map<String, dynamic> get unitAktif => units[unit];
  double get totalStok => stok[unit].values.fold<double>(0, (a, b) => a + b);
  double get sisaKapasitas => kapasitas[unit] - totalStok;
  int get nilaiStok => stok[unit].entries.fold<int>(0, (a, e) => a + (e.value * (harga[e.key] ?? 0)).round());

  int get totalPermintaanBaru => permintaanNasabah.where((p) => p['status'] == 'DIAJUKAN').length;
  int get totalMenungguBayar => setoranMenungguBayar.length;

  void pilihUnit(int i) {
    unit = i;
    notifyListeners();
  }

  void setHarga(String k, int v) {
    harga[k] = v;
    notifyListeners();
  }

  // ---------- Muat ulang semua data alur penjemputan dari server ----------
  Future<void> muat() async {
    isLoading = true;
    errorMuat = null;
    notifyListeners();

    final orders = await ApiService.getPenjemputanOrNull();
    final kurir = await ApiService.getDaftarKurir();

    if (orders == null) {
      errorMuat = 'Gagal memuat data dari server. Periksa koneksi lalu tarik untuk menyegarkan.';
    } else {
      _petakanOrder(orders);
    }
    kurirList
      ..clear()
      ..addAll(kurir.map(_petakanKurir));

    isLoading = false;
    notifyListeners();
  }

  static double _num(dynamic v) => v is num ? v.toDouble() : (double.tryParse('$v') ?? 0);

  static Map<String, dynamic> _map(dynamic v) =>
      v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{};

  static List<Map<String, dynamic>> _details(Map<String, dynamic> p) =>
      p['details'] is List ? (p['details'] as List).map(_map).toList() : [];

  static String _komoditas(Map<String, dynamic> p) {
    final names = _details(p)
        .map((d) => _map(d['jenis_sampah'])['nama']?.toString())
        .whereType<String>()
        .toList();
    return names.isEmpty ? 'Sampah Terpilah' : names.join(' & ');
  }

  static String _waktu(dynamic iso) {
    final t = DateTime.tryParse('$iso')?.toLocal();
    if (t == null) return '-';
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 1) return 'Baru saja';
    if (d.inMinutes < 60) return '${d.inMinutes} Menit lalu';
    if (d.inHours < 24) return '${d.inHours} Jam lalu';
    return '${d.inDays} Hari lalu';
  }

  void _petakanOrder(List<Map<String, dynamic>> orders) {
    permintaanNasabah.clear();
    setoranMenungguBayar.clear();

    for (final p in orders) {
      final status = p['status']?.toString().toUpperCase() ?? '';
      final user = _map(p['user']);
      final kurir = _map(p['kurir']);
      final id = p['id'];

      if (status == 'DIAJUKAN' || status == 'DITERIMA' || status == 'DALAM PROSES') {
        permintaanNasabah.add({
          'id': 'REG-$id',
          'backendId': id,
          'nasabah': user['nama'] ?? 'Nasabah',
          'hp': user['no_hp'] ?? '-',
          'alamat': p['lokasi'] ?? '-',
          'sesi': p['sesi'] ?? '-',
          'komoditas': _komoditas(p),
          'beratEstimasi': _num(p['total_berat']),
          'estimasiNilai': _num(p['total_harga']).round(),
          'catatan': (p['catatan'] ?? '-').toString(),
          'status': status == 'DIAJUKAN' ? 'DIAJUKAN' : 'DITUGASKAN',
          'kurir': kurir['nama'],
          'waktu': _waktu(p['created_at']),
        });
      } else if (status == 'DIJEMPUT') {
        final rincian = _details(p)
            .map((d) => '${_map(d['jenis_sampah'])['nama'] ?? 'Sampah'} ${_num(d['berat_aktual'] ?? d['berat_estimasi']).toStringAsFixed(1)} kg')
            .join(' • ');
        setoranMenungguBayar.add({
          'id': 'STR-$id',
          'orderId': 'REG-$id',
          'backendId': id,
          'kurir': kurir['nama'] ?? '-',
          'armada': kurir['id'] != null ? 'ARM-${kurir['id'].toString().padLeft(2, '0')}' : '-',
          'nasabah': user['nama'] ?? 'Nasabah',
          'hp': user['no_hp'] ?? '-',
          'alamat': p['lokasi'] ?? '-',
          'komoditas': _komoditas(p),
          'beratAktual': _num(p['total_berat']),
          'totalBayar': _num(p['total_harga']).round(),
          'rincian': rincian.isEmpty ? '-' : rincian,
          'status': 'DITIMBANG',
          'waktu': _waktu(p['updated_at']),
        });
      }
    }
  }

  Map<String, dynamic> _petakanKurir(Map<String, dynamic> k) => {
        'id': k['id'],
        'nama': k['nama'] ?? '-',
        'armada': k['armada'] ?? '-',
        'kendaraan': k['kendaraan'] ?? '-',
        'rating': _num(k['rating']),
        'totalUlasan': _num(k['total_ulasan']).toInt(),
        'poinKinerja': _num(k['poin_kinerja']).toInt(),
        'tugasSelesai': _num(k['tugas_selesai']).toInt(),
        'totalKg': _num(k['total_kg']),
        'gajiAkumulasi': _num(k['gaji_akumulasi']).toInt(),
        'status': k['status'] ?? 'Siap Ditugaskan',
        'statusGaji': k['status_gaji'] ?? '-',
      };

  static String? _pesanError(Map<String, dynamic> r) {
    if (r['success'] == true) return null;
    final data = r['data'];
    return (data is Map ? data['message'] : null)?.toString() ??
        r['message']?.toString() ??
        'Terjadi kesalahan, coba lagi.';
  }

  // ---------- Aksi (semua lewat server; return null = sukses, selain itu pesan error) ----------

  // MITRA MENUGASKAN KURIR: DIAJUKAN -> DITERIMA
  Future<String?> tugaskanKurir(Map<String, dynamic> permintaan, Map<String, dynamic> kurir) async {
    final r = await ApiService.tugaskanKurir(
      id: permintaan['backendId'] ?? permintaan['id'],
      kurirId: kurir['id'],
    );
    await muat();
    return _pesanError(r);
  }

  // MITRA MEMBAYAR NASABAH: DIJEMPUT -> SELESAI. Nominal dihitung server dari data timbangan.
  Future<String?> bayarNasabah(Map<String, dynamic> setoran) async {
    final r = await ApiService.selesaiPenjemputan(
      id: setoran['backendId'] ?? setoran['orderId'],
      totalBerat: _num(setoran['beratAktual']),
      totalSaldo: _num(setoran['totalBayar']),
    );
    final error = _pesanError(r);
    if (error == null) {
      // Gudang masih data lokal (belum ada tabel stok di backend)
      final kg = _num(setoran['beratAktual']);
      final kom = (setoran['komoditas'] as String).split('&')[0].trim();
      final target = stok[unit].containsKey(kom) ? kom : stok[unit].keys.first;
      stok[unit][target] = (stok[unit][target] ?? 0) + kg;
    }
    await muat();
    return error;
  }

  // MITRA MEMBAYAR GAJI KURIR (maksimal sebesar gaji yang belum dibayar)
  Future<String?> bayarGajiKurir(Map<String, dynamic> kurir, double nominal) async {
    final r = await ApiService.bayarGajiKurir(kurirId: kurir['id'], nominal: nominal);
    await muat();
    return _pesanError(r);
  }

  void setorNasabah(int ni, String kom, double kg) {
    stok[unit][kom] = (stok[unit][kom] ?? 0) + kg;
    final n = nasabah[unit][ni];
    n['saldo'] = (n['saldo'] as int) + (kg * (harga[kom] ?? 0)).round();
    n['kg'] = (n['kg'] as double) + kg;
    notifyListeners();
  }

  void cairkan(int ni, int nominal) {
    final n = nasabah[unit][ni];
    n['saldo'] = (n['saldo'] as int) - nominal;
    notifyListeners();
  }
}

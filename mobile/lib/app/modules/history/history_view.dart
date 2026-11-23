import 'package:flutter/material.dart';

import '../mitra/pemilik_data.dart';
import '../../../api_service.dart';
import '../../../app_data.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _apiItems = [];
  int _selectedFilter = 0; // 0: Semua, 1: Dalam Proses, 2: Selesai

  @override
  void initState() {
    super.initState();
    _fetchRiwayat();
  }

  Future<void> _fetchRiwayat() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    final items = await ApiService.getRiwayatPenjemputan();

    if (!mounted) return;
    setState(() {
      _apiItems = items;
      _isLoading = false;
    });
  }

  void _showRatingDialog(Map<String, dynamic> item) {
    int rating = 5;
    final List<String> tags = ['Tepat Waktu', 'Ramah & Sopan', 'Timbangan Akurat', 'Cepat Tanggap'];
    final Set<String> selectedTags = {'Tepat Waktu', 'Ramah & Sopan'};
    final ulasanC = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.star, color: Colors.amber, size: 24),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text('Nilai Pelayanan Kurir', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Penilaian Anda akan menjadi poin kinerja & reward langsung bagi kurir armada!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    final isFilled = i < rating;
                    return IconButton(
                      icon: Icon(
                        isFilled ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 32,
                      ),
                      onPressed: () => setS(() => rating = i + 1),
                    );
                  }),
                ),
                Text(
                  rating == 5
                      ? 'Luar Biasa (+50 Poin Kurir)'
                      : rating == 4
                          ? 'Sangat Baik (+40 Poin Kurir)'
                          : rating == 3
                              ? 'Cukup (+30 Poin Kurir)'
                              : 'Perlu Ditingkatkan',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2E7D32)),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: tags.map((t) {
                    final sel = selectedTags.contains(t);
                    return FilterChip(
                      label: Text(t, style: TextStyle(fontSize: 11, color: sel ? Colors.white : Colors.black87)),
                      selected: sel,
                      selectedColor: const Color(0xFF2E7D32),
                      backgroundColor: Colors.grey.shade100,
                      onSelected: (val) {
                        setS(() {
                          if (val) {
                            selectedTags.add(t);
                          } else {
                            selectedTags.remove(t);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: ulasanC,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Tulis apresiasi atau saran untuk kurir...',
                    hintStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Nanti')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                final hasil = await ApiService.beriPenilaianKurir(
                  id: item['id'],
                  rating: rating.toDouble(),
                  ulasan: ulasanC.text.trim(),
                  tags: selectedTags.toList(),
                );
                Navigator.pop(ctx);
                if (hasil['success'] != true) {
                  final dd = hasil['data'];
                  final msg = (dd is Map ? dd['message'] : null) ?? 'Gagal mengirim penilaian';
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$msg'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating),
                  );
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✓ Terima kasih! Penilaian $rating ⭐ berhasil dikirim. Kurir menerima bonus poin kinerja.'),
                    backgroundColor: const Color(0xFF2E7D32),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Kirim Penilaian', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFormattedItems() {
    if (_apiItems.isEmpty) {
      // Data dummy sebagai referensi jika riwayat penjemputan baru masih kosong
      return [
        {
          'id': '#REG-20240527-09',
          'status': 'Masih dalam proses',
          'statusColor': Colors.orange,
          'date': 'Hari ini • 10:30 WIT',
          'category': 'KATEGORI & BOBOT',
          'weight': '18.5 kg (Kardus & Plastik PET)',
          'pickupPoint': 'TITIK JEMPUT',
          'address': 'Jl. Revolusi No. 42, Kalumata, Ternate',
          'note': 'Kurir sedang menuju lokasi Anda',
          'estimate': 'Rp 55.500',
          'buttonText': 'Pantau Kurir',
          'isProcess': true,
        },
        {
          'id': '#REG-20240524-03',
          'status': 'Sudah dikonfirmasi',
          'statusColor': Colors.green,
          'date': '24 Mei 2024 • 14:15 WIT',
          'category': 'KATEGORI & BOBOT',
          'weight': '12.5 kg (Koran Bekas & Kaleng Logam)',
          'pickupPoint': 'TITIK JEMPUT',
          'address': 'Jl. Revolusi No. 42, Kalumata, Ternate',
          'note': null,
          'estimate': '+ Rp 37.500',
          'buttonText': 'Unduh Struk',
          'isProcess': false,
        },
      ];
    }

    return _apiItems.map((e) {
      final status = e['status']?.toString() ?? 'DIAJUKAN';
      final isDone = status == 'SELESAI';
      final isBatal = status == 'DIBATALKAN';
      final totalBerat = e['total_berat'] ?? 0;
      final totalHarga = e['total_harga'] ?? 0;
      final sesi = e['sesi'] ?? 'PAGI';
      final tgl = e['tanggal'] ?? '';

      Color color = Colors.orange;
      String statusLabel = 'Masih dalam proses';
      if (isDone) {
        color = Colors.green;
        statusLabel = 'Sudah dikonfirmasi';
      } else if (isBatal) {
        color = Colors.red;
        statusLabel = 'Dibatalkan';
      }

      return {
        'id': '#REG-${e['id']}',
        'status': statusLabel,
        'statusColor': color,
        'date': '$tgl • Sesi $sesi',
        'category': 'KATEGORI & BOBOT',
        'weight': '$totalBerat kg',
        'pickupPoint': 'TITIK JEMPUT',
        'address': e['lokasi'] ?? 'Jl. Revolusi No. 42, Kalumata',
        'note': e['catatan'],
        'estimate': '${isDone ? '+' : ''} Rp ${AppData.formatAngka(double.tryParse(totalHarga.toString())?.toInt() ?? 0)}',
        'buttonText': isDone ? 'Unduh Struk' : 'Pantau Kurir',
        'isProcess': !isDone && !isBatal,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final allItems = _getFormattedItems();
    final filteredItems = allItems.where((item) {
      if (_selectedFilter == 1) return item['isProcess'] == true;
      if (_selectedFilter == 2) return item['isProcess'] == false;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Riwayat',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchRiwayat,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchRiwayat,
        color: Colors.green[800],
        child: Column(
          children: [
            // Bagian Ringkasan Riwayat
            Container(
              color: Colors.green[800],
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[700],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'RINGKASAN RIWAYAT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Bulan Ini',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSummaryItem(
                          Icons.scale,
                          'Total Bobot',
                          AppData.totalSampah.isNotEmpty ? AppData.totalSampah : '0 kg',
                        ),
                        _buildSummaryItem(
                          Icons.check_circle,
                          'Total Order',
                          '${allItems.length} Kali',
                        ),
                        _buildSummaryItem(
                          Icons.account_balance_wallet,
                          'Saldo Saat Ini',
                          'Rp ${AppData.formatAngka(AppData.saldoTersedia)}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Filter Tab
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _selectedFilter = 0),
                    child: _buildFilterChip(
                      'Semua (${allItems.length})',
                      isSelected: _selectedFilter == 0,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() => _selectedFilter = 1),
                    child: _buildFilterChip(
                      'Dalam Proses (${allItems.where((i) => i['isProcess'] == true).length})',
                      isSelected: _selectedFilter == 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() => _selectedFilter = 2),
                    child: _buildFilterChip(
                      'Selesai (${allItems.where((i) => i['isProcess'] == false).length})',
                      isSelected: _selectedFilter == 2,
                    ),
                  ),
                ],
              ),
            ),

            // List Riwayat
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.green),
                    )
                  : filteredItems.isEmpty
                      ? const Center(
                          child: Text(
                            'Tidak ada riwayat penjemputan pada filter ini.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Header: ID & Status
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item['id'],
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: (item['statusColor'] as Color)
                                                .withOpacity(0.15),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                item['isProcess']
                                                    ? Icons.schedule
                                                    : Icons.check_circle,
                                                size: 12,
                                                color: item['statusColor'],
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                item['status'],
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: item['statusColor'],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item['date'],
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const Divider(height: 20),

                                    // Kategori & Bobot
                                    Text(
                                      item['category'],
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item['weight'],
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    // Titik Jemput
                                    if (item['pickupPoint'] != null) ...[
                                      Text(
                                        item['pickupPoint'],
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item['address'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],

                                    // Catatan (jika ada)
                                    if (item['note'] != null &&
                                        item['note'].toString().isNotEmpty) ...[
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            size: 14,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            item['note'],
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                    ],

                                    // Footer: Estimasi & Tombol
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['isProcess']
                                                  ? 'Estimasi Nilai'
                                                  : 'Saldo Diterima',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                            Text(
                                              item['estimate'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: item['isProcess']
                                                    ? Colors.black87
                                                    : Colors.green[800],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            if (!item['isProcess']) ...[
                                              ElevatedButton.icon(
                                                onPressed: () => _showRatingDialog(item),
                                                icon: const Icon(Icons.star, color: Colors.amber, size: 14),
                                                label: const Text('Beri Nilai Kurir', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(0xFFFFF3E0),
                                                  foregroundColor: const Color(0xFFE65100),
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                            ],
                                            ElevatedButton(
                                              onPressed: () {
                                                if (!item['isProcess']) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Struk resmi transaksi berhasil diunduh ke perangkat Anda.')),
                                                  );
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: item['isProcess'] ? Colors.green[800] : Colors.grey[200],
                                                foregroundColor: item['isProcess'] ? Colors.white : Colors.black87,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                              ),
                                              child: Text(item['buttonText'], style: const TextStyle(fontSize: 11)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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

  Widget _buildSummaryItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green[800] : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

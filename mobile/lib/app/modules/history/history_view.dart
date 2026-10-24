
import 'package:flutter/material.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  String selectedFilter = 'Semua';

  final List<Map<String, dynamic>> historyItems = [
    {
      'id': '#REG-20240527-09',
      'status': 'Masih dalam proses',
      'statusColor': Colors.orange,
      'date': 'Hari ini, 27 Mei 2024 • 10:30 WIT',
      'category': 'KATEGORI & BOBOT',
      'weight': '18.5 kg (Kardus & Plastik PET Campur)',
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
    {
      'id': '#REG-20240519-11',
      'status': 'Sudah dikonfirmasi',
      'statusColor': Colors.green,
      'date': '19 Mei 2024 • 09:00 WIT',
      'category': 'KATEGORI & BOBOT',
      'weight': '8.0 kg (Minyak Jelantah & Kardus Box)',
      'pickupPoint': 'LOKASI DROP/JEMPUT',
      'address': 'Kantor Eco Hub Ternate Tengah',
      'note': null,
      'estimate': '+ Rp 28.000',
      'buttonText': 'Unduh Struk',
      'isProcess': false,
    },
    {
      'id': '#REG-20240512-05',
      'status': 'Sudah dikonfirmasi',
      'statusColor': Colors.green,
      'date': '12 Mei 2024 • 16:00 WIT',
      'category': 'KATEGORI & BOBOT',
      'weight': '25.0 kg (Buku Bekas & Kertas Arsip)',
      'pickupPoint': null,
      'address': null,
      'note': null,
      'estimate': '+ Rp 62.500',
      'buttonText': 'Unduh Struk',
      'isProcess': false,
    },
  ];

  List<Map<String, dynamic>> get filteredItems {
    if (selectedFilter == 'Dalam Proses') {
      return historyItems
          .where((item) => item['isProcess'] == true)
          .toList();
    }

    if (selectedFilter == 'Selesai') {
      return historyItems
          .where((item) => item['isProcess'] == false)
          .toList();
    }

    return historyItems;
  }

  void showTracking(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.local_shipping, color: Colors.green),
              SizedBox(width: 8),
              Expanded(child: Text('Pantau Penjemputan')),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['id'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 16),
              _buildTrackingStep(
                Icons.check_circle,
                'Permintaan diterima',
                'Permintaan penjemputan telah tercatat.',
                true,
              ),
              _buildTrackingStep(
                Icons.local_shipping,
                'Kurir menuju lokasi',
                item['note'] as String? ??
                    'Kurir sedang menuju lokasi penjemputan.',
                true,
              ),
              _buildTrackingStep(
                Icons.scale,
                'Penimbangan sampah',
                'Menunggu proses penjemputan dan penimbangan.',
                false,
              ),
              _buildTrackingStep(
                Icons.account_balance_wallet,
                'Saldo diterima',
                'Saldo diberikan setelah transaksi selesai.',
                false,
              ),
              const SizedBox(height: 8),
              const Text(
                'Catatan: informasi ini merupakan simulasi '
                'karena aplikasi masih menggunakan data dummy.',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Tutup',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTrackingStep(
    IconData icon,
    String title,
    String description,
    bool completed,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 22,
            color: completed ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: completed ? Colors.green[800] : Colors.grey,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showReceipt(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.receipt_long, color: Colors.green),
              SizedBox(width: 8),
              Expanded(child: Text('Struk Transaksi')),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.eco,
                        color: Colors.green,
                        size: 42,
                      ),
                      Text(
                        'REGREEN',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        'Bukti Transaksi Daur Ulang',
                        style: TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 28),
                _receiptRow('ID Transaksi', item['id'] as String),
                _receiptRow('Tanggal', item['date'] as String),
                _receiptRow('Status', item['status'] as String),
                const Divider(height: 24),
                const Text(
                  'Kategori & Bobot',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item['weight'] as String,
                  style: const TextStyle(fontSize: 13),
                ),
                if (item['address'] != null) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Lokasi Penjemputan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['address'] as String,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
                const Divider(height: 24),
                _receiptRow(
                  'Total Nilai',
                  item['estimate'] as String,
                  bold: true,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Struk ini merupakan pratinjau transaksi '
                  'dari data simulasi REGREEN.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Tutup',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Pratinjau struk ditutup. '
                      'Fitur simpan PDF belum diaktifkan.',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.check, size: 18),
              label: const Text('Selesai'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[800],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _receiptRow(
    String label,
    String value, {
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                color: bold ? Colors.green[800] : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showNotifications() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.notifications_active, color: Colors.green),
              SizedBox(width: 8),
              Text('Notifikasi'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.local_shipping,
                  color: Colors.orange,
                ),
                title: Text(
                  'Penjemputan diproses',
                  style: TextStyle(fontSize: 13),
                ),
                subtitle: Text(
                  'Kurir sedang menuju lokasi Anda.',
                  style: TextStyle(fontSize: 11),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.account_balance_wallet,
                  color: Colors.green,
                ),
                title: Text(
                  'Transaksi selesai',
                  style: TextStyle(fontSize: 13),
                ),
                subtitle: Text(
                  'Lihat riwayat untuk memeriksa transaksi.',
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Tutup',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = filteredItems;
    final processCount =
        historyItems.where((item) => item['isProcess'] == true).length;
    final completedCount =
        historyItems.where((item) => item['isProcess'] == false).length;

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
            icon: const Icon(Icons.notifications_none),
            onPressed: showNotifications,
          ),
          const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 16,
            child: Icon(Icons.person, color: Colors.green, size: 22),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Ringkasan Riwayat
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
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
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
                        '124 kg',
                      ),
                      _buildSummaryItem(
                        Icons.check_circle,
                        'Selesai',
                        '14 Kali',
                      ),
                      _buildSummaryItem(
                        Icons.account_balance_wallet,
                        'Pendapatan',
                        'Rp 498.5k',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Filter Riwayat
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(
                    'Semua',
                    'Semua (${historyItems.length})',
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    'Dalam Proses',
                    'Dalam Proses ($processCount)',
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    'Selesai',
                    'Selesai ($completedCount)',
                  ),
                ],
              ),
            ),
          ),

          // List Riwayat
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text('Belum ada riwayat transaksi.'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];

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
                              // ID dan Status
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item['id'] as String,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: (item['statusColor'] as Color)
                                            .withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            item['isProcess'] == true
                                                ? Icons.schedule
                                                : Icons.check_circle,
                                            size: 12,
                                            color: item['statusColor'] as Color,
                                          ),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              item['status'] as String,
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: item['statusColor']
                                                    as Color,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['date'] as String,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const Divider(height: 20),

                              // Kategori dan Bobot
                              Text(
                                item['category'] as String,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item['weight'] as String,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Lokasi
                              if (item['pickupPoint'] != null) ...[
                                Text(
                                  item['pickupPoint'] as String,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item['address'] as String,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],

                              // Catatan
                              if (item['note'] != null) ...[
                                Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      size: 14,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        item['note'] as String,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],

                              // Nilai dan Tombol
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['isProcess'] == true
                                              ? 'Estimasi Nilai'
                                              : 'Saldo Diterima',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                        Text(
                                          item['estimate'] as String,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: item['isProcess'] == true
                                                ? Colors.black87
                                                : Colors.green[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (item['isProcess'] == true) {
                                          showTracking(item);
                                        } else {
                                          showReceipt(item);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            item['isProcess'] == true
                                                ? Colors.green[800]
                                                : Colors.grey[200],
                                        foregroundColor:
                                            item['isProcess'] == true
                                                ? Colors.white
                                                : Colors.black87,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                      ),
                                      child: Text(
                                        item['buttonText'] as String,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                    ),
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
    );
  }

  Widget _buildSummaryItem(
    IconData icon,
    String label,
    String value,
  ) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final bool isSelected = selectedFilter == value;

    return InkWell(
      onTap: () {
        setState(() {
          selectedFilter = value;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 6,
        ),
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
      ),
    );
  }
}

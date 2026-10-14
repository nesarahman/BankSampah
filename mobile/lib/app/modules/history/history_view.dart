import 'package:flutter/material.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy sesuai desain di file
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
            onPressed: () {},
          ),
          const CircleAvatar(
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            radius: 16,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
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
                      _buildSummaryItem(Icons.scale, 'Total Bobot', '124 kg'),
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

          // Filter Tab
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip('Semua (4)', isSelected: true),
                const SizedBox(width: 8),
                _buildFilterChip('Dalam Proses (1)'),
                const SizedBox(width: 8),
                _buildFilterChip('Selesai (3)'),
              ],
            ),
          ),

          // List Riwayat
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: historyItems.length,
              itemBuilder: (context, index) {
                final item = historyItems[index];
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                color: item['statusColor'].withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
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
                        if (item['note'] != null) ...[
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: item['isProcess']
                                    ? Colors.green[800]
                                    : Colors.grey[200],
                                foregroundColor: item['isProcess']
                                    ? Colors.white
                                    : Colors.black87,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                              child: Text(
                                item['buttonText'],
                                style: const TextStyle(fontSize: 11),
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

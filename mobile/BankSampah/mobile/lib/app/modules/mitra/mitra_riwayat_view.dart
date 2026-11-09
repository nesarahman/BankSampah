import 'package:flutter/material.dart';

class MitraRiwayatView extends StatefulWidget {
  const MitraRiwayatView({super.key});

  @override
  State<MitraRiwayatView> createState() => _MitraRiwayatViewState();
}

class _MitraRiwayatViewState extends State<MitraRiwayatView> {
  String _selectedFilter = 'Semua';
  static const primaryGreen = Color(0xFF2E7D32);

  final List<Map<String, dynamic>> _riwayatList = [
    {
      'id': 'REG-8901',
      'nama': 'Pak Budi Santoso',
      'waktu': 'Hari Ini, 09:30 WIT',
      'berat': '18.2 Kg',
      'material': 'Kardus Box & Logam Kaleng',
      'alamat': 'Jl. Bastiong No. 12, Ternate Selatan',
      'komisi': 'Rp 15.000',
      'status': 'SELESAI',
      'filterGroup': 'Hari Ini',
      'rincian': [
        {'nama': 'Kardus Box', 'berat': '12.0 Kg', 'subtotal': 'Rp 36.000'},
        {'nama': 'Logam Kaleng', 'berat': '6.2 Kg', 'subtotal': 'Rp 46.500'},
      ],
      'totalNasabah': 'Rp 82.500',
    },
    {
      'id': 'REG-8898',
      'nama': 'Ibu Rahmawati',
      'waktu': 'Hari Ini, 07:45 WIT',
      'berat': '12.0 Kg',
      'material': 'Minyak Jelantah (UCO)',
      'alamat': 'Jl. Pantai Kalumata No. 5',
      'komisi': 'Rp 12.000',
      'status': 'SELESAI',
      'filterGroup': 'Hari Ini',
      'rincian': [
        {'nama': 'Minyak Jelantah', 'berat': '12.0 L', 'subtotal': 'Rp 78.000'},
      ],
      'totalNasabah': 'Rp 78.000',
    },
    {
      'id': 'REG-8895',
      'nama': 'Kantor Dinas LH',
      'waktu': '2 Nov 2026, 11:20 WIT',
      'berat': '45.0 Kg',
      'material': 'Kertas Arsip & Karton Tebal',
      'alamat': 'Kompleks Perkantoran Pemda Ternate',
      'komisi': 'Rp 35.000',
      'status': 'SELESAI',
      'filterGroup': 'Minggu Ini',
      'rincian': [
        {'nama': 'Kertas Arsip', 'berat': '30.0 Kg', 'subtotal': 'Rp 90.000'},
        {'nama': 'Karton Tebal', 'berat': '15.0 Kg', 'subtotal': 'Rp 45.000'},
      ],
      'totalNasabah': 'Rp 135.000',
    },
    {
      'id': 'REG-8890',
      'nama': 'Warung Bu Siti',
      'waktu': '1 Nov 2026, 14:10 WIT',
      'berat': '22.5 Kg',
      'material': 'Botol Plastik PET & Cup PP',
      'alamat': 'Jl. Gamalama Pasar Sentral',
      'komisi': 'Rp 18.000',
      'status': 'SELESAI',
      'filterGroup': 'Minggu Ini',
      'rincian': [
        {'nama': 'Botol PET Bening', 'berat': '15.0 Kg', 'subtotal': 'Rp 63.000'},
        {'nama': 'Cup Plastik PP', 'berat': '7.5 Kg', 'subtotal': 'Rp 22.500'},
      ],
      'totalNasabah': 'Rp 85.500',
    },
  ];

  List<Map<String, dynamic>> get _filteredList {
    if (_selectedFilter == 'Semua') return _riwayatList;
    return _riwayatList.where((item) => item['filterGroup'] == _selectedFilter).toList();
  }

  void _showStrukDialog(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Detail Penjemputan #${item['id']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(item['waktu'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const Divider(),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(backgroundColor: Color(0xFFE8F5E9), child: Icon(Icons.person, color: primaryGreen, size: 20)),
              title: Text(item['nama'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: Text(item['alamat'], style: const TextStyle(fontSize: 11)),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFF9FAF9), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade200)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Rincian Sampah Terpilah:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 6),
                  if (item['rincian'] != null)
                    ...(item['rincian'] as List).map((r) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${r['nama']} (${r['berat']})', style: const TextStyle(fontSize: 12)),
                              Text(r['subtotal'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                        )),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Setoran Nasabah:', style: TextStyle(fontSize: 12)),
                      Text(item['totalNasabah'] ?? 'Rp 62.040', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: primaryGreen)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Komisi Kurir Anda:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      Text(item['komisi'], style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: primaryGreen)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Struk #${item['id']} berhasil dibagikan ke WhatsApp!'),
                      backgroundColor: primaryGreen,
                    ),
                  );
                },
                icon: const Icon(Icons.share, color: Colors.white, size: 18),
                label: const Text('Bagikan Struk ke WhatsApp Nasabah', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, padding: const EdgeInsets.symmetric(vertical: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPerformaDetail() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Statistik Performa Kurir', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.task_alt, color: primaryGreen),
              title: const Text('42 Order Selesai'),
              subtitle: const Text('Tingkat penyelesaian 98.5% tanpa pembatalan.'),
            ),
            ListTile(
              leading: const Icon(Icons.scale, color: primaryGreen),
              title: const Text('524.0 Kg Sampah Terkumpul'),
              subtitle: const Text('Membantu mereduksi 1.2 ton emisi karbon di Ternate.'),
            ),
            ListTile(
              leading: const Icon(Icons.payments, color: primaryGreen),
              title: const Text('Rp 580.000 Total Komisi'),
              subtitle: const Text('Komisi dasar Rp 480.000 + Bonus tonase Rp 100.000.'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Riwayat Jemputan',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. STATS RINGKASAN BULANAN (Clickable)
            InkWell(
              onTap: _showPerformaDetail,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'PERFORMA JEMPUTAN BULAN INI',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'Detail >',
                          style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatItem('42', 'Order Selesai', Icons.task_alt),
                        Container(width: 1, height: 32, color: Colors.white24),
                        _buildStatItem('524 Kg', 'Total Tonase', Icons.scale),
                        Container(width: 1, height: 32, color: Colors.white24),
                        _buildStatItem('Rp 580rb', 'Total Komisi', Icons.payments),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 2. FILTER TABS (Interactive)
            Row(
              children: ['Semua', 'Hari Ini', 'Minggu Ini'].map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(
                      filter,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: primaryGreen,
                    backgroundColor: Colors.white,
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? primaryGreen : Colors.grey.shade300,
                      ),
                    ),
                    onSelected: (val) {
                      setState(() => _selectedFilter = filter);
                    },
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // 3. DAFTAR RIWAYAT SELESAI (Clickable to open receipt)
            ..._filteredList.map((item) {
              return InkWell(
                onTap: () => _showStrukDialog(item),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F5E9),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(Icons.check_circle, color: primaryGreen, size: 14),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '#${item['id']}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '+ Komisi ${item['komisi']}',
                              style: const TextStyle(
                                color: primaryGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['nama'],
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${item['material']}  •  ${item['berat']}',
                        style: const TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 12, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item['alamat'],
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['waktu'],
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          Row(
                            children: const [
                              Text(
                                'Lihat Struk ',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: primaryGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.chevron_right, size: 14, color: primaryGreen),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  static Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFC8E6C9), size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ],
    );
  }
}

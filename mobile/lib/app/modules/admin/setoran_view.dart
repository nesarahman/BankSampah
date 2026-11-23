import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: SetoranView()),
  );
}

class SetoranView extends StatefulWidget {
  const SetoranView({super.key});

  @override
  State<SetoranView> createState() => _SetoranViewState();
}

class _SetoranViewState extends State<SetoranView> {
  int _selectedIndex = 1; // Setoran aktif
  String _selectedFilter = 'Semua';

  // Data mock transaksi
  final List<Map<String, dynamic>> _transaksi = [
    {
      'nama': 'Rizky Pratama',
      'tanggal': '12 Nov 2026 • 08:30',
      'jenis': 'Setoran',
      'sampah': 'Plastik PET Bening',
      'berat': '12.5 kg',
      'hargaPerKg': 'Rp 4.200/kg',
      'total': 'Rp 52.500',
      'status': 'Pending',
      'avatar': Icons.person,
    },
    {
      'nama': 'Siti Aminah',
      'tanggal': '12 Nov 2026 • 09:15',
      'jenis': 'Penarikan',
      'sampah': 'Tarik Saldo',
      'berat': '-',
      'hargaPerKg': '-',
      'total': 'Rp 150.000',
      'status': 'Pending',
      'avatar': Icons.person,
    },
    {
      'nama': 'Budi Santoso',
      'tanggal': '11 Nov 2026 • 14:20',
      'jenis': 'Setoran',
      'sampah': 'Kardus Corrugated Box',
      'berat': '8.3 kg',
      'hargaPerKg': 'Rp 3.000/kg',
      'total': 'Rp 24.900',
      'status': 'Disetujui',
      'avatar': Icons.person,
    },
    {
      'nama': 'Dewi Lestari',
      'tanggal': '11 Nov 2026 • 16:45',
      'jenis': 'Penarikan',
      'sampah': 'Tarik Saldo',
      'berat': '-',
      'hargaPerKg': '-',
      'total': 'Rp 75.000',
      'status': 'Disetujui',
      'avatar': Icons.person,
    },
    {
      'nama': 'Ahmad Fauzi',
      'tanggal': '10 Nov 2026 • 10:00',
      'jenis': 'Setoran',
      'sampah': 'Kaleng Aluminium',
      'berat': '5.2 kg',
      'hargaPerKg': 'Rp 14.000/kg',
      'total': 'Rp 72.800',
      'status': 'Ditolak',
      'avatar': Icons.person,
    },
    {
      'nama': 'Nurul Hidayah',
      'tanggal': '10 Nov 2026 • 11:30',
      'jenis': 'Setoran',
      'sampah': 'Minyak Jelantah',
      'berat': '3.8 liter',
      'hargaPerKg': 'Rp 6.500/liter',
      'total': 'Rp 24.700',
      'status': 'Pending',
      'avatar': Icons.person,
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return const Color(0xFFF9A825);
      case 'Disetujui':
        return const Color(0xFF2E7D32);
      case 'Ditolak':
        return const Color(0xFFC62828);
      default:
        return Colors.grey;
    }
  }

  List<Map<String, dynamic>> get _filteredTransaksi {
    if (_selectedFilter == 'Semua') return _transaksi;
    return _transaksi.where((t) => t['jenis'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF2E7D32);
    const Color bgLight = Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(primaryGreen),
            // Filter Tabs
            _buildFilterTabs(primaryGreen),
            // Transaksi List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                itemCount: _filteredTransaksi.length,
                itemBuilder: (context, index) {
                  final t = _filteredTransaksi[index];
                  return _buildTransaksiCard(t, primaryGreen);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(primaryGreen),
    );
  }

  // ============================================================
  // 1. HEADER
  // ============================================================
  Widget _buildHeader(Color primaryGreen) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_ios_new, size: 18),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Setoran & Penarikan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 2),
                Text(
                  'Verifikasi transaksi nasabah',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: primaryGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.sync, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  'Sync',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 2. FILTER TABS
  // ============================================================
  Widget _buildFilterTabs(Color primaryGreen) {
    final List<String> filters = ['Semua', 'Setoran', 'Penarikan'];

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: filters.map((filter) {
          final isActive = _selectedFilter == filter;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isActive ? primaryGreen : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isActive
                        ? primaryGreen
                        : Colors.grey.withOpacity(0.3),
                  ),
                ),
                child: Center(
                  child: Text(
                    filter,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white : Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ============================================================
  // 3. TRANSAKSI CARD
  // ============================================================
  Widget _buildTransaksiCard(Map<String, dynamic> t, Color primaryGreen) {
    final status = t['status'] as String;
    final isPenarikan = t['jenis'] == 'Penarikan';
    final isPending = status == 'Pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          // Top Row: Avatar + Info + Badge
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  t['avatar'] as IconData,
                  color: primaryGreen,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t['nama'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      t['tanggal'],
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),
          // Info Transaksi
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t['jenis'],
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      t['sampah'],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    t['total'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: primaryGreen,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Detail (jika setoran)
          if (!isPenarikan) ...[
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(label: 'Berat', value: t['berat']),
                ),
                Expanded(
                  child: _buildDetailItem(
                    label: 'Harga/kg',
                    value: t['hargaPerKg'],
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          // Action Buttons (hanya jika Pending)
          if (isPending) ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        t['status'] = 'Ditolak';
                      });
                    },
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text('Tolak', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        t['status'] = 'Disetujui';
                      });
                    },
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text(
                      'Setujui',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            // Status badge jika sudah diproses
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: _getStatusColor(status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    status == 'Disetujui' ? Icons.check_circle : Icons.cancel,
                    size: 16,
                    color: _getStatusColor(status),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Transaksi ${status.toLowerCase()}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(status),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailItem({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  // ============================================================
  // 4. BOTTOM NAVIGATION BAR
  // ============================================================
  Widget _buildBottomNav(Color primaryGreen) {
    final List<Map<String, dynamic>> items = [
      {'icon': Icons.dashboard_outlined, 'label': 'Ringkasan'},
      {'icon': Icons.swap_vert, 'label': 'Setoran'},
      {'icon': Icons.account_balance_wallet_outlined, 'label': 'Keuangan'},
      {'icon': Icons.settings_outlined, 'label': 'Konfigurasi'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (i) {
            final isActive = i == _selectedIndex;
            return Expanded(
              child: InkWell(
                onTap: () => setState(() => _selectedIndex = i),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        items[i]['icon'],
                        color: isActive ? primaryGreen : Colors.grey,
                        size: 22,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        items[i]['label'],
                        style: TextStyle(
                          fontSize: 10,
                          color: isActive ? primaryGreen : Colors.grey,
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

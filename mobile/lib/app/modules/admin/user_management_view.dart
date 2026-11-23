import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserManagementView(),
    ),
  );
}

class UserManagementView extends StatefulWidget {
  final bool showBottomNav;
  const UserManagementView({super.key, this.showBottomNav = false});

  @override
  State<UserManagementView> createState() => _UserManagementViewState();
}

class _UserManagementViewState extends State<UserManagementView> {
  int _selectedIndex = 3; // Konfigurasi aktif
  String _searchQuery = '';
  String _selectedFilter = 'Semua';
  final TextEditingController _searchController = TextEditingController();

  // Data mock pengguna
  final List<Map<String, dynamic>> _users = [
    {
      'name': 'Rizky Pratama',
      'contact': 'rizky.pratama@gmail.com',
      'phone': '0812-3456-7890',
      'role': 'Nasabah',
      'status': 'Aktif',
      'totalSampah': '124.5 kg',
      'saldo': 'Rp 348.500',
      'joinDate': '12 Mar 2026',
      'avatar': Icons.person,
    },
    {
      'name': 'Siti Aminah',
      'contact': 'siti.aminah@gmail.com',
      'phone': '0821-9876-5432',
      'role': 'Kurir',
      'status': 'Kurir',
      'totalSampah': '2.4 Ton',
      'saldo': 'Rp 1.250.000',
      'joinDate': '5 Jan 2026',
      'avatar': Icons.delivery_dining,
    },
    {
      'name': 'Budi Santoso',
      'contact': 'budi.santoso@gmail.com',
      'phone': '0856-1122-3344',
      'role': 'Nasabah',
      'status': 'Pending',
      'totalSampah': '0 kg',
      'saldo': 'Rp 0',
      'joinDate': '10 Nov 2026',
      'avatar': Icons.person_outline,
    },
    {
      'name': 'Dewi Lestari',
      'contact': 'dewi.lestari@gmail.com',
      'phone': '0878-5566-7788',
      'role': 'Nasabah',
      'status': 'Aktif',
      'totalSampah': '89.2 kg',
      'saldo': 'Rp 215.000',
      'joinDate': '22 Jul 2026',
      'avatar': Icons.person,
    },
    {
      'name': 'Ahmad Fauzi',
      'contact': 'ahmad.fauzi@gmail.com',
      'phone': '0813-9988-7766',
      'role': 'Nasabah',
      'status': 'Diblokir',
      'totalSampah': '12.1 kg',
      'saldo': 'Rp 0',
      'joinDate': '3 Okt 2026',
      'avatar': Icons.person_off,
    },
    {
      'name': 'Nurul Hidayah',
      'contact': 'nurul.h@gmail.com',
      'phone': '0822-4455-6677',
      'role': 'Kurir',
      'status': 'Kurir',
      'totalSampah': '3.8 Ton',
      'saldo': 'Rp 2.100.000',
      'joinDate': '18 Feb 2026',
      'avatar': Icons.delivery_dining,
    },
    {
      'name': 'Kevin Romiyanto',
      'contact': 'kevin.romi@gmail.com',
      'phone': '0895-1234-5678',
      'role': 'Nasabah',
      'status': 'Aktif',
      'totalSampah': '56.7 kg',
      'saldo': 'Rp 178.000',
      'joinDate': '1 Sep 2026',
      'avatar': Icons.person,
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Aktif':
        return const Color(0xFF2E7D32);
      case 'Pending':
        return const Color(0xFFF9A825);
      case 'Kurir':
        return const Color(0xFF1565C0);
      case 'Diblokir':
        return const Color(0xFFC62828);
      default:
        return Colors.grey;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'Aktif':
        return const Color(0xFF2E7D32).withOpacity(0.12);
      case 'Pending':
        return const Color(0xFFF9A825).withOpacity(0.15);
      case 'Kurir':
        return const Color(0xFF1565C0).withOpacity(0.12);
      case 'Diblokir':
        return const Color(0xFFC62828).withOpacity(0.12);
      default:
        return Colors.grey.withOpacity(0.12);
    }
  }

  List<Map<String, dynamic>> get _filteredUsers {
    return _users.where((user) {
      final matchSearch =
          user['name'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          user['contact'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          user['phone'].toString().contains(_searchQuery);
      final matchFilter =
          _selectedFilter == 'Semua' || user['status'] == _selectedFilter;
      return matchSearch && matchFilter;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF2E7D32);
    const Color bgLight = Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: bgLight,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                // Header
                _buildHeader(primaryGreen),
                // Search & Filter
                _buildSearchAndFilter(primaryGreen),
                // User List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return _buildUserCard(user, primaryGreen);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: widget.showBottomNav ? _buildBottomNav(primaryGreen) : null,
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
                  'Manajemen Pengguna',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 2),
                Text(
                  'Daftar nasabah terverifikasi & akun kurir',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person_add, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 2. SEARCH & FILTER
  // ============================================================
  Widget _buildSearchAndFilter(Color primaryGreen) {
    final List<String> filters = [
      'Semua',
      'Aktif',
      'Pending',
      'Kurir',
      'Diblokir',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: bgLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey[600], size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Cari nama, email, atau nomor HP...',
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    style: const TextStyle(fontSize: 13),
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                    child: Icon(Icons.close, color: Colors.grey[600], size: 18),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Filter Chips
          SizedBox(
            height: 32,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = filters[index];
                final isActive = _selectedFilter == filter;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = filter),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: isActive ? primaryGreen : Colors.white,
                      borderRadius: BorderRadius.circular(20),
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
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isActive ? Colors.white : Colors.grey[700],
                        ),
                      ),
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

  // ============================================================
  // 3. USER CARD
  // ============================================================
  Widget _buildUserCard(Map<String, dynamic> user, Color primaryGreen) {
    final status = user['status'] as String;
    final role = user['role'] as String;

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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  user['avatar'] as IconData,
                  color: primaryGreen,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user['contact'],
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user['phone'],
                      style: TextStyle(fontSize: 10, color: Colors.grey[500]),
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
                  color: _getStatusBgColor(status),
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
          // Info Grid
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.eco,
                  label: 'Total Sampah',
                  value: user['totalSampah'],
                  primaryGreen: primaryGreen,
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.account_balance_wallet,
                  label: 'Saldo',
                  value: user['saldo'],
                  primaryGreen: primaryGreen,
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.calendar_today,
                  label: 'Bergabung',
                  value: user['joinDate'],
                  primaryGreen: primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.visibility_outlined, size: 16),
                  label: const Text('Detail', style: TextStyle(fontSize: 11)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryGreen,
                    side: BorderSide(color: primaryGreen.withOpacity(0.3)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Edit', style: TextStyle(fontSize: 11)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: BorderSide(color: Colors.blue.withOpacity(0.3)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.block, size: 16),
                  label: const Text('Blokir', style: TextStyle(fontSize: 11)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red.withOpacity(0.3)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color primaryGreen,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: primaryGreen),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 9, color: Colors.grey[600])),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
      {'icon': Icons.local_shipping_outlined, 'label': 'Penjemputan'},
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

// Konstanta background color
const Color bgLight = Color(0xFFF8F9FA);

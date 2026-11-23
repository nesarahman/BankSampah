import 'package:flutter/material.dart';

class AdminKatalogView extends StatefulWidget {
  final bool showAppBar;
  const AdminKatalogView({super.key, this.showAppBar = true});

  @override
  State<AdminKatalogView> createState() => _AdminKatalogViewState();
}

class _AdminKatalogViewState extends State<AdminKatalogView> {
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color darkGreen = Color(0xFF0D631B);
  static const Color bgSurface = Color(0xFFF9F9FF);

  String _selectedCategory = 'all';
  bool _isSyncing = false;

  late List<Map<String, dynamic>> _materials;

  @override
  void initState() {
    super.initState();
    _materials = [
      {
        'id': '1',
        'category': 'plastik',
        'categoryLabel': 'Kategori Plastik',
        'subLabel': 'PET #1',
        'title': 'Plastik PET Bening',
        'desc': 'Botol bersih tanpa label & tutup',
        'icon': Icons.recycling,
        'isActive': true,
        'unit': '/kg',
        'priceController': TextEditingController(text: '4200'),
        'factoryBuyer': 'Mitra Pabrik (Sinar Resik Ternate)',
        'factoryPrice': 'Rp 6.000 /kg',
        'margin': 'Margin Rp 1.800',
        'profit': '+30% untung',
      },
      {
        'id': '2',
        'category': 'kertas',
        'categoryLabel': 'Kertas & Karton',
        'subLabel': 'Kraft Box',
        'title': 'Kardus Corrugated Box',
        'desc': 'Kering, tidak terkena minyak & diikat',
        'icon': Icons.description,
        'isActive': true,
        'unit': '/kg',
        'priceController': TextEditingController(text: '3000'),
        'factoryBuyer': 'Pabrik Pulp Daur Ulang Morotai',
        'factoryPrice': 'Rp 4.100 /kg',
        'margin': 'Margin Rp 1.100',
        'profit': '+26.8%',
      },
      {
        'id': '3',
        'category': 'logam',
        'categoryLabel': 'Kategori Logam',
        'subLabel': 'Alu-Can #41',
        'title': 'Kaleng Aluminium & Besi',
        'desc': 'Kaleng softdrink, aerosol kempes',
        'icon': Icons.hardware,
        'isActive': true,
        'unit': '/kg',
        'priceController': TextEditingController(text: '14000'),
        'factoryBuyer': 'Smelter Peleburan Bitung',
        'factoryPrice': 'Rp 18.500 /kg',
        'margin': 'Margin Rp 4.500',
        'profit': '+24.3%',
      },
      {
        'id': '4',
        'category': 'jelantah_kaca',
        'categoryLabel': 'Jelantah Energi',
        'subLabel': 'UCO Grade A',
        'title': 'Minyak Jelantah (UCO)',
        'desc': 'Disaring kasar, tanpa endapan air',
        'icon': Icons.science,
        'isActive': true,
        'unit': '/Liter',
        'priceController': TextEditingController(text: '6500'),
        'factoryBuyer': 'Refinery Biofuel Halmahera',
        'factoryPrice': 'Rp 8.800 /Liter',
        'margin': 'Margin Rp 2.300',
        'profit': '+26.1%',
      },
      {
        'id': '5',
        'category': 'jelantah_kaca',
        'categoryLabel': 'Kaca & Beling',
        'subLabel': 'Gudang Penuh',
        'title': 'Kaca Bening & Botol',
        'desc': 'Botol sirup & kecap utuh',
        'icon': Icons.wine_bar,
        'isActive': false,
        'unit': '/kg',
        'priceController': TextEditingController(text: '1200'),
        'factoryBuyer': 'Depo Kaca Maluku Utara',
        'factoryPrice': 'Rp 1.800 /kg',
        'margin': 'Margin Rp 600',
        'profit': 'Tertunda',
      },
    ];
  }

  @override
  void dispose() {
    for (var m in _materials) {
      m['priceController'].dispose();
    }
    super.dispose();
  }

  void _syncMarket() async {
    setState(() => _isSyncing = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
            SizedBox(width: 12),
            Text('Sinkronisasi bursa daur ulang Ternate...'),
          ],
        ),
        duration: Duration(milliseconds: 1200),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 1300));
    if (!mounted) return;
    setState(() => _isSyncing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: primaryGreen,
        content: Row(
          children: [
            Icon(Icons.verified, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text('Katalog selaras dengan indeks pasar regional!'),
          ],
        ),
      ),
    );
  }

  void _saveSingleItem(Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: primaryGreen,
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text('Harga ${item['title']} berhasil diperbarui!'),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _publishAllPrices() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: primaryGreen,
        content: Row(
          children: [
            Icon(Icons.rocket_launch, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text('Seluruh harga katalog diterbitkan ke aplikasi warga!'),
          ],
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedCategory == 'all'
        ? _materials
        : _materials.where((m) => m['category'] == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: bgSurface,
      appBar: widget.showAppBar
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0.5,
              title: const Row(
                children: [
                  Text(
                    'Admin Katalog Harga',
                    style: TextStyle(
                      color: Color(0xFF121C2C),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 20),
                ),
              ],
            )
          : null,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Sub-Header & Market Sync Bar
                      _buildSubHeaderCard(),
                      const SizedBox(height: 16),

                      // Market Highlight Margin Banner
                      _buildMarginHighlightCard(),
                      const SizedBox(height: 16),

                      // Category Tabs Filter
                      _buildCategoryFilterTabs(),
                      const SizedBox(height: 16),

                      // Material items list
                      ...filtered.map((item) => _buildMaterialCard(item)),
                    ],
                  ),
                ),
              ),

              // Fixed Bottom CTA Button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _publishAllPrices,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 2,
                    ),
                    icon: const Icon(Icons.published_with_changes, size: 20),
                    label: const Text(
                      'Simpan & Perbarui Semua Harga',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F3FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD9E3F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: primaryGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'MODE ADMINISTRATOR',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Katalog & Harga Sampah',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF121C2C),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Update Realtime Indeks Bank Sampah Kota Ternate',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: _isSyncing ? null : _syncMarket,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: _isSyncing
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.sync, size: 16),
                label: const Text(
                  'Sync Pasar',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFD9E3F9)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.history_edu, size: 15, color: Colors.grey[600]),
                  const SizedBox(width: 5),
                  Text(
                    'Terakhir diperbarui: Hari ini, 08:30 WIT',
                    style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7EEFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Superadmin',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF40493D),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMarginHighlightCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [darkGreen, primaryGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Margin Rata-rata Operasional',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFA3F69C),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const Text(
                    '28.4%',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(Rp 2.140/kg)',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '5 komoditas aktif tercatat di gudang pusat',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
            ],
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.trending_up, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilterTabs() {
    final categories = [
      {'key': 'all', 'label': 'Semua (5)', 'icon': Icons.grid_view},
      {'key': 'plastik', 'label': 'Plastik', 'icon': Icons.recycling},
      {'key': 'kertas', 'label': 'Kertas & Karton', 'icon': Icons.description},
      {'key': 'logam', 'label': 'Logam', 'icon': Icons.hardware},
      {'key': 'jelantah_kaca', 'label': 'Jelantah & Kaca', 'icon': Icons.science},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final isSelected = _selectedCategory == cat['key'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => setState(() => _selectedCategory = cat['key'] as String),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? primaryGreen : const Color(0xFFE7EEFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      cat['icon'] as IconData,
                      size: 15,
                      color: isSelected ? Colors.white : const Color(0xFF40493D),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      cat['label'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : const Color(0xFF40493D),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMaterialCard(Map<String, dynamic> item) {
    final bool isActive = item['isActive'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isActive ? Colors.transparent : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Item
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFFE8F5E9) : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  item['icon'] as IconData,
                  color: isActive ? primaryGreen : Colors.grey,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isActive ? const Color(0xFF91F78E).withOpacity(0.3) : const Color(0xFFFFDAD6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item['categoryLabel'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isActive ? const Color(0xFF00731E) : const Color(0xFF93000A),
                            ),
                          ),
                        ),
                        Text(
                          item['subLabel'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isActive ? Colors.grey[600] : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['title'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF121C2C),
                      ),
                    ),
                    Text(
                      item['desc'] as String,
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Reception Status Switch Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F3FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isActive ? primaryGreen : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isActive ? 'Menerima Setoran' : 'Sementara Tutup / Penuh',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isActive ? const Color(0xFF121C2C) : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: isActive,
                  activeColor: primaryGreen,
                  onChanged: (val) {
                    setState(() {
                      item['isActive'] = val;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          val
                              ? 'Status ${item['title']} aktif menerima setoran'
                              : 'Penerimaan ${item['title']} dinonaktifkan sementara',
                        ),
                        duration: const Duration(milliseconds: 1500),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Price Form Field
          Text(
            'Harga Beli Warga ${item['unit']}',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey[700]),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: item['priceController'] as TextEditingController,
                  keyboardType: TextInputType.number,
                  enabled: isActive,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF121C2C),
                  ),
                  decoration: InputDecoration(
                    prefixText: 'Rp ',
                    suffixText: item['unit'] as String,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    filled: true,
                    fillColor: isActive ? const Color(0xFFE7EEFF).withOpacity(0.5) : Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Market Price / Factory Buyer info box
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F3FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['factoryBuyer'] as String,
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['factoryPrice'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF121C2C),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF91F78E).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item['margin'] as String,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00731E),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['profit'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: primaryGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Action Button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () => _saveSingleItem(item),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isActive ? const Color(0xFF91F78E).withOpacity(0.4) : const Color(0xFFE7EEFF),
                  foregroundColor: isActive ? const Color(0xFF00731E) : Colors.grey[800],
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: Icon(isActive ? Icons.check : Icons.lock_reset, size: 16),
                label: Text(
                  isActive ? 'Simpan Perubahan' : 'Buka Kuota Setor',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

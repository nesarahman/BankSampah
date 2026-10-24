
import 'package:flutter/material.dart';

class CatalogView extends StatefulWidget {
  const CatalogView({super.key});

  @override
  State<CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends State<CatalogView> {
  String selectedCategory = 'Semua';
  String searchQuery = '';

  final List<Map<String, dynamic>> catalogItems = [
    {
      'title': 'Kertas & Karton',
      'subtitle': 'Kardus, HVS, Koran, Majalah',
      'image':
          'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=800',
      'price': 'Rp 2.500 - Rp 3.800 /kg',
      'tag': 'Kertas',
      'tagColor': Colors.blue,
    },
    {
      'title': 'Plastik Daur Ulang',
      'subtitle': 'PET, HDPE, LDPE, Jernih',
      'image':
          'https://images.unsplash.com/photo-1605600659873-d808a13e4d9a?w=800',
      'price': 'Rp 4.000 - Rp 7.500 /kg',
      'tag': 'Plastik',
      'tagColor': Colors.orange,
    },
    {
      'title': 'Logam & Gelas',
      'subtitle': 'Besi, Tembaga, Botol, Kaca',
      'image':
          'https://images.unsplash.com/photo-1611284446314-60a58ac0deb9?w=800',
      'price': 'Rp 5.000 - Rp 14.000 /kg',
      'tag': 'Logam',
      'tagColor': Colors.grey,
    },
    {
      'title': 'Organik & Minyak Jelantah',
      'subtitle': 'Sisa Makanan, Minyak Goreng, Daun Kering',
      'image':
          'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=800',
      'price': 'Rp 6.500 /Liter',
      'tag': 'Organik',
      'tagColor': Colors.green,
    },
  ];

  final List<String> categories = [
    'Semua',
    'Kertas',
    'Plastik',
    'Logam',
    'Organik',
  ];

  List<Map<String, dynamic>> get filteredItems {
    return catalogItems.where((item) {
      final categoryMatch = selectedCategory == 'Semua' ||
          item['tag'] == selectedCategory;

      final query = searchQuery.toLowerCase().trim();

      final searchMatch = query.isEmpty ||
          (item['title'] as String).toLowerCase().contains(query) ||
          (item['subtitle'] as String).toLowerCase().contains(query) ||
          (item['tag'] as String).toLowerCase().contains(query);

      return categoryMatch && searchMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = filteredItems;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Katalog Sampah',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'PANDUAN PILIHAN EKONOMI',
              style: TextStyle(
                fontSize: 10,
                color: Colors.white70,
              ),
            ),
          ],
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
            backgroundColor: Colors.white,
            radius: 16,
            child: Icon(Icons.person, color: Colors.green, size: 22),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.green[800],
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari jenis sampah, cth: botol PET, kardus...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // Filter Kategori
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildFilterChip(category),
                  );
                }).toList(),
              ),
            ),
          ),

          // Jumlah hasil
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${items.length} jenis sampah ditemukan',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),

          // Hasil Katalog
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Jenis sampah tidak ditemukan',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedCategory = 'Semua';
                              searchQuery = '';
                            });
                          },
                          child: const Text('Reset filter'),
                        ),
                      ],
                    ),
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
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Gambar dan Tag
                            Stack(
                              children: [
                                Image.network(
                                  item['image'] as String,
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, progress) {
                                    if (progress == null) return child;

                                    return Container(
                                      height: 150,
                                      width: double.infinity,
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.green,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    return Container(
                                      height: 150,
                                      width: double.infinity,
                                      color: Colors.green.shade50,
                                      child: Center(
                                        child: Icon(
                                          _getWasteIcon(
                                            item['tag'] as String,
                                          ),
                                          size: 60,
                                          color: Colors.green[800],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: item['tagColor'] as Color,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      item['tag'] as String,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Informasi Detail
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item['title'] as String,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.info_outline,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['subtitle'] as String,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'ESTIMASI HARGA',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          item['price'] as String,
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green[800],
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        'Jadwalkan Penjemputan Sekarang',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final bool isSelected = selectedCategory == label;

    return InkWell(
      onTap: () {
        setState(() {
          selectedCategory = label;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
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
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  IconData _getWasteIcon(String tag) {
    switch (tag) {
      case 'Kertas':
        return Icons.description;
      case 'Plastik':
        return Icons.recycling;
      case 'Logam':
        return Icons.wine_bar;
      case 'Organik':
        return Icons.eco;
      default:
        return Icons.delete_outline;
    }
  }
}

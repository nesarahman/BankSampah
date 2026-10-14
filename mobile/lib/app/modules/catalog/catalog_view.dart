import 'package:flutter/material.dart';

class CatalogView extends StatelessWidget {
  const CatalogView({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy sesuai desain di file
    final List<Map<String, dynamic>> catalogItems = [
      {
        'title': 'Kertas & Karton',
        'subtitle': 'Kardus, HVS, Koran, Majalah',
        'image': 'https://via.placeholder.com/150', // Ganti dengan asset gambar Anda
        'price': 'Rp 2.500 - Rp 3.800 /kg',
        'tag': 'Kertas',
        'tagColor': Colors.blue,
      },
      {
        'title': 'Plastik Daur Ulang',
        'subtitle': 'PET, HDPE, LDPE, Jernih',
        'image': 'https://via.placeholder.com/150',
        'price': 'Rp 4.000 - Rp 7.500 /kg',
        'tag': 'Plastik',
        'tagColor': Colors.orange,
      },
      {
        'title': 'Logam & Gelas',
        'subtitle': 'Besi, Tembaga, Botol, Kaca',
        'image': 'https://via.placeholder.com/150',
        'price': 'Rp 5.000 - Rp 14.000 /kg',
        'tag': 'Logam/Gelas',
        'tagColor': Colors.grey,
      },
      {
        'title': 'Organik & Minyak Jelantah',
        'subtitle': 'Sisa Makanan, Minyak Goreng, Daun Kering',
        'image': 'https://via.placeholder.com/150',
        'price': 'Rp 6.500 /Liter',
        'tag': 'Organik',
        'tagColor': Colors.green,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Katalog Sampah',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'PANDUAN PILIHAN EKONOMI',
              style: TextStyle(fontSize: 10, color: Colors.white70),
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
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            radius: 16,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Bagian Search Bar
          Container(
            color: Colors.green[800],
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari jenis sampah, cth: botol PET, kardus...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          
          // Bagian Filter/Tab
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip('Semua', isSelected: true),
                const SizedBox(width: 8),
                _buildFilterChip('Kertas'),
                const SizedBox(width: 8),
                _buildFilterChip('Plastik'),
                const SizedBox(width: 8),
                _buildFilterChip('Logam'),
              ],
            ),
          ),

          // List Katalog
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: catalogItems.length,
              itemBuilder: (context, index) {
                final item = catalogItems[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gambar & Tag
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(
                              item['image'],
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 150,
                                color: Colors.grey[300],
                                child: const Center(child: Icon(Icons.image, size: 50, color: Colors.grey)),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: item['tagColor'],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item['tag'],
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Info Detail
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item['title'],
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const Icon(Icons.info_outline, color: Colors.grey, size: 20),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['subtitle'],
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'ESTIMASI HARGA',
                                  style: TextStyle(fontSize: 10, color: Colors.grey[500], fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  item['price'],
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
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
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Jadwalkan Penjemputan Sekarang'),
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

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
    );
  }
}
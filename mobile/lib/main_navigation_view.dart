import 'package:flutter/material.dart';

// Import file placeholder yang sudah kamu buat
import 'app/modules/home/home_view.dart';
import 'app/modules/pickup/pickup_view.dart';
import 'app/modules/catalog/catalog_view.dart';
import 'app/modules/history/history_view.dart';
import 'app/modules/drop_point/drop_point_view.dart';

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  // Variabel untuk menyimpan halaman mana yang sedang aktif (0 = Beranda, dst)
  int _currentIndex = 0;

  // Daftar halaman yang akan ditampilkan di body aplikasi
  final List<Widget> _pages = const [
    HomeView(), // Index 0
    PickupView(), // Index 1
    CatalogView(), // Index 2
    HistoryView(), // Index 3
    DropPointView(), // Index 4
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body akan menampilkan halaman sesuai dengan _currentIndex
      body: _pages[_currentIndex],

      // Ini adalah menu navigasi di bagian bawah layar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          // Saat menu diklik, ubah _currentIndex dan refresh tampilan
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed, // Agar semua ikon & teks terlihat
        selectedItemColor: Colors.green, // Warna saat dipilih
        unselectedItemColor: Colors.grey, // Warna saat tidak dipilih
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
            icon: Icon(Icons.delivery_dining),
            label: 'Jemput',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.recycling),
            label: 'Katalog',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Drop Point',
          ),
        ],
      ),
    );
  }
}

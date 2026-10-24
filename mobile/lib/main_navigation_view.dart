import 'package:flutter/material.dart';

// 1. IMPORT HALAMAN: Kita memanggil file-file View yang sudah dibuat tim
// agar bisa ditampilkan di dalam navigasi ini.
import 'app/modules/catalog/catalog_view.dart';
import 'app/modules/home/home_view.dart';
import 'app/modules/pickup/pickup_view.dart';
import 'app/modules/history/history_view.dart';
import 'app/modules/drop_point/drop_point_view.dart';

// 2. STATEFULWIDGET: Kita gunakan StatefulWidget karena halaman ini perlu 
// "mengingat" (menyimpan state) tab mana yang sedang aktif.
class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  // 3. VARIABEL STATE: Penunjuk halaman aktif. 
  // 0 = Beranda, 1 = Jemput, 2 = Katalog, 3 = Riwayat, 4 = Drop Point.
  int _selectedIndex = 0;

  // 4. FUNGSI EVENT: Fungsi ini akan dipanggil setiap kali user mengetuk 
  // salah satu ikon di Bottom Navigation Bar.
  void _onItemTapped(int index) {
    // setState memberi tahu Flutter: "Data berubah, tolong gambar ulang (rebuild) UI-nya!"
    setState(() {
      _selectedIndex = index; // Update index sesuai tab yang diklik
    });
  }

  @override
  Widget build(BuildContext context) {
    // 5. SCAFFOLD: Kerangka dasar halaman Material Design.
    return Scaffold(
      
      // 6. BODY DENGAN INDEXEDSTACK (FITUR UNGGULAN):
      // IndexedStack menumpuk semua halaman, tapi hanya menampilkan 1 halaman 
      // sesuai dengan '_selectedIndex'. 
      // KEUNGGULAN: Saat user pindah tab dan kembali, posisi scroll dan data 
      // di halaman sebelumnya TIDAK HILANG (State Preserved).
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeView(onTabSelected: _onItemTapped),       // Index 0: Beranda
          const PickupView(showBottomNav: false),       // Index 1: Jemput
          const CatalogView(),                          // Index 2: Katalog
          const HistoryView(),                          // Index 3: Riwayat
          const DropPointView(),                        // Index 4: Drop Point
        ],
      ),

      // 7. BOTTOM NAVIGATION BAR: Menu navigasi di bagian bawah layar.
      bottomNavigationBar: BottomNavigationBar(
        // 'fixed' memastikan semua label teks (Beranda, Jemput, dll) tetap muncul,
        // tidak disembunyikan otomatis oleh Flutter (penting untuk 3-5 menu).
        type: BottomNavigationBarType.fixed,
        
        // Menautkan warna aktif dengan variabel index kita
        currentIndex: _selectedIndex,
        
        // Saat diklik, jalankan fungsi _onItemTapped untuk ganti halaman
        onTap: _onItemTapped,
        
        // Kustomisasi Warna sesuai Brand REGREEN
        selectedItemColor: const Color(0xFF2E7D32), // Hijau tua saat aktif
        unselectedItemColor: Colors.grey,           // Abu-abu saat tidak aktif
        backgroundColor: Colors.white,
        elevation: 8, // Memberi efek bayangan agar menu terlihat melayang di atas konten

        // 8. DAFTAR ITEM MENU: Urutan di sini HARUS SAMA PERSIS dengan urutan 
        // di dalam 'children' IndexedStack di atas (Index 0 s/d 4).
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home), // Ikon berubah jadi solid saat aktif
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping_outlined),
            activeIcon: Icon(Icons.local_shipping),
            label: 'Jemput',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.recycling_outlined),
            activeIcon: Icon(Icons.recycling),
            label: 'Katalog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            activeIcon: Icon(Icons.location_on),
            label: 'Drop Point',
          ),
        ],
      ),
    );
  }
}
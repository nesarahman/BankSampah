import 'package:flutter/material.dart';
import 'mitra_tugas_view.dart';
import 'mitra_riwayat_view.dart';
import 'mitra_profil_view.dart';

/// Navigasi untuk akun ber-role 'kurir' (armada penjemput).
/// Kurir hanya mengerjakan tugas yang ditugaskan mitra: lihat tugas, jemput, timbang, lihat riwayat.
/// Penugasan, pembayaran nasabah, dan gaji ada di MitraNavigationView (role 'mitra').
class KurirNavigationView extends StatefulWidget {
  final int initialIndex;
  const KurirNavigationView({super.key, this.initialIndex = 0});

  @override
  State<KurirNavigationView> createState() => _KurirNavigationViewState();
}

class _KurirNavigationViewState extends State<KurirNavigationView> {
  static const primaryGreen = Color(0xFF2E7D32);
  late int _index = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          MitraTugasView(),
          MitraRiwayatView(),
          MitraProfilView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: primaryGreen,
        unselectedItemColor: Colors.grey.shade500,
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping_outlined),
            activeIcon: Icon(Icons.local_shipping),
            label: 'Tugas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

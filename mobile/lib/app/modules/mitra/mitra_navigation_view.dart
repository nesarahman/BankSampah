import 'package:flutter/material.dart';
import 'pemilik_data.dart';
import 'pemilik_beranda_view.dart';
import 'pemilik_setoran_view.dart';
import 'pemilik_nasabah_view.dart';
import 'mitra_profil_view.dart';

class MitraNavigationView extends StatefulWidget {
  final int initialIndex;
  const MitraNavigationView({super.key, this.initialIndex = 0});

  @override
  State<MitraNavigationView> createState() => _MitraNavigationViewState();
}

class _MitraNavigationViewState extends State<MitraNavigationView> {
  late int _currentIndex;
  static const primaryGreen = Color(0xFF2E7D32);

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Data permintaan/setoran/kurir selalu diambil ulang dari server saat pindah tab
    PemilikData.I.muat();
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    PemilikData.I.muat();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      PemilikBerandaView(onSwitchTab: _onTabTapped),
      const PemilikSetoranView(),
      const PemilikNasabahView(),
      const MitraProfilView(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: PemilikData.I,
        builder: (context, _) {
          final d = PemilikData.I;
          final hasSetoran = d.setoran[d.unit].isNotEmpty;

          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            selectedItemColor: primaryGreen,
            unselectedItemColor: Colors.grey.shade500,
            backgroundColor: Colors.white,
            elevation: 8,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 11),
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.warehouse_outlined),
                activeIcon: Icon(Icons.warehouse),
                label: 'Gudang',
              ),
              BottomNavigationBarItem(
                icon: Badge(
                  isLabelVisible: hasSetoran,
                  label: Text('${d.setoran[d.unit].length}'),
                  child: const Icon(Icons.local_shipping_outlined),
                ),
                activeIcon: const Icon(Icons.local_shipping),
                label: 'Setoran',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.groups_outlined),
                activeIcon: Icon(Icons.groups),
                label: 'Nasabah',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'pemilik_data.dart';
import 'pemilik_beranda_view.dart';
import 'pemilik_setoran_view.dart';
import 'pemilik_nasabah_view.dart';
import 'mitra_profil_view.dart';

class PemilikNavigationView extends StatefulWidget {
  final int initialIndex;
  const PemilikNavigationView({super.key, this.initialIndex = 0});

  @override
  State<PemilikNavigationView> createState() => _PemilikNavigationViewState();
}

class _PemilikNavigationViewState extends State<PemilikNavigationView> {
  late int _i = widget.initialIndex;

  final _pages = const [
    PemilikBerandaView(),
    PemilikSetoranView(),
    PemilikNasabahView(),
    MitraProfilView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _i, children: _pages),
      bottomNavigationBar: ListenableBuilder(
        listenable: PemilikData.I,
        builder: (context, _) {
          final d = PemilikData.I;
          final hasSetoran = d.setoran[d.unit].isNotEmpty;

          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _i,
            onTap: (v) => setState(() => _i = v),
            selectedItemColor: kGreen,
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

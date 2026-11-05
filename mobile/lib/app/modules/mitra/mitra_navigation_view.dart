import 'package:flutter/material.dart';
import 'mitra_tugas_view.dart';
import 'mitra_riwayat_view.dart';
import 'mitra_profil_view.dart';

class MitraNavigationView extends StatefulWidget {
  const MitraNavigationView({super.key});

  @override
  State<MitraNavigationView> createState() => _MitraNavigationViewState();
}

class _MitraNavigationViewState extends State<MitraNavigationView> {
  int _currentIndex = 0;
  static const primaryGreen = Color(0xFF2E7D32);

  final List<Widget> _pages = const [
    MitraTugasView(),
    MitraRiwayatView(),
    MitraProfilView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
          },
          backgroundColor: Colors.white,
          selectedItemColor: primaryGreen,
          unselectedItemColor: Colors.grey.shade500,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              activeIcon: Icon(Icons.assignment),
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
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'admin_dashboard_view.dart';
import 'admin_katalog_view.dart';
import 'admin_keuangan_view.dart';
import 'user_management_view.dart';

class AdminNavigationView extends StatefulWidget {
  final int initialIndex;
  const AdminNavigationView({super.key, this.initialIndex = 0});

  @override
  State<AdminNavigationView> createState() => _AdminNavigationViewState();
}

class _AdminNavigationViewState extends State<AdminNavigationView> {
  late int _currentIndex;
  static const Color primaryGreen = Color(0xFF2E7D32);

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabChange(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      AdminDashboardView(onTabChange: _onTabChange, showBottomNav: false),
      const AdminKatalogView(showAppBar: true),
      const AdminKeuanganView(showAppBar: true),
      const UserManagementView(showBottomNav: false),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
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
        child: SafeArea(
          top: false,
          child: Align(
            alignment: Alignment.bottomCenter,
            heightFactor: 1.0,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: _onTabChange,
                backgroundColor: Colors.white,
                selectedItemColor: primaryGreen,
                unselectedItemColor: Colors.grey.shade500,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                unselectedLabelStyle: const TextStyle(fontSize: 11),
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard_outlined),
                    activeIcon: Icon(Icons.dashboard),
                    label: 'Ringkasan',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.price_change_outlined),
                    activeIcon: Icon(Icons.price_change),
                    label: 'Katalog',
                  ),
                  BottomNavigationBarItem(
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Icons.payments_outlined),
                        Positioned(
                          right: -3,
                          top: -2,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    activeIcon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Icons.payments),
                        Positioned(
                          right: -3,
                          top: -2,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    label: 'Keuangan',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.people_outline),
                    activeIcon: Icon(Icons.people),
                    label: 'Pengguna',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

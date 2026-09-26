import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Rangka navigasi bawah 4 tab (PRD 6.3).
///
/// Memakai `StatefulNavigationShell` supaya tiap tab menyimpan riwayat
/// navigasinya sendiri — berpindah dari Riwayat ke Beranda lalu kembali tidak
/// mereset posisi scroll atau filter yang sedang aktif.
class AppShell extends StatelessWidget {
  const new({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const _destinations = <NavigationDestination>[
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Beranda',
    ),
    NavigationDestination(
      icon: Icon(Icons.access_time_outlined),
      selectedIcon: Icon(Icons.access_time_filled),
      label: 'Riwayat',
    ),
    NavigationDestination(
      icon: Icon(Icons.show_chart_outlined),
      selectedIcon: Icon(Icons.show_chart),
      label: 'Tren',
    ),
    NavigationDestination(
      icon: Icon(Icons.tune_outlined),
      selectedIcon: Icon(Icons.tune),
      label: 'Setelan',
    ),
  ];

  void _onTap(int index) {
    // initialLocation: true saat menekan tab yang sedang aktif = kembali ke
    // akar tab tersebut, perilaku standar navigasi bawah.
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        destinations: _destinations,
      ),
    );
  }
}

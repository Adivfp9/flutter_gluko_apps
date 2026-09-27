import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

/// Rangka navigasi bawah 4 tab (PRD 6.3).
///
/// Memakai `StatefulNavigationShell` supaya tiap tab menyimpan riwayat
/// navigasinya sendiri — berpindah dari Riwayat ke Beranda lalu kembali tidak
/// mereset posisi scroll atau filter yang sedang aktif.
class AppShell extends StatelessWidget {
  const new({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  List<NavigationDestination> _destinations(AppLocalizations l10n) => [
    NavigationDestination(
      icon: const Icon(Icons.home_outlined),
      selectedIcon: const Icon(Icons.home),
      label: l10n.navHome,
    ),
    NavigationDestination(
      icon: const Icon(Icons.access_time_outlined),
      selectedIcon: const Icon(Icons.access_time_filled),
      label: l10n.navHistory,
    ),
    NavigationDestination(
      icon: const Icon(Icons.show_chart_outlined),
      selectedIcon: const Icon(Icons.show_chart),
      label: l10n.navTrend,
    ),
    NavigationDestination(
      icon: const Icon(Icons.tune_outlined),
      selectedIcon: const Icon(Icons.tune),
      label: l10n.navSettings,
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
        destinations: _destinations(context.l10n),
      ),
    );
  }
}

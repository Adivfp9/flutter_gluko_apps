import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/core/widgets/sprint_placeholder.dart';

/// S-03 Beranda (F-04).
class DashboardPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SprintPlaceholder(
          title: 'Beranda',
          sprint:
              'Kartu GDP/GDS, rata-rata 7 hari, dan mini chart '
              'diisi pada Sprint 3 (F-04).',
          icon: Icons.home_outlined,
        ),
      ),
    );
  }
}

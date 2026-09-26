import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/core/widgets/sprint_placeholder.dart';

/// S-08 Tren (F-06).
class TrendPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SprintPlaceholder(
          title: 'Tren',
          sprint:
              'Grafik 7/14/30/90 hari dan kartu statistik '
              'diisi pada Sprint 4 (F-06).',
          icon: Icons.show_chart_outlined,
        ),
      ),
    );
  }
}

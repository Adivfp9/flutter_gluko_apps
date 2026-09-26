import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/core/widgets/sprint_placeholder.dart';

/// S-06 Riwayat (F-05).
class HistoryPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SprintPlaceholder(
          title: 'Riwayat',
          sprint:
              'Daftar per tanggal, filter, dan kalender '
              'diisi pada Sprint 3 (F-05).',
          icon: Icons.history_outlined,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/core/router/app_router.dart';
import 'package:flutter_gluko_apps/core/widgets/sprint_placeholder.dart';
import 'package:go_router/go_router.dart';

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
      floatingActionButton: _RecordButton(),
    );
  }
}

class _RecordButton extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => FloatingActionButton.extended(
    onPressed: () => context.pushNamed(AppRoute.record),
    icon: const Icon(Icons.add),
    label: const Text('Catat'),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/core/router/app_router.dart';
import 'package:flutter_gluko_apps/core/widgets/sprint_placeholder.dart';
import 'package:go_router/go_router.dart';

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

import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/core/widgets/sprint_placeholder.dart';

/// S-09 Pengaturan.
///
/// Layar ini tidak ada di paket desain (temuan D-1 pada rencana implementasi):
/// tab keempat di preview menautkan langsung ke layar Target. Mengikuti PRD
/// 6.3, tab keempat adalah Pengaturan dan Target menjadi sub-halaman.
class SettingsPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SprintPlaceholder(
          title: 'Pengaturan',
          sprint:
              'Profil, target, satuan, pengingat, keamanan, dan backup '
              'diisi pada Sprint 2 dan 4.',
          icon: Icons.tune_outlined,
        ),
      ),
    );
  }
}

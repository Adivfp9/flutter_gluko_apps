import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/core/router/app_router.dart';
import 'package:flutter_gluko_apps/core/theme/app_spacing.dart';
import 'package:go_router/go_router.dart';

/// S-09 Pengaturan.
///
/// Layar ini tidak ada di paket desain (temuan D-1 pada rencana implementasi):
/// tab keempat di preview menautkan langsung ke layar Target. Mengikuti PRD
/// 6.3, tab keempat adalah Pengaturan dan Target menjadi sub-halaman.
class SettingsPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenGutter,
          vertical: AppSpacing.sm,
        ),
        children: [
          Text('Pemantauan', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.tune),
                  title: const Text('Target & satuan'),
                  subtitle: const Text(
                    'Atur rentang GDP, GDS, 2 Jam PP, serta mg/dL atau mmol/L.',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.pushNamed(AppRoute.target),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text('Pengingat'),
                  subtitle: const Text('Jadwal cek gula darah harian.'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.pushNamed(AppRoute.reminders),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('Keamanan'),
                  subtitle: const Text('PIN dan biometrik.'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.pushNamed(AppRoute.security),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Akan hadir', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          const Card(
            child: Column(
              children: [
                _UpcomingSetting(
                  icon: Icons.backup_outlined,
                  title: 'Backup & restore',
                  subtitle: 'Cadangan terenkripsi · Sprint 4',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Tentang GlukoTrack'),
            subtitle: Text(
              'Alat pencatatan pribadi, bukan pengganti diagnosis atau '
              'nasihat dokter.',
            ),
          ),
        ],
      ),
    );
  }
}

class _UpcomingSetting extends StatelessWidget {
  const new({required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => ListTile(
    enabled: false,
    leading: Icon(icon),
    title: Text(title),
    subtitle: Text(subtitle),
  );
}

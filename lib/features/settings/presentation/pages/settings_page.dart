import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/core/di/injection.dart';
import 'package:flutter_gluko_apps/core/router/app_router.dart';
import 'package:flutter_gluko_apps/core/theme/app_spacing.dart';
import 'package:flutter_gluko_apps/features/backup/domain/backup_service.dart';
import 'package:flutter_gluko_apps/features/backup/presentation/pages/backup_page.dart';
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
    final titleStyle = Theme.of(context).textTheme.titleSmall;

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenGutter,
          vertical: AppSpacing.sm,
        ),
        children: [
          Text('Pemantauan', style: titleStyle),
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
          Text('Data', style: titleStyle),
          const SizedBox(height: AppSpacing.sm),
          const _BackupTile(),
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

/// PRD F-09 AC3: tanggal backup terakhir + pengingat bila > 30 hari.
class _BackupTile extends StatefulWidget {
  const new();

  @override
  State<_BackupTile> createState() => _BackupTileState();
}

class _BackupTileState extends State<_BackupTile> {
  late final Stream<DateTime?> _lastBackup = getIt<BackupService>()
      .watchLastBackup();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime?>(
      stream: _lastBackup,
      builder: (context, snapshot) {
        final last = snapshot.data;
        final loaded = snapshot.connectionState != ConnectionState.waiting;
        final nudge = loaded && needsBackupNudge(last, clock.now());
        final scheme = Theme.of(context).colorScheme;

        return Card(
          color: nudge ? scheme.tertiaryContainer : null,
          child: ListTile(
            leading: Icon(
              nudge ? Icons.warning_amber_rounded : Icons.backup_outlined,
            ),
            title: const Text('Backup & restore'),
            subtitle: Text(
              !loaded
                  ? 'Memuat…'
                  : last == null
                  ? 'Belum pernah backup. Buat sekarang agar data aman.'
                  : nudge
                  ? 'Terakhir ${formatBackupDate(last)} — sudah lebih dari '
                        '30 hari.'
                  : 'Terakhir ${formatBackupDate(last)}',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.pushNamed(AppRoute.backup),
          ),
        );
      },
    );
  }
}

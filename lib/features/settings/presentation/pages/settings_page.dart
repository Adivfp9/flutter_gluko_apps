import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/core/di/injection.dart';
import 'package:flutter_gluko_apps/core/router/app_router.dart';
import 'package:flutter_gluko_apps/core/theme/app_spacing.dart';
import 'package:flutter_gluko_apps/features/backup/domain/backup_service.dart';
import 'package:flutter_gluko_apps/features/backup/presentation/pages/backup_page.dart';
import 'package:flutter_gluko_apps/l10n/l10n.dart';
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
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenGutter,
          vertical: AppSpacing.sm,
        ),
        children: [
          Text(l10n.settingsSectionMonitoring, style: titleStyle),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.tune),
                  title: Text(l10n.settingsTargetTitle),
                  subtitle: Text(l10n.settingsTargetSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.pushNamed(AppRoute.target),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: Text(l10n.settingsRemindersTitle),
                  subtitle: Text(l10n.settingsRemindersSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.pushNamed(AppRoute.reminders),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: Text(l10n.settingsSecurityTitle),
                  subtitle: Text(l10n.settingsSecuritySubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.pushNamed(AppRoute.security),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(l10n.settingsSectionData, style: titleStyle),
          const SizedBox(height: AppSpacing.sm),
          const _BackupTile(),
          const SizedBox(height: AppSpacing.xl),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.settingsAboutTitle),
              subtitle: Text(l10n.settingsAboutSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.pushNamed(AppRoute.about),
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
    final l10n = context.l10n;

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
            title: Text(l10n.settingsBackupTitle),
            subtitle: Text(
              !loaded
                  ? l10n.settingsBackupLoading
                  : last == null
                  ? l10n.settingsBackupNever
                  : nudge
                  ? l10n.settingsBackupStale(formatBackupDate(last))
                  : l10n.settingsBackupLast(formatBackupDate(last)),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.pushNamed(AppRoute.backup),
          ),
        );
      },
    );
  }
}

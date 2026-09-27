import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gluko_apps/core/di/injection.dart';
import 'package:flutter_gluko_apps/core/theme/app_palette.dart';
import 'package:flutter_gluko_apps/core/theme/app_spacing.dart';
import 'package:flutter_gluko_apps/features/backup/domain/backup_codec.dart';
import 'package:flutter_gluko_apps/features/backup/domain/backup_service.dart';
import 'package:flutter_gluko_apps/features/backup/presentation/cubit/backup_cubit.dart';
import 'package:flutter_gluko_apps/features/backup/presentation/cubit/backup_state.dart';
import 'package:intl/intl.dart';

String formatBackupDate(DateTime at) =>
    DateFormat('d MMMM y, HH.mm', 'id').format(at.toLocal());

/// Pengaturan › Backup & restore (PRD F-09).
///
/// [restoreOnly] dipakai dari onboarding di HP baru: hanya bagian pulihkan
/// yang tampil, dan [onRestored] dipanggil setelah berhasil.
class BackupPage extends StatelessWidget {
  const new({super.key, this.restoreOnly = false, this.onRestored});

  final bool restoreOnly;
  final VoidCallback? onRestored;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BackupCubit>()..start(),
      child: _BackupView(restoreOnly: restoreOnly, onRestored: onRestored),
    );
  }
}

class _BackupView extends StatelessWidget {
  const new({required this.restoreOnly, required this.onRestored});

  final bool restoreOnly;
  final VoidCallback? onRestored;

  Future<void> _create(BuildContext context, BackupDestination to) async {
    final cubit = context.read<BackupCubit>();
    final passphrase = await showDialog<String>(
      context: context,
      builder: (_) => const _PassphraseDialog(confirm: true),
    );
    if (passphrase != null) {
      await cubit.createBackup(passphrase, destination: to);
    }
  }

  Future<void> _askPassphrase(BuildContext context) async {
    final cubit = context.read<BackupCubit>();
    final passphrase = await showDialog<String>(
      context: context,
      builder: (_) => const _PassphraseDialog(confirm: false),
    );
    if (passphrase == null) {
      cubit.cancelRestore();
    } else {
      await cubit.openPending(passphrase);
    }
  }

  Future<void> _restore(BuildContext context) async {
    final picked = await context.read<BackupCubit>().pickFile();
    if (picked && context.mounted) await _askPassphrase(context);
  }

  Future<void> _confirm(BuildContext context, BackupPreview preview) async {
    final cubit = context.read<BackupCubit>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Timpa data sekarang?'),
        content: Text(
          'Backup ${formatBackupDate(preview.createdAt)} berisi '
          '${preview.readingCount} catatan dan ${preview.reminderCount} '
          'pengingat.\n\nSemua catatan, target, dan pengingat di HP ini akan '
          'diganti isi backup. Tindakan ini tidak bisa dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Pulihkan'),
          ),
        ],
      ),
    );
    if (ok ?? false) {
      await cubit.confirmRestore();
    } else {
      cubit.cancelRestore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BackupCubit, BackupState>(
      listenWhen: (a, b) =>
          a.errorMessage != b.errorMessage ||
          a.infoMessage != b.infoMessage ||
          a.preview != b.preview ||
          a.restored != b.restored,
      listener: (context, state) {
        final preview = state.preview;
        if (preview != null) {
          unawaited(_confirm(context, preview));
          return;
        }
        final message = state.errorMessage ?? state.infoMessage;
        if (message != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(message)));
        }
        // Passphrase salah: file masih dipegang, langsung minta ulang.
        final retryPassphrase =
            state.errorMessage != null && state.hasPendingFile;
        final restored = state.restored;
        if (message != null || restored) {
          context.read<BackupCubit>().clearMessages();
        }
        if (retryPassphrase) unawaited(_askPassphrase(context));
        if (restored) onRestored?.call();
      },
      builder: (context, state) {
        final text = Theme.of(context).textTheme;
        final palette = context.palette;
        return Scaffold(
          appBar: AppBar(
            title: Text(restoreOnly ? 'Pulihkan backup' : 'Backup & restore'),
          ),
          body: AbsorbPointer(
            absorbing: state.isBusy,
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenGutter,
                vertical: AppSpacing.sm,
              ),
              children: [
                if (state.isBusy) ...[
                  LinearProgressIndicator(semanticsLabel: state.busyLabel),
                  const SizedBox(height: AppSpacing.sm),
                  Text(state.busyLabel!, style: text.bodySmall),
                  const SizedBox(height: AppSpacing.md),
                ],
                if (!restoreOnly) ...[
                  _LastBackupCard(lastBackupAt: state.lastBackupAt),
                  const SizedBox(height: AppSpacing.md),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.ios_share),
                          title: const Text('Buat backup & bagikan'),
                          subtitle: const Text(
                            'Kirim ke Google Drive, WhatsApp, atau email.',
                          ),
                          onTap: () =>
                              _create(context, BackupDestination.share),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.save_alt),
                          title: const Text('Simpan ke perangkat'),
                          subtitle: const Text('Pilih folder penyimpanan.'),
                          onTap: () =>
                              _create(context, BackupDestination.device),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.restore),
                    title: const Text('Pulihkan dari file'),
                    subtitle: const Text(
                      'Pilih file .gtbak lalu masukkan passphrase-nya.',
                    ),
                    onTap: () => _restore(context),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Backup dienkripsi dengan passphrase pilihan Anda dan bisa '
                  'dipulihkan di HP lain. Passphrase tidak disimpan di mana '
                  'pun — tanpa passphrase, backup tidak bisa dibuka oleh '
                  'siapa pun.',
                  style: text.bodySmall?.copyWith(color: palette.textSecondary),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LastBackupCard extends StatelessWidget {
  const new({required this.lastBackupAt});

  final DateTime? lastBackupAt;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final last = lastBackupAt;
    final nudge = needsBackupNudge(last, DateTime.now());
    final scheme = Theme.of(context).colorScheme;

    return Card(
      color: nudge ? scheme.tertiaryContainer : null,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Icon(nudge ? Icons.warning_amber_rounded : Icons.verified_outlined),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Backup terakhir', style: text.titleSmall),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    last == null ? 'Belum pernah' : formatBackupDate(last),
                    style: text.bodyMedium,
                  ),
                  if (nudge) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Buat backup agar catatan tidak hilang saat HP rusak '
                      'atau berganti.',
                      style: text.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PassphraseDialog extends StatefulWidget {
  const new({required this.confirm});

  /// `true` saat membuat backup: passphrase diketik dua kali.
  final bool confirm;

  @override
  State<_PassphraseDialog> createState() => _PassphraseDialogState();
}

class _PassphraseDialogState extends State<_PassphraseDialog> {
  final TextEditingController _first = TextEditingController();
  final TextEditingController _second = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _first.dispose();
    _second.dispose();
    super.dispose();
  }

  /// `null` = boleh dikirim; string kosong = belum diisi (tanpa pesan).
  String? get _error {
    final first = _first.text;
    if (first.isEmpty) return '';
    if (!widget.confirm) return null;
    if (!BackupCodec.isAcceptablePassphrase(first)) {
      return 'Minimal ${BackupCodec.minPassphraseLength} karakter.';
    }
    if (_second.text != first) return 'Passphrase tidak sama.';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final error = _error;

    return AlertDialog(
      title: Text(widget.confirm ? 'Buat passphrase' : 'Masukkan passphrase'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.confirm)
              const Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.md),
                child: Text(
                  'Catat passphrase ini di tempat aman. Tanpanya, backup '
                  'tidak bisa dipulihkan.',
                ),
              ),
            TextField(
              controller: _first,
              autofocus: true,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: 'Passphrase',
                suffixIcon: IconButton(
                  tooltip: _obscure ? 'Tampilkan' : 'Sembunyikan',
                  icon: Icon(
                    _obscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            if (widget.confirm) ...[
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _second,
                obscureText: _obscure,
                decoration: const InputDecoration(
                  labelText: 'Ulangi passphrase',
                ),
                onChanged: (_) => setState(() {}),
              ),
            ],
            if (error != null && error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(
                  error,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: error == null
              ? () => Navigator.pop(context, _first.text)
              : null,
          child: Text(widget.confirm ? 'Buat backup' : 'Buka'),
        ),
      ],
    );
  }
}

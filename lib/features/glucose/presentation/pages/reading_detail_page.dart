import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/core/di/injection.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/router/app_router.dart';
import 'package:flutter_gluko_apps/core/theme/app_palette.dart';
import 'package:flutter_gluko_apps/core/theme/app_spacing.dart';
import 'package:flutter_gluko_apps/core/theme/app_typography.dart';
import 'package:flutter_gluko_apps/core/utils/unit_converter.dart';
import 'package:flutter_gluko_apps/core/widgets/status_badge.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/repositories/glucose_repository.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/delete_reading.dart';
import 'package:flutter_gluko_apps/features/profile/domain/repositories/profile_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// S-07 Detail catatan (PRD F-05 AC3).
class ReadingDetailPage extends StatelessWidget {
  const new({required this.readingId, super.key});

  final int readingId;

  @override
  Widget build(BuildContext context) {
    return ReadingDetailView(
      readingId: readingId,
      repository: getIt<GlucoseRepository>(),
      profiles: getIt<ProfileRepository>(),
      deleteReading: getIt<DeleteReading>(),
      restoreReading: getIt<RestoreReading>(),
    );
  }
}

/// Dipisah supaya test widget bisa menyuntik dependensinya sendiri.
class ReadingDetailView extends StatelessWidget {
  const new({
    required this.readingId,
    required this.repository,
    required this.profiles,
    required this.deleteReading,
    required this.restoreReading,
    super.key,
  });

  final int readingId;
  final GlucoseRepository repository;
  final ProfileRepository profiles;
  final DeleteReading deleteReading;
  final RestoreReading restoreReading;

  Future<void> _delete(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus catatan ini?'),
        content: const Text(
          'Catatan masih bisa dikembalikan selama 5 detik setelah dihapus.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final result = await deleteReading(readingId);
    final failure = result.getLeft().toNullable();
    if (failure != null) {
      messenger.showSnackBar(SnackBar(content: Text(failure.message)));
      return;
    }

    // Detail catatan yang sudah dihapus tidak punya isi lagi, jadi layarnya
    // ditutup dan Undo ditawarkan dari layar sebelumnya.
    if (router.canPop()) router.pop();

    messenger.showSnackBar(
      SnackBar(
        content: const Text('Catatan dihapus'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Urungkan',
          onPressed: () async {
            final undo = await restoreReading(readingId);
            final undoFailure = undo.getLeft().toNullable();
            if (undoFailure != null) {
              messenger.showSnackBar(
                SnackBar(content: Text(undoFailure.message)),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail catatan')),
      body: StreamBuilder<GlucoseReading?>(
        stream: repository.watchById(readingId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final reading = snapshot.data;
          if (reading == null || reading.isDeleted) {
            return const Center(child: Text('Catatan tidak ditemukan.'));
          }

          return StreamBuilder<GlucoseUnit>(
            stream: profiles.watchProfile().map((p) => p.unit),
            initialData: GlucoseUnit.mgDl,
            builder: (context, unitSnapshot) => _Body(
              reading: reading,
              unit: unitSnapshot.data ?? GlucoseUnit.mgDl,
              onEdit: () => context.pushNamed(
                AppRoute.record,
                queryParameters: {'edit': '$readingId'},
              ),
              onDelete: () => _delete(context),
            ),
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const new({
    required this.reading,
    required this.unit,
    required this.onEdit,
    required this.onDelete,
  });

  final GlucoseReading reading;
  final GlucoseUnit unit;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final text = Theme.of(context).textTheme;
    final date = DateFormat(
      'EEEE, d MMMM y',
      'id',
    ).format(DateTime.parse(reading.localDate));

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenGutter),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      UnitConverter.formatValue(reading.valueMgDl, unit),
                      style: AppTypography.cardNumeral.copyWith(
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(unit.label, style: text.bodyMedium),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                StatusBadge(status: reading.status),
                if (reading.isCritical) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Nilai ini termasuk sangat rendah atau sangat tinggi.',
                    textAlign: TextAlign.center,
                    style: text.bodySmall?.copyWith(
                      color: palette.high.foreground,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Column(
              children: [
                _DetailRow(label: 'Tipe', value: reading.type.label),
                _DetailRow(label: 'Tanggal', value: date),
                _DetailRow(label: 'Jam', value: reading.formattedTime),
                if (reading.mealContext != null)
                  _DetailRow(
                    label: 'Konteks',
                    value: reading.mealContext!.label,
                  ),
                if (reading.hoursAfterMeal != null)
                  _DetailRow(
                    label: 'Setelah makan',
                    value: '${reading.hoursAfterMeal} jam',
                  ),
                if (reading.symptoms.isNotEmpty)
                  _DetailRow(
                    label: 'Gejala',
                    value: reading.symptoms.map((s) => s.label).join(', '),
                  ),
                if ((reading.note ?? '').isNotEmpty)
                  _DetailRow(label: 'Catatan', value: reading.note!),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        FilledButton.icon(
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined),
          label: const Text('Edit catatan'),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextButton.icon(
          onPressed: onDelete,
          style: TextButton.styleFrom(foregroundColor: palette.high.foreground),
          icon: const Icon(Icons.delete_outline),
          label: const Text('Hapus catatan'),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const new({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: text.bodySmall)),
          Expanded(child: Text(value, style: text.bodyMedium)),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gluko_apps/core/di/injection.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/router/app_router.dart';
import 'package:flutter_gluko_apps/core/theme/app_palette.dart';
import 'package:flutter_gluko_apps/core/theme/app_spacing.dart';
import 'package:flutter_gluko_apps/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:flutter_gluko_apps/features/onboarding/presentation/cubit/onboarding_state.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/services/notification_scheduler.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/usecases/reminder_sync.dart';
import 'package:go_router/go_router.dart';

/// S-02 Onboarding, empat langkah (PRD F-10 AC1).
///
/// Mengikuti `docs/glukotrack-ui/design/Onboarding.dc.html`: indikator empat
/// segmen, ikon 88dp, judul 28/800, daftar poin, lalu satu aksi utama.
class OnboardingPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OnboardingCubit>(),
      child: const _OnboardingView(),
    );
  }
}

/// Menyalakan sinkronisasi pengingat setelah onboarding selesai.
///
/// Izin notifikasi baru diminta di sini — bukan saat aplikasi pertama dibuka —
/// karena pengguna baru saja memilih jam pengingat, jadi alasannya jelas.
Future<void> _activateReminders({required bool askPermission}) async {
  try {
    if (askPermission) {
      await getIt<NotificationScheduler>().requestPermissions();
    }
  } on Object {
    // Penolakan izin tidak boleh menghalangi pengguna masuk ke beranda;
    // layar Pengingat menampilkan banner untuk memintanya lagi.
  }
  getIt<ReminderSync>().start();
}

class _OnboardingView extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listenWhen: (a, b) =>
          a.isDone != b.isDone || a.errorMessage != b.errorMessage,
      listener: (context, state) {
        if (state.isDone) {
          unawaited(
            _activateReminders(askPermission: state.fastingReminderEnabled),
          );
          context.goNamed(AppRoute.dashboard);
          return;
        }
        final message = state.errorMessage;
        if (message != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        }
      },
      builder: (context, state) {
        final cubit = context.read<OnboardingCubit>();

        return Scaffold(
          backgroundColor: palette.surface,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StepIndicator(index: state.stepIndex),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.xl),
                        child: switch (state.step) {
                          OnboardingStep.welcome => const _WelcomeStep(),
                          OnboardingStep.disclaimer => _DisclaimerStep(
                            accepted: state.disclaimerAccepted,
                            onChanged: (v) =>
                                cubit.setDisclaimerAccepted(accepted: v),
                          ),
                          OnboardingStep.unit => _UnitStep(state: state),
                          OnboardingStep.reminder => _ReminderStep(
                            state: state,
                          ),
                        },
                      ),
                    ),
                  ),
                  _Actions(state: state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const new({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final total = OnboardingStep.values.length;

    return Semantics(
      label: 'Langkah ${index + 1} dari $total',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 160,
            child: Row(
              children: [
                for (var i = 0; i < total; i++) ...[
                  if (i > 0) const SizedBox(width: 6),
                  Expanded(
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: i <= index ? palette.brand : palette.border,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          ExcludeSemantics(
            child: Text(
              'Langkah ${index + 1} dari $total',
              style: Theme.of(context).textTheme.labelMedium
                  ?.copyWith(color: palette.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  const new({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: palette.brandSoft,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Icon(icon, size: 44, color: palette.brandStrong),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(title, style: text.displaySmall),
        const SizedBox(height: AppSpacing.md),
        Text(
          body,
          style: text.bodyLarge?.copyWith(color: palette.textSecondary),
        ),
      ],
    );
  }
}

class _BulletPoint extends StatelessWidget {
  const new({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: palette.fieldFill,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: palette.brandStrong),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeader(
          icon: Icons.water_drop_outlined,
          title: 'Selamat datang di GlukoTrack',
          body:
              'Catat gula darah puasa dan sewaktu secara terpisah, lihat '
              'trennya, dan bawa ringkasannya saat kontrol ke dokter.',
        ),
        SizedBox(height: AppSpacing.xl),
        _BulletPoint(
          icon: Icons.bolt_outlined,
          text: 'Mencatat satu hasil cukup beberapa detik.',
        ),
        _BulletPoint(
          icon: Icons.insights_outlined,
          text: 'Puasa dan sewaktu dipisah, jadi trennya benar-benar terbaca.',
        ),
        _BulletPoint(
          icon: Icons.wifi_off_outlined,
          text: 'Bekerja penuh tanpa internet dan tanpa akun.',
        ),
      ],
    );
  }
}

class _DisclaimerStep extends StatelessWidget {
  const new({required this.accepted, required this.onChanged});

  final bool accepted;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepHeader(
          icon: Icons.verified_user_outlined,
          title: 'Sebelum mulai',
          body:
              'GlukoTrack membantu Anda mencatat dan memantau gula darah '
              'puasa maupun sewaktu. Aplikasi ini bukan alat diagnosis.',
        ),
        const SizedBox(height: AppSpacing.xl),
        const _BulletPoint(
          icon: Icons.check,
          text:
              'Target dan status di aplikasi bersifat umum. Sesuaikan target '
              'pribadi bersama dokter.',
        ),
        const _BulletPoint(
          icon: Icons.lock_outline,
          text:
              'Data tersimpan hanya di perangkat ini, terenkripsi, tanpa akun.',
        ),
        const _BulletPoint(
          icon: Icons.warning_amber_outlined,
          text:
              'Bila gula darah sangat rendah atau sangat tinggi, segera cari '
              'pertolongan medis.',
        ),
        const SizedBox(height: AppSpacing.sm),
        // PRD F-10 AC1: persetujuan wajib, jadi area sentuhnya dibuat selebar
        // kartu supaya tidak terlewat.
        InkWell(
          onTap: () => onChanged(!accepted),
          borderRadius: BorderRadius.circular(AppRadius.button),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border.all(
                color: accepted ? palette.brand : palette.inputBorder,
                width: accepted ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: accepted,
                  onChanged: (v) => onChanged(v ?? false),
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Saya mengerti GlukoTrack adalah alat pencatatan, bukan '
                    'pengganti nasihat dokter.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _UnitStep extends StatelessWidget {
  const new({required this.state});

  final OnboardingState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();
    final palette = context.palette;
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepHeader(
          icon: Icons.straighten_outlined,
          title: 'Satuan dan kondisi Anda',
          body:
              'Satuan hanya mengubah tampilan. Data tetap disimpan dalam '
              'mg/dL sehingga bisa diganti kapan saja.',
        ),
        const SizedBox(height: AppSpacing.xl),
        SegmentedButton<GlucoseUnit>(
          segments: [
            for (final u in GlucoseUnit.values)
              ButtonSegment(value: u, label: Text(u.label)),
          ],
          selected: {state.unit},
          onSelectionChanged: (s) => cubit.setUnit(s.first),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('Jenis diabetes (opsional)', style: text.titleMedium),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Menentukan target bawaan Anda. Bisa diubah kapan saja di Pengaturan.',
          style: text.bodySmall,
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final type in DiabetesType.values)
              ChoiceChip(
                label: Text(type.label),
                selected: state.diabetesType == type,
                onSelected: (_) => cubit.setDiabetesType(type),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: palette.brandSoft,
            borderRadius: BorderRadius.circular(AppRadius.key),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 20, color: palette.brandStrong),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Target bawaan: preset ${state.resultingPreset.label}.',
                  style: text.bodySmall?.copyWith(color: palette.brandStrong),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReminderStep extends StatelessWidget {
  const new({required this.state});

  final OnboardingState state;

  Future<void> _pickTime(BuildContext context) async {
    final cubit = context.read<OnboardingCubit>();
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: state.fastingReminderMinutes ~/ 60,
        minute: state.fastingReminderMinutes % 60,
      ),
    );
    if (picked != null) {
      cubit.setReminderMinutes(picked.hour * 60 + picked.minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();
    final palette = context.palette;
    final text = Theme.of(context).textTheme;
    final hour = (state.fastingReminderMinutes ~/ 60).toString().padLeft(
      2,
      '0',
    );
    final minute = (state.fastingReminderMinutes % 60).toString().padLeft(
      2,
      '0',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepHeader(
          icon: Icons.notifications_active_outlined,
          title: 'Pengingat cek puasa',
          body:
              'Gula darah puasa diukur sebelum makan atau minum apa pun di '
              'pagi hari. Satu pengingat harian membantu menjaga rutinitas.',
        ),
        const SizedBox(height: AppSpacing.xl),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          value: state.fastingReminderEnabled,
          onChanged: (v) => cubit.setReminderEnabled(enabled: v),
          title: Text('Aktifkan pengingat harian', style: text.titleMedium),
          subtitle: Text(
            'Dilewati otomatis bila Anda sudah mencatat puasa hari itu.',
            style: text.bodySmall,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        InkWell(
          onTap: state.fastingReminderEnabled ? () => _pickTime(context) : null,
          borderRadius: BorderRadius.circular(AppRadius.button),
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            decoration: BoxDecoration(
              border: Border.all(color: palette.inputBorder),
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            child: Row(
              children: [
                Icon(Icons.schedule, color: palette.textSecondary),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: Text('Jam pengingat', style: text.bodyMedium)),
                Text(
                  '$hour.$minute',
                  style: text.titleLarge?.copyWith(
                    color: state.fastingReminderEnabled
                        ? palette.textPrimary
                        : palette.textSecondary,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Icon(Icons.chevron_right, color: palette.textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  const new({required this.state});

  final OnboardingState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: Column(
        children: [
          FilledButton(
            onPressed: state.isSubmitting || !state.canContinue
                ? null
                : () => state.isLastStep ? cubit.submit() : cubit.next(),
            child: state.isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Text(state.isLastStep ? 'Mulai pakai GlukoTrack' : 'Lanjut'),
          ),
          SizedBox(
            height: AppSizes.minTouchTarget,
            child: state.isFirstStep
                ? null
                : TextButton(
                    onPressed: state.isSubmitting ? null : cubit.back,
                    child: const Text('Kembali'),
                  ),
          ),
        ],
      ),
    );
  }
}

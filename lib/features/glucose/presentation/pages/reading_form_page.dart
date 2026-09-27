import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gluko_apps/core/di/injection.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/router/app_router.dart';
import 'package:flutter_gluko_apps/core/theme/app_palette.dart';
import 'package:flutter_gluko_apps/core/theme/app_spacing.dart';
import 'package:flutter_gluko_apps/core/utils/unit_converter.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/repositories/glucose_repository.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/add_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/presentation/cubit/reading_form_cubit.dart';
import 'package:flutter_gluko_apps/features/glucose/presentation/cubit/reading_form_state.dart';
import 'package:go_router/go_router.dart';

class ReadingFormPage extends StatelessWidget {
  const new({this.initialType, this.editId, super.key});

  final ReadingType? initialType;

  /// Bila terisi, form menyunting catatan tersebut alih-alih membuat baru.
  final int? editId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ReadingFormCubit>(),
      child: ReadingFormView(initialType: initialType, editId: editId),
    );
  }
}

class ReadingFormView extends StatefulWidget {
  const new({this.initialType, this.editId, super.key});

  final ReadingType? initialType;

  /// Id catatan yang sedang disunting (PRD F-05 AC3).
  final int? editId;

  @override
  State<ReadingFormView> createState() => _ReadingFormViewState();
}

class _ReadingFormViewState extends State<ReadingFormView> {
  @override
  void initState() {
    super.initState();
    unawaited(_bootstrap());
  }

  /// Mode sunting memuat catatan lama dulu; mode catat baru langsung memakai
  /// tipe saran.
  Future<void> _bootstrap() async {
    final cubit = context.read<ReadingFormCubit>();
    final editId = widget.editId;

    if (editId == null) {
      await cubit.initialize(initialType: widget.initialType);
      return;
    }

    final existing = await getIt<GlucoseRepository>().findById(editId);
    final reading = existing.getOrElse((_) => null);
    if (reading == null) {
      // Catatan hilang di antara ketukan tombol dan pembukaan form: jangan
      // diam-diam membuat catatan baru, kembali saja.
      if (mounted) Navigator.of(context).maybePop();
      return;
    }
    await cubit.initializeForEdit(reading);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReadingFormCubit, ReadingFormState>(
      listenWhen: (previous, current) =>
          previous.duplicateFasting != current.duplicateFasting &&
          current.duplicateFasting != null,
      listener: _showDuplicateDialog,
      builder: (context, state) {
        if (state.isLoading || !state.isReady) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final saved = state.savedReading;
        if (saved != null) {
          return _SavedReadingView(reading: saved, unit: state.unit);
        }
        return _ReadingForm(state: state);
      },
    );
  }

  Future<void> _showDuplicateDialog(
    BuildContext context,
    ReadingFormState state,
  ) async {
    final cubit = context.read<ReadingFormCubit>();
    final duplicate = state.duplicateFasting!;
    final action = await showDialog<DuplicateFastingAction>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('GDP hari ini sudah ada'),
        content: Text(
          'Catatan sebelumnya '
          '${UnitConverter.formatWithUnit(duplicate.existingValueMgDl, state.unit)}. '
          'Pilih cara menyimpan nilai baru.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(
              dialogContext,
              DuplicateFastingAction.saveAsRandom,
            ),
            child: const Text('Jadikan Sewaktu'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, DuplicateFastingAction.replace),
            child: const Text('Ganti yang lama'),
          ),
        ],
      ),
    );
    if (!context.mounted) return;
    if (action == null) {
      cubit.dismissDuplicate();
    } else {
      await cubit.resolveDuplicate(action);
    }
  }
}

class _ReadingForm extends StatelessWidget {
  const new({required this.state});

  final ReadingFormState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReadingFormCubit>();
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.surface,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(
          AppSpacing.screenGutter,
          AppSpacing.sm,
          AppSpacing.screenGutter,
          AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (state.validationMessage ?? state.errorMessage
                case final message?) ...[
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: palette.high.foreground),
              ),
              const SizedBox(height: AppSpacing.xs),
            ],
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: state.canSubmit ? cubit.submit : null,
                child: state.isSubmitting
                    ? const SizedBox.square(
                        dimension: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenGutter,
                AppSpacing.sm,
                AppSpacing.screenGutter,
                AppSpacing.xl,
              ),
              sliver: SliverList.list(
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: palette.inputBorder,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Catat Gula Darah',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Tutup',
                        onPressed: () => _closeForm(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SegmentedButton<ReadingType>(
                    segments: [
                      for (final type in ReadingType.values)
                        ButtonSegment(value: type, label: Text(type.label)),
                    ],
                    selected: {state.type},
                    onSelectionChanged: (values) => cubit.setType(values.first),
                    showSelectedIcon: false,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _ValueSummary(state: state),
                  Align(
                    child: TextButton(
                      onPressed: state.rawValue.isEmpty
                          ? null
                          : () => cubit.setValue(''),
                      child: const Text('Hapus nilai'),
                    ),
                  ),
                  _MeasurementDetails(state: state),
                  const SizedBox(height: AppSpacing.md),
                  _Keypad(state: state),
                  const SizedBox(height: AppSpacing.lg),
                  _Symptoms(state: state),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    maxLength: 500,
                    minLines: 1,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Catatan (opsional)',
                      hintText: 'Contoh: sesudah makan siang',
                    ),
                    onChanged: cubit.setNote,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ValueSummary extends StatelessWidget {
  const new({required this.state});

  final ReadingFormState state;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final classification = state.classification;
    final colors = _statusColors(palette, classification?.status);
    final thresholds = state.targets!.forType(state.type);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              state.rawValue.isEmpty ? '—' : state.rawValue,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              state.unit.label,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Text(
            classification == null
                ? 'Masukkan nilai'
                : '${classification.status.glyph} ${classification.status.label}',
            style: Theme.of(context).textTheme.labelLarge
                ?.copyWith(color: colors.foreground),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Target normal ${UnitConverter.formatValue(thresholds.lowMax, state.unit)}–'
          '${UnitConverter.formatValue(thresholds.normalMax, state.unit)} '
          '${state.unit.label}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _MeasurementDetails extends StatelessWidget {
  const new({required this.state});

  final ReadingFormState state;

  Future<void> _pickDateTime(BuildContext context) async {
    final current = state.measuredAt!;
    final date = await showDatePicker(
      context: context,
      firstDate: clock.now().subtract(const Duration(days: 365)),
      lastDate: clock.now(),
      initialDate: current,
    );
    if (date == null || !context.mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );
    if (time == null || !context.mounted) return;
    context.read<ReadingFormCubit>().setMeasuredAt(
      DateTime(date.year, date.month, date.day, time.hour, time.minute),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReadingFormCubit>();
    final palette = context.palette;
    final measured = state.measuredAt!;
    final dateLabel = MaterialLocalizations.of(context)
        .formatMediumDate(measured);
    final timeLabel = TimeOfDay.fromDateTime(measured).format(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: palette.border),
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Waktu'),
            trailing: Text('$dateLabel, $timeLabel'),
            onTap: () => _pickDateTime(context),
          ),
          Divider(height: 1, color: palette.divider),
          if (state.type == ReadingType.fasting)
            CheckboxListTile(
              value: state.fastingConfirmed,
              onChanged: (value) =>
                  cubit.setFastingConfirmed(value: value ?? false),
              title: const Text('Sudah puasa minimal 8 jam'),
              controlAffinity: ListTileControlAffinity.leading,
            )
          else
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final meal in MealContext.values)
                      ChoiceChip(
                        label: Text(meal.label),
                        selected: state.mealContext == meal,
                        onSelected: (selected) =>
                            cubit.setMealContext(selected ? meal : null),
                      ),
                  ],
                ),
              ),
            ),
          if (state.type == ReadingType.postprandial2h ||
              (state.type == ReadingType.random &&
                  state.mealContext == MealContext.afterMeal))
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.md,
              ),
              child: DropdownButtonFormField<double>(
                initialValue: state.hoursAfterMeal ?? 2,
                decoration: const InputDecoration(
                  labelText: 'Jam setelah makan',
                ),
                items: const <double>[1, 1.5, 2, 2.5, 3]
                    .map(
                      (hours) => DropdownMenuItem(
                        value: hours,
                        child: Text('$hours jam'),
                      ),
                    )
                    .toList(),
                onChanged: cubit.setHoursAfterMeal,
              ),
            ),
        ],
      ),
    );
  }
}

class _Symptoms extends StatelessWidget {
  const new({required this.state});

  final ReadingFormState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReadingFormCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gejala (opsional)',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final symptom in Symptom.values)
              FilterChip(
                label: Text(symptom.label),
                selected: state.symptoms.contains(symptom),
                onSelected: (_) => cubit.toggleSymptom(symptom),
              ),
          ],
        ),
      ],
    );
  }
}

class _Keypad extends StatelessWidget {
  const new({required this.state});

  final ReadingFormState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReadingFormCubit>();
    final keys = <String>[
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      if (state.unit == GlucoseUnit.mmolL) ',' else 'C',
      '0',
      '⌫',
    ];
    final palette = context.palette;
    // Tinggi tetap (bukan rasio aspek) agar tombol tidak pernah < 48 dp di
    // layar sempit, dan warna eksplisit agar angka tetap kontras di kedua
    // tema (audit 5.1).
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisExtent: AppSizes.keypadKeyHeight,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (final key in keys)
          FilledButton(
            key: Key('keypad-$key'),
            style: FilledButton.styleFrom(
              backgroundColor: palette.fieldFill,
              foregroundColor: palette.textPrimary,
              minimumSize: const Size.fromHeight(AppSizes.keypadKeyHeight),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.key),
              ),
            ),
            onPressed: () => cubit.appendKey(key),
            // Glyph "⌫" tidak ada di Plus Jakarta Sans dan bergantung pada
            // font cadangan perangkat; ikon selalu tampil dan berlabel.
            child: key == '⌫'
                ? const Icon(Icons.backspace_outlined, semanticLabel: 'Hapus')
                : Text(key, style: Theme.of(context).textTheme.titleLarge),
          ),
      ],
    );
  }
}

class _SavedReadingView extends StatelessWidget {
  const new({required this.reading, required this.unit});

  final GlucoseReading reading;
  final GlucoseUnit unit;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final colors = _statusColors(palette, reading.status);
    return Scaffold(
      backgroundColor: palette.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, size: 72, color: colors.solid),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Tersimpan',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                UnitConverter.formatWithUnit(reading.valueMgDl, unit),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${reading.status.glyph} ${reading.status.label}',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(color: colors.foreground),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(_statusMessage(reading.status)),
              const SizedBox(height: AppSpacing.xxl),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.goNamed(AppRoute.dashboard),
                  child: const Text('Selesai'),
                ),
              ),
              TextButton(
                onPressed: () => context.read<ReadingFormCubit>().initialize(
                  initialType: reading.type,
                ),
                child: const Text('Catat lagi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

StatusColors _statusColors(AppPalette palette, GlucoseStatus? status) =>
    switch (status) {
      GlucoseStatus.low => palette.low,
      GlucoseStatus.normal => palette.normal,
      GlucoseStatus.warning => palette.warning,
      GlucoseStatus.high => palette.high,
      null => palette.neutralStatus,
    };

String _statusMessage(GlucoseStatus status) => switch (status) {
  GlucoseStatus.normal => 'Bagus, sesuai target.',
  GlucoseStatus.warning =>
    'Sedikit di atas target. Perhatikan pola makan hari ini.',
  GlucoseStatus.high =>
    'Di atas target. Catat dan pantau; hubungi dokter bila berulang.',
  GlucoseStatus.low =>
    'Di bawah target. Segera konsumsi gula cepat serap bila ada gejala.',
};

void _closeForm(BuildContext context) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.goNamed(AppRoute.dashboard);
  }
}

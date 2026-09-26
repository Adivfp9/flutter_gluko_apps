import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gluko_apps/core/di/injection.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/theme/app_palette.dart';
import 'package:flutter_gluko_apps/core/theme/app_spacing.dart';
import 'package:flutter_gluko_apps/core/utils/unit_converter.dart';
import 'package:flutter_gluko_apps/features/target/presentation/cubit/target_settings_cubit.dart';
import 'package:flutter_gluko_apps/features/target/presentation/cubit/target_settings_state.dart';

class TargetSettingsPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<TargetSettingsCubit>(),
    child: const TargetSettingsView(),
  );
}

class TargetSettingsView extends StatefulWidget {
  const new({super.key});

  @override
  State<TargetSettingsView> createState() => _TargetSettingsViewState();
}

class _TargetSettingsViewState extends State<TargetSettingsView> {
  @override
  void initState() {
    super.initState();
    unawaited(context.read<TargetSettingsCubit>().initialize());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TargetSettingsCubit, TargetSettingsState>(
      listenWhen: (previous, current) =>
          previous.infoMessage != current.infoMessage ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        final message = state.errorMessage ?? state.infoMessage;
        if (message == null) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      },
      builder: (context, state) {
        if (state.isLoading || !state.isReady) {
          return const Scaffold(
            appBar: _TargetAppBar(),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return _TargetEditor(state: state);
      },
    );
  }
}

class _TargetAppBar extends StatelessWidget implements PreferredSizeWidget {
  const new();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) =>
      AppBar(title: const Text('Target Gula Darah'));
}

class _TargetEditor extends StatelessWidget {
  const new({required this.state});

  final TargetSettingsState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TargetSettingsCubit>();
    final palette = context.palette;

    return Scaffold(
      appBar: const _TargetAppBar(),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(
          AppSpacing.screenGutter,
          AppSpacing.sm,
          AppSpacing.screenGutter,
          AppSpacing.md,
        ),
        child: FilledButton(
          onPressed: state.canSave ? cubit.save : null,
          child: state.isSaving
              ? const SizedBox.square(
                  dimension: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : const Text('Simpan target'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenGutter,
          AppSpacing.sm,
          AppSpacing.screenGutter,
          AppSpacing.xl,
        ),
        children: [
          SegmentedButton<TargetPreset>(
            segments: [
              for (final preset in TargetPreset.values)
                ButtonSegment<TargetPreset>(
                  value: preset,
                  label: Text(preset.label),
                  enabled:
                      preset != TargetPreset.custom ||
                      state.selectedPreset == TargetPreset.custom,
                ),
            ],
            selected: {state.selectedPreset},
            onSelectionChanged: (values) => cubit.selectPreset(values.first),
            showSelectedIcon: false,
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: palette.brandSoft,
              borderRadius: BorderRadius.circular(AppRadius.key),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: palette.brandStrong),
                const SizedBox(width: AppSpacing.sm),
                const Expanded(
                  child: Text(
                    'Target bawaan bersifat umum. Sesuaikan angka ini '
                    'bersama dokter Anda.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SegmentedButton<GlucoseUnit>(
            segments: [
              for (final unit in GlucoseUnit.values)
                ButtonSegment(value: unit, label: Text(unit.label)),
            ],
            selected: {state.unit},
            onSelectionChanged: (values) => cubit.setUnit(values.first),
            showSelectedIcon: false,
          ),
          const SizedBox(height: AppSpacing.md),
          for (final type in ReadingType.values) ...[
            _TargetCard(type: type, state: state),
            const SizedBox(height: AppSpacing.md),
          ],
          OutlinedButton.icon(
            onPressed: state.isSaving ? null : cubit.reset,
            icon: const Icon(Icons.restart_alt),
            label: const Text('Kembalikan ke default'),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton.icon(
            onPressed: state.isReclassifying ? null : cubit.reclassify,
            icon: state.isReclassifying
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
            label: const Text('Hitung ulang status data lama'),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _TargetCard extends StatelessWidget {
  const new({required this.type, required this.state});

  final ReadingType type;
  final TargetSettingsState state;

  String get _title => switch (type) {
    ReadingType.fasting => 'Puasa (GDP)',
    ReadingType.random => 'Sewaktu (GDS)',
    ReadingType.postprandial2h => '2 Jam Setelah Makan',
  };

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final cubit = context.read<TargetSettingsCubit>();
    final thresholds = state.targets!.forType(type);

    String display(int value) => UnitConverter.formatValue(value, state.unit);
    void update(TargetBoundary boundary, String raw) {
      final value = UnitConverter.parseToMgDl(raw, state.unit);
      if (value != null) cubit.updateThreshold(type, boundary, value);
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border.all(color: palette.border),
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(state.unit.label),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: SizedBox(
              height: 10,
              child: Row(
                children: [
                  Expanded(child: ColoredBox(color: palette.low.solid)),
                  const SizedBox(width: 2),
                  Expanded(
                    flex: (thresholds.normalMax - thresholds.lowMax).clamp(
                      1,
                      20,
                    ),
                    child: ColoredBox(color: palette.normal.solid),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    flex: (thresholds.warningMax - thresholds.normalMax).clamp(
                      1,
                      20,
                    ),
                    child: ColoredBox(color: palette.warning.solid),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    flex: 3,
                    child: ColoredBox(color: palette.high.solid),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _ThresholdField(
                  key: Key('target-${type.dbValue}-low'),
                  label: 'Rendah di bawah',
                  value: display(thresholds.lowMax),
                  unit: state.unit,
                  onChanged: (raw) => update(TargetBoundary.lowMax, raw),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _ThresholdField(
                  key: Key('target-${type.dbValue}-normal'),
                  label: 'Normal hingga',
                  value: display(thresholds.normalMax),
                  unit: state.unit,
                  onChanged: (raw) => update(TargetBoundary.normalMax, raw),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _ThresholdField(
                  key: Key('target-${type.dbValue}-warning'),
                  label: 'Waspada hingga',
                  value: display(thresholds.warningMax),
                  unit: state.unit,
                  onChanged: (raw) => update(TargetBoundary.warningMax, raw),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThresholdField extends StatefulWidget {
  const new({
    required this.label,
    required this.value,
    required this.unit,
    required this.onChanged,
    super.key,
  });

  final String label;
  final String value;
  final GlucoseUnit unit;
  final ValueChanged<String> onChanged;

  @override
  State<_ThresholdField> createState() => _ThresholdFieldState();
}

class _ThresholdFieldState extends State<_ThresholdField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value,
  );

  @override
  void didUpdateWidget(covariant _ThresholdField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: _controller,
    keyboardType: TextInputType.numberWithOptions(
      decimal: widget.unit == GlucoseUnit.mmolL,
    ),
    textAlign: TextAlign.center,
    decoration: InputDecoration(
      labelText: widget.label,
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
    onChanged: widget.onChanged,
  );
}

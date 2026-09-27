import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gluko_apps/core/di/injection.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/theme/app_palette.dart';
import 'package:flutter_gluko_apps/core/theme/app_spacing.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/entities/reminder.dart';
import 'package:flutter_gluko_apps/features/reminder/presentation/cubit/reminders_cubit.dart';
import 'package:flutter_gluko_apps/features/reminder/presentation/cubit/reminders_state.dart';

/// S-11 Daftar pengingat.
///
/// Tidak ada di paket desain (temuan D-3); disusun dari kartu dan chip yang
/// sudah dipakai layar Target.
class RemindersPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RemindersCubit>()..start(),
      child: const _RemindersView(),
    );
  }
}

class _RemindersView extends StatefulWidget {
  const new();

  @override
  State<_RemindersView> createState() => _RemindersViewState();
}

class _RemindersViewState extends State<_RemindersView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Izin alarm tepat waktu diberikan di layar sistem; statusnya dibaca ulang
  /// saat pengguna kembali ke aplikasi.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(context.read<RemindersCubit>().refreshPermission());
    }
  }

  Future<void> _openEditor(BuildContext context, [Reminder? initial]) async {
    final cubit = context.read<RemindersCubit>();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _ReminderEditor(initial: initial),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Reminder reminder) async {
    final cubit = context.read<RemindersCubit>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus pengingat?'),
        content: Text(
          '"${reminder.label}" pukul ${reminder.formattedTime} tidak akan '
          'berbunyi lagi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok ?? false) await cubit.delete(reminder);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RemindersCubit, RemindersState>(
      listenWhen: (a, b) =>
          a.errorMessage != b.errorMessage || a.infoMessage != b.infoMessage,
      listener: (context, state) {
        final message = state.errorMessage ?? state.infoMessage;
        if (message == null) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
        context.read<RemindersCubit>().clearMessages();
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Pengingat')),
          floatingActionButton: FloatingActionButton.extended(
            heroTag: null,
            onPressed: () => _openEditor(context),
            icon: const Icon(Icons.add),
            label: const Text('Tambah'),
          ),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenGutter,
                    AppSpacing.sm,
                    AppSpacing.screenGutter,
                    96,
                  ),
                  children: [
                    if (state.needsPermission) _PermissionBanner(state: state),
                    if (state.reminders.isEmpty)
                      const _EmptyReminders()
                    else
                      for (final reminder in state.reminders)
                        _ReminderCard(
                          reminder: reminder,
                          onTap: () => _openEditor(context, reminder),
                          onDelete: () => _confirmDelete(context, reminder),
                          onToggle: (value) => context
                              .read<RemindersCubit>()
                              .setActive(reminder, isActive: value),
                        ),
                    const SizedBox(height: AppSpacing.lg),
                    const _ReliabilityGuide(),
                  ],
                ),
        );
      },
    );
  }
}

class _ReminderCard extends StatelessWidget {
  const new({
    required this.reminder,
    required this.onTap,
    required this.onDelete,
    required this.onToggle,
  });

  final Reminder reminder;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final palette = context.palette;
    final type = reminder.readingType;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card),
        onTap: onTap,
        onLongPress: onDelete,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.formattedTime,
                      style: text.headlineSmall?.copyWith(
                        color: reminder.isActive ? null : palette.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(reminder.label, style: text.titleSmall),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      [
                        describeDays(reminder.daysMask),
                        if (type != null) type.label,
                      ].join(' · '),
                      style: text.bodySmall?.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                    if (type == ReadingType.fasting) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Dilewati otomatis bila GDP hari itu sudah dicatat.',
                        style: text.bodySmall?.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Hapus pengingat',
                icon: const Icon(Icons.delete_outline),
                onPressed: onDelete,
              ),
              Semantics(
                label: 'Aktifkan pengingat ${reminder.formattedTime}',
                child: Switch(value: reminder.isActive, onChanged: onToggle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ringkasan hari aktif: "Setiap hari", "Hari kerja", atau "Sen, Rab, Jum".
String describeDays(int mask) {
  if (mask == Reminder.everyDay) return 'Setiap hari';
  if (mask == 0x1F) return 'Hari kerja';
  if (mask == 0x60) return 'Akhir pekan';
  return [
    for (var d = 1; d <= 7; d++)
      if ((mask & (1 << (d - 1))) != 0) _dayShort[d - 1],
  ].join(', ');
}

const _dayShort = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

class _EmptyReminders extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        children: [
          const Icon(Icons.notifications_none, size: 48),
          const SizedBox(height: AppSpacing.md),
          Text('Belum ada pengingat', style: text.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Tambahkan jadwal cek agar tidak terlewat.',
            style: text.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PermissionBanner extends StatelessWidget {
  const new({required this.state});

  final RemindersState state;

  @override
  Widget build(BuildContext context) {
    final permission = state.permission!;
    final message = !permission.notificationsEnabled
        ? 'Notifikasi dimatikan untuk GlukoTrack, jadi pengingat tidak akan '
              'muncul.'
        : 'Izin "Alarm & pengingat" belum diberikan. Pengingat tetap muncul, '
              'tetapi bisa terlambat beberapa menit.';

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.tonal(
                onPressed: () =>
                    context.read<RemindersCubit>().requestPermissions(),
                child: const Text('Beri izin'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Rencana implementasi §7: battery optimizer OEM sering mematikan alarm.
class _ReliabilityGuide extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      child: ExpansionTile(
        leading: const Icon(Icons.battery_alert_outlined),
        title: const Text('Pengingat tidak muncul?'),
        childrenPadding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Beberapa merek HP menghentikan aplikasi di latar belakang untuk '
            'menghemat baterai. Izinkan GlukoTrack berjalan di latar:',
            style: text.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final (brand, steps) in _oemSteps)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '$brand: ',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: steps),
                  ],
                ),
                style: text.bodySmall,
              ),
            ),
        ],
      ),
    );
  }
}

const _oemSteps = [
  (
    'Xiaomi / Redmi / POCO',
    'Setelan › Aplikasi › GlukoTrack › Penghemat baterai › Tidak ada '
        'batasan, lalu aktifkan Mulai otomatis.',
  ),
  (
    'OPPO / realme',
    'Setelan › Baterai › Konsumsi daya aplikasi › GlukoTrack › izinkan '
        'aktivitas latar belakang.',
  ),
  (
    'vivo',
    'Setelan › Baterai › Konsumsi daya latar belakang tinggi › aktifkan '
        'GlukoTrack.',
  ),
  ('Samsung', 'Setelan › Aplikasi › GlukoTrack › Baterai › Tidak dibatasi.'),
  ('Lainnya', 'Setelan › Aplikasi › GlukoTrack › Baterai › Jangan optimalkan.'),
];

class _ReminderEditor extends StatefulWidget {
  const new({this.initial});

  final Reminder? initial;

  @override
  State<_ReminderEditor> createState() => _ReminderEditorState();
}

class _ReminderEditorState extends State<_ReminderEditor> {
  late final TextEditingController _label = TextEditingController(
    text: widget.initial?.label ?? 'Cek gula darah',
  );
  late int _minutes = widget.initial?.timeOfMinutes ?? 7 * 60;
  late int _daysMask = widget.initial?.daysMask ?? Reminder.everyDay;
  late ReadingType? _type = widget.initial?.readingType;
  bool _saving = false;

  @override
  void dispose() {
    _label.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _minutes ~/ 60, minute: _minutes % 60),
    );
    if (picked != null) {
      setState(() => _minutes = picked.hour * 60 + picked.minute);
    }
  }

  Future<void> _save() async {
    final label = _label.text.trim();
    if (label.isEmpty || _daysMask == 0) return;
    setState(() => _saving = true);
    final base = widget.initial;
    // Reminder.copyWith tidak bisa mengosongkan readingType, jadi entity
    // dibangun ulang dari nol.
    final reminder = Reminder(
      id: base?.id,
      label: label,
      timeOfMinutes: _minutes,
      readingType: _type,
      daysMask: _daysMask,
      isActive: base?.isActive ?? true,
    );
    final ok = await context.read<RemindersCubit>().save(reminder);
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final time =
        '${(_minutes ~/ 60).toString().padLeft(2, '0')}.'
        '${(_minutes % 60).toString().padLeft(2, '0')}';
    final canSave = _label.text.trim().isNotEmpty && _daysMask != 0;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenGutter,
        0,
        AppSpacing.screenGutter,
        MediaQuery.viewInsetsOf(context).bottom + AppSpacing.xl,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.initial == null ? 'Pengingat baru' : 'Ubah pengingat',
              style: text.titleLarge,
            ),
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: TextButton(
                onPressed: _pickTime,
                child: Text(
                  time,
                  style: text.displaySmall,
                  semanticsLabel: 'Jam pengingat $time, ketuk untuk mengubah',
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _label,
              maxLength: 60,
              decoration: const InputDecoration(labelText: 'Label'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text('Hari', style: text.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (var d = 1; d <= 7; d++)
                  FilterChip(
                    label: Text(_dayShort[d - 1]),
                    selected: (_daysMask & (1 << (d - 1))) != 0,
                    onSelected: (_) =>
                        setState(() => _daysMask ^= 1 << (d - 1)),
                  ),
              ],
            ),
            if (_daysMask == 0)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Text(
                  'Pilih minimal satu hari.',
                  style: text.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            Text('Buka form catat dengan tipe', style: text.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              children: [
                ChoiceChip(
                  label: const Text('Pilih nanti'),
                  selected: _type == null,
                  onSelected: (_) => setState(() => _type = null),
                ),
                for (final type in ReadingType.values)
                  ChoiceChip(
                    label: Text(type.label),
                    selected: _type == type,
                    onSelected: (_) => setState(() => _type = type),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              height: AppSizes.primaryButtonHeight,
              child: FilledButton(
                onPressed: canSave && !_saving ? _save : null,
                child: Text(_saving ? 'Menyimpan…' : 'Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

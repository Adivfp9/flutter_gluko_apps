import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gluko_apps/core/di/injection.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/router/app_router.dart';
import 'package:flutter_gluko_apps/core/theme/app_palette.dart';
import 'package:flutter_gluko_apps/core/theme/app_spacing.dart';
import 'package:flutter_gluko_apps/core/theme/app_typography.dart';
import 'package:flutter_gluko_apps/core/widgets/status_badge.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/reading_group.dart';
import 'package:flutter_gluko_apps/features/glucose/presentation/cubit/history_cubit.dart';
import 'package:flutter_gluko_apps/features/glucose/presentation/cubit/history_state.dart';
import 'package:flutter_gluko_apps/features/glucose/presentation/widgets/reading_tile.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// S-06 Riwayat (PRD F-05), mengikuti `Riwayat.dc.html`.
class HistoryPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HistoryCubit>()..start(),
      child: const HistoryView(),
    );
  }
}

/// Dipisah supaya test widget bisa menyuntik cubit sendiri.
class HistoryView extends StatelessWidget {
  const new({super.key});

  Future<void> _confirmDelete(
    BuildContext context,
    GlucoseReading reading,
  ) async {
    final cubit = context.read<HistoryCubit>();
    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus catatan ini?'),
        content: Text(
          '${reading.type.label} ${reading.valueMgDl} mg/dL pada '
          '${reading.formattedTime}.',
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

    final id = reading.id;
    if (id == null) return;

    final error = await cubit.delete(id);
    if (error != null) {
      messenger.showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    // PRD F-05 AC3: Undo tersedia 5 detik.
    messenger.showSnackBar(
      SnackBar(
        content: const Text('Catatan dihapus'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Urungkan',
          onPressed: () async {
            final undoError = await cubit.undoDelete(id);
            if (undoError != null) {
              messenger.showSnackBar(SnackBar(content: Text(undoError)));
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () => context.pushNamed(AppRoute.record),
        tooltip: 'Catat gula darah',
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, state) {
            final cubit = context.read<HistoryCubit>();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenGutter,
                    AppSpacing.xl,
                    AppSpacing.screenGutter,
                    0,
                  ),
                  child: Column(
                    children: [
                      _Header(state: state),
                      const SizedBox(height: AppSpacing.md),
                      if (state.viewMode == HistoryViewMode.list)
                        _TypeFilters(state: state),
                    ],
                  ),
                ),
                Expanded(
                  child: switch (state.viewMode) {
                    HistoryViewMode.list => _HistoryList(
                      state: state,
                      onLoadMore: cubit.loadMore,
                      onDelete: (reading) => _confirmDelete(context, reading),
                    ),
                    HistoryViewMode.calendar => _CalendarView(state: state),
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const new({required this.state});

  final HistoryState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HistoryCubit>();

    final title = Text(
      'Riwayat',
      style: Theme.of(context).textTheme.headlineSmall,
    );
    final toggle = SegmentedButton<HistoryViewMode>(
      showSelectedIcon: false,
      segments: const [
        ButtonSegment(value: HistoryViewMode.list, label: Text('Daftar')),
        ButtonSegment(value: HistoryViewMode.calendar, label: Text('Kalender')),
      ],
      selected: {state.viewMode},
      onSelectionChanged: (s) => cubit.setViewMode(s.first),
    );

    // Audit 5.1: pada text scale besar judul dan tombol segmen tidak muat
    // berdampingan, jadi tombol turun ke bawah judul.
    // Wrap: bila judul dan tombol segmen tidak muat berdampingan (layar
    // sempit atau text scale besar), tombol turun ke bawah judul.
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [title, toggle],
      ),
    );
  }
}

/// Chip filter tipe (PRD F-05 AC2).
class _TypeFilters extends StatelessWidget {
  const new({required this.state});

  final HistoryState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HistoryCubit>();

    return SizedBox(
      height: AppSizes.filterChipHeight + 8,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ChoiceChip(
            label: const Text('Semua'),
            selected: state.typeFilter == null,
            onSelected: (_) => cubit.setTypeFilter(null),
          ),
          for (final type in ReadingType.values) ...[
            const SizedBox(width: AppSpacing.sm),
            ChoiceChip(
              label: Text(type.label),
              selected: state.typeFilter == type,
              onSelected: (_) => cubit.setTypeFilter(type),
            ),
          ],
        ],
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const new({
    required this.state,
    required this.onLoadMore,
    required this.onDelete,
  });

  final HistoryState state;
  final VoidCallback onLoadMore;
  final void Function(GlucoseReading) onDelete;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && state.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.isEmpty) {
      return _EmptyHistory(hasFilter: state.hasActiveFilter);
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        // Muat halaman berikutnya sebelum pengguna benar-benar mentok, supaya
        // gulirannya tidak terasa tersendat (PRD F-05 AC1).
        if (notification.metrics.pixels >=
            notification.metrics.maxScrollExtent - 200) {
          onLoadMore();
        }
        return false;
      },
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenGutter,
          AppSpacing.md,
          AppSpacing.screenGutter,
          96,
        ),
        itemCount: state.groups.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.groups.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return _DateGroup(
            group: state.groups[index],
            unit: state.unit,
            onDelete: onDelete,
          );
        },
      ),
    );
  }
}

class _DateGroup extends StatelessWidget {
  const new({required this.group, required this.unit, required this.onDelete});

  final ReadingGroup group;
  final GlucoseUnit unit;
  final void Function(GlucoseReading) onDelete;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final header = ReadingGrouper.headerLabel(
      group.localDate,
      now: clock.now(),
      formatDate: (d) => DateFormat('EEE, d MMM', 'id').format(d),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xs, bottom: 6),
            child: Text(
              header.toUpperCase(),
              style: AppTypography.sectionLabel.copyWith(
                color: palette.textSecondary,
              ),
            ),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                children: [
                  for (final (index, reading) in group.readings.indexed)
                    Dismissible(
                      key: ValueKey('reading-${reading.id}'),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (_) async {
                        onDelete(reading);
                        // Penghapusan berjalan lewat dialog konfirmasi; baris
                        // tidak dibuang di sini karena stream drift yang akan
                        // memperbarui daftarnya.
                        return false;
                      },
                      background: ColoredBox(
                        color: palette.high.background,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: AppSpacing.lg,
                            ),
                            child: Icon(
                              Icons.delete_outline,
                              color: palette.high.foreground,
                            ),
                          ),
                        ),
                      ),
                      child: ReadingTile(
                        reading: reading,
                        unit: unit,
                        showDivider: index > 0,
                        onTap: () => context.pushNamed(
                          AppRoute.readingDetail,
                          pathParameters: {'id': '${reading.id}'},
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const new({required this.hasFilter});

  final bool hasFilter;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final text = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasFilter ? Icons.filter_alt_off_outlined : Icons.inbox_outlined,
              size: 48,
              color: palette.textSecondary,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              hasFilter
                  ? 'Tidak ada catatan untuk filter ini'
                  : 'Belum ada catatan',
              style: text.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              hasFilter
                  ? 'Coba pilih tipe lain atau tampilkan semua.'
                  : 'Mulai dengan cek gula darah puasa besok pagi.',
              textAlign: TextAlign.center,
              style: text.bodyMedium?.copyWith(color: palette.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tampilan kalender dengan titik warna per hari (PRD F-05 AC4).
///
/// Layar ini tidak ada di paket desain (temuan D-2 pada rencana implementasi),
/// jadi tata letaknya diturunkan dari bahasa visual kartu yang sudah dipakai.
class _CalendarView extends StatelessWidget {
  const new({required this.state});

  final HistoryState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HistoryCubit>();
    final palette = context.palette;
    final text = Theme.of(context).textTheme;
    final month = state.calendarMonth ?? clock.now();

    final firstOfMonth = DateTime(month.year, month.month);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    // weekday Dart: 1 = Senin, sama dengan kolom pertama kalender.
    final leadingBlanks = firstOfMonth.weekday - 1;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenGutter,
        AppSpacing.md,
        AppSpacing.screenGutter,
        96,
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => cubit.loadCalendar(
                month: DateTime(month.year, month.month - 1),
              ),
              icon: const Icon(Icons.chevron_left),
              tooltip: 'Bulan sebelumnya',
            ),
            Expanded(
              child: Text(
                DateFormat('MMMM y', 'id').format(month),
                style: text.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              onPressed: () => cubit.loadCalendar(
                month: DateTime(month.year, month.month + 1),
              ),
              icon: const Icon(Icons.chevron_right),
              tooltip: 'Bulan berikutnya',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            for (final label in [
              'Sen',
              'Sel',
              'Rab',
              'Kam',
              'Jum',
              'Sab',
              'Min',
            ])
              Expanded(
                child: Center(child: Text(label, style: text.bodySmall)),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 0.85,
          ),
          itemCount: leadingBlanks + daysInMonth,
          itemBuilder: (context, index) {
            if (index < leadingBlanks) return const SizedBox.shrink();

            final day = index - leadingBlanks + 1;
            final key =
                '${month.year.toString().padLeft(4, '0')}-'
                '${month.month.toString().padLeft(2, '0')}-'
                '${day.toString().padLeft(2, '0')}';
            final status = state.calendarStatuses[key];

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$day', style: text.bodyMedium),
                const SizedBox(height: 4),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: status == null
                        ? palette.border
                        : statusColorsOf(context, status).solid,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Keterangan titik', style: text.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Titik menunjukkan status terburuk pada hari itu.',
                  style: text.bodySmall,
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.lg,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final status in GlucoseStatus.values)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: statusColorsOf(context, status).solid,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(status.label, style: text.bodySmall),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

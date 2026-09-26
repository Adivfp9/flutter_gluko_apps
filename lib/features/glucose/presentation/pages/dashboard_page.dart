import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gluko_apps/core/di/injection.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/router/app_router.dart';
import 'package:flutter_gluko_apps/core/theme/app_palette.dart';
import 'package:flutter_gluko_apps/core/theme/app_spacing.dart';
import 'package:flutter_gluko_apps/core/theme/app_typography.dart';
import 'package:flutter_gluko_apps/core/utils/unit_converter.dart';
import 'package:flutter_gluko_apps/core/widgets/status_badge.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/dashboard_summary.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/presentation/cubit/dashboard_cubit.dart';
import 'package:flutter_gluko_apps/features/glucose/presentation/cubit/dashboard_state.dart';
import 'package:flutter_gluko_apps/features/glucose/presentation/widgets/reading_tile.dart';
import 'package:flutter_gluko_apps/features/glucose/presentation/widgets/sparkline_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// S-03 Beranda (PRD F-04), mengikuti `Main.dc.html`.
class DashboardPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DashboardCubit>()..start(),
      child: const DashboardView(),
    );
  }
}

/// Dipisah dari [DashboardPage] supaya test widget bisa menyuntik cubit
/// sendiri tanpa menyentuh dependency injection.
class DashboardView extends StatefulWidget {
  const new({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView>
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Aplikasi yang dibiarkan terbuka semalaman harus tetap menampilkan
    // "Puasa hari ini" untuk hari yang benar.
    if (state == AppLifecycleState.resumed) {
      context.read<DashboardCubit>().refreshIfDayChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(AppRoute.record),
        icon: const Icon(Icons.add),
        label: const Text('Catat'),
      ),
      body: SafeArea(
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state.isLoading && state.summary == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final summary = state.summary;
            if (summary == null) {
              return _ErrorView(message: state.errorMessage);
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenGutter,
                AppSpacing.xl,
                AppSpacing.screenGutter,
                96,
              ),
              children: [
                _Greeting(name: state.userName),
                const SizedBox(height: AppSpacing.lg),
                if (summary.isEmpty)
                  const _EmptyState()
                else ...[
                  _TodayCards(summary: summary, unit: state.unit),
                  const SizedBox(height: AppSpacing.md),
                  _WeeklyAverageCard(summary: summary, unit: state.unit),
                  const SizedBox(height: AppSpacing.md),
                  _RecentCard(summary: summary, unit: state.unit),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const new({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Text(
          message ?? 'Beranda belum bisa dimuat.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const new({this.name});

  final String? name;

  /// Sapaan mengikuti jam, seperti "Selamat pagi" pada desain.
  String _salutation(int hour) {
    if (hour < 11) return 'Selamat pagi';
    if (hour < 15) return 'Selamat siang';
    if (hour < 19) return 'Selamat sore';
    return 'Selamat malam';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final text = Theme.of(context).textTheme;
    final date = DateFormat('EEEE, d MMMM y', 'id').format(now);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date, style: text.bodySmall),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${_salutation(now.hour)}, ${name ?? 'Anda'}',
                style: text.headlineSmall,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => context.goNamed(AppRoute.settings),
          icon: const Icon(Icons.notifications_none),
          tooltip: 'Pengingat',
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: palette.brandSoft,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Icon(
              Icons.water_drop_outlined,
              size: 44,
              color: palette.brandStrong,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Belum ada catatan', style: text.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Mulai dengan cek gula darah puasa besok pagi.',
            textAlign: TextAlign.center,
            style: text.bodyMedium?.copyWith(color: palette.textSecondary),
          ),
        ],
      ),
    );
  }
}

/// Kartu "Puasa hari ini" dan "Sewaktu terakhir" (PRD F-04 AC1).
class _TodayCards extends StatelessWidget {
  const new({required this.summary, required this.unit});

  final DashboardSummary summary;
  final GlucoseUnit unit;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: _ReadingCard(
            title: 'Puasa hari ini',
            icon: Icons.wb_twilight,
            type: ReadingType.fasting,
            reading: summary.todayFasting,
            unit: unit,
            emptyLabel: 'Catat sekarang',
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _ReadingCard(
            title: 'Sewaktu terakhir',
            icon: Icons.water_drop_outlined,
            type: ReadingType.random,
            reading: summary.lastRandom,
            unit: unit,
            emptyLabel: 'Belum ada',
            showRelativeDay: true,
            today: summary.today,
          ),
        ),
      ],
    );
  }
}

class _ReadingCard extends StatelessWidget {
  const new({
    required this.title,
    required this.icon,
    required this.type,
    required this.unit,
    required this.emptyLabel,
    this.reading,
    this.showRelativeDay = false,
    this.today,
  });

  final String title;
  final IconData icon;
  final ReadingType type;
  final GlucoseReading? reading;
  final GlucoseUnit unit;
  final String emptyLabel;
  final bool showRelativeDay;
  final String? today;

  String _timeLabel(GlucoseReading value) {
    if (!showRelativeDay || today == null) return value.formattedTime;
    if (value.localDate == today) return 'Hari ini ${value.formattedTime}';

    final date = DateTime.parse(value.localDate);
    return '${DateFormat('d MMM', 'id').format(date)} ${value.formattedTime}';
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final text = Theme.of(context).textTheme;
    final accent = accentColorsOf(context, type);
    final value = reading;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: accent.foreground),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.sectionLabel.copyWith(
                      color: accent.foreground,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (value == null) ...[
              const Text('—', style: AppTypography.cardNumeral),
              const SizedBox(height: 10),
              Text(
                emptyLabel,
                style: text.bodySmall?.copyWith(color: palette.brandStrong),
              ),
            ] else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        UnitConverter.formatValue(value.valueMgDl, unit),
                        style: AppTypography.cardNumeral.copyWith(
                          color: palette.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(unit.label, style: text.bodySmall),
                ],
              ),
              const SizedBox(height: 10),
              StatusBadge(status: value.status),
              const SizedBox(height: 6),
              Text(_timeLabel(value), style: text.bodySmall),
            ],
          ],
        ),
      ),
    );
  }
}

/// Rata-rata 7 hari per tipe plus mini chart (PRD F-04 AC2 & AC3).
class _WeeklyAverageCard extends StatelessWidget {
  const new({required this.summary, required this.unit});

  final DashboardSummary summary;
  final GlucoseUnit unit;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final text = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Rata-rata 7 hari', style: text.titleMedium),
                TextButton(
                  onPressed: () => context.goNamed(AppRoute.trend),
                  style: TextButton.styleFrom(
                    minimumSize: const Size(0, AppSizes.minTouchTarget),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                    ),
                  ),
                  child: const Text('Lihat tren'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: _AverageColumn(
                    average: summary.fastingAverage,
                    unit: unit,
                    color: palette.fasting.series,
                  ),
                ),
                Expanded(
                  child: _AverageColumn(
                    average: summary.randomAverage,
                    unit: unit,
                    color: palette.random.series,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            SparklineChart(
              series: [
                SparklineSeries(
                  points: summary.fastingSparkline,
                  color: palette.fasting.series,
                  strokeWidth: 2.5,
                ),
                SparklineSeries(
                  points: summary.randomSparkline,
                  color: palette.random.series,
                ),
              ],
              baselineColor: palette.divider,
            ),
          ],
        ),
      ),
    );
  }
}

class _AverageColumn extends StatelessWidget {
  const new({required this.average, required this.unit, required this.color});

  final PeriodAverage average;
  final GlucoseUnit unit;
  final Color color;

  /// Teks perubahan; hanya bermakna bila periode pembanding punya data.
  String _deltaLabel() {
    final delta = average.delta;
    if (delta == null) return 'Belum ada pembanding';
    if (delta == 0) return 'Stabil vs minggu lalu';
    final arrow = delta < 0 ? '↓' : '↑';
    return '$arrow ${delta.abs()} vs minggu lalu';
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final rounded = average.roundedAverage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(average.type.label, style: text.bodySmall),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          rounded == null ? '—' : UnitConverter.formatValue(rounded, unit),
          style: text.headlineSmall,
        ),
        const SizedBox(height: 2),
        Text(_deltaLabel(), style: text.bodySmall),
      ],
    );
  }
}

/// Lima catatan terakhir (PRD F-04 AC3).
class _RecentCard extends StatelessWidget {
  const new({required this.summary, required this.unit});

  final DashboardSummary summary;
  final GlucoseUnit unit;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Catatan terakhir', style: text.titleMedium),
                TextButton(
                  onPressed: () => context.goNamed(AppRoute.history),
                  style: TextButton.styleFrom(
                    minimumSize: const Size(0, AppSizes.minTouchTarget),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                    ),
                  ),
                  child: const Text('Semua'),
                ),
              ],
            ),
            for (final (index, reading) in summary.recentReadings.indexed)
              ReadingTile(
                reading: reading,
                unit: unit,
                showDivider: index > 0,
                onTap: () => context.goNamed(AppRoute.history),
              ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}

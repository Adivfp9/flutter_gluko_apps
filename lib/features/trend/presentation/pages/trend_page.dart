import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gluko_apps/core/di/injection.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/theme/app_palette.dart';
import 'package:flutter_gluko_apps/core/theme/app_spacing.dart';
import 'package:flutter_gluko_apps/core/theme/app_typography.dart';
import 'package:flutter_gluko_apps/core/utils/unit_converter.dart';
import 'package:flutter_gluko_apps/core/widgets/status_badge.dart';
import 'package:flutter_gluko_apps/features/trend/domain/entities/trend_summary.dart';
import 'package:flutter_gluko_apps/features/trend/presentation/cubit/trend_cubit.dart';
import 'package:flutter_gluko_apps/features/trend/presentation/cubit/trend_state.dart';
import 'package:intl/intl.dart';

/// S-08 Tren (PRD F-06), mengikuti `Tren.dc.html`.
class TrendPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TrendCubit>()..start(),
      child: const TrendView(),
    );
  }
}

/// Dipisah supaya test widget bisa menyuntik cubit sendiri.
class TrendView extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<TrendCubit, TrendState>(
          builder: (context, state) {
            final summary = state.summary;

            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenGutter,
                AppSpacing.xl,
                AppSpacing.screenGutter,
                AppSpacing.xl,
              ),
              children: [
                Text('Tren', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: AppSpacing.md),
                _PeriodSelector(state: state),
                const SizedBox(height: AppSpacing.md),
                if (state.isLoading && summary == null)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 64),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (summary == null || summary.isEmpty)
                  const _EmptyTrend()
                else ...[
                  _ChartCard(state: state, summary: summary),
                  const SizedBox(height: AppSpacing.md),
                  _StatsGrid(state: state, summary: summary),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  const new({required this.state});

  final TrendState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TrendCubit>();

    return SegmentedButton<TrendPeriod>(
      showSelectedIcon: false,
      segments: [
        for (final p in TrendPeriod.values)
          ButtonSegment(value: p, label: Text(p.label)),
      ],
      selected: {state.period},
      onSelectionChanged: (s) => cubit.setPeriod(s.first),
    );
  }
}

class _EmptyTrend extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Column(
        children: [
          Icon(
            Icons.show_chart_outlined,
            size: 48,
            color: palette.textSecondary,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Belum ada data pada periode ini', style: text.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Catat beberapa kali dulu, trennya akan muncul di sini.',
            textAlign: TextAlign.center,
            style: text.bodyMedium?.copyWith(color: palette.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const new({required this.state, required this.summary});

  final TrendState state;
  final TrendSummary summary;

  /// Sumbu X memakai epoch milidetik supaya jarak antar titik sebanding dengan
  /// jarak waktu sebenarnya. Memakai indeks akan membuat dua pengukuran
  /// berjarak sejam tampak sejauh dua pengukuran berjarak seminggu.
  LineChartBarData _series(
    BuildContext context,
    ReadingType type,
    List<TrendPoint> points,
  ) {
    final accent = accentColorsOf(context, type);

    return LineChartBarData(
      spots: [
        for (final p in points)
          FlSpot(
            p.measuredAt.millisecondsSinceEpoch.toDouble(),
            p.valueMgDl.toDouble(),
          ),
      ],
      color: accent.series,
      barWidth: type == ReadingType.fasting ? 2.5 : 2,
      dotData: FlDotData(
        getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
          radius: 3.5,
          // PRD F-06 AC2: titik diwarnai sesuai statusnya, bukan warna garis.
          color: statusColorsOf(context, points[index].status).solid,
          strokeWidth: 1.5,
          strokeColor: context.palette.surface,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final text = Theme.of(context).textTheme;
    final scale = summary.scale;

    final visible = [
      for (final type in ReadingType.values)
        if (state.isVisible(type) && summary.pointsOf(type).isNotEmpty)
          _series(context, type, summary.pointsOf(type)),
    ];

    final from = DateTime.parse(summary.fromLocalDate);
    final to = DateTime.parse(summary.toLocalDate);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                for (final type in ReadingType.values)
                  FilterChip(
                    label: Text(type.label),
                    selected: state.isVisible(type),
                    avatar: CircleAvatar(
                      radius: 5,
                      backgroundColor: accentColorsOf(context, type).series,
                    ),
                    onSelected: (_) =>
                        context.read<TrendCubit>().toggleType(type),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  minY: scale.min,
                  maxY: scale.max,
                  minX: from.millisecondsSinceEpoch.toDouble(),
                  maxX: to
                      .add(const Duration(days: 1))
                      .millisecondsSinceEpoch
                      .toDouble(),
                  lineBarsData: visible,
                  gridData: FlGridData(
                    drawVerticalLine: false,
                    horizontalInterval: scale.step,
                    getDrawingHorizontalLine: (value) =>
                        FlLine(color: palette.divider, strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(),
                    rightTitles: const AxisTitles(),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: scale.step,
                        reservedSize: 38,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: text.bodySmall,
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: _bottomInterval(from, to),
                        getTitlesWidget: (value, meta) {
                          final date = DateTime.fromMillisecondsSinceEpoch(
                            value.toInt(),
                          );
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              DateFormat('d MMM', 'id').format(date),
                              style: text.bodySmall,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // PRD F-06 AC2: pita hijau menandai rentang target.
                  rangeAnnotations: RangeAnnotations(
                    horizontalRangeAnnotations: [
                      HorizontalRangeAnnotation(
                        y1: summary.bandLow ?? scale.min,
                        y2: summary.bandHigh ?? scale.min,
                        color: palette.normal.solid.withValues(alpha: 0.1),
                      ),
                    ],
                  ),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => palette.textPrimary,
                      getTooltipItems: (spots) => [
                        for (final spot in spots)
                          LineTooltipItem(
                            '${spot.y.toInt()} mg/dL\n'
                            '${DateFormat('d MMM, HH.mm', 'id').format(DateTime.fromMillisecondsSinceEpoch(spot.x.toInt()))}',
                            TextStyle(
                              color: palette.surface,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('Warna titik = status:', style: text.bodySmall),
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
                      const SizedBox(width: 3),
                      Text(status.label, style: text.bodySmall),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Jarak label tanggal agar tidak bertumpuk pada periode panjang.
  double _bottomInterval(DateTime from, DateTime to) {
    final days = to.difference(from).inDays + 1;
    final every = days <= 7
        ? 2
        : days <= 14
        ? 3
        : days <= 30
        ? 7
        : 21;
    return Duration(days: every).inMilliseconds.toDouble();
  }
}

class _StatsGrid extends StatelessWidget {
  const new({required this.state, required this.summary});

  final TrendState state;
  final TrendSummary summary;

  @override
  Widget build(BuildContext context) {
    final visible = [
      for (final type in ReadingType.values)
        if (state.isVisible(type)) type,
    ];

    return Column(
      children: [
        for (final type in visible) ...[
          _StatsCard(
            stats: summary.statsOf(type),
            unit: state.unit,
            type: type,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

class _StatsCard extends StatelessWidget {
  const new({required this.stats, required this.unit, required this.type});

  final TrendStats stats;
  final GlucoseUnit unit;
  final ReadingType type;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final text = Theme.of(context).textTheme;
    final accent = accentColorsOf(context, type);
    final tir = stats.timeInRangePercent;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: accent.series,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(type.label, style: text.titleMedium),
                const Spacer(),
                Text('${stats.count} pembacaan', style: text.bodySmall),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (!stats.hasData)
              Text(
                'Belum ada data pada periode ini.',
                style: text.bodySmall?.copyWith(color: palette.textSecondary),
              )
            else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    UnitConverter.formatValue(stats.roundedAverage!, unit),
                    style: AppTypography.statNumeral.copyWith(
                      color: palette.textPrimary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      'rata-rata ${unit.label}',
                      style: text.bodySmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Min ${UnitConverter.formatValue(stats.min!, unit)} · '
                'Maks ${UnitConverter.formatValue(stats.max!, unit)}',
                style: text.bodySmall,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Text('Dalam target', style: text.bodySmall),
                  const Spacer(),
                  Text('$tir%', style: text.titleMedium),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: (tir ?? 0) / 100,
                  minHeight: 6,
                  backgroundColor: palette.divider,
                  valueColor: AlwaysStoppedAnimation(accent.series),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

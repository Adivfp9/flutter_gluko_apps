import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/dashboard_summary.dart';

/// Satu garis pada mini chart.
class SparklineSeries {
  const new({required this.points, required this.color, this.strokeWidth = 2});

  final List<DailyPoint> points;
  final Color color;
  final double strokeWidth;
}

/// Mini chart 7 hari di beranda (`Main.dc.html`, 316x60).
///
/// Hari tanpa data memutus garis, bukan digambar sebagai nol — grafik yang
/// terjun ke dasar setiap hari libur akan terbaca seperti hipoglikemia.
class SparklineChart extends StatelessWidget {
  const new({
    required this.series,
    required this.baselineColor,
    this.height = 60,
    super.key,
  });

  final List<SparklineSeries> series;
  final Color baselineColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    final hasAnyData = series.any(
      (s) => s.points.any((p) => p.average != null),
    );

    return SizedBox(
      height: height,
      width: double.infinity,
      child: hasAnyData
          ? CustomPaint(
              painter: _SparklinePainter(
                series: series,
                baselineColor: baselineColor,
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  const new({required this.series, required this.baselineColor});

  final List<SparklineSeries> series;
  final Color baselineColor;

  @override
  void paint(Canvas canvas, Size size) {
    const padding = 4.0;
    final baseline = Paint()
      ..color = baselineColor
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height - 1),
      Offset(size.width, size.height - 1),
      baseline,
    );

    // Skala dihitung dari seluruh seri sekaligus supaya GDP dan GDS bisa
    // dibandingkan langsung; menskalakan tiap garis sendiri-sendiri akan
    // membuat nilai 98 dan 156 tampak sama tinggi.
    final values = <double>[
      for (final s in series)
        for (final p in s.points)
          if (p.average != null) p.average!,
    ];
    if (values.isEmpty) return;

    var min = values.first;
    var max = values.first;
    for (final v in values) {
      if (v < min) min = v;
      if (v > max) max = v;
    }
    // Rentang datar (semua nilai sama) digambar di tengah, bukan dibagi nol.
    final span = (max - min).abs() < 1 ? 1.0 : max - min;

    for (final s in series) {
      if (s.points.length < 2) continue;

      final paint = Paint()
        ..color = s.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = s.strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final stepX = (size.width - padding * 2) / (s.points.length - 1);
      final path = Path();
      var started = false;

      for (var i = 0; i < s.points.length; i++) {
        final value = s.points[i].average;
        if (value == null) {
          // Putus garis: titik berikutnya memulai sub-path baru.
          started = false;
          continue;
        }

        final x = padding + stepX * i;
        final normalized = (value - min) / span;
        final y = padding + (1 - normalized) * (size.height - padding * 2 - 2);

        if (started) {
          path.lineTo(x, y);
        } else {
          path.moveTo(x, y);
          started = true;
        }
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_SparklinePainter oldDelegate) =>
      oldDelegate.series != series ||
      oldDelegate.baselineColor != baselineColor;
}

import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/dashboard_summary.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/entities/scheduled_notification.dart';
import 'package:flutter_gluko_apps/features/trend/domain/entities/trend_summary.dart';
import 'package:flutter_test/flutter_test.dart';

/// Kesetaraan entity menentukan apakah Cubit memancarkan state baru. Bila
/// terlalu longgar, perubahan data tidak tampil di layar (bug ReadingGroup
/// yang ditemukan Sprint 5.3); bila terlalu ketat, layar di-rebuild terus.
void main() {
  GlucoseReading reading({int id = 1, int value = 100}) => GlucoseReading(
    id: id,
    type: ReadingType.fasting,
    valueMgDl: value,
    measuredAt: DateTime.utc(2026, 9, 26, 23),
    tzOffsetMinutes: 420,
    status: GlucoseStatus.warning,
    isCritical: false,
  );

  test('DailyPoint', () {
    const a = DailyPoint(localDate: '2026-09-27', average: 98);
    const same = DailyPoint(localDate: '2026-09-27', average: 98);

    expect(a, same);
    expect(a.hashCode, same.hashCode);
    expect(a, isNot(const DailyPoint(localDate: '2026-09-27', average: 99)));
  });

  test('ScheduledNotification', () {
    ScheduledNotification n({String body = 'b'}) => ScheduledNotification(
      id: 17,
      reminderId: 1,
      weekday: 7,
      firstFireAt: DateTime(2026, 9, 27, 6),
      title: 't',
      body: body,
      payload: '/catat',
    );

    expect(n(), n());
    expect(n().hashCode, n().hashCode);
    expect(n(), isNot(n(body: 'lain')));
    expect(n().toString(), contains('17'));
    expect(ScheduledNotification.idFor(3, 5), 35);
  });

  group('TrendSummary', () {
    test('TrendStats membandingkan seluruh angka', () {
      const a = TrendStats(
        type: ReadingType.fasting,
        count: 2,
        inTargetCount: 1,
        average: 100,
        min: 90,
        max: 110,
      );
      const same = TrendStats(
        type: ReadingType.fasting,
        count: 2,
        inTargetCount: 1,
        average: 100,
        min: 90,
        max: 110,
      );
      const moreInTarget = TrendStats(
        type: ReadingType.fasting,
        count: 2,
        inTargetCount: 2,
        average: 100,
        min: 90,
        max: 110,
      );

      expect(a, same);
      expect(a.hashCode, same.hashCode);
      expect(a, isNot(moreInTarget));
    });

    test('TrendPoint diidentifikasi oleh pembacaannya', () {
      final p = TrendPoint(reading: reading());

      expect(p, TrendPoint(reading: reading()));
      expect(p.hashCode, TrendPoint(reading: reading()).hashCode);
      expect(p.valueMgDl, 100);
      expect(p.status, GlucoseStatus.warning);
      expect(p.measuredAt, DateTime.utc(2026, 9, 26, 23));
      expect(p, isNot(TrendPoint(reading: reading(id: 2))));
    });

    test('ChartScale', () {
      const a = ChartScale(min: 60, max: 200, step: 40);
      const same = ChartScale(min: 60, max: 200, step: 40);

      expect(a, same);
      expect(a.hashCode, same.hashCode);
      expect(a, isNot(const ChartScale(min: 60, max: 200, step: 20)));
      expect(a.span, 140);
    });
  });
}

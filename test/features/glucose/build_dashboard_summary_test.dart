import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/build_dashboard_summary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const build = BuildDashboardSummary();

  // Acuan tetap supaya hasil test tidak bergantung pada tanggal saat dijalankan.
  final now = DateTime(2026, 9, 27, 8, 30);
  const tzOffset = 420; // WIB, +07:00.

  /// Pembacaan pada [daysAgo] hari lalu, pukul [hour] waktu lokal.
  ///
  /// Jam dinding yang diinginkan dibangun sebagai UTC lalu dikurangi offset,
  /// sehingga hasilnya adalah instan UTC yang benar. Memakai `DateTime` lokal
  /// lalu `.toUtc()` akan menerapkan offset mesin penguji untuk kedua kalinya
  /// dan menggeser tanggalnya.
  GlucoseReading readingAt({
    required int daysAgo,
    required int value,
    ReadingType type = ReadingType.fasting,
    int hour = 6,
  }) {
    final wallClock = DateTime.utc(
      now.year,
      now.month,
      now.day - daysAgo,
      hour,
    );
    return GlucoseReading(
      type: type,
      valueMgDl: value,
      measuredAt: wallClock.subtract(const Duration(minutes: tzOffset)),
      tzOffsetMinutes: tzOffset,
      status: GlucoseStatus.normal,
      isCritical: false,
    );
  }

  group('Rata-rata 7 hari (PRD F-04 AC2)', () {
    test('menghitung rata-rata periode berjalan dan pembandingnya', () {
      final summary = build(
        DashboardInput(
          windowReadings: [
            // Periode berjalan: hari ke-0 sampai ke-6.
            readingAt(daysAgo: 0, value: 100),
            readingAt(daysAgo: 1, value: 110),
            readingAt(daysAgo: 2, value: 90),
            // Periode pembanding: hari ke-7 sampai ke-13.
            readingAt(daysAgo: 7, value: 120),
            readingAt(daysAgo: 8, value: 130),
          ],
          recentReadings: const [],
        ),
        now: now,
      );

      expect(summary.fastingAverage.average, 100);
      expect(summary.fastingAverage.previousAverage, 125);
      expect(summary.fastingAverage.count, 3);
      expect(summary.fastingAverage.delta, -25);
    });

    test('hari ke-6 masuk periode berjalan, hari ke-7 tidak', () {
      final summary = build(
        DashboardInput(
          windowReadings: [
            readingAt(daysAgo: 6, value: 100),
            readingAt(daysAgo: 7, value: 200),
          ],
          recentReadings: const [],
        ),
        now: now,
      );

      expect(summary.fastingAverage.count, 1);
      expect(summary.fastingAverage.average, 100);
      expect(summary.fastingAverage.previousAverage, 200);
    });

    test('periode kosong menghasilkan null, bukan nol', () {
      final summary = build(
        const DashboardInput(windowReadings: [], recentReadings: []),
        now: now,
      );

      expect(summary.fastingAverage.average, isNull);
      expect(summary.fastingAverage.hasData, isFalse);
      expect(summary.fastingAverage.roundedAverage, isNull);
    });

    test('delta null bila periode pembanding kosong', () {
      final summary = build(
        DashboardInput(
          windowReadings: [readingAt(daysAgo: 1, value: 100)],
          recentReadings: const [],
        ),
        now: now,
      );

      expect(summary.fastingAverage.average, 100);
      expect(summary.fastingAverage.previousAverage, isNull);
      expect(
        summary.fastingAverage.delta,
        isNull,
        reason: 'tanpa pembanding, menampilkan perubahan akan menyesatkan',
      );
    });

    test('GDP dan GDS dihitung terpisah', () {
      final summary = build(
        DashboardInput(
          windowReadings: [
            readingAt(daysAgo: 1, value: 100),
            readingAt(daysAgo: 1, value: 160, type: ReadingType.random),
            readingAt(daysAgo: 2, value: 180, type: ReadingType.random),
          ],
          recentReadings: const [],
        ),
        now: now,
      );

      expect(summary.fastingAverage.average, 100);
      expect(summary.randomAverage.average, 170);
      expect(summary.fastingAverage.count, 1);
      expect(summary.randomAverage.count, 2);
    });

    test('2 Jam PP tidak ikut ke rata-rata GDP maupun GDS', () {
      final summary = build(
        DashboardInput(
          windowReadings: [
            readingAt(daysAgo: 1, value: 210, type: ReadingType.postprandial2h),
          ],
          recentReadings: const [],
        ),
        now: now,
      );

      expect(summary.fastingAverage.average, isNull);
      expect(summary.randomAverage.average, isNull);
    });

    test(
      'beberapa pembacaan pada hari sama dirata-rata, bukan diambil satu',
      () {
        final summary = build(
          DashboardInput(
            windowReadings: [
              readingAt(daysAgo: 1, value: 140, type: ReadingType.random),
              readingAt(
                daysAgo: 1,
                value: 160,
                type: ReadingType.random,
                hour: 20,
              ),
            ],
            recentReadings: const [],
          ),
          now: now,
        );

        expect(summary.randomAverage.average, 150);
      },
    );
  });

  group('Mini chart 7 hari (PRD F-04 AC3)', () {
    test('selalu berisi 7 titik berurutan yang berakhir hari ini', () {
      final summary = build(
        const DashboardInput(windowReadings: [], recentReadings: []),
        now: now,
      );

      expect(summary.fastingSparkline.length, 7);
      expect(summary.fastingSparkline.first.localDate, '2026-09-21');
      expect(summary.fastingSparkline.last.localDate, '2026-09-27');
    });

    test('hari tanpa data bernilai null agar garis terputus', () {
      final summary = build(
        DashboardInput(
          windowReadings: [readingAt(daysAgo: 0, value: 98)],
          recentReadings: const [],
        ),
        now: now,
      );

      expect(summary.fastingSparkline.last.average, 98);
      expect(summary.fastingSparkline.first.average, isNull);
      expect(summary.fastingSparkline.first.isEmpty, isTrue);
    });

    test(
      'titik harian memakai rata-rata bila satu hari punya beberapa nilai',
      () {
        final summary = build(
          DashboardInput(
            windowReadings: [
              readingAt(daysAgo: 0, value: 100, type: ReadingType.random),
              readingAt(
                daysAgo: 0,
                value: 150,
                type: ReadingType.random,
                hour: 19,
              ),
            ],
            recentReadings: const [],
          ),
          now: now,
        );

        expect(summary.randomSparkline.last.average, 125);
      },
    );

    test('data di luar 7 hari tidak masuk grafik', () {
      final summary = build(
        DashboardInput(
          windowReadings: [readingAt(daysAgo: 10, value: 98)],
          recentReadings: const [],
        ),
        now: now,
      );

      expect(
        summary.fastingSparkline.every((p) => p.isEmpty),
        isTrue,
        reason: 'hari ke-10 berada di periode pembanding, bukan grafik',
      );
    });
  });

  group('Kartu beranda (PRD F-04 AC1)', () {
    test('mengambil GDP hari ini, bukan GDP kemarin', () {
      final summary = build(
        DashboardInput(
          windowReadings: [
            readingAt(daysAgo: 1, value: 97),
            readingAt(daysAgo: 0, value: 98),
          ],
          recentReadings: const [],
        ),
        now: now,
      );

      expect(summary.todayFasting?.valueMgDl, 98);
      expect(summary.today, '2026-09-27');
    });

    test('GDP hari ini null bila belum dicatat', () {
      final summary = build(
        DashboardInput(
          windowReadings: [readingAt(daysAgo: 1, value: 97)],
          recentReadings: const [],
        ),
        now: now,
      );

      expect(summary.todayFasting, isNull);
    });

    test('kartu sewaktu terakhir dipakai apa adanya walau lebih tua dari '
        'jendela 14 hari', () {
      final old = readingAt(daysAgo: 40, value: 156, type: ReadingType.random);
      final summary = build(
        DashboardInput(
          windowReadings: const [],
          recentReadings: const [],
          lastRandom: old,
        ),
        now: now,
      );

      expect(summary.lastRandom?.valueMgDl, 156);
    });

    test('isEmpty hanya benar bila tidak ada catatan sama sekali', () {
      final kosong = build(
        const DashboardInput(windowReadings: [], recentReadings: []),
        now: now,
      );
      expect(kosong.isEmpty, isTrue);

      final adaIsi = build(
        DashboardInput(
          windowReadings: const [],
          recentReadings: [readingAt(daysAgo: 30, value: 98)],
        ),
        now: now,
      );
      expect(adaIsi.isEmpty, isFalse);
    });
  });

  group('Batas hari', () {
    test('pergantian bulan tidak menggeser jendela', () {
      final awalBulan = DateTime(2026, 10, 2, 9);
      final summary = build(
        const DashboardInput(windowReadings: [], recentReadings: []),
        now: awalBulan,
      );

      expect(summary.fastingSparkline.first.localDate, '2026-09-26');
      expect(summary.fastingSparkline.last.localDate, '2026-10-02');
    });

    test('tahun kabisat dihitung benar', () {
      final setelahKabisat = DateTime(2028, 3, 1, 9);
      final summary = build(
        const DashboardInput(windowReadings: [], recentReadings: []),
        now: setelahKabisat,
      );

      expect(
        summary.fastingSparkline.first.localDate,
        '2028-02-24',
        reason: '2028 kabisat, jadi Februari punya 29 hari',
      );
    });
  });
}

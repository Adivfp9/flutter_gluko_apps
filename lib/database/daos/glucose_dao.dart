import 'package:drift/drift.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/database/tables/glucose_readings_table.dart';
import 'package:flutter_gluko_apps/database/tables/reading_symptoms_table.dart';

part 'glucose_dao.g.dart';

/// Satu pembacaan beserta gejalanya.
class ReadingWithSymptoms {
  const new(this.row, this.symptoms);

  final GlucoseReadingRow row;
  final List<String> symptoms;
}

/// Ringkasan agregat satu tipe pengukuran pada satu rentang tanggal.
class TypeAggregate {
  const new({
    required this.type,
    required this.count,
    required this.average,
    required this.min,
    required this.max,
    required this.normalCount,
  });

  final ReadingType type;
  final int count;
  final double average;
  final int min;
  final int max;

  /// Jumlah pembacaan berstatus Normal — pembilang Time in Range (PRD 5.4).
  final int normalCount;

  /// PRD 5.4: TIR = pembacaan Normal ÷ total pembacaan tipe tersebut.
  ///
  /// Mengembalikan `null` bila belum ada data, bukan 0, supaya UI bisa
  /// membedakan "0% dalam target" dari "belum ada data".
  double? get timeInRange => count == 0 ? null : normalCount / count;
}

/// Rata-rata harian satu tipe, untuk mini chart dashboard.
class DailyAverage {
  const new({
    required this.localDate,
    required this.type,
    required this.average,
  });

  final String localDate;
  final ReadingType type;
  final double average;
}

/// Bahan mentah beranda, hasil satu kali pembacaan bersama.
class DashboardRaw {
  const new({required this.window, required this.recent, this.lastRandom});

  /// Pembacaan aktif dalam rentang tanggal yang diminta.
  final List<GlucoseReadingRow> window;

  /// Catatan terakhir, tanpa batas umur.
  final List<ReadingWithSymptoms> recent;

  /// Pembacaan sewaktu terakhir, juga tanpa batas umur.
  final GlucoseReadingRow? lastRandom;
}

/// Status terburuk pada satu hari, untuk titik warna pada tampilan kalender
/// (PRD F-05 AC4).
class DailyWorstStatus {
  const new(this.localDate, this.status);

  final String localDate;
  final GlucoseStatus status;
}

@DriftAccessor(tables: [GlucoseReadingsTable, ReadingSymptomsTable])
class GlucoseDao extends DatabaseAccessor<AppDatabase> with _$GlucoseDaoMixin {
  new(super.attachedDatabase);

  // ----------------------------------------------------------------- baca

  Future<GlucoseReadingRow?> findRowById(int id) => (select(
    glucoseReadingsTable,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<ReadingWithSymptoms?> findById(int id) async {
    final row = await findRowById(id);
    if (row == null) return null;
    final map = await _symptomsOf([row.id]);
    return ReadingWithSymptoms(row, map[row.id] ?? const []);
  }

  Stream<ReadingWithSymptoms?> watchById(int id) {
    final query = select(glucoseReadingsTable)..where((t) => t.id.equals(id));
    return query.watchSingleOrNull().asyncMap((row) async {
      if (row == null) return null;
      final map = await _symptomsOf([row.id]);
      return ReadingWithSymptoms(row, map[row.id] ?? const []);
    });
  }

  /// PRD 5.5: mencari GDP yang sudah tercatat pada satu tanggal lokal.
  ///
  /// Hanya melihat baris yang belum di-soft delete, sama persis dengan kondisi
  /// indeks unik `ux_fasting_per_day`.
  Future<GlucoseReadingRow?> fastingOn(String localDate) =>
      (select(glucoseReadingsTable)..where(
            (t) =>
                t.readingType.equals(ReadingType.fasting.dbValue) &
                t.localDate.equals(localDate) &
                t.deletedAt.isNull(),
          ))
          .getSingleOrNull();

  Stream<GlucoseReadingRow?> watchFastingOn(String localDate) =>
      (select(glucoseReadingsTable)..where(
            (t) =>
                t.readingType.equals(ReadingType.fasting.dbValue) &
                t.localDate.equals(localDate) &
                t.deletedAt.isNull(),
          ))
          .watchSingleOrNull();

  /// Pembacaan terakhir untuk satu tipe.
  Stream<GlucoseReadingRow?> watchLatestOfType(ReadingType type) =>
      (select(glucoseReadingsTable)
            ..where(
              (t) => t.readingType.equals(type.dbValue) & t.deletedAt.isNull(),
            )
            ..orderBy([
              (t) => OrderingTerm(
                expression: t.measuredAt,
                mode: OrderingMode.desc,
              ),
            ])
            ..limit(1))
          .watchSingleOrNull();

  /// Daftar terbaru, dipakai kartu "Catatan terakhir" di beranda.
  Stream<List<ReadingWithSymptoms>> watchLatest({int limit = 5}) {
    final query = select(glucoseReadingsTable)
      ..where((t) => t.deletedAt.isNull())
      ..orderBy([
        (t) => OrderingTerm(expression: t.measuredAt, mode: OrderingMode.desc),
      ])
      ..limit(limit);
    return query.watch().asyncMap(_attachSymptoms);
  }

  /// Riwayat berpaginasi dengan filter (PRD F-05 AC1 & AC2).
  Stream<List<ReadingWithSymptoms>> watchHistory({
    ReadingType? type,
    GlucoseStatus? status,
    String? fromLocalDate,
    String? toLocalDate,
    int limit = 30,
    int offset = 0,
  }) {
    final query = select(glucoseReadingsTable)
      ..where((t) {
        var predicate = t.deletedAt.isNull();
        if (type != null) {
          predicate = predicate & t.readingType.equals(type.dbValue);
        }
        if (status != null) {
          predicate = predicate & t.status.equals(status.dbValue);
        }
        if (fromLocalDate != null) {
          predicate =
              predicate & t.localDate.isBiggerOrEqualValue(fromLocalDate);
        }
        if (toLocalDate != null) {
          predicate =
              predicate & t.localDate.isSmallerOrEqualValue(toLocalDate);
        }
        return predicate;
      })
      ..orderBy([
        (t) => OrderingTerm(expression: t.measuredAt, mode: OrderingMode.desc),
      ])
      ..limit(limit, offset: offset);

    return query.watch().asyncMap(_attachSymptoms);
  }

  /// Seluruh pembacaan pada rentang tanggal lokal, untuk grafik tren.
  ///
  /// Mengembalikan pembacaan individual (bukan rata-rata harian) supaya tap
  /// pada titik bisa menampilkan nilai, tanggal, dan jam aslinya
  /// (PRD F-06 AC3).
  Future<List<GlucoseReadingRow>> readingsBetween({
    required String fromLocalDate,
    required String toLocalDate,
    ReadingType? type,
  }) {
    final query = select(glucoseReadingsTable)
      ..where((t) {
        var predicate =
            t.deletedAt.isNull() &
            t.localDate.isBiggerOrEqualValue(fromLocalDate) &
            t.localDate.isSmallerOrEqualValue(toLocalDate);
        if (type != null) {
          predicate = predicate & t.readingType.equals(type.dbValue);
        }
        return predicate;
      })
      ..orderBy([(t) => OrderingTerm(expression: t.measuredAt)]);
    return query.get();
  }

  Stream<List<GlucoseReadingRow>> watchReadingsBetween({
    required String fromLocalDate,
    required String toLocalDate,
  }) {
    final query = select(glucoseReadingsTable)
      ..where(
        (t) =>
            t.deletedAt.isNull() &
            t.localDate.isBiggerOrEqualValue(fromLocalDate) &
            t.localDate.isSmallerOrEqualValue(toLocalDate),
      )
      ..orderBy([(t) => OrderingTerm(expression: t.measuredAt)]);
    return query.watch();
  }

  // -------------------------------------------------------------- agregat

  /// Statistik per tipe pada satu rentang tanggal lokal (PRD F-06 AC4).
  Future<List<TypeAggregate>> aggregateByType({
    required String fromLocalDate,
    required String toLocalDate,
  }) async {
    final rows = await customSelect(
      'SELECT reading_type, '
      'COUNT(*) AS cnt, '
      'AVG(value_mg_dl) AS avg_value, '
      'MIN(value_mg_dl) AS min_value, '
      'MAX(value_mg_dl) AS max_value, '
      "SUM(CASE WHEN status = 'normal' THEN 1 ELSE 0 END) AS normal_cnt "
      'FROM glucose_readings '
      'WHERE deleted_at IS NULL AND local_date >= ?1 AND local_date <= ?2 '
      'GROUP BY reading_type',
      variables: [
        Variable<String>(fromLocalDate),
        Variable<String>(toLocalDate),
      ],
      readsFrom: {glucoseReadingsTable},
    ).get();

    return rows
        .map(
          (r) => TypeAggregate(
            type: ReadingType.fromDb(r.read<String>('reading_type')),
            count: r.read<int>('cnt'),
            average: r.read<double>('avg_value'),
            min: r.read<int>('min_value'),
            max: r.read<int>('max_value'),
            normalCount: r.read<int>('normal_cnt'),
          ),
        )
        .toList();
  }

  /// Rata-rata per hari per tipe, untuk mini chart 7 hari di beranda.
  Future<List<DailyAverage>> dailyAverages({
    required String fromLocalDate,
    required String toLocalDate,
  }) async {
    final rows = await customSelect(
      'SELECT local_date, reading_type, AVG(value_mg_dl) AS avg_value '
      'FROM glucose_readings '
      'WHERE deleted_at IS NULL AND local_date >= ?1 AND local_date <= ?2 '
      'GROUP BY local_date, reading_type '
      'ORDER BY local_date',
      variables: [
        Variable<String>(fromLocalDate),
        Variable<String>(toLocalDate),
      ],
      readsFrom: {glucoseReadingsTable},
    ).get();

    return rows
        .map(
          (r) => DailyAverage(
            localDate: r.read<String>('local_date'),
            type: ReadingType.fromDb(r.read<String>('reading_type')),
            average: r.read<double>('avg_value'),
          ),
        )
        .toList();
  }

  /// Status terburuk per hari, untuk titik warna pada kalender.
  ///
  /// Urutan keparahan ditulis eksplisit di SQL: tinggi > rendah > waspada >
  /// normal. Rendah diletakkan di atas waspada karena hipoglikemia perlu
  /// tindakan lebih cepat daripada nilai yang sedikit di atas target.
  Future<List<DailyWorstStatus>> worstStatusPerDay({
    required String fromLocalDate,
    required String toLocalDate,
  }) async {
    final rows = await customSelect(
      'SELECT local_date, MAX(CASE status '
      "WHEN 'high' THEN 4 "
      "WHEN 'low' THEN 3 "
      "WHEN 'warning' THEN 2 "
      'ELSE 1 END) AS severity '
      'FROM glucose_readings '
      'WHERE deleted_at IS NULL AND local_date >= ?1 AND local_date <= ?2 '
      'GROUP BY local_date',
      variables: [
        Variable<String>(fromLocalDate),
        Variable<String>(toLocalDate),
      ],
      readsFrom: {glucoseReadingsTable},
    ).get();

    return rows.map((r) {
      final status = switch (r.read<int>('severity')) {
        4 => GlucoseStatus.high,
        3 => GlucoseStatus.low,
        2 => GlucoseStatus.warning,
        _ => GlucoseStatus.normal,
      };
      return DailyWorstStatus(r.read<String>('local_date'), status);
    }).toList();
  }

  Future<int> countActive() async {
    final row = await customSelect(
      'SELECT COUNT(*) AS c FROM glucose_readings WHERE deleted_at IS NULL',
      readsFrom: {glucoseReadingsTable},
    ).getSingle();
    return row.read<int>('c');
  }

  Future<List<ReadingWithSymptoms>> allActive() async {
    final rows =
        await (select(glucoseReadingsTable)
              ..where((t) => t.deletedAt.isNull())
              ..orderBy([(t) => OrderingTerm(expression: t.measuredAt)]))
            .get();
    return await _attachSymptoms(rows);
  }

  /// Seluruh bahan beranda dalam **satu** langganan (PRD 7.4 langkah 5).
  ///
  /// Beranda butuh empat potong data dengan bentuk berbeda. Melanggankan empat
  /// stream terpisah akan membuat kartu-kartunya ter-update pada frame yang
  /// berlainan dan sempat tampil tidak konsisten. Di sini yang dilanggan hanya
  /// perubahan tabel, lalu seluruh potongan dibaca ulang bersama-sama.
  Stream<DashboardRaw> watchDashboard({
    required String fromLocalDate,
    required String toLocalDate,
    int recentLimit = 5,
  }) async* {
    Future<DashboardRaw> load() async {
      final window = await readingsBetween(
        fromLocalDate: fromLocalDate,
        toLocalDate: toLocalDate,
      );
      final recent =
          await (select(glucoseReadingsTable)
                ..where((t) => t.deletedAt.isNull())
                ..orderBy([
                  (t) => OrderingTerm(
                    expression: t.measuredAt,
                    mode: OrderingMode.desc,
                  ),
                ])
                ..limit(recentLimit))
              .get();
      final lastRandom =
          await (select(glucoseReadingsTable)
                ..where(
                  (t) =>
                      t.readingType.equals(ReadingType.random.dbValue) &
                      t.deletedAt.isNull(),
                )
                ..orderBy([
                  (t) => OrderingTerm(
                    expression: t.measuredAt,
                    mode: OrderingMode.desc,
                  ),
                ])
                ..limit(1))
              .getSingleOrNull();

      return DashboardRaw(
        window: window,
        recent: await _attachSymptoms(recent),
        lastRandom: lastRandom,
      );
    }

    yield await load();

    await for (final _ in attachedDatabase.tableUpdates(
      TableUpdateQuery.onTable(glucoseReadingsTable),
    )) {
      yield await load();
    }
  }

  // ----------------------------------------------------------------- tulis

  /// Menyimpan pembacaan beserta gejalanya dalam satu transaksi.
  ///
  /// NFR-07 menuntut transaksi atomik: pembacaan tanpa gejalanya, atau gejala
  /// yatim tanpa pembacaan, sama-sama tidak boleh terjadi.
  Future<int> insertReading(
    GlucoseReadingsTableCompanion reading,
    List<String> symptoms,
  ) {
    return transaction(() async {
      final id = await into(glucoseReadingsTable).insert(reading);
      await _writeSymptoms(id, symptoms);
      return id;
    });
  }

  Future<void> updateReading(
    int id,
    GlucoseReadingsTableCompanion reading,
    List<String> symptoms,
  ) {
    return transaction(() async {
      await (update(
        glucoseReadingsTable,
      )..where((t) => t.id.equals(id))).write(reading);
      await (delete(
        readingSymptomsTable,
      )..where((t) => t.readingId.equals(id))).go();
      await _writeSymptoms(id, symptoms);
    });
  }

  /// PRD F-05 AC3 dan 5.5: hapus bersifat soft delete agar Undo aman.
  Future<void> softDelete(int id, DateTime at) =>
      (update(glucoseReadingsTable)..where((t) => t.id.equals(id))).write(
        GlucoseReadingsTableCompanion(
          deletedAt: Value(at.millisecondsSinceEpoch),
          updatedAt: Value(at.millisecondsSinceEpoch),
        ),
      );

  /// Membatalkan soft delete (tombol Undo 5 detik).
  ///
  /// Bisa gagal karena indeks unik bila pengguna sempat mencatat GDP baru pada
  /// tanggal yang sama sebelum menekan Undo. Pemanggil wajib menangani kasus
  /// itu, bukan menelannya diam-diam.
  Future<void> restore(int id) =>
      (update(glucoseReadingsTable)..where((t) => t.id.equals(id))).write(
        const GlucoseReadingsTableCompanion(deletedAt: Value(null)),
      );

  Future<void> hardDelete(int id) =>
      (delete(glucoseReadingsTable)..where((t) => t.id.equals(id))).go();

  Future<void> updateClassifications(
    List<({int id, String status, bool isCritical, int updatedAt})> updates,
  ) => transaction(() async {
    for (final value in updates) {
      await (update(
        glucoseReadingsTable,
      )..where((t) => t.id.equals(value.id))).write(
        GlucoseReadingsTableCompanion(
          status: Value(value.status),
          isCritical: Value(value.isCritical),
          updatedAt: Value(value.updatedAt),
        ),
      );
    }
  });

  // ---------------------------------------------------------------- privat

  Future<void> _writeSymptoms(int readingId, List<String> symptoms) async {
    if (symptoms.isEmpty) return;
    await batch((b) {
      b.insertAll(readingSymptomsTable, [
        for (final s in symptoms.toSet())
          ReadingSymptomsTableCompanion.insert(
            readingId: readingId,
            symptom: s,
          ),
      ]);
    });
  }

  Future<Map<int, List<String>>> _symptomsOf(List<int> readingIds) async {
    if (readingIds.isEmpty) return {};
    final rows = await (select(
      readingSymptomsTable,
    )..where((t) => t.readingId.isIn(readingIds))).get();

    final map = <int, List<String>>{};
    for (final row in rows) {
      map.putIfAbsent(row.readingId, () => []).add(row.symptom);
    }
    return map;
  }

  Future<List<ReadingWithSymptoms>> _attachSymptoms(
    List<GlucoseReadingRow> rows,
  ) async {
    if (rows.isEmpty) return const [];
    final map = await _symptomsOf([for (final r in rows) r.id]);
    return [
      for (final row in rows) ReadingWithSymptoms(row, map[row.id] ?? const []),
    ];
  }
}

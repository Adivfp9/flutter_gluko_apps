import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/features/glucose/data/repositories/glucose_repository_impl.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/add_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/classify_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/reclassify_readings.dart';
import 'package:flutter_gluko_apps/features/target/data/repositories/target_repository_impl.dart';
import 'package:flutter_gluko_apps/features/target/domain/entities/target_set.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = createTestDatabase());
  tearDown(() => db.close());

  test(
    'menghitung ulang snapshot status memakai target yang dipilih',
    () async {
      final readings = GlucoseRepositoryImpl(db.glucoseDao);
      final targets = TargetRepositoryImpl(db.targetDao);
      final now = DateTime.utc(2026, 9, 27, 6);
      final saved =
          await AddReading.withClock(
            readings,
            targets,
            const ClassifyReading(),
            () => now,
          )(
            AddReadingParams(
              type: ReadingType.fasting,
              valueMgDl: 120,
              measuredAt: now,
            ),
          );
      final id = saved.getRight().toNullable()!.id!;
      expect((await db.glucoseDao.findRowById(id))!.status, 'warning');

      final diabetes = TargetSet.fromPreset(TargetPreset.diabetes);
      final result = await ReclassifyReadings(
        readings,
        const ClassifyReading(),
      )(diabetes);

      expect(result.getRight().toNullable(), 1);
      expect((await db.glucoseDao.findRowById(id))!.status, 'normal');
    },
  );
}

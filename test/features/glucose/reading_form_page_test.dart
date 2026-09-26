import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gluko_apps/core/theme/app_theme.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/features/glucose/data/repositories/glucose_repository_impl.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/add_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/classify_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/find_fasting_on.dart';
import 'package:flutter_gluko_apps/features/glucose/presentation/cubit/reading_form_cubit.dart';
import 'package:flutter_gluko_apps/features/glucose/presentation/pages/reading_form_page.dart';
import 'package:flutter_gluko_apps/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_gluko_apps/features/profile/domain/usecases/get_profile.dart';
import 'package:flutter_gluko_apps/features/target/data/repositories/target_repository_impl.dart';
import 'package:flutter_gluko_apps/features/target/domain/usecases/get_targets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late ReadingFormCubit cubit;

  setUp(() {
    db = createTestDatabase();
    final readings = GlucoseRepositoryImpl(db.glucoseDao);
    final targets = TargetRepositoryImpl(db.targetDao);
    final profiles = ProfileRepositoryImpl(db.profileDao);
    final now = DateTime(2026, 9, 27, 6, 15);
    cubit = ReadingFormCubit.withClock(
      AddReading.withClock(
        readings,
        targets,
        const ClassifyReading(),
        () => now,
      ),
      GetTargets(targets),
      GetProfile(profiles),
      FindFastingOn(readings),
      const ClassifyReading(),
      () => now,
    );
  });

  tearDown(() async {
    await cubit.close();
    await db.close();
  });

  Future<void> pumpForm(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: BlocProvider.value(value: cubit, child: const ReadingFormView()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('menampilkan form lengkap dan klasifikasi live', (tester) async {
    await pumpForm(tester);

    expect(find.text('Catat Gula Darah'), findsOneWidget);
    for (final label in ['Puasa', 'Sewaktu', '2 Jam PP']) {
      expect(find.text(label), findsWidgets);
    }
    expect(find.text('Sudah puasa minimal 8 jam'), findsOneWidget);

    await tester.tap(find.byKey(const Key('keypad-1')));
    await tester.tap(find.byKey(const Key('keypad-1')));
    await tester.tap(find.byKey(const Key('keypad-2')));
    await tester.pump();

    expect(find.text('112'), findsOneWidget);
    expect(find.textContaining('Waspada'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Simpan'), findsOneWidget);
  });

  testWidgets('menyimpan nilai dan menampilkan hasil', (tester) async {
    await pumpForm(tester);

    for (final digit in ['1', '1', '2']) {
      await tester.tap(find.byKey(Key('keypad-$digit')));
    }
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Tersimpan'), findsOneWidget);
    expect(find.text('112 mg/dL'), findsOneWidget);
    expect(find.textContaining('Waspada'), findsOneWidget);
    expect(find.text('Selesai'), findsOneWidget);
  });
}

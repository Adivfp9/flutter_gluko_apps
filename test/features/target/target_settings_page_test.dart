import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/theme/app_theme.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/features/glucose/data/repositories/glucose_repository_impl.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/classify_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/reclassify_readings.dart';
import 'package:flutter_gluko_apps/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_gluko_apps/features/profile/domain/usecases/get_profile.dart';
import 'package:flutter_gluko_apps/features/target/data/repositories/target_repository_impl.dart';
import 'package:flutter_gluko_apps/features/target/domain/usecases/get_targets.dart';
import 'package:flutter_gluko_apps/features/target/domain/usecases/reset_targets.dart';
import 'package:flutter_gluko_apps/features/target/domain/usecases/save_targets.dart';
import 'package:flutter_gluko_apps/features/target/presentation/cubit/target_settings_cubit.dart';
import 'package:flutter_gluko_apps/features/target/presentation/pages/target_settings_page.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TargetSettingsCubit cubit;

  setUp(() {
    db = createTestDatabase();
    final targets = TargetRepositoryImpl(db.targetDao);
    final profiles = ProfileRepositoryImpl(db.profileDao);
    final saveTargets = SaveTargets(targets, profiles);
    cubit = TargetSettingsCubit(
      GetTargets(targets),
      saveTargets,
      ResetTargets(saveTargets),
      GetProfile(profiles),
      ReclassifyReadings(
        GlucoseRepositoryImpl(db.glucoseDao),
        const ClassifyReading(),
      ),
    );
  });

  tearDown(() async {
    await cubit.close();
    await db.close();
  });

  Future<void> pumpTargetPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: BlocProvider.value(
          value: cubit,
          child: const TargetSettingsView(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('mengubah preset dan menyimpan target', (tester) async {
    await pumpTargetPage(tester);

    expect(find.text('Target Gula Darah'), findsOneWidget);
    expect(find.text('Puasa (GDP)'), findsOneWidget);
    expect(find.text('Sewaktu (GDS)'), findsOneWidget);
    expect(find.text('2 Jam Setelah Makan'), findsOneWidget);

    await tester.tap(find.text('Diabetes'));
    await tester.pump();

    final normalField = tester.widget<TextFormField>(
      find.descendant(
        of: find.byKey(const Key('target-fasting-normal')),
        matching: find.byType(TextFormField),
      ),
    );
    expect(normalField.controller!.text, '130');

    await tester.tap(find.widgetWithText(FilledButton, 'Simpan target'));
    await tester.pumpAndSettle();

    expect(find.text('Target dan satuan berhasil disimpan.'), findsOneWidget);
  });

  testWidgets('menjaga teks desimal mmol selama pengguna mengetik', (
    tester,
  ) async {
    await pumpTargetPage(tester);
    cubit.setUnit(GlucoseUnit.mmolL);
    await tester.pump();

    final field = find.descendant(
      of: find.byKey(const Key('target-fasting-low')),
      matching: find.byType(TextFormField),
    );
    await tester.enterText(field, '4');
    await tester.pump();
    expect(tester.widget<TextFormField>(field).controller!.text, '4');

    await tester.enterText(field, '');
    await tester.pump();
    expect(tester.widget<TextFormField>(field).controller!.text, isEmpty);
    expect(find.textContaining('wajib diisi'), findsOneWidget);
  });
}

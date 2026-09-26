import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/router/app_router.dart';
import 'package:flutter_gluko_apps/core/theme/app_theme.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/features/glucose/data/repositories/glucose_repository_impl.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/add_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/classify_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/find_fasting_on.dart';
import 'package:flutter_gluko_apps/features/glucose/presentation/cubit/reading_form_cubit.dart';
import 'package:flutter_gluko_apps/features/glucose/presentation/pages/reading_form_page.dart';
import 'package:flutter_gluko_apps/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_gluko_apps/features/profile/domain/entities/user_profile.dart';
import 'package:flutter_gluko_apps/features/profile/domain/usecases/get_profile.dart';
import 'package:flutter_gluko_apps/features/target/data/repositories/target_repository_impl.dart';
import 'package:flutter_gluko_apps/features/target/domain/usecases/get_targets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late ReadingFormCubit cubit;
  late GlucoseRepositoryImpl readings;
  late TargetRepositoryImpl targets;
  late ProfileRepositoryImpl profiles;
  final now = DateTime(2026, 9, 27, 6, 15);

  setUp(() {
    db = createTestDatabase();
    readings = GlucoseRepositoryImpl(db.glucoseDao);
    targets = TargetRepositoryImpl(db.targetDao);
    profiles = ProfileRepositoryImpl(db.profileDao);
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

  Future<void> pumpForm(WidgetTester tester, {ReadingType? initialType}) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: BlocProvider.value(
          value: cubit,
          child: ReadingFormView(initialType: initialType),
        ),
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

  testWidgets('menampilkan validasi rentang tanpa mengaktifkan tombol simpan', (
    tester,
  ) async {
    await pumpForm(tester);
    await tester.tap(find.byKey(const Key('keypad-1')));
    await tester.tap(find.byKey(const Key('keypad-0')));
    await tester.pump();

    expect(find.textContaining('20 dan 600'), findsOneWidget);
    final save = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Simpan'),
    );
    expect(save.onPressed, isNull);
  });

  testWidgets('hasil dan dialog duplikat mengikuti satuan global', (
    tester,
  ) async {
    await profiles.saveProfile(
      const UserProfile(unit: GlucoseUnit.mmolL, onboardingDone: true),
    );
    final seed =
        await AddReading.withClock(
          readings,
          targets,
          const ClassifyReading(),
          () => now,
        )(
          AddReadingParams(
            type: ReadingType.fasting,
            valueMgDl: 98,
            measuredAt: now,
          ),
        );
    expect(seed.isRight(), isTrue);
    await pumpForm(tester, initialType: ReadingType.fasting);

    cubit.setValue('6,2');
    await tester.pump();
    expect(cubit.state.type, ReadingType.fasting);
    expect(cubit.state.canSubmit, isTrue);
    await cubit.submit();
    await tester.pumpAndSettle();
    expect(cubit.state.duplicateFasting, isNotNull);
    expect(find.text('GDP hari ini sudah ada'), findsOneWidget);
    expect(find.textContaining('5,4 mmol/L'), findsOneWidget);

    await tester.tap(find.text('Jadikan Sewaktu'));
    await tester.pumpAndSettle();
    expect(find.text('6,2 mmol/L'), findsOneWidget);
  });

  testWidgets('route catat langsung kembali ke dashboard saat ditutup', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/catat',
      routes: [
        GoRoute(
          path: '/catat',
          builder: (_, _) =>
              BlocProvider.value(value: cubit, child: const ReadingFormView()),
        ),
        GoRoute(
          path: '/beranda',
          name: AppRoute.dashboard,
          builder: (_, _) => const Scaffold(body: Text('Dashboard test')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Tutup'));
    await tester.pumpAndSettle();
    expect(find.text('Dashboard test'), findsOneWidget);
  });

  testWidgets('hasil tersimpan selalu selesai ke dashboard', (tester) async {
    final router = GoRouter(
      initialLocation: '/catat',
      routes: [
        GoRoute(
          path: '/catat',
          builder: (_, _) => BlocProvider.value(
            value: cubit,
            child: const ReadingFormView(initialType: ReadingType.random),
          ),
        ),
        GoRoute(
          path: '/beranda',
          name: AppRoute.dashboard,
          builder: (_, _) => const Scaffold(body: Text('Dashboard test')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    );
    await tester.pumpAndSettle();
    cubit.setValue('112');
    await cubit.submit();
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Selesai'));
    await tester.pumpAndSettle();
    expect(find.text('Dashboard test'), findsOneWidget);
  });
}

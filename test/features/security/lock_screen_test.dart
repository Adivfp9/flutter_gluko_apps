import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/app.dart';
import 'package:flutter_gluko_apps/core/router/app_router.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/features/glucose/data/repositories/glucose_repository_impl.dart';
import 'package:flutter_gluko_apps/features/reminder/data/repositories/reminder_repository_impl.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/usecases/plan_reminder_schedule.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/usecases/reminder_sync.dart';
import 'package:flutter_gluko_apps/features/security/data/repositories/security_repository_impl.dart';
import 'package:flutter_gluko_apps/features/security/domain/services/pin_hasher.dart';
import 'package:flutter_gluko_apps/features/security/domain/usecases/reset_app_data.dart';
import 'package:flutter_gluko_apps/features/security/presentation/cubit/app_lock_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_di.dart';
import 'security_fakes.dart';

void main() {
  late AppDatabase db;
  late SecurityRepositoryImpl repository;
  late AppLockCubit cubit;

  setUp(() {
    db = configureTestDependencies();
    final scheduler = RecordingScheduler();
    repository = SecurityRepositoryImpl(
      db.settingsDao,
      FakeSecretStore(),
      PinHasher.withIterations(1000),
    );
    cubit = AppLockCubit(
      repository,
      FakeBiometric()..available = false,
      FakeSecureScreen(),
      ResetAppData(
        db,
        repository,
        ReminderSync(
          ReminderRepositoryImpl(db.reminderDao),
          GlucoseRepositoryImpl(db.glucoseDao),
          scheduler,
          const PlanReminderSchedule(),
        ),
        scheduler,
      ),
    );
  });

  tearDown(() async {
    await cubit.close();
    await resetTestDependencies();
    await db.close();
  });

  Future<void> pumpLockedApp(WidgetTester tester) async {
    await tester.runAsync(() async {
      await repository.enableLock('123456');
      await cubit.initialize();
    });
    await tester.pumpWidget(
      GlukoTrackApp(
        router: createRouter(initialLocation: '/beranda'),
        appLock: cubit,
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Melepas pohon widget di dalam test agar timer pembatalan stream drift
  /// sempat jalan (lihat widget_test.dart).
  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pump(const Duration(milliseconds: 1));
  }

  testWidgets('layar kunci menutupi beranda sampai PIN benar', (tester) async {
    await pumpLockedApp(tester);

    expect(find.text('Masukkan PIN'), findsOneWidget);
    expect(find.text('Lupa PIN?'), findsOneWidget);

    await tester.runAsync(() => cubit.submitPin('123456'));
    await tester.pumpAndSettle();

    expect(find.text('Masukkan PIN'), findsNothing);
    expect(find.text('Belum ada catatan'), findsOneWidget);

    await unmount(tester);
  });

  testWidgets('PIN salah menampilkan pesan dan tetap terkunci', (tester) async {
    await pumpLockedApp(tester);

    await tester.runAsync(() => cubit.submitPin('000000'));
    await tester.pumpAndSettle();

    expect(find.textContaining('PIN salah'), findsOneWidget);
    expect(find.text('Masukkan PIN'), findsOneWidget);

    await unmount(tester);
  });

  testWidgets('dialog Lupa PIN butuh konfirmasi HAPUS', (tester) async {
    await pumpLockedApp(tester);

    await tester.tap(find.text('Lupa PIN?'));
    await tester.pumpAndSettle();

    final deleteButton = find.widgetWithText(FilledButton, 'Hapus semua data');
    expect(tester.widget<FilledButton>(deleteButton).onPressed, isNull);

    await tester.enterText(find.byType(TextField), 'hapus');
    await tester.pump();
    expect(tester.widget<FilledButton>(deleteButton).onPressed, isNotNull);

    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();
    expect(find.text('Masukkan PIN'), findsOneWidget);

    await unmount(tester);
  });
}

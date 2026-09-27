import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/app.dart';
import 'package:flutter_gluko_apps/core/di/injection.config.dart';
import 'package:flutter_gluko_apps/core/di/injection.dart';
import 'package:flutter_gluko_apps/core/router/app_router.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/features/backup/domain/backup_codec.dart';
import 'package:flutter_gluko_apps/features/backup/domain/backup_service.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/services/notification_scheduler.dart';
import 'package:flutter_gluko_apps/features/security/domain/services/pin_hasher.dart';
import 'package:flutter_gluko_apps/features/security/domain/services/security_services.dart';
import 'package:flutter_gluko_apps/features/security/presentation/cubit/app_lock_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../features/security/security_fakes.dart';
import 'test_database.dart';

/// File backup "di luar aplikasi" untuk test: yang dibagikan disimpan,
/// yang dipilih diambil dari [nextPick].
class FakeBackupFiles implements BackupFileGateway {
  Uint8List? lastShared;
  String? lastFileName;
  Uint8List? nextPick;

  @override
  Future<bool> share(Uint8List bytes, String fileName) async {
    lastShared = bytes;
    lastFileName = fileName;
    return true;
  }

  @override
  Future<bool> saveAs(Uint8List bytes, String fileName) =>
      share(bytes, fileName);

  @override
  Future<Uint8List?> pick() async => nextPick;
}

/// Seluruh pengganti platform yang dipakai harness.
class AppHarness {
  new _(this.db);

  final AppDatabase db;
  final FakeSecretStore secrets = FakeSecretStore();
  final FakeBiometric biometric = FakeBiometric()..available = false;
  final FakeSecureScreen secureScreen = FakeSecureScreen();
  final RecordingScheduler scheduler = RecordingScheduler();
  final FakeBackupFiles files = FakeBackupFiles();

  /// DI produksi (hasil injectable) dengan bagian yang menyentuh platform
  /// diganti: database in-memory, Keystore, biometrik, FLAG_SECURE,
  /// notifikasi, dan file. Wiring use case, repository, dan cubit asli.
  static AppHarness setUp() {
    final harness = AppHarness._(createTestDatabase());
    getIt
      ..init()
      ..allowReassignment = true
      ..registerSingleton<AppDatabase>(harness.db)
      ..registerSingleton<SecretStore>(harness.secrets)
      ..registerSingleton<BiometricAuthenticator>(harness.biometric)
      ..registerSingleton<SecureScreen>(harness.secureScreen)
      ..registerSingleton<NotificationScheduler>(harness.scheduler)
      ..registerSingleton<BackupFileGateway>(harness.files)
      // KDF produksi (100k/200k iterasi) terlalu lambat untuk suite test.
      ..registerSingleton<PinHasher>(PinHasher.withIterations(1000))
      ..registerSingleton<BackupCodec>(BackupCodec.withIterations(1000))
      ..allowReassignment = false;
    return harness;
  }

  Future<void> tearDown() async {
    await getIt.reset();
    await db.close();
  }

  /// Menandai onboarding selesai agar beranda bisa dibuka langsung.
  Future<void> completeOnboarding() => db.profileDao.save(
    const UserProfileTableCompanion(
      onboardingDone: Value(true),
      createdAt: Value(0),
      updatedAt: Value(0),
    ),
  );

  /// Membaca setelan kunci seperti `main()`; wajib sebelum `app(withLock:)`
  /// agar overlay "checking" tidak menutupi layar.
  Future<void> initLock() => getIt<AppLockCubit>().initialize();

  Widget app({String initialLocation = '/beranda', bool withLock = false}) =>
      GlukoTrackApp(
        router: createRouter(initialLocation: initialLocation),
        appLock: withLock ? getIt<AppLockCubit>() : null,
      );
}

/// Melepas pohon widget di dalam test agar timer pembatalan stream drift
/// sempat berjalan sebelum test selesai.
Future<void> unmountApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 1));
  await tester.pump(const Duration(milliseconds: 1));
}

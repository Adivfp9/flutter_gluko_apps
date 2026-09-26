import 'package:flutter_gluko_apps/core/di/injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final GetIt getIt = GetIt.instance;

/// Registrasi seluruh dependensi.
///
/// Dipanggil sekali dari `main()` sebelum `runApp`. Implementasi konkret
/// didaftarkan lewat anotasi `@injectable`/`@LazySingleton` di masing-masing
/// layer, lalu dikumpulkan oleh injectable_generator ke `injection.config.dart`.
@injectableInit
Future<void> configureDependencies() async => getIt.init();

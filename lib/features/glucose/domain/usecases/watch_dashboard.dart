import 'package:flutter_gluko_apps/core/usecase/usecase.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/dashboard_summary.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/repositories/glucose_repository.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/build_dashboard_summary.dart';
import 'package:injectable/injectable.dart';

/// Isi beranda yang selalu mengikuti perubahan data (PRD F-04).
///
/// Jendela tanggal ditetapkan sekali saat berlangganan. Bila aplikasi dibiarkan
/// terbuka melewati tengah malam, jendelanya jadi tertinggal satu hari — karena
/// itu cubit berlangganan ulang ketika aplikasi kembali dari background.
@injectable
class WatchDashboard implements StreamUseCase<DashboardSummary, DateTime> {
  const new(this._repository, this._build);

  final GlucoseRepository _repository;
  final BuildDashboardSummary _build;

  @override
  Stream<DashboardSummary> call(DateTime params) => _repository
      .watchDashboard(now: params)
      .map((input) => _build(input, now: params));
}

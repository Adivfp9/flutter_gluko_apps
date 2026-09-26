import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/dashboard_summary.dart';
import 'package:meta/meta.dart';

/// State beranda (S-03).
@immutable
class DashboardState {
  const new({
    this.summary,
    this.unit = GlucoseUnit.mgDl,
    this.userName,
    this.isLoading = true,
    this.errorMessage,
  });

  final DashboardSummary? summary;

  /// Satuan tampilan; data tetap tersimpan dalam mg/dL (PRD 5.3).
  final GlucoseUnit unit;

  final String? userName;
  final bool isLoading;
  final String? errorMessage;

  DashboardState copyWith({
    DashboardSummary? summary,
    GlucoseUnit? unit,
    String? userName,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) => DashboardState(
    summary: summary ?? this.summary,
    unit: unit ?? this.unit,
    userName: userName ?? this.userName,
    isLoading: isLoading ?? this.isLoading,
    errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
  );

  @override
  bool operator ==(Object other) =>
      other is DashboardState &&
      identical(other.summary, summary) &&
      other.unit == unit &&
      other.userName == userName &&
      other.isLoading == isLoading &&
      other.errorMessage == errorMessage;

  @override
  int get hashCode =>
      Object.hash(summary, unit, userName, isLoading, errorMessage);
}

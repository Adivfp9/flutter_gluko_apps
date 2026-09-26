// Design tokens GlukoTrack — diturunkan dari preview UI & PRD bagian 6.2
import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF0E7C86);
  static const primaryDark = Color(0xFF0B5F66);
  static const primarySoft = Color(0xFFDDF1F2);
  static const background = Color(0xFFF5F7F8);
  static const surface = Color(0xFFFFFFFF);
  static const border = Color(0xFFE8EDF0);
  static const divider = Color(0xFFEEF1F3);
  static const inputBorder = Color(0xFFD5DCE0);
  static const textPrimary = Color(0xFF1F2933);
  static const textSecondary = Color(0xFF5B6770);
  static const gdsSeries = Color(0xFF3D5A80);
}

enum GlucoseStatus { low, normal, warning, high }

class StatusStyle {
  const StatusStyle(this.bg, this.fg, this.label, this.glyph, this.solid);
  final Color bg, fg, solid;
  final String label, glyph;

  static const map = {
    GlucoseStatus.low: StatusStyle(Color(0xFFEDE9FE), Color(0xFF5B21B6), 'Rendah', '↓', Color(0xFF7C3AED)),
    GlucoseStatus.normal: StatusStyle(Color(0xFFDCFCE7), Color(0xFF166534), 'Normal', '✓', Color(0xFF16A34A)),
    GlucoseStatus.warning: StatusStyle(Color(0xFFFEF3C7), Color(0xFF92400E), 'Waspada', '!', Color(0xFFD97706)),
    GlucoseStatus.high: StatusStyle(Color(0xFFFEE2E2), Color(0xFF991B1B), 'Tinggi', '↑', Color(0xFFDC2626)),
  };
}

class AppRadius {
  static const card = 16.0, button = 14.0, chip = 18.0, key = 12.0, sheet = 24.0;
}

ThemeData buildAppTheme() {
  const font = 'PlusJakartaSans'; // daftarkan di pubspec.yaml atau pakai google_fonts
  final base = ThemeData(useMaterial3: true, fontFamily: font);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, primary: AppColors.primary, surface: AppColors.surface),
    textTheme: base.textTheme.copyWith(
      displayLarge: const TextStyle(fontSize: 64, fontWeight: FontWeight.w800, height: 1, color: AppColors.textPrimary, fontFeatures: [FontFeature.tabularFigures()]),
      displayMedium: const TextStyle(fontSize: 42, fontWeight: FontWeight.w800, height: 1, color: AppColors.textPrimary, fontFeatures: [FontFeature.tabularFigures()]),
      headlineSmall: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      titleMedium: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      bodyMedium: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
      bodySmall: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface, elevation: 0, margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.card), side: const BorderSide(color: AppColors.border)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary, minimumSize: const Size.fromHeight(54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: AppColors.surface, indicatorColor: AppColors.primarySoft, height: 76,
    ),
  );
}

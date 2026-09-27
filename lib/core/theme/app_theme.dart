import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/core/theme/app_palette.dart';
import 'package:flutter_gluko_apps/core/theme/app_spacing.dart';
import 'package:flutter_gluko_apps/core/theme/app_typography.dart';

/// Tema Material 3 GlukoTrack untuk mode terang dan gelap.
abstract final class AppTheme {
  static ThemeData get light => _build(AppPalette.light, Brightness.light);

  static ThemeData get dark => _build(AppPalette.dark, Brightness.dark);

  static ThemeData _build(AppPalette palette, Brightness brightness) {
    final textTheme = AppTypography.textTheme(
      primary: palette.textPrimary,
      secondary: palette.textSecondary,
    );

    // WCAG AA: teal mode gelap (#4FB8C0) terlalu terang untuk teks putih
    // (rasio 2,35), jadi di atasnya dipakai warna latar gelap (rasio > 8).
    final onBrand = brightness == Brightness.dark
        ? palette.background
        : Colors.white;

    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppPalette.light.brand,
          brightness: brightness,
        ).copyWith(
          primary: palette.brand,
          surface: palette.surface,
          error: palette.high.solid,
          outline: palette.border,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: AppTypography.fontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: palette.background,
      textTheme: textTheme,
      extensions: [palette],

      dividerTheme: DividerThemeData(
        color: palette.divider,
        thickness: 1,
        space: 1,
      ),

      cardTheme: CardThemeData(
        color: palette.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: BorderSide(color: palette.border),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.brand,
          foregroundColor: onBrand,
          minimumSize: const Size.fromHeight(AppSizes.primaryButtonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.brandStrong,
          minimumSize: const Size.fromHeight(AppSizes.minTouchTarget),
          textStyle: textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.brand,
        foregroundColor: onBrand,
        elevation: 4,
        extendedTextStyle: textTheme.labelLarge?.copyWith(color: onBrand),
        shape: const StadiumBorder(),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: palette.surface,
        indicatorColor: palette.brandSoft,
        height: AppSizes.navBarHeight,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            color: selected ? palette.brandStrong : palette.textSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 22,
            color: selected ? palette.brandStrong : palette.textSecondary,
          );
        }),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.segment),
          borderSide: BorderSide(color: palette.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.segment),
          borderSide: BorderSide(color: palette.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.segment),
          borderSide: BorderSide(color: palette.brand, width: 2),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.sheet),
          ),
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: palette.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: IconThemeData(color: palette.textPrimary),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: palette.textPrimary,
        contentTextStyle: TextStyle(fontSize: 14, color: palette.surface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.key),
        ),
      ),
    );
  }
}

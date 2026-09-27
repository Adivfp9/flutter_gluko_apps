import 'package:flutter/material.dart';

/// Tipografi GlukoTrack.
///
/// Angka gula darah selalu memakai `tabularFigures` supaya lebar digit tetap —
/// tanpa itu, nilai yang berubah saat mengetik di keypad membuat teks
/// bergeser-geser, dan kolom nilai di daftar riwayat tidak lurus.
abstract final class AppTypography {
  static const String fontFamily = 'PlusJakartaSans';

  static const List<FontFeature> _tabular = [FontFeature.tabularFigures()];

  /// Angka besar pada form catat (`Catat.dc.html`: 64px/800).
  static const TextStyle inputNumeral = TextStyle(
    fontSize: 64,
    fontWeight: FontWeight.w800,
    height: 1,
    letterSpacing: -1.9,
    fontFeatures: _tabular,
  );

  /// Angka pada kartu dashboard (`Main.dc.html`: 42px/800).
  static const TextStyle cardNumeral = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.w800,
    height: 1,
    letterSpacing: -0.84,
    fontFeatures: _tabular,
  );

  /// Angka statistik pada layar tren (`Tren.dc.html`: 26px/800).
  static const TextStyle statNumeral = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    fontFeatures: _tabular,
  );

  /// Nilai pada baris riwayat (`Riwayat.dc.html`: 18px/700).
  static const TextStyle listNumeral = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontFeatures: _tabular,
  );

  /// Header bagian, huruf kapital berspasi (mis. `PUASA HARI INI`).
  static const TextStyle sectionLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.48,
  );

  static TextTheme textTheme({
    required Color primary,
    required Color secondary,
  }) {
    return TextTheme(
      // Judul onboarding: 28px/800.
      displaySmall: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        height: 1.2,
        letterSpacing: -0.56,
        color: primary,
      ),
      // Judul halaman: Beranda, Riwayat, Tren (24px/700).
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.24,
        color: primary,
      ),
      // Judul bottom sheet & sub-halaman (20px/700).
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      // Judul kartu (15px/700).
      titleMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      // Nama item pada daftar riwayat (15px/600).
      titleSmall: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      bodyLarge: TextStyle(fontSize: 16, height: 1.55, color: primary),
      bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: primary),
      // Meta: jam, konteks makan, catatan kaki.
      bodySmall: TextStyle(fontSize: 12, color: secondary),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      labelMedium: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: secondary,
      ),
      // Keluarga font dipasang di sini, bukan hanya lewat ThemeData.fontFamily:
      // tema tombol (Text/Filled/FAB) memakai TextTheme ini langsung, dan tanpa
      // fontFamily labelnya jatuh ke Roboto di Android (ketahuan dari golden).
    ).apply(fontFamily: fontFamily);
  }
}

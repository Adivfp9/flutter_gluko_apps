import 'package:flutter/material.dart';

/// Warna semantik GlukoTrack yang tidak tertampung `ColorScheme`.
///
/// Diturunkan dari PRD 6.2 (tabel token) dan dari nilai `style` inline pada
/// enam layar preview di `docs/glukotrack-ui/design/`.
///
/// Dibawa sebagai `ThemeExtension` supaya widget mengambilnya lewat
/// `context.palette` dan otomatis ikut berganti saat mode gelap aktif —
/// bukan mengimpor konstanta warna langsung, yang akan mengunci UI ke mode
/// terang.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const new({
    required this.brand,
    required this.brandStrong,
    required this.brandSoft,
    required this.surface,
    required this.background,
    required this.border,
    required this.divider,
    required this.inputBorder,
    required this.fieldFill,
    required this.textPrimary,
    required this.textSecondary,
    required this.low,
    required this.normal,
    required this.warning,
    required this.high,
    required this.neutralStatus,
    required this.fasting,
    required this.random,
    required this.postprandial,
  });

  final Color brand;
  final Color brandStrong;
  final Color brandSoft;

  final Color surface;
  final Color background;
  final Color border;
  final Color divider;
  final Color inputBorder;
  final Color fieldFill;

  final Color textPrimary;
  final Color textSecondary;

  /// Empat status klasifikasi (PRD 5.2).
  final StatusColors low;
  final StatusColors normal;
  final StatusColors warning;
  final StatusColors high;

  /// Dipakai saat nilai belum diisi di form catat ("Masukkan nilai").
  final StatusColors neutralStatus;

  /// Aksen per tipe pengukuran — badge GDP / GDS / 2J di riwayat & dashboard.
  final AccentColors fasting;
  final AccentColors random;
  final AccentColors postprandial;

  static const light = AppPalette(
    brand: Color(0xFF0E7C86),
    brandStrong: Color(0xFF0B5F66),
    brandSoft: Color(0xFFDDF1F2),
    surface: Color(0xFFFFFFFF),
    background: Color(0xFFF5F7F8),
    border: Color(0xFFE8EDF0),
    divider: Color(0xFFEEF1F3),
    inputBorder: Color(0xFFD5DCE0),
    fieldFill: Color(0xFFF1F4F5),
    textPrimary: Color(0xFF1F2933),
    textSecondary: Color(0xFF5B6770),
    low: StatusColors(
      background: Color(0xFFEDE9FE),
      foreground: Color(0xFF5B21B6),
      solid: Color(0xFF7C3AED),
    ),
    normal: StatusColors(
      background: Color(0xFFDCFCE7),
      foreground: Color(0xFF166534),
      solid: Color(0xFF16A34A),
    ),
    warning: StatusColors(
      background: Color(0xFFFEF3C7),
      foreground: Color(0xFF92400E),
      solid: Color(0xFFD97706),
    ),
    high: StatusColors(
      background: Color(0xFFFEE2E2),
      foreground: Color(0xFF991B1B),
      solid: Color(0xFFDC2626),
    ),
    neutralStatus: StatusColors(
      background: Color(0xFFEEF1F3),
      foreground: Color(0xFF5B6770),
      solid: Color(0xFF5B6770),
    ),
    fasting: AccentColors(
      background: Color(0xFFE0F2F3),
      foreground: Color(0xFF0B5F66),
      series: Color(0xFF0E7C86),
    ),
    random: AccentColors(
      background: Color(0xFFE6ECF5),
      foreground: Color(0xFF2F4A6D),
      series: Color(0xFF3D5A80),
    ),
    postprandial: AccentColors(
      background: Color(0xFFF3ECE3),
      foreground: Color(0xFF6B4A2B),
      series: Color(0xFF9A6B3F),
    ),
  );

  /// Mode gelap. Nilai brand/status/teks mengikuti kolom "Dark" di PRD 6.2;
  /// pasangan latar-teks untuk pill status tidak ada di PRD sehingga
  /// diturunkan di sini dengan menjaga kontras minimal WCAG AA.
  static const dark = AppPalette(
    brand: Color(0xFF4FB8C0),
    brandStrong: Color(0xFF7FD6DC),
    brandSoft: Color(0xFF0E3A3E),
    surface: Color(0xFF121417),
    background: Color(0xFF0B0D0F),
    border: Color(0xFF232A30),
    divider: Color(0xFF1C2227),
    inputBorder: Color(0xFF39434B),
    fieldFill: Color(0xFF1A1F24),
    textPrimary: Color(0xFFE5E7EB),
    textSecondary: Color(0xFF9AA5AE),
    low: StatusColors(
      background: Color(0xFF2A1F45),
      foreground: Color(0xFFC4B5FD),
      solid: Color(0xFFA78BFA),
    ),
    normal: StatusColors(
      background: Color(0xFF14331F),
      foreground: Color(0xFF86EFAC),
      solid: Color(0xFF4ADE80),
    ),
    warning: StatusColors(
      background: Color(0xFF3A2A0C),
      foreground: Color(0xFFFCD34D),
      solid: Color(0xFFFBBF24),
    ),
    high: StatusColors(
      background: Color(0xFF3B1717),
      foreground: Color(0xFFFCA5A5),
      solid: Color(0xFFF87171),
    ),
    neutralStatus: StatusColors(
      background: Color(0xFF1C2227),
      foreground: Color(0xFF9AA5AE),
      solid: Color(0xFF9AA5AE),
    ),
    fasting: AccentColors(
      background: Color(0xFF0E2E31),
      foreground: Color(0xFF7FD6DC),
      series: Color(0xFF4FB8C0),
    ),
    random: AccentColors(
      background: Color(0xFF1A2436),
      foreground: Color(0xFF9DB4D8),
      series: Color(0xFF7D9CC9),
    ),
    postprandial: AccentColors(
      background: Color(0xFF2E2418),
      foreground: Color(0xFFD6B48C),
      series: Color(0xFFC08F5C),
    ),
  );

  @override
  AppPalette copyWith({
    Color? brand,
    Color? brandStrong,
    Color? brandSoft,
    Color? surface,
    Color? background,
    Color? border,
    Color? divider,
    Color? inputBorder,
    Color? fieldFill,
    Color? textPrimary,
    Color? textSecondary,
    StatusColors? low,
    StatusColors? normal,
    StatusColors? warning,
    StatusColors? high,
    StatusColors? neutralStatus,
    AccentColors? fasting,
    AccentColors? random,
    AccentColors? postprandial,
  }) {
    return AppPalette(
      brand: brand ?? this.brand,
      brandStrong: brandStrong ?? this.brandStrong,
      brandSoft: brandSoft ?? this.brandSoft,
      surface: surface ?? this.surface,
      background: background ?? this.background,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      inputBorder: inputBorder ?? this.inputBorder,
      fieldFill: fieldFill ?? this.fieldFill,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      low: low ?? this.low,
      normal: normal ?? this.normal,
      warning: warning ?? this.warning,
      high: high ?? this.high,
      neutralStatus: neutralStatus ?? this.neutralStatus,
      fasting: fasting ?? this.fasting,
      random: random ?? this.random,
      postprandial: postprandial ?? this.postprandial,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      brand: Color.lerp(brand, other.brand, t)!,
      brandStrong: Color.lerp(brandStrong, other.brandStrong, t)!,
      brandSoft: Color.lerp(brandSoft, other.brandSoft, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      background: Color.lerp(background, other.background, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      inputBorder: Color.lerp(inputBorder, other.inputBorder, t)!,
      fieldFill: Color.lerp(fieldFill, other.fieldFill, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      low: low.lerp(other.low, t),
      normal: normal.lerp(other.normal, t),
      warning: warning.lerp(other.warning, t),
      high: high.lerp(other.high, t),
      neutralStatus: neutralStatus.lerp(other.neutralStatus, t),
      fasting: fasting.lerp(other.fasting, t),
      random: random.lerp(other.random, t),
      postprandial: postprandial.lerp(other.postprandial, t),
    );
  }
}

/// Tiga warna yang selalu dipakai bersama untuk satu status.
///
/// [background]/[foreground] untuk pill dan badge; [solid] untuk titik grafik
/// dan pita target, tempat warna berdiri sendiri tanpa teks di atasnya.
@immutable
class StatusColors {
  const new({
    required this.background,
    required this.foreground,
    required this.solid,
  });

  final Color background;
  final Color foreground;
  final Color solid;

  StatusColors lerp(StatusColors other, double t) {
    return StatusColors(
      background: Color.lerp(background, other.background, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
      solid: Color.lerp(solid, other.solid, t)!,
    );
  }
}

/// Aksen satu tipe pengukuran: badge kode (GDP/GDS/2J) dan warna garis grafik.
@immutable
class AccentColors {
  const new({
    required this.background,
    required this.foreground,
    required this.series,
  });

  final Color background;
  final Color foreground;
  final Color series;

  AccentColors lerp(AccentColors other, double t) {
    return AccentColors(
      background: Color.lerp(background, other.background, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
      series: Color.lerp(series, other.series, t)!,
    );
  }
}

extension AppPaletteX on BuildContext {
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
}

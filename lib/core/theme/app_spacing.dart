/// Skala jarak 4dp (PRD 6.2).
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  /// Padding horizontal layar utama — 20dp pada semua layar preview.
  static const double screenGutter = 20;
}

/// Radius sudut.
///
/// Dasarnya PRD 6.2, dengan dua koreksi dari nilai `style` di file desain yang
/// berbeda dari tabel PRD: tombol memakai 14 (bukan 12) dan chip 16–18
/// (bukan 8).
abstract final class AppRadius {
  static const double card = 16;
  static const double button = 14;
  static const double chip = 18;
  static const double key = 12;
  static const double sheet = 24;
  static const double segment = 10;
  static const double segmentTrack = 14;

  /// Pill status dan FAB memakai radius penuh.
  static const double pill = 999;
}

/// Ukuran komponen yang berulang di banyak layar.
abstract final class AppSizes {
  /// NFR-08: target sentuh minimal.
  static const double minTouchTarget = 48;

  static const double primaryButtonHeight = 54;
  static const double fieldHeight = 44;
  static const double keypadKeyHeight = 50;
  static const double chipHeight = 32;
  static const double filterChipHeight = 36;
  static const double segmentHeight = 40;
  static const double navBarHeight = 76;
  static const double fabSize = 56;
  static const double typeBadgeSize = 40;
  static const double iconButtonSize = 44;
}

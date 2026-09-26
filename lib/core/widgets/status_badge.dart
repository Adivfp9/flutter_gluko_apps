import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/theme/app_palette.dart';
import 'package:flutter_gluko_apps/core/theme/app_spacing.dart';

/// Warna untuk satu status pada tema yang sedang aktif.
StatusColors statusColorsOf(BuildContext context, GlucoseStatus status) {
  final palette = context.palette;
  return switch (status) {
    GlucoseStatus.low => palette.low,
    GlucoseStatus.normal => palette.normal,
    GlucoseStatus.warning => palette.warning,
    GlucoseStatus.high => palette.high,
  };
}

/// Aksen untuk satu tipe pengukuran (badge GDP/GDS/2J dan warna garis grafik).
AccentColors accentColorsOf(BuildContext context, ReadingType type) {
  final palette = context.palette;
  return switch (type) {
    ReadingType.fasting => palette.fasting,
    ReadingType.random => palette.random,
    ReadingType.postprandial2h => palette.postprandial,
  };
}

/// Pill status (PRD F-02 AC3).
///
/// Selalu menampilkan warna, ikon, **dan** teks sekaligus. Status tidak boleh
/// dibedakan hanya lewat warna karena pengguna dengan buta warna tidak akan
/// bisa membacanya.
class StatusBadge extends StatelessWidget {
  const new({
    required this.status,
    this.compact = false,
    this.width,
    super.key,
  });

  final GlucoseStatus status;

  /// Versi ringkas untuk daftar padat.
  final bool compact;

  /// Lebar tetap, dipakai daftar riwayat supaya kolomnya lurus (78dp di desain).
  final double? width;

  @override
  Widget build(BuildContext context) {
    final colors = statusColorsOf(context, status);

    return Semantics(
      label: 'Status ${status.label}',
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(
          horizontal: compact ? AppSpacing.sm : 10,
          vertical: compact ? 2 : 4,
        ),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(
          '${status.glyph} ${status.label}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: compact ? 11 : 12,
            fontWeight: FontWeight.w700,
            color: colors.foreground,
          ),
        ),
      ),
    );
  }
}

/// Badge kode tipe pengukuran (GDP / GDS / 2J).
class ReadingTypeBadge extends StatelessWidget {
  const new({required this.type, super.key});

  final ReadingType type;

  @override
  Widget build(BuildContext context) {
    final colors = accentColorsOf(context, type);

    return Semantics(
      label: type.label,
      child: Container(
        width: AppSizes.typeBadgeSize,
        height: AppSizes.typeBadgeSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(AppRadius.key),
        ),
        child: ExcludeSemantics(
          child: Text(
            type.shortCode,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: colors.foreground,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/theme/app_palette.dart';
import 'package:flutter_gluko_apps/core/theme/app_spacing.dart';
import 'package:flutter_gluko_apps/core/theme/app_typography.dart';
import 'package:flutter_gluko_apps/core/utils/unit_converter.dart';
import 'package:flutter_gluko_apps/core/widgets/status_badge.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/glucose_reading.dart';

/// Satu baris pembacaan pada daftar riwayat dan kartu "Catatan terakhir".
///
/// Mengikuti `Riwayat.dc.html`: badge kode 40dp, nama tipe, meta, nilai, lalu
/// pill status berlebar tetap supaya kolomnya lurus antar-baris.
class ReadingTile extends StatelessWidget {
  const new({
    required this.reading,
    required this.unit,
    this.onTap,
    this.showDivider = true,
    super.key,
  });

  final GlucoseReading reading;
  final GlucoseUnit unit;
  final VoidCallback? onTap;
  final bool showDivider;

  /// Baris kedua: jam, konteks makan, lalu gejala bila ada.
  String _meta() {
    final parts = <String>[reading.formattedTime];

    final context = reading.mealContext;
    if (context != null) parts.add(context.label.toLowerCase());

    if (reading.symptoms.isNotEmpty) {
      parts.add(reading.symptoms.map((s) => s.label).join(', '));
    }
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final text = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: showDivider
            ? BoxDecoration(
                border: Border(top: BorderSide(color: palette.divider)),
              )
            : null,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            ReadingTypeBadge(type: reading.type),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(reading.type.label, style: text.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    _meta(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              UnitConverter.formatValue(reading.valueMgDl, unit),
              style: AppTypography.listNumeral.copyWith(
                color: palette.textPrimary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            StatusBadge(status: reading.status, width: 78),
          ],
        ),
      ),
    );
  }
}

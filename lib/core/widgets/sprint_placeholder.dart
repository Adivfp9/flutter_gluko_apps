import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/core/theme/app_palette.dart';
import 'package:flutter_gluko_apps/core/theme/app_spacing.dart';

/// Isi sementara untuk layar yang kerangkanya sudah ada tapi fiturnya belum
/// dikerjakan.
///
/// Sprint 0 hanya membangun rangka navigasi; tiap layar diisi pada sprint yang
/// disebut di [sprint]. Widget ini hilang begitu layar terkait selesai.
class SprintPlaceholder extends StatelessWidget {
  const new({
    required this.title,
    required this.sprint,
    required this.icon,
    super.key,
  });

  final String title;
  final String sprint;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: palette.textSecondary),
            const SizedBox(height: AppSpacing.lg),
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            Text(
              sprint,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

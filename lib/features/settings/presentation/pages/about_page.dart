import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/core/theme/app_palette.dart';
import 'package:flutter_gluko_apps/core/theme/app_spacing.dart';
import 'package:flutter_gluko_apps/l10n/l10n.dart';

/// Pengaturan › Tentang (rencana 5.7).
///
/// Teks disclaimer (`aboutDisclaimer`) adalah PRD 10.4 verbatim; test
/// `about_page_test.dart` membandingkannya langsung dengan dokumen PRD.
class AboutPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final palette = context.palette;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsAboutTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenGutter),
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: palette.brandSoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.water_drop_outlined,
                  color: palette.brandStrong,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('GlukoTrack', style: text.titleLarge),
                    Text(
                      l10n.aboutTagline,
                      style: text.bodyMedium?.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.medical_information_outlined,
                        color: palette.brandStrong,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          l10n.aboutDisclaimerTitle,
                          style: text.titleSmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(l10n.aboutDisclaimer),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.aboutPrivacyTitle, style: text.titleSmall),
                  const SizedBox(height: AppSpacing.sm),
                  Text(l10n.aboutPrivacyBody),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

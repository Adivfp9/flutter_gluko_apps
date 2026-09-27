import 'package:flutter/widgets.dart';
import 'package:flutter_gluko_apps/l10n/app_localizations.dart';

export 'package:flutter_gluko_apps/l10n/app_localizations.dart';

/// `context.l10n.navHome` — pintasan ke string hasil gen-l10n (Sprint 5.6).
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

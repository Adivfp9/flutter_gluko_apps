// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navHistory => 'History';

  @override
  String get navTrend => 'Trends';

  @override
  String get navSettings => 'Settings';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionMonitoring => 'Monitoring';

  @override
  String get settingsSectionData => 'Data';

  @override
  String get settingsTargetTitle => 'Targets & units';

  @override
  String get settingsTargetSubtitle =>
      'Set fasting, random, and 2-hour post-meal ranges, and mg/dL or mmol/L.';

  @override
  String get settingsRemindersTitle => 'Reminders';

  @override
  String get settingsRemindersSubtitle => 'Daily blood sugar check schedule.';

  @override
  String get settingsSecurityTitle => 'Security';

  @override
  String get settingsSecuritySubtitle => 'PIN and biometrics.';

  @override
  String get settingsBackupTitle => 'Backup & restore';

  @override
  String get settingsBackupLoading => 'Loading…';

  @override
  String get settingsBackupNever =>
      'Never backed up. Create one now to keep your data safe.';

  @override
  String settingsBackupLast(String date) {
    return 'Last backup $date';
  }

  @override
  String settingsBackupStale(String date) {
    return 'Last backup $date — more than 30 days ago.';
  }

  @override
  String get settingsAboutTitle => 'About GlukoTrack';

  @override
  String get settingsAboutSubtitle => 'Medical disclaimer and privacy.';

  @override
  String get aboutTagline => 'Personal blood sugar log';

  @override
  String get aboutDisclaimerTitle => 'Medical disclaimer';

  @override
  String get aboutDisclaimer =>
      'GlukoTrack is a personal blood sugar logging aid. It is not a diagnostic tool and does not replace advice from a healthcare professional. Targets and classifications in this app are general. Discuss your personal targets, medication, and any change in therapy with your doctor. If you have symptoms of very low or very high blood sugar, seek medical help immediately.';

  @override
  String get aboutPrivacyTitle => 'Privacy';

  @override
  String get aboutPrivacyBody =>
      'All records are stored encrypted on this phone only. GlukoTrack has no accounts, sends no data to any server, and does not request internet access.';
}

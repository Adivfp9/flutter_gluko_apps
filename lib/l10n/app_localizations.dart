import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// Tab navigasi bawah: beranda/dashboard.
  ///
  /// In id, this message translates to:
  /// **'Beranda'**
  String get navHome;

  /// No description provided for @navHistory.
  ///
  /// In id, this message translates to:
  /// **'Riwayat'**
  String get navHistory;

  /// No description provided for @navTrend.
  ///
  /// In id, this message translates to:
  /// **'Tren'**
  String get navTrend;

  /// Tab navigasi bawah; label pendek sesuai desain.
  ///
  /// In id, this message translates to:
  /// **'Setelan'**
  String get navSettings;

  /// No description provided for @settingsTitle.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get settingsTitle;

  /// No description provided for @settingsSectionMonitoring.
  ///
  /// In id, this message translates to:
  /// **'Pemantauan'**
  String get settingsSectionMonitoring;

  /// No description provided for @settingsSectionData.
  ///
  /// In id, this message translates to:
  /// **'Data'**
  String get settingsSectionData;

  /// No description provided for @settingsTargetTitle.
  ///
  /// In id, this message translates to:
  /// **'Target & satuan'**
  String get settingsTargetTitle;

  /// No description provided for @settingsTargetSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Atur rentang GDP, GDS, 2 Jam PP, serta mg/dL atau mmol/L.'**
  String get settingsTargetSubtitle;

  /// No description provided for @settingsRemindersTitle.
  ///
  /// In id, this message translates to:
  /// **'Pengingat'**
  String get settingsRemindersTitle;

  /// No description provided for @settingsRemindersSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Jadwal cek gula darah harian.'**
  String get settingsRemindersSubtitle;

  /// No description provided for @settingsSecurityTitle.
  ///
  /// In id, this message translates to:
  /// **'Keamanan'**
  String get settingsSecurityTitle;

  /// No description provided for @settingsSecuritySubtitle.
  ///
  /// In id, this message translates to:
  /// **'PIN dan biometrik.'**
  String get settingsSecuritySubtitle;

  /// No description provided for @settingsBackupTitle.
  ///
  /// In id, this message translates to:
  /// **'Backup & restore'**
  String get settingsBackupTitle;

  /// No description provided for @settingsBackupLoading.
  ///
  /// In id, this message translates to:
  /// **'Memuat…'**
  String get settingsBackupLoading;

  /// No description provided for @settingsBackupNever.
  ///
  /// In id, this message translates to:
  /// **'Belum pernah backup. Buat sekarang agar data aman.'**
  String get settingsBackupNever;

  /// No description provided for @settingsBackupLast.
  ///
  /// In id, this message translates to:
  /// **'Terakhir {date}'**
  String settingsBackupLast(String date);

  /// No description provided for @settingsBackupStale.
  ///
  /// In id, this message translates to:
  /// **'Terakhir {date} — sudah lebih dari 30 hari.'**
  String settingsBackupStale(String date);

  /// No description provided for @settingsAboutTitle.
  ///
  /// In id, this message translates to:
  /// **'Tentang GlukoTrack'**
  String get settingsAboutTitle;

  /// No description provided for @settingsAboutSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Disclaimer medis dan privasi.'**
  String get settingsAboutSubtitle;

  /// No description provided for @aboutTagline.
  ///
  /// In id, this message translates to:
  /// **'Catatan gula darah pribadi'**
  String get aboutTagline;

  /// No description provided for @aboutDisclaimerTitle.
  ///
  /// In id, this message translates to:
  /// **'Disclaimer medis'**
  String get aboutDisclaimerTitle;

  /// PRD 10.4, verbatim. Jangan diubah tanpa persetujuan pemilik produk.
  ///
  /// In id, this message translates to:
  /// **'GlukoTrack adalah alat bantu pencatatan gula darah pribadi, bukan alat diagnosis maupun pengganti nasihat tenaga kesehatan. Target dan klasifikasi di aplikasi ini bersifat umum. Konsultasikan target pribadi, pengobatan, dan setiap perubahan terapi dengan dokter Anda. Bila Anda mengalami gejala gula darah sangat rendah atau sangat tinggi, segera cari pertolongan medis.'**
  String get aboutDisclaimer;

  /// No description provided for @aboutPrivacyTitle.
  ///
  /// In id, this message translates to:
  /// **'Privasi'**
  String get aboutPrivacyTitle;

  /// No description provided for @aboutPrivacyBody.
  ///
  /// In id, this message translates to:
  /// **'Semua catatan tersimpan terenkripsi hanya di HP ini. GlukoTrack tidak memiliki akun, tidak mengirim data ke server, dan tidak meminta izin internet.'**
  String get aboutPrivacyBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

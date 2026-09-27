/// Enum lintas-fitur (shared kernel).
///
/// PRD 7.2 menempatkan enum di `features/glucose/domain/entities/enums.dart`,
/// tetapi `target`, `profile`, `reminder`, dan `trend` semuanya butuh
/// [ReadingType] dan [GlucoseUnit]. Menaruhnya di satu feature akan memaksa
/// feature lain mengimpor domain milik feature tetangga. Diletakkan di core
/// supaya arah dependensi tetap satu arah.
///
/// Nilai `dbValue` harus persis sama dengan CHECK constraint di PRD 8.2 —
/// mengubahnya berarti migrasi skema.
library;

/// Tipe pengukuran (PRD F-01 AC1).
enum ReadingType {
  fasting('fasting', 'GDP', 'Puasa'),
  random('random', 'GDS', 'Sewaktu'),
  postprandial2h('postprandial_2h', '2J', '2 Jam PP');

  new(this.dbValue, this.shortCode, this.label);

  final String dbValue;

  /// Kode pada badge daftar riwayat.
  final String shortCode;

  final String label;

  static ReadingType fromDb(String value) => values.firstWhere(
    (e) => e.dbValue == value,
    orElse: () => throw ArgumentError('reading_type tidak dikenal: $value'),
  );
}

/// Status klasifikasi (PRD 5.2).
enum GlucoseStatus {
  low('low', 'Rendah', '↓'),
  normal('normal', 'Normal', '✓'),
  warning('warning', 'Waspada', '!'),
  high('high', 'Tinggi', '↑');

  new(this.dbValue, this.label, this.glyph);

  final String dbValue;
  final String label;

  /// PRD 6.1: status tidak boleh dibedakan hanya lewat warna.
  final String glyph;

  static GlucoseStatus fromDb(String value) => values.firstWhere(
    (e) => e.dbValue == value,
    orElse: () => throw ArgumentError('status tidak dikenal: $value'),
  );
}

/// Satuan tampilan. Penyimpanan selalu mg/dL (PRD 5.3).
enum GlucoseUnit {
  mgDl('mg_dl', 'mg/dL'),
  mmolL('mmol_l', 'mmol/L');

  new(this.dbValue, this.label);

  final String dbValue;
  final String label;

  static GlucoseUnit fromDb(String value) =>
      values.firstWhere((e) => e.dbValue == value, orElse: () => mgDl);
}

/// Jenis diabetes pada profil; menentukan preset target (PRD 5.1).
enum DiabetesType {
  none('none', 'Tidak ada'),
  prediabetes('prediabetes', 'Prediabetes'),
  type1('type_1', 'Tipe 1'),
  type2('type_2', 'Tipe 2'),
  gestational('gestational', 'Gestasional'),
  unknown('unknown', 'Tidak tahu');

  new(this.dbValue, this.label);

  final String dbValue;
  final String label;

  static DiabetesType fromDb(String value) =>
      values.firstWhere((e) => e.dbValue == value, orElse: () => unknown);

  /// PRD 5.1: preset dipilih otomatis saat onboarding.
  TargetPreset get defaultPreset => switch (this) {
    DiabetesType.type1 ||
    DiabetesType.type2 ||
    DiabetesType.gestational => TargetPreset.diabetes,
    DiabetesType.none ||
    DiabetesType.prediabetes ||
    DiabetesType.unknown => TargetPreset.general,
  };
}

/// Preset ambang target.
///
/// [custom] tidak ada di PRD 5.1 tetapi ada di layar desain `Target.dc.html`;
/// dipakai otomatis begitu pengguna mengubah angka secara manual.
enum TargetPreset {
  general('general', 'Umum'),
  diabetes('diabetes', 'Diabetes'),
  custom('custom', 'Kustom');

  new(this.dbValue, this.label);

  final String dbValue;
  final String label;

  static TargetPreset fromDb(String value) =>
      values.firstWhere((e) => e.dbValue == value, orElse: () => general);
}

/// Konteks makan untuk tipe non-puasa (PRD F-01 AC5).
enum MealContext {
  beforeMeal('before_meal', 'Sebelum makan'),
  afterMeal('after_meal', 'Setelah makan'),
  wakeUp('wake_up', 'Saat bangun'),
  bedtime('bedtime', 'Sebelum tidur'),
  other('other', 'Lainnya');

  new(this.dbValue, this.label);

  final String dbValue;
  final String label;

  static MealContext? fromDb(String? value) {
    if (value == null) return null;
    for (final e in values) {
      if (e.dbValue == value) return e;
    }
    return null;
  }
}

/// Gejala opsional (PRD F-01 AC6).
enum Symptom {
  dizzy('dizzy', 'Pusing'),
  shaky('shaky', 'Gemetar'),
  sweating('sweating', 'Berkeringat'),
  thirsty('thirsty', 'Haus'),
  weak('weak', 'Lemas'),
  blurredVision('blurred_vision', 'Pandangan kabur');

  new(this.dbValue, this.label);

  final String dbValue;
  final String label;

  static Symptom? fromDb(String value) {
    for (final e in values) {
      if (e.dbValue == value) return e;
    }
    return null;
  }
}

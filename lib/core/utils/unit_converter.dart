import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';

/// Konversi satuan gula darah (PRD 5.3).
///
/// Penyimpanan **selalu** mg/dL. Konversi hanya untuk tampilan dan untuk
/// menormalkan input pengguna, sesuai PRD 7.5 ("konversi satuan hanya terjadi
/// di presentation").
abstract final class UnitConverter {
  /// PRD 5.3: mmol/L = mg/dL ÷ 18,0.
  static const double mgDlPerMmolL = 18;

  /// Batas nilai valid dalam mg/dL (PRD 5.5).
  static const int minMgDl = 20;
  static const int maxMgDl = 600;

  static double mgDlToMmolL(int mgDl) => mgDl / mgDlPerMmolL;

  /// Nilai mmol/L untuk tampilan, dibulatkan 1 desimal (PRD 5.3).
  static double mgDlToMmolLRounded(int mgDl) =>
      (mgDl / mgDlPerMmolL * 10).round() / 10;

  /// Input mmol/L dikonversi lalu dibulatkan ke mg/dL bulat sebelum disimpan.
  static int mmolLToMgDl(double mmolL) => (mmolL * mgDlPerMmolL).round();

  /// Batas bawah dalam mmol/L, dibulatkan **ke atas** supaya nilai yang lolos
  /// validasi mmol/L tidak jatuh di bawah [minMgDl] setelah dikonversi.
  static double get minMmolL => (minMgDl / mgDlPerMmolL * 10).ceil() / 10;

  /// Batas atas dalam mmol/L, dibulatkan **ke bawah** dengan alasan simetris.
  static double get maxMmolL => (maxMgDl / mgDlPerMmolL * 10).floor() / 10;

  /// Nilai mg/dL ke angka yang ditampilkan pada satuan [unit].
  static num toDisplay(int mgDl, GlucoseUnit unit) => switch (unit) {
    GlucoseUnit.mgDl => mgDl,
    GlucoseUnit.mmolL => mgDlToMmolLRounded(mgDl),
  };

  /// Teks angka tanpa satuan, mis. `112` atau `6,2`.
  ///
  /// Memakai koma sebagai pemisah desimal (NFR-09, format id_ID).
  static String formatValue(int mgDl, GlucoseUnit unit) => switch (unit) {
    GlucoseUnit.mgDl => '$mgDl',
    GlucoseUnit.mmolL => mgDlToMmolLRounded(
      mgDl,
    ).toStringAsFixed(1).replaceAll('.', ','),
  };

  /// Teks angka beserta satuannya, mis. `112 mg/dL`.
  static String formatWithUnit(int mgDl, GlucoseUnit unit) =>
      '${formatValue(mgDl, unit)} ${unit.label}';

  /// Mengubah teks yang diketik pengguna menjadi mg/dL.
  ///
  /// Menerima koma maupun titik sebagai pemisah desimal. Mengembalikan `null`
  /// bila teks bukan angka yang sah — pemanggil yang memutuskan pesan error.
  static int? parseToMgDl(String raw, GlucoseUnit unit) {
    final cleaned = raw.trim().replaceAll(',', '.');
    if (cleaned.isEmpty) return null;

    return switch (unit) {
      GlucoseUnit.mgDl => int.tryParse(cleaned),
      GlucoseUnit.mmolL => switch (double.tryParse(cleaned)) {
        final value? when value.isFinite => mmolLToMgDl(value),
        _ => null,
      },
    };
  }

  static bool isInValidRange(int mgDl) => mgDl >= minMgDl && mgDl <= maxMgDl;
}

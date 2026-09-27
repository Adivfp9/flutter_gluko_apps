/// Utilitas tanggal lokal.
///
/// PRD 5.5: "hari dihitung berdasarkan zona waktu perangkat saat pengukuran
/// (disimpan offset-nya)". Karena itu `local_date` tidak boleh diturunkan ulang
/// dari `measured_at` dengan zona waktu perangkat **saat membaca** — kalau
/// pengguna berpindah zona waktu, pembacaan lama bisa berpindah hari dan
/// menabrak indeks unik GDP-per-hari. Selalu pakai offset yang tersimpan.
abstract final class LocalDate {
  /// Format `YYYY-MM-DD`, sama dengan kolom `local_date` (PRD 8.2).
  static String format(DateTime dateTime) {
    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Tanggal lokal dari waktu UTC + offset zona waktu (dalam menit).
  static String fromUtc(DateTime utc, int tzOffsetMinutes) =>
      format(utc.toUtc().add(Duration(minutes: tzOffsetMinutes)));

  /// Tanggal lokal sebuah [DateTime] beserta offset perangkat saat ini.
  static String ofLocal(DateTime local) => format(local);

  static int offsetMinutesOf(DateTime local) => local.timeZoneOffset.inMinutes;

  /// Mengembalikan waktu lokal (bukan UTC) dari pasangan nilai tersimpan.
  static DateTime toLocalWallClock(DateTime utc, int tzOffsetMinutes) =>
      utc.toUtc().add(Duration(minutes: tzOffsetMinutes));

  /// Tengah malam tanggal lokal [local], dipakai sebagai batas rentang query.
  static DateTime startOfDay(DateTime local) =>
      DateTime(local.year, local.month, local.day);

  /// Awal hari [daysBack] hari sebelum [local].
  static DateTime startOfDayBefore(DateTime local, int daysBack) =>
      startOfDay(local).subtract(Duration(days: daysBack));

  /// Daftar tanggal `YYYY-MM-DD` dari [daysBack] hari lalu hingga hari ini.
  static List<String> lastDates(DateTime today, int daysBack) {
    final start = startOfDay(today).subtract(Duration(days: daysBack - 1));
    return List.generate(daysBack, (i) => format(start.add(Duration(days: i))));
  }
}

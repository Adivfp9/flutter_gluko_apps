/// Kegagalan yang boleh sampai ke layer presentation.
///
/// PRD 7.4 langkah 6: kegagalan dikembalikan sebagai `Left(Failure)`, bukan
/// exception yang bocor ke UI. Dibuat `sealed` supaya `switch` di BLoC
/// dicek keterlengkapannya oleh compiler — kalau ada jenis kegagalan baru,
/// build gagal alih-alih diam-diam jatuh ke pesan generik.
sealed class Failure {
  const new(this.message);

  /// Pesan siap tampil dalam Bahasa Indonesia.
  final String message;

  @override
  String toString() => message;
}

/// Operasi database gagal (I/O, constraint, transaksi dibatalkan).
final class DatabaseFailure extends Failure {
  const new([super.message = 'Gagal menyimpan data.']);
}

/// Input tidak lolos aturan PRD 5.5 — di luar 20–600 mg/dL, waktu di masa
/// depan, atau lebih dari 1 tahun ke belakang.
final class ValidationFailure extends Failure {
  const new(super.message, {this.field});

  /// Nama field agar pesan bisa ditempel di input yang tepat.
  final String? field;
}

/// PRD 5.5: sudah ada GDP pada tanggal tersebut.
///
/// Bukan error teknis melainkan percabangan alur — UI menampilkan tiga pilihan
/// (ganti yang lama, simpan sebagai Sewaktu, batal), jadi konteks pembacaan
/// lama ikut dibawa.
final class DuplicateFastingFailure extends Failure {
  const new({
    required this.existingReadingId,
    required this.existingValueMgDl,
    required this.localDate,
  }) : super('Sudah ada catatan gula darah puasa untuk tanggal ini.');

  final int existingReadingId;
  final int existingValueMgDl;

  /// Format `YYYY-MM-DD`, sama dengan kolom `local_date`.
  final String localDate;
}

/// Data yang diminta tidak ada atau sudah dihapus.
final class NotFoundFailure extends Failure {
  const new([super.message = 'Data tidak ditemukan.']);
}

/// PIN salah, biometrik gagal, atau kunci database tidak bisa dibaca.
final class SecurityFailure extends Failure {
  const new([super.message = 'Verifikasi keamanan gagal.']);
}

/// Ekspor/impor `.gtbak` gagal: checksum tidak cocok, versi skema lebih baru,
/// atau passphrase salah.
final class BackupFailure extends Failure {
  const new(super.message);
}

/// Izin sistem ditolak (notifikasi, exact alarm, akses berkas).
final class PermissionFailure extends Failure {
  const new(super.message, {required this.permission});

  final String permission;
}

/// Jaring pengaman terakhir. Kemunculannya di log berarti ada jalur error
/// yang belum dipetakan ke `Failure` yang lebih spesifik.
final class UnexpectedFailure extends Failure {
  const new([super.message = 'Terjadi kesalahan yang tidak terduga.']);
}

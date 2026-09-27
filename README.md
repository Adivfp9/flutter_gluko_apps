<p align="center">
  <img src="docs/logo-brand/png/logo/logo-horizontal@2x.png" alt="GlukoTrack" height="64">
</p>

# GlukoTrack

Aplikasi Android untuk mencatat gula darah harian. Nilai puasa (GDP),
sewaktu (GDS), dan 2 jam setelah makan disimpan terpisah, langsung diberi
status sesuai target, dan bisa dilihat trennya per minggu atau per bulan.
Semua data tinggal di HP, terenkripsi, tanpa akun dan tanpa internet.

Dibuat dengan Flutter, drift (SQLite + SQLCipher), dan BLoC.

## Latar belakang

Banyak orang dengan diabetes atau prediabetes mencatat hasil cek gula darah
di buku atau di notes HP. Masalahnya muncul saat catatan itu dibawa ke
dokter: angka puasa dan sewaktu bercampur, tidak kelihatan apakah minggu
ini lebih baik dari minggu lalu, dan rata-rata harus dihitung manual.
Aplikasi di Play Store kebanyakan berbahasa Inggris, minta daftar akun, atau
terlalu banyak fitur untuk orang yang hanya ingin mencatat satu angka tiap
pagi.

GlukoTrack dibuat untuk kebutuhan yang sempit itu: mencatat satu nilai
dalam kurang dari 10 detik, lalu melihat polanya.

## Fitur

- **Catat** GDP, GDS, atau 2 Jam PP dengan keypad angka. Status (Rendah,
  Normal, Waspada, Tinggi) langsung muncul selagi mengetik. Bisa ditambah
  gejala, konteks makan, dan catatan.
- **Satu GDP per hari.** Kalau sudah ada, aplikasi menanyakan apakah yang
  lama diganti atau yang baru dijadikan GDS.
- **Beranda**: GDP hari ini, GDS terakhir, rata-rata 7 hari beserta
  selisihnya dari minggu lalu, dan 5 catatan terakhir.
- **Riwayat** dikelompokkan per tanggal, dengan filter tipe dan status,
  plus tampilan kalender yang mewarnai tiap hari dengan status terburuknya.
  Catatan yang dihapus bisa dikembalikan dalam 5 detik.
- **Tren** 7/14/30/90 hari: grafik dengan pita target, titik berwarna per
  status, rata-rata, minimum, maksimum, dan persentase waktu dalam target.
- **Target** memakai preset (Umum atau Diabetes) atau diatur sendiri, dalam
  mg/dL atau mmol/L. Setelah target diubah, catatan lama bisa diklasifikasi
  ulang.
- **Pengingat** harian atau untuk hari tertentu. Pengingat puasa tidak
  berbunyi kalau GDP hari itu sudah dicatat. Menyentuh notifikasi langsung
  membuka form catat dengan tipe yang sesuai.
- **Kunci aplikasi** dengan PIN 6 digit atau sidik jari. Terkunci lagi
  kalau aplikasi ditinggal lebih dari 1 menit, dan isinya tidak terlihat di
  daftar aplikasi terbaru.
- **Backup** ke satu file `.gtbak` yang dienkripsi dengan passphrase. File
  bisa dikirim ke Google Drive atau WhatsApp lalu dipulihkan di HP lain,
  termasuk langsung dari layar onboarding.
- Tema terang dan gelap. Antarmuka berbahasa Indonesia.

## Cara kerja

### Klasifikasi

Setiap nilai dibandingkan dengan tiga ambang milik tipenya:

```
nilai <  batas_rendah   → Rendah
nilai <= batas_normal   → Normal
nilai <= batas_waspada  → Waspada
di atasnya              → Tinggi
```

Ambang bawaan (mg/dL):

| Preset | Tipe | Rendah | Normal | Waspada | Tinggi |
| --- | --- | --- | --- | --- | --- |
| Umum | Puasa | < 70 | 70–99 | 100–125 | ≥ 126 |
| Umum | Sewaktu, 2 Jam PP | < 70 | 70–139 | 140–199 | ≥ 200 |
| Diabetes | Puasa | < 70 | 70–130 | 131–180 | > 180 |
| Diabetes | Sewaktu, 2 Jam PP | < 70 | 70–180 | 181–250 | > 250 |

Preset dipilih otomatis dari jenis diabetes di profil dan bisa diubah
kapan saja. Nilai selalu disimpan dalam mg/dL; mmol/L hanya dipakai untuk
tampilan dan input.

### Waktu dan tanggal

Setiap catatan menyimpan waktu dalam UTC, offset zona waktu saat dicatat,
dan tanggal lokalnya. Riwayat dikelompokkan memakai tanggal lokal yang
tersimpan, bukan dihitung ulang dari zona waktu HP saat ini. Tanpa itu,
catatan orang yang pernah bepergian akan pindah hari setiap kali riwayat
dibuka.

### Data dan keamanan

- Database SQLite dienkripsi SQLCipher. Kuncinya 256-bit acak, dibuat
  sekali saat aplikasi pertama dibuka, dan disimpan di Android Keystore.
  File database dikecualikan dari auto-backup Android, karena tanpa kunci
  dari Keystore file itu tidak bisa dibuka di HP lain.
- PIN tidak pernah disimpan. Yang disimpan hanya hash PBKDF2-HMAC-SHA256
  dengan salt acak. Setelah 5 kali salah, ada jeda 30 detik yang berlipat
  dua pada setiap kesalahan berikutnya, maksimal 15 menit. Penghitungnya
  ada di database, jadi menutup aplikasi tidak mereset jeda.
- Lupa PIN tidak bisa dipulihkan. Jalan keluarnya adalah menghapus semua
  data (dengan mengetik HAPUS sebagai konfirmasi), lalu memulihkan dari
  file backup.
- File `.gtbak` terdiri dari header JSON terbuka (versi skema, waktu
  dibuat, salt, jumlah iterasi) dan isi database yang dikompres gzip lalu
  dienkripsi AES-256-GCM. Kuncinya diturunkan dari passphrase dengan
  PBKDF2. Checksum SHA-256 membedakan file yang rusak dari passphrase yang
  salah. Backup dari versi aplikasi yang lebih baru ditolak.
- Restore berjalan dalam satu transaksi. Kalau gagal di tengah, data lama
  tidak berubah.
- Build rilis tidak meminta izin internet.

### Pengingat

Android tidak bisa mengecek database saat notifikasi akan muncul. Karena
itu setiap pengingat dijadwalkan sebagai notifikasi mingguan untuk tiap
hari aktifnya, dan aplikasi menyusun ulang jadwal setiap kali pengingat
diubah, GDP hari ini disimpan atau dihapus, atau aplikasi dibuka kembali.
Kalau GDP hari ini sudah ada, kemunculan pengingat puasa hari ini digeser
ke minggu depan. Jadwal tetap berlaku setelah HP di-restart.

### Arsitektur

```
lib/
├── core/            tema, router, DI, enum domain, util tanggal & satuan
├── database/        tabel, DAO, koneksi SQLCipher, snapshot untuk backup
├── features/
│   ├── glucose/     catat, beranda, riwayat, detail, klasifikasi
│   ├── trend/       statistik dan grafik
│   ├── target/      preset dan ambang
│   ├── reminder/    pengingat dan penjadwalan notifikasi
│   ├── security/    PIN, biometrik, layar kunci
│   ├── backup/      format .gtbak, backup dan restore
│   ├── profile/     profil pengguna
│   ├── onboarding/  4 langkah awal
│   ├── settings/    pengaturan dan halaman Tentang
│   └── startup/     splash dan pembersihan data lama
└── l10n/            string aplikasi (ARB, gen-l10n)
```

Tiap fitur dibagi tiga lapis:

- `domain`: entity, interface repository, dan use case dalam Dart murni,
  tanpa Flutter.
- `data`: implementasi repository di atas DAO drift.
- `presentation`: Cubit dan halaman.

Kode yang menyentuh platform (notifikasi, Keystore, biometrik, share
sheet, pemilih file) ada di balik interface, jadi logikanya bisa dites
tanpa perangkat.

Layar membaca data lewat stream drift. Begitu sebuah catatan disimpan,
beranda, riwayat, dan tren ikut berubah tanpa refresh manual.

## Stack

| Bagian | Yang dipakai |
| --- | --- |
| UI | Flutter 3.47, Material 3, font Plus Jakarta Sans |
| State | flutter_bloc (Cubit), freezed |
| Database | drift, SQLite dengan build SQLCipher |
| Navigasi | go_router, 4 tab dengan StatefulShellRoute |
| Dependency injection | get_it + injectable |
| Grafik | fl_chart |
| Notifikasi | flutter_local_notifications, timezone |
| Keamanan | flutter_secure_storage, local_auth, cryptography |
| Platform | Android 8.0 (API 26) ke atas |

## Menjalankan

Butuh Flutter 3.47 (Dart 3.13) dan Android SDK.

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Build APK rilis:

```bash
flutter build apk --release --split-per-abi
```

Tanpa `android/key.properties`, APK rilis ditandatangani dengan kunci
debug. Cukup untuk dicoba di HP, tetapi tidak bisa diunggah ke Play Store.
Cara membuat keystore ada di [docs/RELEASE-CHECKLIST.md](docs/RELEASE-CHECKLIST.md).

## Testing

```bash
flutter test                                        # semua test (300)
flutter test test/golden --update-goldens           # setelah perubahan UI yang disengaja
flutter test integration_test/app_flow_test.dart -d <device>
```

Selain unit test domain dan Cubit, yang dites:

- File database di disk benar-benar terenkripsi: header-nya bukan
  `SQLite format 3` dan isi catatan tidak terbaca.
- Skema hasil pembuatan database sama dengan snapshot di `drift_schemas/`.
- Query beranda, riwayat, kalender, dan tren selesai di bawah 300 ms
  dengan 10.000 catatan.
- Backup, hapus semua, lalu restore menghasilkan isi tabel yang identik,
  juga ke database kosong (skenario HP baru).
- 12 layar diperiksa otomatis dengan ukuran teks 200%: tidak ada teks
  terpotong, target sentuh minimal 48 dp, tombol punya label, dan kontras
  memenuhi WCAG AA di tema terang maupun gelap.
- Golden test 6 layar di tema terang dan gelap.
- Satu alur lengkap lewat UI: onboarding, catat, edit, hapus lalu
  batalkan, backup, restore.

Coverage lapisan domain 92,8%, keseluruhan 80%.

## Status

MVP untuk Android sudah selesai. Yang belum:

- Uji di HP fisik: notifikasi setelah restart, sidik jari, dan performa.
- Terjemahan bahasa Inggris baru mencakup navigasi, Pengaturan, dan
  Tentang.
- APK arm64 berukuran 26,3 MB, sedikit di atas target 25 MB.
- Laporan PDF, ekspor CSV, serta log obat dan makanan direncanakan untuk
  versi berikutnya.

Rencana kerja ada di [docs/IMPLEMENTATION-PLAN.md](docs/IMPLEMENTATION-PLAN.md),
kebutuhan produk di [docs/PRD-GlukoTrack.md](docs/PRD-GlukoTrack.md).

## Disclaimer medis

GlukoTrack adalah alat bantu pencatatan gula darah pribadi, bukan alat
diagnosis maupun pengganti nasihat tenaga kesehatan. Target dan
klasifikasi di aplikasi ini bersifat umum. Konsultasikan target pribadi,
pengobatan, dan setiap perubahan terapi dengan dokter Anda. Bila Anda
mengalami gejala gula darah sangat rendah atau sangat tinggi, segera cari
pertolongan medis.

---

Adi Purwanto · 2026

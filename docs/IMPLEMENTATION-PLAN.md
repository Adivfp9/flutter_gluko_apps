# GlukoTrack — Summary PRD + Rencana Implementasi

**Dibuat:** 26 September 2026 · **Sumber:** `docs/PRD-GlukoTrack.md`, `docs/glukotrack-ui/design/*.dc.html`, `docs/app_theme.dart`
**Baseline repo:** Flutter 3.47.5 · Dart 3.13.4 · scaffold `flutter create` kosong (hanya `lib/main.dart` demo counter)
**Target platform MVP:** **Android saja** (keputusan 26 September 2026) · iOS ditunda ke pasca-MVP

---

## 1. Ringkasan Produk

GlukoTrack = pencatat gula darah harian **offline-first** (Flutter + SQLite/drift), yang memisahkan tegas **GDP (puasa)**, **GDS (sewaktu)**, dan **2 Jam PP**. Nilai jual utama: input < 10 detik, tren mudah dibaca, data 100% di perangkat (tanpa akun, tanpa cloud, DB terenkripsi).

**Lingkup MVP (10 fitur):** F-01 pencatatan · F-02 klasifikasi otomatis · F-03 target & satuan · F-04 dashboard · F-05 riwayat (list + kalender) · F-06 grafik tren · F-07 pengingat · F-08 app lock (PIN/biometrik) · F-09 backup/restore · F-10 onboarding & profil.
**v1.1:** peringatan ekstrem, laporan PDF/CSV, TIR + estimasi HbA1c, log obat/makanan/aktivitas, pengingat obat.
**v2:** Health Connect/HealthKit, glucometer BLE, OCR, sync cloud.

**Inti aturan bisnis yang harus jadi kode (bukan opini):**

| Aturan | Isi |
| --- | --- |
| Klasifikasi | `v < lowMax` → RENDAH · `<= normalMax` → NORMAL · `<= warningMax` → WASPADA · else TINGGI |
| Kritis | `v < 54` atau `v > 300` (dapat diatur) → `isCritical` |
| Preset Umum | GDP 70/99/125 · GDS 70/139/199 · 2JPP 70/139/199 |
| Preset Diabetes | GDP 70/130/180 · GDS 70/180/250 · 2JPP 70/180/250 |
| Penyimpanan | **Selalu mg/dL**; mmol/L hanya lapisan tampilan (`mmol = mg/dL ÷ 18`, 1 desimal) |
| Validasi | 20–600 mg/dL · waktu tidak boleh masa depan · maks mundur 1 tahun |
| GDP unik | Maks 1 GDP per tanggal lokal; input ke-2 → pilih *ganti / simpan sebagai Sewaktu / batal* |
| Status | Disimpan sebagai **snapshot** bersama pembacaan; ubah target tidak mengubah data lama kecuali "Hitung ulang" |
| Hapus | Soft delete (`deleted_at`), purge otomatis > 30 hari |

**Target non-fungsional yang mengikat desain teknis:** cold start ≤ 2 s · simpan ≤ 200 ms · query ≤ 300 ms @10.000 baris · **tanpa permission INTERNET di build MVP** · SQLCipher + kunci 256-bit di Android Keystore · APK ≤ 25 MB · text scale 200% · coverage domain ≥ 90%, data ≥ 80%, total ≥ 70%.

NFR-01 dipersempit untuk MVP: **Android 8.0+ (API 26)** saja, portrait, ponsel. Klausul iOS 14+ tetap berlaku sebagai target pasca-MVP.

---

## 2. Ringkasan Paket UI

6 layar preview tersedia sebagai HTML (`.dc.html`) dengan semua ukuran/warna/jarak di atribut `style` inline — jadi ini spesifikasi pixel yang bisa dipakai langsung, bukan sekadar mockup. Kanvas 390×844.

| Layar desain | Isi kunci yang terbaca dari desain | Target Flutter |
| --- | --- | --- |
| `Onboarding.dc.html` | Progress 4 segmen + "Langkah 2 dari 4", ikon 88×88 r28, 3 poin disclaimer, checkbox wajib, CTA 54 dp r14 | `features/onboarding/.../disclaimer_page.dart` |
| `Main.dc.html` | Sapaan + tanggal, tombol bell 44 dp, 2 kartu grid (GDP hari ini / GDS terakhir) angka 42/800, chip status pill, kartu rata-rata 7 hari + sparkline SVG 316×60, kartu "Catatan terakhir" 2 item, FAB pill "+ Catat" (56 dp, bottom 92), bottom nav 76 dp | `features/glucose/.../dashboard_page.dart` |
| `Catat.dc.html` | Bottom sheet r24 dari top 40, drag handle, segmented 3 tipe, angka **64/800**, chip status live, baris Waktu, checkbox "sudah puasa 8 jam" (hanya tipe Puasa), chip Konteks (hanya non-Puasa), chip Gejala + tombol tambah, keypad 3×4 (`1–9, C, hapus`) tombol 50 dp r12, tombol Simpan 54 dp | `features/glucose/.../widgets/input_sheet.dart` |
| `Riwayat.dc.html` | Toggle Daftar/Kalender, 4 chip filter tipe, grup per tanggal dengan header uppercase 12/700, item: badge kode 40 dp (GDP/GDS/2J) + nama + meta + nilai 18/700 + pill status width 78 | `features/glucose/.../history_page.dart` |
| `Tren.dc.html` | Segmented 7/14/30/90, kartu chart 342×214 dengan pita target hijau 10% + gridline + label sumbu, chip toggle GDP/GDS, titik diwarnai per status, 4 kartu statistik (avg, min/maks, TIR + progress bar) | `features/trend/.../trend_page.dart` |
| `Target.dc.html` | Segmented **Umum / Diabetes / Kustom**, banner info teal, per tipe: bar pratinjau 4 warna proporsional + 3 input angka 44 dp, CTA Simpan + "Kembalikan ke default" | `features/target/.../target_page.dart` |

`docs/app_theme.dart` sudah menyediakan `AppColors`, `StatusStyle` (bg/fg/label/glyph/solid), `AppRadius`, dan `buildAppTheme()` — dipakai sebagai titik awal `lib/core/theme/`.

---

## 3. Temuan: Gap & Keputusan yang Perlu Diambil

Ini hasil pembandingan PRD ↔ desain ↔ repo. Beberapa di antaranya harus diputuskan **sebelum** Sprint 1 dimulai.

### 3.1 Blocker teknis (harus diputuskan lebih dulu)

**B-1 — Font Plus Jakarta Sans belum ada.**
`app_theme.dart` memanggil `fontFamily: 'PlusJakartaSans'`, tapi `pubspec.yaml` tidak punya section `fonts`. Paket `google_fonts` **mengunduh font saat runtime** sehingga bentrok langsung dengan NFR-04 (build MVP tanpa permission INTERNET) dan akan fallback silent ke Roboto.
→ **Bundle TTF lokal** di `assets/fonts/` (weight 400/500/600/700/800), jangan `google_fonts`. Sekitar 1,2 MB, masih aman terhadap NFR-10.

**B-2 — Kunci enkripsi file backup belum ditentukan.**
PRD hanya menyebut ".gtbak terenkripsi". Bila kuncinya adalah kunci DB dari Android Keystore, file **tidak bisa dipulihkan di HP baru** — padahal itu justru mitigasi risiko "data hilang saat ganti HP" di PRD 10.2. Fitur F-09 akan gagal memenuhi tujuannya sendiri.
→ Kunci backup **diturunkan dari passphrase yang diinput pengguna** (PBKDF2-HMAC-SHA256, ≥ 100k iterasi, salt acak di header) + AES-256-GCM. Header plaintext: `{magic, schema_version, created_at, kdf, salt, iterations}`; checksum SHA-256 atas ciphertext.

**B-3 — Target platform: SELESAI, Android saja.**
Keputusan 26 September 2026: MVP fokus Android, iOS ditunda. Ini menutup pertanyaan terbuka PRD 10.3 butir pertama. Konsekuensinya:
- Folder `ios/` **tidak** dibuat; `flutter create --platforms=ios .` baru dijalankan saat iOS benar-benar masuk lingkup.
- Semua keamanan platform memakai jalur Android: kunci DB di **Android Keystore** (via `flutter_secure_storage`), biometrik lewat `local_auth` BiometricPrompt, proteksi app switcher lewat **FLAG_SECURE** (tanpa perlu solusi blur khusus iOS).
- QA Sprint 5 dan DoD PRD 10.1 dipersempit jadi 1 perangkat Android fisik (disarankan tambah 1 perangkat OEM dengan battery optimizer agresif, lihat §7).
- Rilis beta hanya lewat Play Console internal testing; TestFlight dikeluarkan dari lingkup.

**Agar penambahan iOS nanti tetap murah** (biaya nol sekarang, hanya disiplin): jangan letakkan kode platform-specific di `domain` atau `data`. Bungkus notifikasi, biometrik, secure storage, dan share/file picker di balik interface di `core`/feature masing-masing, sehingga penambahan iOS kelak hanya menyentuh lapisan implementasi — bukan logika bisnis.

**B-4 — `ux_fasting_per_day` (unique index) vs alur pilihan GDP ganda.**
Index menolak insert GDP ke-2 dengan exception, sementara AC menuntut dialog 3 pilihan. Tanpa penanganan, hasilnya crash atau pesan error mentah ke UI.
→ Use case `AddReading` **wajib** cek `fastingOn(date)` sebelum insert dan mengembalikan `Left(DuplicateFastingFailure)` yang di-render sebagai dialog. Index tetap dipertahankan sebagai jaring pengaman. Catatan: alur *restore* dan *undo delete* juga bisa menabrak index ini — tangani sebagai kasus uji eksplisit.

**B-5 — `sqlcipher_flutter_libs` sudah EOL; jalur SQLCipher berubah.** *(ditemukan saat Sprint 0.1, 26 Sep 2026)*
PRD 7.1 menyebut `sqlcipher_flutter_libs` sebagai paket enkripsi. Rilis terakhirnya adalah `0.7.0+eol` dengan deskripsi resmi *"Not used anymore, update to version 3.x of package:sqlite3 instead"*. Jadi paket itu tidak boleh dipakai untuk proyek baru.
→ Sejak `sqlite3` 3.x, varian native dipilih lewat **build hook**, bukan paket libs terpisah. Yang dipakai sekarang (sudah masuk `pubspec.yaml`):

```yaml
hooks:
  user_defines:
    sqlite3:
      source: sqlcipher   # alternatif: sqlite3mc
```

Konsekuensi yang perlu diingat:
- `sqlite3` dijadikan dependensi **langsung** (bukan transitif dari drift) supaya versi yang dikenai hook terkendali.
- Tidak perlu `open.overrideFor` — pustaka yang ter-bundle sudah SQLCipher, tinggal `PRAGMA key` setelah open (menyesuaikan tugas 1.3).
- Build SQLCipher menautkan **OpenSSL** di Android, jadi dampaknya ke NFR-10 (APK ≤ 25 MB) harus diukur, bukan diasumsikan. Bila terlalu besar, `source: sqlite3mc` adalah pengganti yang lebih ramping dan tetap mendukung `PRAGMA key`.

### 3.2 Desain belum lengkap (perlu dibuat)

**D-1 — S-09 Pengaturan tidak ada di paket desain.** Tab ke-4 bottom nav berlabel "Setelan" tetapi `href`-nya langsung ke `Target.dc.html`. → Ikuti PRD: tab 4 = Pengaturan (profil, target, satuan, pengingat, keamanan, backup, tentang), Target jadi sub-halaman. Layout diturunkan dari bahasa visual kartu yang sudah ada.

**D-2 — Tampilan Kalender riwayat (F-05 AC4) belum didesain** — toggle-nya ada, isinya tidak. Perlu grid bulan + titik warna = status terburuk hari itu.

**D-3 — Layar S-01 (Splash/Kunci), S-05 (Hasil tersimpan), S-07 (Detail catatan), dan S-11 (Pengingat) belum didesain.** Bisa disusun dari komponen yang sudah ada (angka besar + pill status + dua tombol).

**D-4 — Dark mode belum ada.** `app_theme.dart` hanya light, padahal PRD 6.2 mendefinisikan kolom Dark dan DoD mewajibkan dark mode. Perlu `AppColors.dark` + `buildDarkTheme()`. Pasangan bg/fg pill status versi dark belum ada di PRD sehingga harus diturunkan sendiri, dengan menjaga kontras WCAG AA.

### 3.3 Selisih kecil desain ↔ PRD (putuskan saat implementasi)

- **Preset ke-3 "Kustom"** ada di desain Target, tidak ada di PRD 5.1 → tambahkan `TargetPreset.custom`, di-set otomatis begitu pengguna mengubah angka manual.
- **Keypad desain tidak punya tombol desimal** (`1–9, C, hapus`), sedangkan wireframe PRD 6.5 menampilkan tombol koma. Untuk mode mmol/L keypad **wajib** punya separator desimal, jadi keypad harus adaptif terhadap satuan aktif (dan batas 3 digit di prototipe jadi ≤ 4 karakter untuk mmol/L).
- **Sheet Catat belum memuat field Catatan (maks 500 karakter)** dan belum memuat input *jam ke-berapa setelah makan* (`hours_after_meal`), padahal keduanya diminta AC. Gejala di desain hanya 3 chip + tombol tambah, PRD minta 6 pilihan → tombol tambah membuka sheet pilihan lengkap.
- **Warna aksen per tipe** (GDP `#E0F2F3`/`#0B5F66`, GDS `#E6ECF5`/`#2F4A6D`, 2JPP `#F3ECE3`/`#6B4A2B`) dipakai di desain tapi belum ada di `app_theme.dart` → tambahkan sebagai token `ReadingTypeStyle`.
- **Sumbu Y chart Tren di-hardcode 80–200.** Data nyata berkisar 20–600 → skala harus dihitung dinamis dengan pembulatan nice-number, plus penanganan periode kosong atau hanya 1 titik.
- **Kartu dashboard menampilkan "target 70–99"** (target *saat ini*) berdampingan dengan status *snapshot* lama. Setelah pengguna mengubah target keduanya bisa tampak tidak konsisten → tampilkan target snapshot, atau beri penanda "target telah berubah".
- **Pengingat puasa "dilewati otomatis bila GDP sudah tercatat" (F-07 AC4)** tidak bisa dievaluasi oleh OS saat notifikasi tampil. Solusi: batalkan lalu jadwalkan ulang occurrence berikutnya setiap kali GDP tersimpan, dan rekonsiliasi jadwal pada setiap app start.
- **`applicationId` masih `com.example.flutter_gluko_apps`** dan `minSdk` masih memakai default Flutter (24), padahal NFR-01 menuntut API 26.

---

## 4. Arsitektur Target

Clean Architecture *feature-first* sesuai PRD bagian 7, dengan aturan dependensi `presentation → domain ← data → infrastructure`. Domain murni Dart.

```
lib/
├── main.dart · app.dart
├── core/
│   ├── di/           injection.dart (get_it + injectable)
│   ├── error/        failures.dart, exceptions.dart
│   ├── usecase/      usecase.dart
│   ├── router/       app_router.dart (go_router, deep link notifikasi)
│   ├── theme/        app_colors.dart, app_typography.dart, app_theme.dart, status_style.dart
│   ├── utils/        unit_converter.dart, date_utils.dart, local_date.dart
│   └── widgets/      status_badge.dart, glucose_value_text.dart, app_card.dart,
│                     segmented_tabs.dart, filter_chip_row.dart, empty_state.dart
├── database/
│   ├── app_database.dart      @DriftDatabase + stepByStep migration + SQLCipher
│   ├── tables/                glucose_readings, reading_symptoms, target_ranges,
│   │                          user_profile, reminders, app_settings
│   └── daos/                  glucose_dao, target_dao, reminder_dao, settings_dao, profile_dao
└── features/
    ├── glucose/   {domain,data,presentation}   F-01, F-02, F-04, F-05
    ├── trend/                                  F-06
    ├── target/                                 F-03
    ├── reminder/                               F-07
    ├── security/                               F-08
    ├── backup/                                 F-09
    ├── onboarding/ profile/                    F-10
    └── settings/                               S-09 (baru, lihat D-1)
```

**Aturan yang ditegakkan lewat lint/test:** `domain` tidak boleh import `flutter`/`drift` · BLoC hanya bergantung pada use case · konversi satuan hanya di presentation · 1 use case = 1 tanggung jawab + 1 unit test.

---

## 5. Rencana Implementasi

7 tahap: **Sprint 0** (fondasi teknis — tambahan dari PRD, karena repo masih scaffold kosong) + Sprint 1–5 sesuai roadmap PRD + v1.1.

### Sprint 0 — Bootstrap ✅ SELESAI (26 September 2026)

Tanpa ini, semua sprint berikutnya menumpuk utang konfigurasi.

| ID | Status | Tugas | Output nyata |
| --- | --- | --- | --- |
| 0.1 | ✅ | Tambah dependensi runtime + dev. **Deviasi:** `sqlcipher_flutter_libs` diganti build hook `sqlite3` (lihat B-5) | `pubspec.yaml`, `pubspec.lock` — 90 + 54 paket ter-resolve |
| 0.2 | ✅ | `very_good_analysis` 11.0.0, `strict-casts`/`strict-inference`/`strict-raw-types`, `docs/**` dikecualikan. Batas layer ditegakkan lewat test, bukan lint | `analysis_options.yaml`, `test/architecture_test.dart` (4 test) |
| 0.3 | ✅ | Plus Jakarta Sans statis 5 weight (400–800) + OFL, diunduh dari repo foundry. **652 KB**, bukan ~1,2 MB seperti perkiraan | `assets/fonts/*.ttf` |
| 0.4 | ✅ | `minSdk = 26`, `applicationId = com.adipurwanto.glukotrack`, label `GlukoTrack`, portrait-only, permission notifikasi/exact-alarm/boot/biometrik. INTERNET tetap hanya di varian debug & profile | `android/app/build.gradle.kts`, `AndroidManifest.xml`, `MainActivity.kt` dipindah paket |
| 0.5 | ✅ | `allowBackup=false` + aturan cloud-backup & device-transfer dikecualikan | `res/xml/backup_rules.xml`, `res/xml/data_extraction_rules.xml` |
| 0.6 | ✅ | Palet terang **dan gelap** sebagai `ThemeExtension`, aksen per tipe pengukuran, skala tipografi lengkap dengan tabular figures, spacing/radius/ukuran komponen | `lib/core/theme/` (4 berkas) |
| 0.7 | ✅ | `core/error` (sealed `Failure`, termasuk `DuplicateFastingFailure` untuk B-4), `core/usecase`, `core/di` (get_it + injectable, config ter-generate), `core/router` (go_router `StatefulShellRoute`), shell 4 tab + 4 halaman placeholder | `lib/core/`, `lib/features/*/presentation/pages/`, `lib/app.dart`, `lib/main.dart` |
| 0.8 | ✅ | CI dua job: analyze+test (dengan `--fatal-infos` dan artefak coverage) lalu build APK debug | `.github/workflows/ci.yml` |

**Hasil gate:** `flutter analyze --fatal-infos` → **No issues found** · `flutter test` → **7/7 lulus** · `dart format` bersih · build APK debug diverifikasi terpisah.

**Catatan:** repo ini belum berupa git repository, jadi workflow CI baru aktif setelah `git init` + remote GitHub.

### Sprint 1 (minggu 1–2) — Database, Onboarding, Profil · F-10

| ID | Tugas |
| --- | --- |
| 1.1 | 6 tabel drift sesuai DDL PRD 8.2, termasuk semua `CHECK`, index parsial, dan `ux_fasting_per_day` |
| 1.2 | `AppDatabase`: `schemaVersion = 1`, `beforeOpen` (`foreign_keys=ON`, `journal_mode=WAL`), `onCreate` seed (3 baris `target_ranges` + pengingat puasa 06.00) |
| 1.3 | Integrasi SQLCipher (lihat B-5): kunci acak 256-bit dibuat sekali, disimpan di `flutter_secure_storage`, lalu `PRAGMA key` di `beforeOpen`. Tidak perlu `open.overrideFor` karena pustaka ter-bundle sudah varian SQLCipher |
| 1.4 | Setup `drift_dev schema dump` + `SchemaVerifier` (fondasi migration test) |
| 1.5 | DAO + entity + mapper + repository untuk `profile`, `target`, `settings` |
| 1.6 | Domain: `CompleteOnboarding`, `GetProfile`, `UpdateProfile`, `ApplyPreset` (jenis diabetes → preset, aturan PRD 5.1) |
| 1.7 | UI onboarding 4 langkah persis `Onboarding.dc.html` (progress segmen, disclaimer checkbox wajib, pilih satuan, jam pengingat puasa) |
| 1.8 | Job purge `deleted_at > 30 hari` saat app start |

**Gate:** onboarding selesai → profil + 3 target tersimpan · DB terenkripsi terverifikasi (file mentah tidak mengandung header SQLite) · unit test domain ≥ 90%.

### Sprint 2 (minggu 3–4) — Catat, Klasifikasi, Target & Satuan · F-01, F-02, F-03

| ID | Tugas |
| --- | --- |
| 2.1 | Entity `GlucoseReading` (freezed) + enum `ReadingType`, `GlucoseStatus`, `MealContext`, `Symptom` |
| 2.2 | `ClassifyReading` (pure) + `UnitConverter` — dua unit test terpadat di proyek ini (batas 69/70/99/100/125/126, 54, 300, round-trip mmol/L) |
| 2.3 | `AddReading`: validasi 20–600, waktu tidak di masa depan / maks −1 tahun, cek GDP ganda (B-4), ambil target aktif, klasifikasi, simpan transaksional bersama `reading_symptoms` |
| 2.4 | `GlucoseRepositoryImpl` + `GlucoseDao` + mapper (termasuk `local_date` & `tz_offset_min`) |
| 2.5 | `ReadingFormCubit`: status live saat mengetik, saran tipe default (jam 04–09 dan GDP hari itu belum ada → Puasa), toggle puasa-8-jam |
| 2.6 | `InputSheet` persis `Catat.dc.html` + kekurangannya (§3.3): catatan 500 char, `hours_after_meal` untuk 2JPP, sheet gejala lengkap, keypad adaptif satuan |
| 2.7 | Dialog GDP ganda (ganti / jadikan Sewaktu / batal) |
| 2.8 | Layar S-05 hasil tersimpan + microcopy status PRD 6.5 |
| 2.9 | Halaman Target persis `Target.dc.html`: preset Umum/Diabetes/Kustom, validasi `low < normal < warning`, bar pratinjau, "Kembalikan ke default", toggle satuan global, aksi "Hitung ulang status" |

**Gate:** seluruh AC F-01/F-02/F-03 lolos · input GDP terukur ≤ 10 detik dan simpan ≤ 200 ms · bloc_test untuk form & target.

### Sprint 3 (minggu 5–6) — Dashboard & Riwayat · F-04, F-05

| ID | Tugas |
| --- | --- |
| 3.1 | `WatchDashboardSummary`: GDP hari ini, GDS terakhir, rata-rata 7 hari per tipe + delta vs 7 hari sebelumnya, seri sparkline, 5 catatan terakhir — **satu stream drift**, bukan 5 query terpisah |
| 3.2 | `DashboardPage` persis `Main.dc.html`, termasuk empty state PRD 6.5 |
| 3.3 | `GetReadings` berpaginasi 30 item + filter tipe/status/rentang tanggal |
| 3.4 | `HistoryPage` list ter-grup per tanggal + lazy load + chip filter |
| 3.5 | Tampilan Kalender (D-2): titik warna = status terburuk per hari |
| 3.6 | Detail catatan (S-07) + `UpdateReading` + `SoftDeleteReading` + konfirmasi hapus + **Undo 5 detik** |
| 3.7 | Uji performa: seed 10.000 baris, ukur dashboard & riwayat (NFR-02/03) |

**Gate:** query dashboard & riwayat ≤ 300 ms @10k baris · undo bekerja · reaktivitas stream terbukti (simpan di sheet → dashboard & riwayat ikut berubah tanpa refresh manual).

### Sprint 4 (minggu 7–8) — Tren, Pengingat, Kunci, Backup · F-06 – F-09

| ID | Tugas |
| --- | --- |
| 4.1 | `GetTrendSeries` (7/14/30/90) + statistik periode (avg, min, maks, count, TIR per tipe) |
| 4.2 | `TrendPage` dengan `fl_chart`: pita target, titik berwarna per status, toggle GDP/GDS, tap titik → nilai/tanggal/jam, **skala Y dinamis** (§3.3) |
| 4.3 | Reminder domain + `NotificationService` (`flutter_local_notifications` + `timezone`): jadwal harian & per-hari (`days_mask`), bertahan setelah reboot, deep link `go_router` ke form dengan tipe terisi |
| 4.4 | Logika lewati-pengingat-puasa via reschedule (§3.3) + panduan izin exact alarm / whitelist baterai |
| 4.5 | App lock: PIN 6 digit (hash PBKDF2/Argon2 + salt di secure storage), `local_auth` BiometricPrompt, auto-lock setelah > 1 menit background, `FLAG_SECURE` untuk menyembunyikan konten di app switcher |
| 4.6 | Backup: ekspor `.gtbak` (format B-2) via `share_plus`; restore dengan validasi magic + `schema_version` + checksum + konfirmasi timpa; versi lebih baru ditolak, lebih lama dimigrasi |
| 4.7 | `last_backup_at` di Pengaturan + nudge bila > 30 hari |
| 4.8 | Halaman Pengaturan S-09 (D-1) + S-11 daftar pengingat |

**Gate:** notifikasi hidup setelah reboot di perangkat fisik · backup → wipe → restore menghasilkan data identik · lupa-PIN punya jalan keluar.

### Sprint 5 (minggu 9–10) — Pengerasan & Rilis MVP

| ID | Tugas |
| --- | --- |
| 5.1 | Audit aksesibilitas: text scale 200% di semua layar, label `Semantics`, kontras WCAG AA, target sentuh ≥ 48 dp |
| 5.2 | Golden test light + dark untuk 6 layar utama |
| 5.3 | Integration test alur penuh: onboarding → catat GDP → dashboard → edit → hapus/undo → backup/restore |
| 5.4 | Profiling di perangkat Android fisik: cold start ≤ 2 s, 60 fps saat scroll riwayat, ukuran APK ≤ 25 MB (`--analyze-size`); cek juga app bundle (AAB) untuk rilis Play |
| 5.5 | Migration test `SchemaVerifier` · `flutter analyze` 0 warning · gate coverage (domain 90 / data 80 / total 70) |
| 5.6 | Lokalisasi: ekstrak semua string ke `gen-l10n` (ID default, EN siap), format angka/tanggal `id_ID` |
| 5.7 | Disclaimer medis di Pengaturan → Tentang (teks PRD 10.4, verbatim) · ikon & nama aplikasi final · keystore release + signing config (ganti `signingConfigs.getByName("debug")` yang masih dipakai build release sekarang) |
| 5.8 | Beta internal via Play Console internal testing + isi Data safety form (deklarasi: tidak ada data yang dikumpulkan/dikirim) |

### v1.1 (minggu 11–16)

F-11 peringatan ekstrem + kontak darurat · F-12 laporan PDF (`pdf`/`printing`) + ekspor CSV · F-13 TIR & GMI (`3,31 + 0,02392 × rata-rata`, minimal 14 pembacaan per 30 hari) · F-14 log obat/makanan/aktivitas/berat/HbA1c lab (7 tabel baru → `schemaVersion = 2`) · F-15 pengingat obat.

### Pasca-MVP — dukungan iOS (bila jadi dilanjutkan)

Ditunda per keputusan B-3, bukan dibatalkan. Ruang lingkupnya kelak: `flutter create --platforms=ios .`, Keychain untuk kunci DB, `NSFaceIDUsageDescription`, pengganti `FLAG_SECURE` (overlay blur saat `resignActive`), verifikasi perilaku notifikasi terjadwal iOS, dan penyesuaian golden test. Perkiraan 1,5–2 minggu **jika** disiplin batas layer di B-3 dijaga; jauh lebih mahal bila tidak.

---

## 6. Strategi Testing

| Lapisan | Alat | Cakupan wajib |
| --- | --- | --- |
| Domain | `test` + `mocktail` | Semua use case; `ClassifyReading` dengan uji batas; `UnitConverter` round-trip; validasi rentang & waktu |
| Data / DAO | `NativeDatabase.memory()` | CRUD, soft delete + purge, `ux_fasting_per_day` (termasuk tabrakan saat undo/restore), agregasi dashboard & tren |
| BLoC | `bloc_test` | dashboard, form input, riwayat + filter, target, reminder |
| Widget | `flutter_test` | input sheet, status badge, empty state, text scale 200% |
| Golden | `flutter_test` | 6 layar utama × light/dark |
| Migrasi | `SchemaVerifier` | setiap kenaikan `schemaVersion` |
| Integrasi | `integration_test` | alur end-to-end Sprint 5.3 |

---

## 7. Risiko Teknis

| Risiko | Mitigasi |
| --- | --- |
| SQLCipher + drift salah konfigurasi → DB terbuka tanpa enkripsi tanpa gejala terlihat | Test yang membaca file DB mentah dan memastikan header bukan `SQLite format 3` |
| `flutter_local_notifications` dimatikan battery optimizer OEM (Xiaomi/Oppo/Vivo) | Minta izin exact alarm eksplisit + halaman panduan whitelist per merek + uji di perangkat fisik, bukan emulator |
| Kunci DB hilang saat Android auto-backup memulihkan file DB tanpa isi Keystore → DB terpulihkan tapi tidak bisa dibuka | Tugas 0.5: kecualikan DB dari auto-backup lewat `backup_rules.xml`; pemulihan resmi hanya lewat `.gtbak` |
| Freezed 3.x mengubah sintaks (`abstract class ... with _$X`) | Pin versi di Sprint 0 dan pakai satu gaya konsisten sejak entity pertama |
| `local_date` ganda atau hilang saat pengguna berpindah zona waktu | Selalu turunkan `local_date` dari `measured_at + tz_offset_min`; test khusus pergantian zona |
| Uji performa @10k baris baru jalan di Sprint 3, terlambat untuk mengubah skema | Seed dataset 10k dibuat sejak Sprint 1 dan diukur setiap sprint |

---

## 8. Yang Perlu Diputuskan

- [x] ~~**B-3** MVP Android saja, atau Android + iOS?~~ → **Android saja**, diputuskan 26 September 2026. iOS jadi item pasca-MVP.
- [ ] **B-2** Setuju backup memakai passphrase pengguna (bisa dipulihkan di HP baru) alih-alih kunci Keystore?
- [x] ~~**B-1** Bundle TTF Plus Jakarta Sans lokal~~ → **selesai di Sprint 0.3**: 5 weight statis (400/500/600/700/800) + OFL diambil dari repo foundry `tokotype/PlusJakartaSans`, total 652 KB, terdaftar di `pubspec.yaml`. `google_fonts` tidak dipakai.
- [ ] Tipe "2 Jam PP" masuk MVP atau ditunda? (PRD 10.3 masih terbuka; desain sudah memuatnya di 3 layar, jadi rekomendasi: **masuk MVP**)
- [ ] Nama aplikasi final. Sprint 0.4 memakai **`com.adipurwanto.glukotrack`** dan label **GlukoTrack** sebagai nilai kerja — mudah diganti sekarang, **tidak bisa** diganti setelah rilis pertama ke Play (applicationId permanen), jadi konfirmasikan sebelum Sprint 5.8.
- [ ] **D-1/D-2/D-3** Layar Pengaturan, Kalender, Splash/Kunci, Detail: diturunkan dari bahasa visual yang ada, atau didesain dulu?

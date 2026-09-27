# GlukoTrack — Checklist Rilis MVP (Sprint 5.4, 5.7, 5.8)

Dokumen ini berisi langkah yang **harus dilakukan manusia** sebelum rilis:
keputusan produk, keystore, pengujian di perangkat fisik, dan Play Console.
Semua yang bisa diotomasi sudah ada di test (lihat bagian terakhir).

## 1. Keputusan yang masih terbuka

- [ ] **Nama & applicationId final.** Saat ini `com.adipurwanto.glukotrack` /
      "GlukoTrack". applicationId **tidak bisa diganti** setelah rilis pertama.
- [ ] **Ikon aplikasi final** (masih ikon bawaan Flutter di `mipmap-*`).
- [ ] **D-1/D-2/D-3** — layar tanpa desain (Pengaturan, Kalender, Kunci,
      Detail, Pengingat, Backup, Tentang) diturunkan dari bahasa visual yang
      ada. Tinjau golden di `test/golden/goldens/`.

## 2. Keystore rilis (5.7)

```bash
keytool -genkey -v -keystore android/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Buat `android/key.properties` (sudah di-.gitignore, **jangan di-commit**):

```properties
storeFile=../upload-keystore.jks
storePassword=<kata sandi>
keyAlias=upload
keyPassword=<kata sandi>
```

Simpan keystore + kata sandi di pengelola kata sandi. Aktifkan **Play App
Signing** agar kehilangan upload key masih bisa dipulihkan.
Tanpa `key.properties`, build rilis memakai kunci debug dan Gradle
menampilkan peringatan "Jangan unggah ke Play".

Build untuk Play: `flutter build appbundle --release`

## 3. Uji di perangkat fisik (5.4 dan gate Sprint 4)

Disarankan 1 HP "bersih" + 1 HP OEM dengan penghemat baterai agresif
(Xiaomi/OPPO/vivo).

- [ ] Cold start ≤ 2 detik (`flutter run --profile`, ukur dari ikon ke beranda)
- [ ] Scroll Riwayat 60 fps dengan ±10.000 catatan (DevTools › Performance)
- [ ] Notifikasi pengingat berbunyi tepat waktu, **juga setelah reboot**
- [ ] Tap notifikasi membuka form catat dengan tipe terisi (aplikasi mati & hidup)
- [ ] Pengingat puasa tidak berbunyi bila GDP hari itu sudah dicatat
- [ ] Izin "Alarm & pengingat" dan whitelist baterai (panduan di layar Pengingat)
- [ ] Biometrik: aktifkan, kunci (background > 1 menit), buka dengan sidik jari
- [ ] App switcher menampilkan layar kosong saat kunci aktif (FLAG_SECURE)
- [ ] Backup → bagikan ke Google Drive → hapus aplikasi → pasang lagi →
      "Punya file backup? Pulihkan" → data kembali
- [ ] TalkBack: semua tombol terbaca, urutan fokus masuk akal
- [ ] Integration test di perangkat: `flutter test integration_test/app_flow_test.dart`

### Ukuran (diukur 27 Sep 2026, `--analyze-size`, arm64)

| Artefak | Ukuran |
| --- | --- |
| `app-release.apk` (arm64-v8a saja) | 26,4 MB |
| └ `libflutter.so` | 11,2 MB |
| └ `libapp.so` (kode Dart AOT) | 8,4 MB |
| └ `libsqlcipher.so` (SQLCipher + OpenSSL) | 4,8 MB |

NFR "APK ≤ 25 MB" terlewati 1,4 MB. Library native di APK modern disimpan
**tanpa kompresi** (agar bisa di-mmap), jadi ukuran unduh via Play (AAB +
kompresi transfer) jauh lebih kecil — ukur ulang di Play Console › App size
setelah AAB pertama diunggah. Opsi bila tetap perlu mengecil:
`packaging.jniLibs.useLegacyPackaging = true` (APK ±12 MB, tetapi .so
diekstrak saat instal sehingga memakan penyimpanan lebih besar).

## 4. Play Console — Data safety form (5.8)

| Pertanyaan | Jawaban | Dasar |
| --- | --- | --- |
| Apakah aplikasi mengumpulkan atau membagikan data pengguna? | **Tidak** | Tidak ada akun, analitik, iklan, maupun server; build rilis tidak meminta izin `INTERNET` (NFR-04) |
| Data dienkripsi saat transit? | Tidak berlaku | Tidak ada transmisi |
| Pengguna bisa meminta penghapusan data? | Ya | Data hanya di perangkat; hapus lewat uninstall atau "Lupa PIN › Hapus semua data" |

Catatan untuk reviewer: data kesehatan tersimpan lokal terenkripsi
(SQLCipher, kunci di Android Keystore). File backup `.gtbak` dibuat atas
tindakan pengguna, dienkripsi passphrase pengguna, dan dikirim ke tujuan
yang dipilih pengguna sendiri lewat share sheet Android.

Deklarasi izin sensitif:
- `SCHEDULE_EXACT_ALARM` — pengingat cek gula darah pada jam yang dipilih
  pengguna (fungsi inti; `USE_EXACT_ALARM` sengaja tidak dipakai).
- `USE_BIOMETRIC` — membuka kunci aplikasi.
- `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED` — pengingat bertahan setelah reboot.

Kategori & konten: Kesehatan & Kebugaran. Cantumkan disclaimer medis
(PRD 10.4, sama dengan Pengaturan › Tentang) di deskripsi toko.

## 5. Internal testing

- [ ] Unggah AAB ke track **Internal testing**, undang penguji via email
- [ ] Minimal 1 minggu pemakaian nyata sebelum Closed/Production

## 6. Yang sudah diverifikasi otomatis (CI)

`flutter analyze --fatal-infos`, `dart format`, lalu `flutter test`:
domain/data/cubit, enkripsi DB (berkas mentah bukan SQLite polos),
SchemaVerifier v1, performa 10.000 baris (≤ 300 ms), audit aksesibilitas
12 layar (text scale 200%, target sentuh, label, kontras AA terang/gelap),
golden 6 layar × 2 tema, alur penuh onboarding → catat → edit → hapus/undo
→ backup/restore, dan disclaimer = PRD 10.4 verbatim.

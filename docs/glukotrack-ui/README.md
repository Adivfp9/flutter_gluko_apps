# GlukoTrack — Paket UI

- `PRD-GlukoTrack.md` — PRD lengkap.
- `design/*.dc.html` — sumber 6 layar preview (Onboarding, Beranda/Main, Catat, Riwayat, Tren, Target).
  Semua ukuran, warna, jarak, dan radius ada di atribut `style` inline; data contoh dan logika status ada di blok `<script>` bawah.
  File ini butuh runtime kanvas, jadi buka lewat kanvas atau baca sebagai referensi spesifikasi.
- `flutter/app_theme.dart` — design tokens (warna, status, radius, tipografi) siap dipakai di `lib/core/theme/`.

Pemetaan layar → Flutter (lihat PRD bagian 7.2):
| Layar | File design | Halaman Flutter |
| --- | --- | --- |
| Onboarding | Onboarding.dc.html | features/onboarding/presentation/pages/disclaimer_page.dart |
| Beranda | Main.dc.html | features/glucose/presentation/pages/dashboard_page.dart |
| Catat | Catat.dc.html | features/glucose/presentation/widgets/input_sheet.dart |
| Riwayat | Riwayat.dc.html | features/glucose/presentation/pages/history_page.dart |
| Tren | Tren.dc.html | features/trend/presentation/pages/trend_page.dart |
| Target | Target.dc.html | features/target/presentation/pages/target_page.dart |

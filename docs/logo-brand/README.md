# GlukoTrack — Aset Brand (Opsi 3 · Teal Gelap)

| Token | Hex | Pakai untuk |
| --- | --- | --- |
| primaryDark | #0B5F66 | Latar ikon, splash, "Track" di wordmark |
| primarySoft | #DDF1F2 | Cincin huruf G |
| status.normal | #4ADE80 | Segmen zona target |
| textPrimary | #1F2933 | "Gluko" di wordmark |

## Isi
- `svg/` — vektor master: icon-rounded, icon-square (full-bleed), icon-round, adaptive-foreground & monochrome (108×108, glyph di dalam safe zone 66dp), glyph, logo horizontal (warna, putih untuk latar gelap, mono). Wordmark sudah dikonversi ke outline (Plus Jakarta Sans ExtraBold), jadi tidak butuh font terpasang.
- `png/ios/` — AppIcon 20–1024 px (tanpa sudut bulat, tanpa transparansi; iOS membulatkan sendiri).
- `png/android/mipmap-*/` — ic_launcher, ic_launcher_round, ic_launcher_foreground, ic_launcher_monochrome (Android 13 themed icon); `playstore-512.png`.
- `png/logo/` — logo horizontal @2x (warna & putih) dan preview ikon.
- `flutter/` — `assets/icon/*` + `pubspec_snippet.yaml` untuk flutter_launcher_icons & flutter_native_splash.

## Aturan pakai singkat
- Ruang kosong minimal di sekitar logo = tinggi ikon × 0,25.
- Logo putih hanya di atas #0B5F66 atau latar gelap ≥ #1F2933.
- Jangan ubah warna segmen hijau: itu penanda "dalam target", konsisten dengan status Normal di aplikasi.

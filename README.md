# Responsi Profil Mahasiswa

Proyek Flutter untuk responsi praktikum Pemrograman Mobile.

## Persiapan

- Flutter SDK dan Dart SDK
- Git

Periksa instalasi dengan `flutter doctor`, lalu jalankan:

```shell
Copy-Item .env.example .env
flutter pub get
flutter run
```

Jangan isi `.env` dengan kredensial sungguhan dan jangan commit file tersebut.
Gunakan `.env.example` sebagai template konfigurasi.

## Soal 1 — Struktur sumber

```text
lib/
├── main.dart
├── config/
│   └── app_config.dart
├── models/
│   ├── student.dart
│   └── note.dart
├── repositories/
│   └── note_repository.dart
├── providers/
│   └── app_provider.dart
├── screens/
│   ├── home_screen.dart
│   ├── profile_screen.dart
│   ├── note_form_screen.dart
│   └── public_users_screen.dart
├── services/
│   └── secure_storage_service.dart
├── utils/
│   └── validators.dart
└── widgets/
    ├── profile_card.dart
    ├── note_card.dart
    └── empty_state.dart
```

Metadata catatan disimpan sebagai JSON di SharedPreferences, sedangkan isi
catatan disimpan melalui secure storage. Data pengguna publik dimuat dari API
yang URL-nya ditentukan oleh `.env` melalui halaman Data Pengguna API.

## Navigasi dan UI

Home menampilkan ringkasan profil mahasiswa dan daftar catatan. Tombol pada
AppBar membuka profil atau halaman data pengguna API; tombol Tambah Catatan
membuka formulir dan menampilkan konfirmasi setelah penyimpanan berhasil.
Penghapusan catatan meminta konfirmasi terlebih dahulu. Tampilan memuat,
kosong, dan gagal memuat ditangani secara terpisah, dengan tema Material 3
terpusat di `main.dart`.

## Pemetaan soal ke file dan baris

Rentang baris di bawah bersifat inklusif dan dihitung dari versi kode saat ini.
Komentar `Soal N` ditambahkan di bagian terkait; file hasil generate disebutkan
tanpa komentar inline agar tidak mengubah file yang dikelola Flutter.

### Soal 1 — Instalasi, struktur proyek, dan Git

- `.gitignore`: 1–27 dan 30–51; `analysis_options.yaml`: 1–39.
- `pubspec.yaml`: 1–37, 43–64, dan 67–98.
- `lib/main.dart`: 1–9 (entry point dari scaffold).
- `README.md`: 5–52 (persiapan dan struktur folder proyek).

### Soal 2 — Profil mahasiswa

- `lib/models/student.dart`: 1–25.
- `lib/screens/profile_screen.dart`: 7–27 dan 31–195 (layar serta dialog edit).
- `lib/widgets/profile_card.dart`: 1–113.

### Soal 3 — Catatan, provider, validasi, dan sanitasi

- `lib/models/note.dart`: 1–25; `lib/utils/validators.dart`: 1–43.
- `lib/providers/app_provider.dart`: 10–108 (state aplikasi).
- `lib/screens/note_form_screen.dart`: 7–45 dan 61–130 (form dan validasi).
- `lib/screens/profile_screen.dart`: 28–30; `lib/main.dart`: 12–14.

### Soal 4 — Konfigurasi, penyimpanan aman, dan HTTP

- `lib/config/app_config.dart`: 1–38; `lib/repositories/note_repository.dart`: 1–111.
- `lib/services/secure_storage_service.dart`: 1–32; `lib/services/public_api_service.dart`: 1–89.
- `lib/screens/public_users_screen.dart`: 1–91.
- `lib/providers/app_provider.dart`: 109–141 dan 155–207.
- `lib/screens/note_form_screen.dart`: 46–58; `lib/screens/home_screen.dart`: 165–170.
- `lib/main.dart`: 10–11; `.env.example`: 1–3; `.gitignore`: 28–29.
- `pubspec.yaml`: 38–42 dan 65–66; `android/app/src/main/AndroidManifest.xml`: 2–8.
- File hasil generate Soal 4: `pubspec.lock` 1–570; `linux/flutter/generated_plugin_registrant.cc`
  1–15; `linux/flutter/generated_plugins.cmake` 1–25;
  `macos/Flutter/GeneratedPluginRegistrant.swift` 1–14;
  `windows/flutter/generated_plugin_registrant.cc` 1–14; dan
  `windows/flutter/generated_plugins.cmake` 1–25. Jangan menambah komentar
  manual ke file-file generate ini.

### Soal 5 — Integrasi UI, navigasi, dan dokumentasi

- `lib/screens/home_screen.dart`: 11–164 dan 171–218.
- `lib/widgets/note_card.dart`: 1–66; `lib/widgets/empty_state.dart`: 1–38.
- `lib/providers/app_provider.dart`: 142–154; `lib/screens/note_form_screen.dart`: 59–60.
- `lib/main.dart`: 15–34 (tema terpusat dan layar awal).

## Alur Git per soal

Perintah berikut mendokumentasikan alur pengerjaan dari awal. Jangan jalankan
ulang `git init` atau `git switch -c` jika repository dan branch tersebut sudah
ada. Periksa `git status --short` sebelum staging. File `.env` tidak pernah
ditambahkan; hanya `.env.example` yang boleh di-commit.

### Soal 1 — Inisialisasi, remote, commit, dan push

Jalankan hanya saat membuat repository lokal baru:

```powershell
cd D:\pemrog\responsi_profil_mahasiswa
git init -b master
git add .gitignore .metadata README.md analysis_options.yaml pubspec.yaml pubspec.lock android ios linux macos web windows lib
git diff --cached --stat
git commit -m "chore: setup Flutter project structure"
git remote add origin https://github.com/EkaFajarRahmadani/P1.git
git push -u origin master
```

Jika `origin` sudah ada, lewati `git remote add`.

### Soal 2 — Branch profil

```powershell
git switch master
git switch -c fitur-profil
git add lib/main.dart lib/models/student.dart lib/screens/profile_screen.dart lib/widgets/profile_card.dart
git diff --cached --stat
git commit -m "feat: implement editable student profile"
git push -u origin fitur-profil
```

### Soal 3 — Branch catatan dan validasi

```powershell
git switch fitur-profil
git switch -c fitur-catatan
git add lib/main.dart lib/models/note.dart lib/providers/app_provider.dart lib/screens/profile_screen.dart lib/screens/note_form_screen.dart lib/utils/validators.dart
git diff --cached --stat
git commit -m "feat: add note state and validated form"
git push -u origin fitur-catatan
```

### Soal 4 — Secure storage dan HTTP

Lanjutkan di branch `fitur-catatan`:

```powershell
git switch fitur-catatan
git add .env.example .gitignore README.md pubspec.yaml pubspec.lock android/app/src/main/AndroidManifest.xml lib/config/app_config.dart lib/main.dart lib/providers/app_provider.dart lib/repositories/note_repository.dart lib/screens/home_screen.dart lib/services/public_api_service.dart lib/services/secure_storage_service.dart linux/flutter/generated_plugin_registrant.cc linux/flutter/generated_plugins.cmake macos/Flutter/GeneratedPluginRegistrant.swift windows/flutter/generated_plugin_registrant.cc windows/flutter/generated_plugins.cmake
git diff --cached --stat
git commit -m "feat: add secure note storage and API integration"
git push origin fitur-catatan
```

### Soal 5 — Integrasi UI dan navigasi

Lanjutkan di branch `fitur-catatan` yang sama:

```powershell
git switch fitur-catatan
git add README.md lib/main.dart lib/providers/app_provider.dart lib/screens/home_screen.dart lib/screens/note_form_screen.dart lib/screens/public_users_screen.dart lib/widgets/empty_state.dart lib/widgets/note_card.dart
git diff --cached --stat
git commit -m "feat: integrate notes home UI and navigation"
git push origin fitur-catatan
```

### Merge branch fitur

Setelah semua soal selesai, sinkronkan `master`, merge kedua branch, lalu push:

```powershell
git switch master
git pull --no-rebase origin master
git merge --no-ff fitur-profil -m "merge: fitur-profil into master"
git merge --no-ff fitur-catatan -m "merge: fitur-catatan into master"
git push origin master
```

Di repository ini kedua branch sudah di-merge ke `master`; perintah di atas
hanya sebagai catatan alur Git dan tidak perlu dijalankan ulang.

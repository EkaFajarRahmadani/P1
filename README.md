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

## Struktur sumber

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

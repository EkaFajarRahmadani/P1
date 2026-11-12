# Responsi Profil Mahasiswa

Proyek Flutter untuk responsi praktikum Pemrograman Mobile.

## Persiapan

- Flutter SDK dan Dart SDK
- Git

Periksa instalasi dengan `flutter doctor`, lalu jalankan:

```shell
flutter pub get
flutter run
```

Jalankan pengujian dengan `flutter test`.

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
│   └── note_form_screen.dart
├── services/
│   └── secure_storage_service.dart
├── utils/
│   └── validators.dart
└── widgets/
    ├── profile_card.dart
    ├── note_card.dart
    └── empty_state.dart
```

File fitur disiapkan sebagai kerangka dan akan diimplementasikan bertahap.

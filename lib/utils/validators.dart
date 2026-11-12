/// Soal 3: validates and sanitizes user-provided profile and note form values.
abstract final class Validators {
  Validators._();

  /// Validates a title after sanitizing it: 3 to 50 characters are required.
  static String? validateTitle(String? value) {
    final title = sanitize(value ?? '').trim();
    if (title.isEmpty) {
      return 'Judul wajib diisi';
    }
    if (title.length < 3) {
      return 'Judul minimal 3 karakter';
    }
    if (title.length > 50) {
      return 'Judul maksimal 50 karakter';
    }
    return null;
  }

  /// Validates note content after sanitizing it: 10 to 1000 characters.
  static String? validateContent(String? value) {
    final content = sanitize(value ?? '').trim();
    if (content.isEmpty) {
      return 'Isi catatan wajib diisi';
    }
    if (content.length < 10) {
      return 'Isi catatan minimal 10 karakter';
    }
    if (content.length > 1000) {
      return 'Isi catatan maksimal 1000 karakter';
    }
    return null;
  }

  /// Removes angle brackets and quote characters from user input.
  static String sanitize(String value) {
    return value
        .replaceAll('<', '')
        .replaceAll('>', '')
        .replaceAll('"', '')
        .replaceAll("'", '');
  }
}

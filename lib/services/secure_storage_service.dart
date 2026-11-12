import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Soal 4: stores note bodies using the platform's encrypted key-value storage.
class SecureStorageService {
  /// Creates a secure storage service.
  SecureStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  /// Encrypts and saves [content] under the key `note_content_<noteId>`.
  Future<void> saveContent(String noteId, String content) async {
    await _storage.write(key: _contentKey(noteId), value: content);
  }

  /// Reads encrypted content for [noteId], or returns `null` if absent.
  Future<String?> getContent(String noteId) {
    return _storage.read(key: _contentKey(noteId));
  }

  /// Deletes encrypted content for [noteId].
  Future<void> deleteContent(String noteId) async {
    await _storage.delete(key: _contentKey(noteId));
  }

  String _contentKey(String noteId) {
    if (noteId.trim().isEmpty) {
      throw ArgumentError.value(noteId, 'noteId', 'must not be empty');
    }
    return 'note_content_$noteId';
  }
}

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/note.dart';
import '../services/secure_storage_service.dart';

/// Soal 4: persists note metadata separately from encrypted note content.
class NoteRepository {
  /// Creates a repository using encrypted platform storage for note bodies.
  NoteRepository({SecureStorageService? secureStorage})
    : _secureStorage = secureStorage ?? SecureStorageService();

  static const String _metadataKey = 'study_notes_metadata';
  final SecureStorageService _secureStorage;

  /// Returns notes by combining JSON metadata with encrypted content.
  Future<List<Note>> getNotes() async {
    final preferences = await SharedPreferences.getInstance();
    final metadata = _decodeMetadata(preferences.getString(_metadataKey));
    final notes = <Note>[];

    for (final entry in metadata) {
      final id = entry['id'] as String;
      final content = await _secureStorage.getContent(id);
      if (content == null) {
        throw StateError('Encrypted content for a saved note is missing.');
      }
      notes.add(
        Note(
          id: id,
          title: entry['title'] as String,
          content: content,
          createdAt: DateTime.parse(entry['date'] as String),
        ),
      );
    }
    return List<Note>.unmodifiable(notes);
  }

  /// Saves encrypted content and JSON metadata for [note].
  Future<void> saveNote(Note note) async {
    final preferences = await SharedPreferences.getInstance();
    final metadata = _decodeMetadata(preferences.getString(_metadataKey));

    await _secureStorage.saveContent(note.id, note.content);
    metadata.removeWhere((entry) => entry['id'] == note.id);
    metadata.add({
      'id': note.id,
      'title': note.title,
      'date': note.createdAt.toIso8601String(),
    });

    final saved = await preferences.setString(
      _metadataKey,
      jsonEncode(metadata),
    );
    if (!saved) {
      throw StateError('Note metadata could not be saved.');
    }
  }

  /// Deletes note metadata and encrypted content for [noteId].
  Future<void> deleteNote(String noteId) async {
    final preferences = await SharedPreferences.getInstance();
    final metadata = _decodeMetadata(preferences.getString(_metadataKey))
      ..removeWhere((entry) => entry['id'] == noteId);

    final saved = await preferences.setString(
      _metadataKey,
      jsonEncode(metadata),
    );
    if (!saved) {
      throw StateError('Note metadata could not be updated.');
    }
    await _secureStorage.deleteContent(noteId);
  }

  List<Map<String, dynamic>> _decodeMetadata(String? encoded) {
    if (encoded == null) {
      return [];
    }
    final Object? decoded = jsonDecode(encoded);
    if (decoded is! List) {
      throw const FormatException('Saved note metadata must be a JSON list.');
    }

    return decoded
        .map((entry) {
          if (entry is! Map) {
            throw const FormatException(
              'Saved note metadata entry is invalid.',
            );
          }
          final id = entry['id'];
          final title = entry['title'];
          final date = entry['date'];
          if (id is! String ||
              id.isEmpty ||
              title is! String ||
              date is! String) {
            throw const FormatException(
              'Saved note metadata fields are invalid.',
            );
          }
          DateTime.parse(date);
          return <String, dynamic>{'id': id, 'title': title, 'date': date};
        })
        .toList(growable: true);
  }
}

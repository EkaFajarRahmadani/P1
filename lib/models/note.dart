import 'package:flutter/foundation.dart';

/// Stores the data required to display and manage a study note.
@immutable
class Note {
  /// Creates a study note.
  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  /// The unique identifier used to update or delete this note.
  final String id;

  /// The note title.
  final String title;

  /// The note body.
  final String content;

  /// The date and time the note was created.
  final DateTime createdAt;
}

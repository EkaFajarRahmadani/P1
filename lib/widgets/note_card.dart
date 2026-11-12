import 'package:flutter/material.dart';

import '../models/note.dart';

/// Soal 5: displays a saved study note and an action to delete it.
class NoteCard extends StatelessWidget {
  /// Creates a card for [note].
  const NoteCard({
    super.key,
    required this.note,
    required this.onDelete,
    this.isDeleting = false,
  });

  /// The note displayed by this card.
  final Note note;

  /// Called when the user requests note deletion.
  final VoidCallback onDelete;

  /// Whether this note is currently being deleted.
  final bool isDeleting;

  String _formatDate(DateTime date) {
    final localDate = date.toLocal();
    final day = localDate.day.toString().padLeft(2, '0');
    final month = localDate.month.toString().padLeft(2, '0');
    final hour = localDate.hour.toString().padLeft(2, '0');
    final minute = localDate.minute.toString().padLeft(2, '0');
    return '$day/$month/${localDate.year} • $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        title: Text(note.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_formatDate(note.createdAt)),
              const SizedBox(height: 6),
              Text(note.content, maxLines: 3, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
        trailing: isDeleting
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : IconButton(
                tooltip: 'Hapus catatan',
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
              ),
        isThreeLine: true,
      ),
    );
  }
}

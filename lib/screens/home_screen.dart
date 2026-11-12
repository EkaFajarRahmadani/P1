import 'package:flutter/material.dart';

import '../models/note.dart';
import '../providers/app_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/note_card.dart';
import 'note_form_screen.dart';
import 'profile_screen.dart';
import 'public_users_screen.dart';

/// Displays the student summary and saved study notes.
class HomeScreen extends StatefulWidget {
  /// Creates the notes home screen.
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _deletingNoteId;

  Future<void> _openProfile() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (context) => const ProfileScreen()),
    );
  }

  Future<void> _openPublicUsers() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (context) => const PublicUsersScreen()),
    );
  }

  Future<void> _openNoteForm() async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(builder: (context) => const NoteFormScreen()),
    );
    if (mounted && saved == true) {
      _showMessage('Catatan berhasil disimpan.');
    }
  }

  Future<void> _confirmDelete(Note note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus catatan?'),
        content: Text('Catatan "${note.title}" akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      return;
    }

    setState(() {
      _deletingNoteId = note.id;
    });
    try {
      await AppProvider.of(context).deleteNote(note.id);
      if (mounted) {
        _showMessage('Catatan berhasil dihapus.');
      }
    } on StateError {
      if (mounted) {
        _showMessage('Catatan gagal dihapus. Data tersimpan belum siap.');
      }
    } on Exception {
      if (mounted) {
        _showMessage('Catatan gagal dihapus. Silakan coba lagi.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _deletingNoteId = null;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildNotes(AppProvider appProvider) {
    if (appProvider.isLoadingNotes) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Memuat catatan...'),
          ],
        ),
      );
    }

    if (appProvider.notesError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 40,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 12),
              Text(appProvider.notesError!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: appProvider.reloadNotes,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (appProvider.notes.isEmpty) {
      return const EmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
      itemCount: appProvider.notes.length,
      itemBuilder: (context, index) {
        final note = appProvider.notes[index];
        return NoteCard(
          note: note,
          isDeleting: _deletingNoteId == note.id,
          onDelete: () => _confirmDelete(note),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = AppProvider.of(context);
    final student = appProvider.student;
    final displayName = student.name.trim();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Kuliah'),
        actions: [
          IconButton(
            tooltip: 'Data Pengguna API',
            onPressed: _openPublicUsers,
            icon: const Icon(Icons.cloud_outlined),
          ),
          IconButton(
            tooltip: 'Profil Mahasiswa',
            onPressed: _openProfile,
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(
                    displayName.isEmpty ? '?' : displayName[0].toUpperCase(),
                  ),
                ),
                title: Text(
                  displayName.isEmpty ? 'Nama Mahasiswa' : displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text('NIM: ${student.nim}'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Catatan Saya',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            Expanded(child: _buildNotes(appProvider)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openNoteForm,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Catatan'),
      ),
    );
  }
}

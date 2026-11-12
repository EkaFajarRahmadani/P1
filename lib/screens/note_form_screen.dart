import 'package:flutter/material.dart';

import '../models/note.dart';
import '../providers/app_provider.dart';
import '../utils/validators.dart';

/// Provides a validated form for creating a study note.
class NoteFormScreen extends StatefulWidget {
  /// Creates the study note form.
  const NoteFormScreen({super.key});

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final createdAt = DateTime.now();
    final note = Note(
      id: createdAt.microsecondsSinceEpoch.toString(),
      title: Validators.sanitize(_titleController.text).trim(),
      content: Validators.sanitize(_contentController.text).trim(),
      createdAt: createdAt,
    );

    AppProvider.of(context).addNote(note);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Catatan')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                'Catatan Kuliah',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                textCapitalization: TextCapitalization.sentences,
                maxLength: 50,
                validator: Validators.validateTitle,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Isi catatan',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                minLines: 5,
                maxLines: 10,
                maxLength: 1000,
                validator: Validators.validateContent,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _saveNote,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Simpan Catatan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

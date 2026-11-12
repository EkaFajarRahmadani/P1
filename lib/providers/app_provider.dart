import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../models/note.dart';
import '../models/student.dart';
import '../repositories/note_repository.dart';

/// Soal 3: exposes application profile and note state to descendant widgets.
class AppProvider extends InheritedWidget {
  /// Creates a provider for the current application state.
  const AppProvider({
    super.key,
    required this.student,
    required this.notes,
    required this.isLoadingNotes,
    required this.notesError,
    required this.reloadNotes,
    required this.updateStudent,
    required this.addNote,
    required this.deleteNote,
    required super.child,
  });

  /// The current student profile.
  final Student student;

  /// An immutable view of the current notes.
  final List<Note> notes;

  /// Whether saved notes are currently being loaded.
  final bool isLoadingNotes;

  /// A safe message when saved notes could not be loaded.
  final String? notesError;

  /// Reloads the saved notes after a loading error.
  final Future<void> Function() reloadNotes;

  /// Replaces the current student profile.
  final ValueChanged<Student> updateStudent;

  /// Adds a note to the current collection.
  final Future<void> Function(Note) addNote;

  /// Deletes a note by its identifier.
  final Future<void> Function(String) deleteNote;

  /// Returns the nearest [AppProvider] or throws if none is in the tree.
  static AppProvider of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AppProvider>();
    if (provider == null) {
      throw StateError('AppProvider is missing above this BuildContext.');
    }
    return provider;
  }

  @override
  bool updateShouldNotify(AppProvider oldWidget) {
    return student != oldWidget.student ||
        !listEquals(notes, oldWidget.notes) ||
        isLoadingNotes != oldWidget.isLoadingNotes ||
        notesError != oldWidget.notesError;
  }
}

/// Owns application state and exposes it through an [AppProvider].
class AppProviderWrapper extends StatefulWidget {
  /// Creates a wrapper that provides state to [child].
  const AppProviderWrapper({super.key, required this.child});

  /// The widget subtree that can access the application state.
  final Widget child;

  @override
  State<AppProviderWrapper> createState() => _AppProviderWrapperState();
}

class _AppProviderWrapperState extends State<AppProviderWrapper> {
  final NoteRepository _noteRepository = NoteRepository();
  Student _student = const Student(
    name: 'Nama Mahasiswa',
    nim: 'NIM belum diisi',
    programStudi: 'Program Studi',
    email: 'email@example.com',
  );
  List<Note> _notes = const [];
  bool _isLoadingNotes = true;
  String? _notesError;
  late Future<void> _notesLoadFuture;

  @override
  void initState() {
    super.initState();
    _notesLoadFuture = _loadStoredNotes();
    unawaited(_notesLoadFuture);
  }

  void _updateStudent(Student student) {
    if (_student == student) {
      return;
    }
    setState(() {
      _student = student;
    });
  }

  // Soal 4: load persisted notes through the repository.
  Future<void> _loadStoredNotes() async {
    try {
      final notes = await _noteRepository.getNotes();
      if (!mounted) {
        return;
      }
      setState(() {
        _notes = notes;
      });
    } on StateError {
      if (!mounted) {
        return;
      }
      setState(() {
        _notesError = 'Catatan tersimpan tidak dapat dimuat.';
      });
    } on Exception {
      if (!mounted) {
        return;
      }
      setState(() {
        _notesError = 'Terjadi kesalahan saat memuat catatan tersimpan.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingNotes = false;
        });
      }
    }
  }

  // Soal 5: retry note loading from the HomeScreen error state.
  Future<void> _reloadNotes() async {
    if (_isLoadingNotes) {
      return;
    }
    setState(() {
      _isLoadingNotes = true;
      _notesError = null;
    });
    _notesLoadFuture = _loadStoredNotes();
    await _notesLoadFuture;
  }

  // Soal 4: persist note changes before updating shared UI state.
  Future<void> _addNote(Note note) async {
    await _notesLoadFuture;
    if (_notesError != null) {
      throw StateError('Saved notes must load successfully before editing.');
    }
    await _noteRepository.saveNote(note);
    if (!mounted) {
      return;
    }
    setState(() {
      _notes = List<Note>.unmodifiable([..._notes, note]);
      _notesError = null;
    });
  }

  // Soal 4: remove persisted note data before updating shared UI state.
  Future<void> _deleteNote(String noteId) async {
    await _notesLoadFuture;
    if (_notesError != null) {
      throw StateError('Saved notes must load successfully before editing.');
    }
    if (!_notes.any((note) => note.id == noteId)) {
      return;
    }
    await _noteRepository.deleteNote(noteId);
    if (!mounted) {
      return;
    }
    final updatedNotes = _notes
        .where((note) => note.id != noteId)
        .toList(growable: false);
    setState(() {
      _notes = List<Note>.unmodifiable(updatedNotes);
      _notesError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      student: _student,
      notes: _notes,
      isLoadingNotes: _isLoadingNotes,
      notesError: _notesError,
      reloadNotes: _reloadNotes,
      updateStudent: _updateStudent,
      addNote: _addNote,
      deleteNote: _deleteNote,
      child: widget.child,
    );
  }
}

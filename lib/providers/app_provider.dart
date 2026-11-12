import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../models/note.dart';
import '../models/student.dart';

/// Exposes application profile and note state to descendant widgets.
class AppProvider extends InheritedWidget {
  /// Creates a provider for the current application state.
  const AppProvider({
    super.key,
    required this.student,
    required this.notes,
    required this.updateStudent,
    required this.addNote,
    required this.deleteNote,
    required super.child,
  });

  /// The current student profile.
  final Student student;

  /// An immutable view of the current notes.
  final List<Note> notes;

  /// Replaces the current student profile.
  final ValueChanged<Student> updateStudent;

  /// Adds a note to the current collection.
  final ValueChanged<Note> addNote;

  /// Deletes a note by its identifier.
  final ValueChanged<String> deleteNote;

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
    return student != oldWidget.student || !listEquals(notes, oldWidget.notes);
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
  Student _student = const Student(
    name: 'Nama Mahasiswa',
    nim: 'NIM belum diisi',
    programStudi: 'Program Studi',
    email: 'email@example.com',
  );
  List<Note> _notes = const [];

  void _updateStudent(Student student) {
    if (_student == student) {
      return;
    }
    setState(() {
      _student = student;
    });
  }

  void _addNote(Note note) {
    setState(() {
      _notes = List<Note>.unmodifiable([..._notes, note]);
    });
  }

  void _deleteNote(String noteId) {
    final updatedNotes = _notes
        .where((note) => note.id != noteId)
        .toList(growable: false);
    if (updatedNotes.length == _notes.length) {
      return;
    }
    setState(() {
      _notes = List<Note>.unmodifiable(updatedNotes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      student: _student,
      notes: _notes,
      updateStudent: _updateStudent,
      addNote: _addNote,
      deleteNote: _deleteNote,
      child: widget.child,
    );
  }
}

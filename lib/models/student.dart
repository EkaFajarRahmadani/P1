import 'package:flutter/foundation.dart';

/// Stores the display data for a student profile.
@immutable
class Student {
  /// Creates a student profile with the required details.
  const Student({
    required this.name,
    required this.nim,
    required this.programStudi,
    required this.email,
  });

  /// The student's full name.
  final String name;

  /// The student's identification number.
  final String nim;

  /// The student's study program.
  final String programStudi;

  /// The student's email address.
  final String email;
}

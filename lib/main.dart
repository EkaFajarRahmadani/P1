import 'package:flutter/material.dart';

import 'screens/profile_screen.dart';

/// Starts the student profile application.
void main() {
  runApp(const MyApp());
}

/// Configures the application theme and initial screen.
class MyApp extends StatelessWidget {
  /// Creates the root application widget.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profil Mahasiswa',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
      ),
      home: const ProfileScreen(),
    );
  }
}

import 'package:flutter/material.dart';

import 'config/app_config.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';

/// Soal 1: starts the Flutter application from the project scaffold.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Soal 4: load .env before services access app configuration.
  await AppConfig.load();
  // Soal 3: provide shared profile and note state to every screen.
  runApp(const AppProviderWrapper(child: MyApp()));
}

/// Configures the application theme and initial screen.
class MyApp extends StatelessWidget {
  /// Creates the root application widget.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profil Mahasiswa',
      debugShowCheckedModeBanner: false,
      // Soal 5: centralize the visual theme for consistent UI.
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
      ),
      // Soal 5: start at the integrated profile and notes home screen.
      home: const HomeScreen(),
    );
  }
}

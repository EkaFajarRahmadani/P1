import 'package:flutter/material.dart';

import '../services/public_api_service.dart';

/// Displays users fetched from the configured public API.
class PublicUsersScreen extends StatefulWidget {
  /// Creates the public data screen.
  const PublicUsersScreen({super.key});

  @override
  State<PublicUsersScreen> createState() => _PublicUsersScreenState();
}

class _PublicUsersScreenState extends State<PublicUsersScreen> {
  final PublicApiService _apiService = const PublicApiService();
  late Future<List<PublicUser>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _apiService.fetchUsers();
  }

  void _retryRequest() {
    setState(() {
      _usersFuture = _apiService.fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Pengguna API')),
      body: FutureBuilder<List<PublicUser>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off_outlined, size: 40),
                    const SizedBox(height: 12),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _retryRequest,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final users = snapshot.data ?? const <PublicUser>[];
          if (users.isEmpty) {
            return const Center(child: Text('Data pengguna belum tersedia.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(user.name.substring(0, 1).toUpperCase()),
                  ),
                  title: Text(user.name),
                  subtitle: Text(user.email),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

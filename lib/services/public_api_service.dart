import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';

/// Represents non-sensitive user data returned by the public API.
class PublicUser {
  /// Creates a public user summary.
  const PublicUser({required this.id, required this.name, required this.email});

  /// The user's API identifier.
  final int id;

  /// The user's display name.
  final String name;

  /// The user's public email address.
  final String email;
}

/// Performs HTTP requests to the configured public API.
class PublicApiService {
  /// Creates a public API service.
  const PublicApiService();

  /// Fetches public users, reporting network, timeout, and response errors.
  Future<List<PublicUser>> fetchUsers() async {
    final uri = Uri.parse('${AppConfig.baseUrl}/users');
    try {
      final response = await http
          .get(uri, headers: const {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw ApiRequestException(
          'Server API merespons dengan status ${response.statusCode}.',
        );
      }

      final Object? decoded = jsonDecode(response.body);
      if (decoded is! List) {
        throw const FormatException('Respons API bukan daftar pengguna.');
      }

      return decoded
          .map((item) {
            if (item is! Map ||
                item['id'] is! int ||
                item['name'] is! String ||
                item['email'] is! String) {
              throw const FormatException('Format data pengguna tidak valid.');
            }
            return PublicUser(
              id: item['id'] as int,
              name: item['name'] as String,
              email: item['email'] as String,
            );
          })
          .toList(growable: false);
    } on SocketException {
      throw const ApiRequestException(
        'Tidak dapat terhubung ke server. Periksa koneksi internet.',
      );
    } on TimeoutException {
      throw const ApiRequestException(
        'Permintaan ke server melewati batas waktu.',
      );
    } on FormatException {
      throw const ApiRequestException(
        'Server mengirim data dengan format yang tidak valid.',
      );
    }
  }
}

/// Describes a safe, user-facing API request failure.
class ApiRequestException implements Exception {
  /// Creates an API request failure with a non-sensitive [message].
  const ApiRequestException(this.message);

  /// A safe message that does not contain response bodies or credentials.
  final String message;

  @override
  String toString() => message;
}

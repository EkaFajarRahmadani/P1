import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Loads and validates app configuration from the local `.env` asset.
abstract final class AppConfig {
  AppConfig._();

  /// Loads environment values required by the app.
  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
    _validateBaseUrl(_requiredValue('BASE_URL'));
    _requiredValue('API_KEY');
  }

  /// The base URL for the public API.
  static String get baseUrl => _validateBaseUrl(_requiredValue('BASE_URL'));

  /// The configured API key; never include this value in logs.
  static String get apiKey => _requiredValue('API_KEY');

  static String _validateBaseUrl(String value) {
    final uri = Uri.tryParse(value);
    if (uri == null ||
        !uri.hasScheme ||
        uri.host.isEmpty ||
        (uri.scheme != 'https' && uri.scheme != 'http')) {
      throw StateError('BASE_URL in .env must be an HTTP or HTTPS URL.');
    }
    return value.replaceFirst(RegExp(r'/+$'), '');
  }

  static String _requiredValue(String name) {
    final value = dotenv.env[name]?.trim();
    if (value == null || value.isEmpty) {
      throw StateError('$name is missing from .env.');
    }
    return value;
  }
}

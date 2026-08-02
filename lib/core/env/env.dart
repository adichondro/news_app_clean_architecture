import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Helper utility for accessing environment variables loaded from the `.env` file via [dotenv].
class Env {
  const Env._();

  static String get apiKey => dotenv.env['API_KEY'] ?? '';
}

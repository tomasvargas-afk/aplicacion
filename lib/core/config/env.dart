import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Reads Supabase credentials from the bundled `.env` file (see
/// `.env.example`). Loaded once in `main.dart` before `runApp`.
abstract class Env {
  Env._();

  static String get supabaseUrl => dotenv.get('SUPABASE_URL');

  static String get supabaseAnonKey => dotenv.get('SUPABASE_ANON_KEY');

  static bool get isConfigured =>
      dotenv.maybeGet('SUPABASE_URL')?.startsWith('http') == true &&
      (dotenv.maybeGet('SUPABASE_ANON_KEY')?.isNotEmpty ?? false) &&
      dotenv.get('SUPABASE_URL') != 'https://your-project-ref.supabase.co';
}

import 'package:supabase_flutter/supabase_flutter.dart';

import 'env.dart';

/// Initializes the Supabase SDK once at app startup.
abstract class SupabaseConfig {
  SupabaseConfig._();

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
    );
  }
}

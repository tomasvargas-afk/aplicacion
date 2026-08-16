import 'package:supabase_flutter/supabase_flutter.dart';

import 'env.dart';
import 'secure_local_storage.dart';

/// Initializes the Supabase SDK once at app startup.
abstract class SupabaseConfig {
  SupabaseConfig._();

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        localStorage: SecureLocalStorage(),
      ),
    );
  }
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Persists the Supabase auth session in the OS keychain/keystore (via
/// `flutter_secure_storage`) instead of the default SharedPreferences —
/// this app stores real personal health data behind that session token,
/// so it's worth the extra layer over plain-text local storage.
class SecureLocalStorage extends LocalStorage {
  const SecureLocalStorage();

  static const _storage = FlutterSecureStorage();
  static const _key = 'supabase.auth.token';

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> hasAccessToken() {
    return _storage.containsKey(key: _key);
  }

  @override
  Future<String?> accessToken() {
    return _storage.read(key: _key);
  }

  @override
  Future<void> removePersistedSession() {
    return _storage.delete(key: _key);
  }

  @override
  Future<void> persistSession(String persistSessionString) {
    return _storage.write(key: _key, value: persistSessionString);
  }
}

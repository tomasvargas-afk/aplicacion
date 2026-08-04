import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;

import '../../../../core/error/exceptions.dart';

class AuthRemoteDatasource {
  AuthRemoteDatasource(this._client);

  final SupabaseClient _client;

  Stream<User?> get authStateChanges =>
      _client.auth.onAuthStateChange.map((event) => event.session?.user);

  User? get currentUser => _client.auth.currentUser;

  Future<User> signIn({required String email, required String password}) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) throw const AuthException('No se pudo iniciar sesión');
      return user;
    } on AuthApiException catch (e) {
      throw AuthException(_mapAuthError(e.message));
    }
  }

  Future<User> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
      final user = response.user;
      if (user == null) throw const AuthException('No se pudo crear la cuenta');
      return user;
    } on AuthApiException catch (e) {
      throw AuthException(_mapAuthError(e.message));
    }
  }

  Future<void> signOut() => _client.auth.signOut();

  Future<void> resetPassword(String email) =>
      _client.auth.resetPasswordForEmail(email);

  String _mapAuthError(String message) {
    if (message.toLowerCase().contains('invalid login credentials')) {
      return 'Correo o contraseña incorrectos';
    }
    if (message.toLowerCase().contains('already registered')) {
      return 'Ya existe una cuenta con este correo';
    }
    return message;
  }
}

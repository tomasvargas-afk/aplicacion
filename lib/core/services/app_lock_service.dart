import 'package:local_auth/local_auth.dart';

/// Thin wrapper around `local_auth` for the optional app-open lock
/// (Face ID / Touch ID / fingerprint, with device passcode as fallback).
class AppLockService {
  AppLockService._();

  static final AppLockService instance = AppLockService._();

  final _auth = LocalAuthentication();

  Future<bool> isSupported() async {
    try {
      return await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Confirma tu identidad para abrir la app',
        biometricOnly: false,
      );
    } catch (_) {
      return false;
    }
  }
}

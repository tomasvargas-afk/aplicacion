import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _appLockEnabledKey = 'app_lock_enabled';

/// Whether the user opted into Face ID/Touch ID/passcode lock on app open.
/// Off by default — this is an opt-in extra layer, not a requirement.
class AppLockEnabledNotifier extends Notifier<bool> {
  @override
  bool build() {
    _restore();
    return false;
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_appLockEnabledKey) ?? false;
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_appLockEnabledKey, enabled);
  }
}

final appLockEnabledProvider = NotifierProvider<AppLockEnabledNotifier, bool>(
  AppLockEnabledNotifier.new,
);

/// Whether the current in-memory session has passed the lock screen.
/// Intentionally not persisted — resets whenever the process restarts, and
/// [AppLockGate] flips it back to false whenever the app is backgrounded.
final appLockUnlockedProvider = StateProvider<bool>((ref) => false);

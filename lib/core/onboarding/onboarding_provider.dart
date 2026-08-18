import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _onboardingSeenKey = 'onboarding_seen';

/// Whether the user has already gone through the first-launch onboarding
/// carousel — drives the redirect in `app_router.dart`.
class OnboardingNotifier extends Notifier<bool> {
  @override
  bool build() {
    _restore();
    return false;
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_onboardingSeenKey) ?? false;
  }

  Future<void> markSeen() async {
    state = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingSeenKey, true);
  }
}

final onboardingSeenProvider = NotifierProvider<OnboardingNotifier, bool>(
  OnboardingNotifier.new,
);

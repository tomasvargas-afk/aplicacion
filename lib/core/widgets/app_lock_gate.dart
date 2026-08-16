import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../security/app_lock_provider.dart';
import '../services/app_lock_service.dart';

/// Wraps the app's content. When app-lock is enabled and the current
/// session hasn't been unlocked yet, shows a full-screen overlay requiring
/// Face ID/Touch ID/device passcode before revealing [child]. Also re-locks
/// whenever the app is backgrounded so leaving it open doesn't leave your
/// data exposed.
class AppLockGate extends ConsumerStatefulWidget {
  const AppLockGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(appLockEnabledProvider) &&
          !ref.read(appLockUnlockedProvider)) {
        _unlock();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!ref.read(appLockEnabledProvider)) return;
    if (state == AppLifecycleState.paused) {
      ref.read(appLockUnlockedProvider.notifier).state = false;
    }
  }

  Future<void> _unlock() async {
    final success = await AppLockService.instance.authenticate();
    if (success && mounted) {
      ref.read(appLockUnlockedProvider.notifier).state = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = ref.watch(appLockEnabledProvider);
    final unlocked = ref.watch(appLockUnlockedProvider);

    if (!enabled || unlocked) return widget.child;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.seed, AppColors.seedDeep],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.lock_outline,
                    color: Colors.white,
                    size: 56,
                  ),
                  const SizedBox(height: AppSizes.lg),
                  const Text(
                    'Aplicación bloqueada',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  const Text(
                    'Confirma tu identidad para continuar',
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.xl),
                  FilledButton.icon(
                    onPressed: _unlock,
                    icon: const Icon(Icons.fingerprint),
                    label: const Text('Desbloquear'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

/// Countdown bottom sheet for resting between sets. Buzzes once when it
/// hits zero instead of playing a sound (no audio asset to ship for one
/// haptic tick).
class RestTimerSheet extends StatefulWidget {
  const RestTimerSheet({super.key, required this.seconds});

  final int seconds;

  static Future<void> show(BuildContext context, int seconds) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: false,
      builder: (_) => RestTimerSheet(seconds: seconds <= 0 ? 60 : seconds),
    );
  }

  @override
  State<RestTimerSheet> createState() => _RestTimerSheetState();
}

class _RestTimerSheetState extends State<RestTimerSheet> {
  late int _remaining = widget.seconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining <= 1) {
        _timer?.cancel();
        setState(() => _remaining = 0);
        HapticFeedback.mediumImpact();
        return;
      }
      setState(() => _remaining--);
    });
  }

  void _adjust(int deltaSeconds) {
    setState(() => _remaining = (_remaining + deltaSeconds).clamp(0, 3600));
    if (_remaining > 0 && (_timer == null || !_timer!.isActive)) _start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formatted {
    final m = _remaining ~/ 60;
    final s = _remaining % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final done = _remaining == 0;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              done ? '¡Listo! 💪' : 'Descansando…',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              _formatted,
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.w800,
                color: done ? AppColors.success : AppColors.seed,
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => _adjust(-15),
                  child: const Text('-15s'),
                ),
                const SizedBox(width: AppSizes.md),
                OutlinedButton(
                  onPressed: () => _adjust(15),
                  child: const Text('+15s'),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(done ? 'Cerrar' : 'Saltar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

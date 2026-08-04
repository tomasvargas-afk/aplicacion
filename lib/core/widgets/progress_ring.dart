import 'package:flutter/material.dart';

/// Circular progress indicator with a label in the center. Used for goal
/// completion %, water/adherence rings, etc.
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 96,
    this.strokeWidth = 10,
    this.color,
    this.backgroundColor,
    this.centerText,
    this.label,
  });

  /// 0.0 - 1.0 (values above 1 are clamped visually but shown in [centerText]).
  final double progress;
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final String? centerText;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ringColor = color ?? scheme.primary;
    final clamped = progress.clamp(0.0, 1.0);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: clamped,
              strokeWidth: strokeWidth,
              strokeCap: StrokeCap.round,
              backgroundColor: backgroundColor ?? scheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(ringColor),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                centerText ?? '${(clamped * 100).round()}%',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              if (label != null)
                Text(
                  label!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

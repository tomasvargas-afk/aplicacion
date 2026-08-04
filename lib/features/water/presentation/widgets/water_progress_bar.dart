import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class WaterProgressBar extends StatelessWidget {
  const WaterProgressBar({super.key, required this.currentMl, required this.goalMl});

  final int currentMl;
  final int goalMl;

  @override
  Widget build(BuildContext context) {
    final progress = goalMl <= 0 ? 0.0 : (currentMl / goalMl).clamp(0.0, 1.0);
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${(currentMl / 1000).toStringAsFixed(2)} L',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6, bottom: 6),
              child: Text('/ ${(goalMl / 1000).toStringAsFixed(1)} L'),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 14,
            backgroundColor: scheme.surfaceContainerHighest,
            valueColor: const AlwaysStoppedAnimation(AppColors.water),
          ),
        ),
        const SizedBox(height: AppSizes.xs),
        Text(
          progress >= 1.0
              ? '¡Meta alcanzada! 🎉'
              : '${(goalMl - currentMl).clamp(0, goalMl)} ml restantes',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

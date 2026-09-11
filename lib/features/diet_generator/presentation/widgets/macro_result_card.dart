import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/macro_bar.dart';
import '../../domain/entities/diet_plan.dart';

class MacroResultCard extends StatelessWidget {
  const MacroResultCard({super.key, required this.plan});

  final DietPlan plan;

  @override
  Widget build(BuildContext context) {
    // Positive = calories below maintenance (deficit), negative = above
    // maintenance (surplus). Rounded to the nearest 10 so it reads as the
    // "-500" style number a goal was built from, not a jittery raw diff.
    final diff = ((plan.tdee - plan.dailyCalories) / 10).round() * 10;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                plan.dailyCalories.round().toString(),
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 6, bottom: 6),
                child: Text('kcal / día'),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            'BMR ${plan.bmr.round()} kcal · TDEE ${plan.tdee.round()} kcal',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (diff != 0) ...[
            const SizedBox(height: AppSizes.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: (diff > 0 ? AppColors.success : AppColors.calories)
                    .withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm + 4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    diff > 0 ? Icons.trending_down : Icons.trending_up,
                    size: 16,
                    color: diff > 0 ? AppColors.success : AppColors.calories,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    diff > 0
                        ? 'Déficit de ${diff.abs()} kcal/día vs tu mantenimiento'
                        : 'Superávit de ${diff.abs()} kcal/día vs tu mantenimiento',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: diff > 0 ? AppColors.success : AppColors.calories,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSizes.md),
          MacroBar(
              proteinG: plan.proteinG, carbsG: plan.carbsG, fatG: plan.fatG),
        ],
      ),
    );
  }
}

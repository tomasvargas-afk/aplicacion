import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/macro_bar.dart';
import '../../domain/entities/diet_plan.dart';

class MacroResultCard extends StatelessWidget {
  const MacroResultCard({super.key, required this.plan});

  final DietPlan plan;

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: AppSizes.md),
          MacroBar(proteinG: plan.proteinG, carbsG: plan.carbsG, fatG: plan.fatG),
        ],
      ),
    );
  }
}

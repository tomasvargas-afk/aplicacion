import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Stacked horizontal bar showing the protein/carbs/fat split for a meal,
/// diet plan or daily summary, with a small legend underneath.
class MacroBar extends StatelessWidget {
  const MacroBar({
    super.key,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    this.showLegend = true,
  });

  final double proteinG;
  final double carbsG;
  final double fatG;
  final bool showLegend;

  @override
  Widget build(BuildContext context) {
    final total = proteinG + carbsG + fatG;
    final safeTotal = total <= 0 ? 1.0 : total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          child: SizedBox(
            height: 10,
            child: Row(
              children: [
                Expanded(
                  flex: (proteinG / safeTotal * 1000).round().clamp(0, 1000),
                  child: Container(color: AppColors.protein),
                ),
                Expanded(
                  flex: (carbsG / safeTotal * 1000).round().clamp(0, 1000),
                  child: Container(color: AppColors.carbs),
                ),
                Expanded(
                  flex: (fatG / safeTotal * 1000).round().clamp(0, 1000),
                  child: Container(color: AppColors.fat),
                ),
              ],
            ),
          ),
        ),
        if (showLegend) ...[
          const SizedBox(height: AppSizes.sm),
          Wrap(
            spacing: AppSizes.md,
            runSpacing: AppSizes.xs,
            children: [
              _LegendItem(color: AppColors.protein, label: 'Proteína', value: proteinG),
              _LegendItem(color: AppColors.carbs, label: 'Carbos', value: carbsG),
              _LegendItem(color: AppColors.fat, label: 'Grasas', value: fatG),
            ],
          ),
        ],
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label, required this.value});

  final Color color;
  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          '$label ${value.toStringAsFixed(0)}g',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

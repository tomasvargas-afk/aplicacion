import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';

const _quickAmounts = [250, 500, 1000];

class WaterQuickAddButtons extends StatelessWidget {
  const WaterQuickAddButtons({super.key, required this.onAdd, this.isLoading = false});

  final void Function(int amountMl) onAdd;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.sm,
      runSpacing: AppSizes.sm,
      children: _quickAmounts.map((ml) {
        return FilledButton.tonalIcon(
          onPressed: isLoading ? null : () => onAdd(ml),
          icon: const Icon(Icons.water_drop_outlined, size: 18),
          label: Text(ml >= 1000 ? '+${ml ~/ 1000} L' : '+$ml ml'),
        );
      }).toList(),
    );
  }
}

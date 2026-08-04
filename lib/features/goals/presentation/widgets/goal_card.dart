import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/progress_ring.dart';
import '../../domain/entities/goal.dart';

class GoalCard extends StatelessWidget {
  const GoalCard({
    super.key,
    required this.goal,
    required this.progress,
    this.onTap,
    this.onDelete,
  });

  final Goal goal;
  final double progress;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final type = GoalType.fromDbValue(goal.type);
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          ProgressRing(progress: progress, size: 64, strokeWidth: 6),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(type.icon, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        goal.title,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Meta: ${goal.targetValue.toStringAsFixed(goal.targetValue % 1 == 0 ? 0 : 1)} ${goal.unit ?? ''}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}

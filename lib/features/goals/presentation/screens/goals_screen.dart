import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../providers/goals_provider.dart';
import '../widgets/goal_card.dart';
import 'add_edit_goal_screen.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Objetivos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddEditGoalScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo objetivo'),
      ),
      body: goalsAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorView(
          message: describeError(error),
          onRetry: () => ref.invalidate(goalsProvider),
        ),
        data: (goals) {
          if (goals.isEmpty) {
            return const EmptyState(
              icon: Icons.flag_outlined,
              message:
                  'Todavía no tienes objetivos.\nCrea uno para empezar a medir tu progreso',
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(goalsProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSizes.md),
              itemCount: goals.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSizes.sm),
              itemBuilder: (context, index) {
                final goal = goals[index];
                final progress = ref.watch(goalProgressProvider(goal));
                return GoalCard(
                  goal: goal,
                  progress: progress,
                  onDelete: () async {
                    final confirmed = await ConfirmDialog.show(
                      context,
                      title: 'Eliminar objetivo',
                      message: '¿Eliminar "${goal.title}"?',
                    );
                    if (confirmed && goal.id != null) {
                      await ref.read(goalsControllerProvider.notifier).deleteGoal(goal.id!);
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

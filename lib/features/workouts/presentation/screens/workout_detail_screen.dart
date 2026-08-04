import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/workout.dart';
import '../../domain/entities/workout_log.dart';
import '../providers/workout_provider.dart';
import '../widgets/exercise_tile.dart';

class WorkoutDetailScreen extends ConsumerWidget {
  const WorkoutDetailScreen({super.key, required this.workout});

  final Workout workout;

  Future<void> _markCompleted(BuildContext context, WidgetRef ref) async {
    final durationController = TextEditingController();
    final duration = await showDialog<int?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¡Rutina completada! 💪'),
        content: TextField(
          controller: durationController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Duración (minutos, opcional)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(
              int.tryParse(durationController.text) ?? 0,
            ),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (duration == null) return;

    final user = ref.read(currentUserProvider);
    if (user == null || workout.id == null) return;

    final error = await ref.read(workoutControllerProvider.notifier).logCompletion(
          WorkoutLog(
            userId: user.id,
            workoutId: workout.id!,
            durationMinutes: duration > 0 ? duration : null,
          ),
        );
    if (!context.mounted) return;
    if (error != null) {
      context.showSnackBar(error, isError: true);
    } else {
      context.showSnackBar('¡Buen trabajo! Racha actualizada 🔥');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workout.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final confirmed = await ConfirmDialog.show(
                context,
                title: 'Eliminar rutina',
                message: '¿Seguro que quieres eliminar "${workout.name}"?',
              );
              if (confirmed && workout.id != null) {
                await ref.read(workoutControllerProvider.notifier).deleteWorkout(workout.id!);
                if (context.mounted) Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _markCompleted(context, ref),
        icon: const Icon(Icons.check),
        label: const Text('Marcar completada'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.md),
          children: [
            Wrap(
              spacing: AppSizes.sm,
              children: [
                Chip(label: Text(workout.type.workoutTypeLabel)),
              ],
            ),
            if (workout.description != null && workout.description!.isNotEmpty) ...[
              const SizedBox(height: AppSizes.sm),
              Text(workout.description!, style: context.textTheme.bodyMedium),
            ],
            const SizedBox(height: AppSizes.lg),
            Text('Ejercicios', style: context.textTheme.titleMedium),
            const SizedBox(height: AppSizes.sm),
            if (workout.exercises.isEmpty)
              const EmptyState(message: 'Esta rutina no tiene ejercicios')
            else
              ...workout.exercises.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.sm),
                    child: ExerciseTile(workoutExercise: e),
                  )),
            const SizedBox(height: AppSizes.xxl),
          ],
        ),
      ),
    );
  }
}

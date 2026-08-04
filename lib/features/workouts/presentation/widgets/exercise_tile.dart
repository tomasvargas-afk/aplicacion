import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/workout_exercise.dart';

class ExerciseTile extends StatelessWidget {
  const ExerciseTile({super.key, required this.workoutExercise, this.onRemove});

  final WorkoutExercise workoutExercise;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final exercise = workoutExercise.exercise;
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise?.name ?? 'Ejercicio',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  '${workoutExercise.sets} series × ${workoutExercise.reps} reps'
                  '${workoutExercise.targetWeightKg != null ? ' · ${workoutExercise.targetWeightKg!.toStringAsFixed(0)} kg' : ''}'
                  ' · ${workoutExercise.restSeconds}s descanso',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (workoutExercise.notes != null && workoutExercise.notes!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      workoutExercise.notes!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ),
              ],
            ),
          ),
          if (onRemove != null)
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }
}

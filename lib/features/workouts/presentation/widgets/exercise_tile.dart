import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/workout_exercise.dart';
import '../providers/workout_provider.dart';

class ExerciseTile extends ConsumerStatefulWidget {
  const ExerciseTile({
    super.key,
    required this.workoutExercise,
    this.onRemove,
  });

  final WorkoutExercise workoutExercise;
  final VoidCallback? onRemove;

  @override
  ConsumerState<ExerciseTile> createState() => _ExerciseTileState();
}

class _ExerciseTileState extends ConsumerState<ExerciseTile> {
  bool _isLoadingSuggestion = false;

  Future<void> _getSuggestion() async {
    final exercise = widget.workoutExercise.exercise;
    if (exercise?.id == null) return;

    setState(() => _isLoadingSuggestion = true);
    final (suggestion, error) = await ref
        .read(progressionSuggestionControllerProvider.notifier)
        .fetch(exerciseId: exercise!.id!, exerciseName: exercise.name);
    if (!mounted) return;
    setState(() => _isLoadingSuggestion = false);

    if (error != null) {
      context.showSnackBar(error, isError: true);
      return;
    }
    if (suggestion == null) return;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sugerencia de progreso 💡'),
        content: Text(
          '${suggestion.text}\n\n'
          'Próxima sesión: ${suggestion.suggestedReps} reps × '
          '${suggestion.suggestedWeightKg.toStringAsFixed(1)} kg',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workoutExercise = widget.workoutExercise;
    final exercise = workoutExercise.exercise;
    final showSuggestionButton =
        widget.onRemove == null && exercise?.id != null;

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
                if (workoutExercise.notes != null &&
                    workoutExercise.notes!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      workoutExercise.notes!,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ),
                if (showSuggestionButton)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: TextButton.icon(
                      onPressed: _isLoadingSuggestion ? null : _getSuggestion,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: _isLoadingSuggestion
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.auto_awesome, size: 16),
                      label: const Text('Sugerencia IA'),
                    ),
                  ),
              ],
            ),
          ),
          if (widget.onRemove != null)
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: widget.onRemove,
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../body_tracking/presentation/providers/body_tracking_provider.dart';
import '../../domain/entities/workout.dart';
import '../../domain/entities/workout_log.dart';
import '../../domain/entities/workout_log_set.dart';
import '../../domain/usecases/workout_calorie_calculator.dart';
import '../providers/workout_provider.dart';

class _SetControllers {
  _SetControllers({required String reps, required String weight})
      : reps = TextEditingController(text: reps),
        weight = TextEditingController(text: weight);

  final TextEditingController reps;
  final TextEditingController weight;

  void dispose() {
    reps.dispose();
    weight.dispose();
  }
}

/// Full workout completion flow: duration + per-set reps/weight for every
/// exercise, pre-filled with sensible defaults. Feeds workout_log_sets,
/// which is what the AI progression suggestion is built from.
class LogWorkoutScreen extends ConsumerStatefulWidget {
  const LogWorkoutScreen({super.key, required this.workout});

  final Workout workout;

  @override
  ConsumerState<LogWorkoutScreen> createState() => _LogWorkoutScreenState();
}

class _LogWorkoutScreenState extends ConsumerState<LogWorkoutScreen> {
  final _durationController = TextEditingController();
  late final Map<String, List<_SetControllers>> _setControllers;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _setControllers = {
      for (final e in widget.workout.exercises)
        e.exerciseId: List.generate(
          e.sets,
          (_) => _SetControllers(
            reps: _defaultReps(e.reps).toString(),
            weight:
                e.targetWeightKg != null ? _trimZero(e.targetWeightKg!) : '',
          ),
        ),
    };
  }

  int _defaultReps(String repsRange) {
    final match = RegExp(r'\d+').firstMatch(repsRange);
    return match != null ? int.parse(match.group(0)!) : 10;
  }

  String _trimZero(double value) => value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toString();

  @override
  void dispose() {
    _durationController.dispose();
    for (final list in _setControllers.values) {
      for (final c in list) {
        c.dispose();
      }
    }
    super.dispose();
  }

  Future<void> _save() async {
    final user = ref.read(currentUserProvider);
    if (user == null || widget.workout.id == null) return;

    final duration = int.tryParse(_durationController.text) ?? 0;

    final sets = <WorkoutLogSet>[];
    for (final exercise in widget.workout.exercises) {
      final controllers = _setControllers[exercise.exerciseId] ?? [];
      for (var i = 0; i < controllers.length; i++) {
        final reps = int.tryParse(controllers[i].reps.text);
        final weight = double.tryParse(
          controllers[i].weight.text.replaceAll(',', '.'),
        );
        if (reps == null && weight == null) continue;
        sets.add(
          WorkoutLogSet(
            exerciseId: exercise.exerciseId,
            setNumber: i + 1,
            repsDone: reps,
            weightKg: weight,
          ),
        );
      }
    }

    double? caloriesBurned;
    if (duration > 0) {
      final measurements =
          ref.read(bodyMeasurementHistoryProvider).valueOrNull ?? const [];
      double? weightKg;
      for (final m in measurements.reversed) {
        if (m.weightKg != null) {
          weightKg = m.weightKg;
          break;
        }
      }
      if (weightKg != null) {
        caloriesBurned = WorkoutCalorieCalculator.estimate(
          durationMinutes: duration,
          weightKg: weightKg,
        );
      }
    }

    setState(() => _isSaving = true);
    final error =
        await ref.read(workoutControllerProvider.notifier).logCompletion(
              WorkoutLog(
                userId: user.id,
                workoutId: widget.workout.id!,
                durationMinutes: duration > 0 ? duration : null,
                caloriesBurned: caloriesBurned,
              ),
              sets: sets,
            );
    if (!mounted) return;
    setState(() => _isSaving = false);

    if (error != null) {
      context.showSnackBar(error, isError: true);
      return;
    }
    Navigator.of(context).pop();
    context.showSnackBar(
      caloriesBurned != null
          ? '¡Buen trabajo! ~${caloriesBurned.round()} kcal quemadas 🔥'
          : '¡Buen trabajo! Racha actualizada 🔥',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar entrenamiento')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.md),
          children: [
            TextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Duración (minutos, opcional)',
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            ...widget.workout.exercises.map((exercise) {
              final controllers = _setControllers[exercise.exerciseId] ?? [];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.md),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  tilePadding: EdgeInsets.zero,
                  title: Text(
                    exercise.exercise?.name ?? 'Ejercicio',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  children: [
                    AppCard(
                      child: Column(
                        children: List.generate(controllers.length, (i) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom:
                                  i == controllers.length - 1 ? 0 : AppSizes.sm,
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 56,
                                  child: Text(
                                    'Serie ${i + 1}',
                                    style: context.textTheme.bodySmall,
                                  ),
                                ),
                                const SizedBox(width: AppSizes.sm),
                                Expanded(
                                  child: TextField(
                                    controller: controllers[i].reps,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Reps',
                                      isDense: true,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSizes.sm),
                                Expanded(
                                  child: TextField(
                                    controller: controllers[i].weight,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                    decoration: const InputDecoration(
                                      labelText: 'Kg',
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: AppSizes.lg),
            PrimaryButton(
              label: 'Guardar',
              isLoading: _isSaving,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/workout.dart';
import '../../domain/entities/workout_exercise.dart';
import '../providers/workout_provider.dart';
import '../widgets/exercise_tile.dart';
import 'exercise_picker_screen.dart';

const _workoutTypes = [
  ('ppl', 'Push Pull Legs'),
  ('upper_lower', 'Upper / Lower'),
  ('full_body', 'Full Body'),
  ('arnold_split', 'Arnold Split'),
  ('custom', 'Personalizada'),
];

class CreateEditWorkoutScreen extends ConsumerStatefulWidget {
  const CreateEditWorkoutScreen({super.key});

  @override
  ConsumerState<CreateEditWorkoutScreen> createState() =>
      _CreateEditWorkoutScreenState();
}

class _CreateEditWorkoutScreenState extends ConsumerState<CreateEditWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _type = 'custom';
  final List<WorkoutExercise> _exercises = [];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _addExercise() async {
    final exercise = await Navigator.of(context).push<Exercise>(
      MaterialPageRoute(builder: (_) => const ExercisePickerScreen()),
    );
    if (exercise == null || exercise.id == null || !mounted) return;

    final configured = await showDialog<WorkoutExercise>(
      context: context,
      builder: (context) => _ExerciseConfigDialog(exercise: exercise),
    );
    if (configured != null) {
      setState(() => _exercises.add(configured));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final workout = Workout(
      userId: user.id,
      name: _nameController.text.trim(),
      type: _type,
      description:
          _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      exercises: _exercises,
    );

    final error = await ref.read(workoutControllerProvider.notifier).saveWorkout(workout);
    if (!mounted) return;
    if (error != null) {
      context.showSnackBar(error, isError: true);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(workoutControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva rutina')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSizes.lg),
            children: [
              AppTextField(
                controller: _nameController,
                label: 'Nombre de la rutina',
                validator: Validators.required,
              ),
              const SizedBox(height: AppSizes.md),
              Text('Tipo', style: context.textTheme.titleSmall),
              const SizedBox(height: AppSizes.xs),
              Wrap(
                spacing: AppSizes.sm,
                runSpacing: AppSizes.sm,
                children: _workoutTypes.map((t) {
                  return ChoiceChip(
                    label: Text(t.$2),
                    selected: _type == t.$1,
                    onSelected: (_) => setState(() => _type = t.$1),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSizes.md),
              AppTextField(
                controller: _descriptionController,
                label: 'Descripción (opcional)',
                maxLines: 2,
              ),
              const SizedBox(height: AppSizes.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Ejercicios', style: context.textTheme.titleMedium),
                  TextButton.icon(
                    onPressed: _addExercise,
                    icon: const Icon(Icons.add),
                    label: const Text('Añadir'),
                  ),
                ],
              ),
              if (_exercises.isEmpty)
                const EmptyState(
                  icon: Icons.fitness_center_outlined,
                  message: 'Añade al menos un ejercicio a tu rutina',
                )
              else
                ..._exercises.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.sm),
                    child: ExerciseTile(
                      workoutExercise: entry.value,
                      onRemove: () => setState(() => _exercises.removeAt(entry.key)),
                    ),
                  );
                }),
              const SizedBox(height: AppSizes.lg),
              PrimaryButton(
                label: 'Guardar rutina',
                isLoading: isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExerciseConfigDialog extends StatefulWidget {
  const _ExerciseConfigDialog({required this.exercise});

  final Exercise exercise;

  @override
  State<_ExerciseConfigDialog> createState() => _ExerciseConfigDialogState();
}

class _ExerciseConfigDialogState extends State<_ExerciseConfigDialog> {
  final _setsController = TextEditingController(text: '3');
  final _repsController = TextEditingController(text: '8-12');
  final _restController = TextEditingController(text: '60');
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _setsController.dispose();
    _repsController.dispose();
    _restController.dispose();
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.exercise.name),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _setsController,
                    label: 'Series',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: AppTextField(controller: _repsController, label: 'Reps'),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _restController,
                    label: 'Descanso (s)',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: AppTextField(
                    controller: _weightController,
                    label: 'Peso (kg)',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            AppTextField(controller: _notesController, label: 'Notas (opcional)'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(
              WorkoutExercise(
                exerciseId: widget.exercise.id!,
                exercise: widget.exercise,
                sets: int.tryParse(_setsController.text) ?? 3,
                reps: _repsController.text.trim().isEmpty ? '8-12' : _repsController.text.trim(),
                restSeconds: int.tryParse(_restController.text) ?? 60,
                targetWeightKg: double.tryParse(_weightController.text.replaceAll(',', '.')),
                notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
              ),
            );
          },
          child: const Text('Añadir'),
        ),
      ],
    );
  }
}

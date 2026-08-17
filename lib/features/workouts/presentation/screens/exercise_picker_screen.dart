import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../domain/entities/exercise.dart';
import '../providers/workout_provider.dart';

/// Pushed for a result: pops with the selected [Exercise], or null if
/// the user backs out.
class ExercisePickerScreen extends ConsumerStatefulWidget {
  const ExercisePickerScreen({super.key});

  @override
  ConsumerState<ExercisePickerScreen> createState() =>
      _ExercisePickerScreenState();
}

class _ExercisePickerScreenState extends ConsumerState<ExercisePickerScreen> {
  String _query = '';
  bool _isCreating = false;

  Future<void> _createCustomExercise({String initialName = ''}) async {
    final controller = TextEditingController(text: initialName);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Crear ejercicio'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(labelText: 'Nombre del ejercicio'),
          onSubmitted: (value) => Navigator.of(context).pop(value.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Crear'),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) return;

    setState(() => _isCreating = true);
    final (exercise, error) = await ref
        .read(workoutControllerProvider.notifier)
        .createCustomExercise(name);
    if (!mounted) return;
    setState(() => _isCreating = false);

    if (error != null) {
      context.showSnackBar(error, isError: true);
      return;
    }
    Navigator.of(context).pop(exercise);
  }

  @override
  Widget build(BuildContext context) {
    final exercisesAsync = ref.watch(exerciseLibraryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Elegir ejercicio'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.md,
              0,
              AppSizes.md,
              AppSizes.sm,
            ),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar ejercicio...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) =>
                  setState(() => _query = value.toLowerCase()),
            ),
          ),
        ),
      ),
      body: exercisesAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorView(
          onRetry: () => ref.invalidate(exerciseLibraryProvider),
        ),
        data: (exercises) {
          final filtered = _query.isEmpty
              ? exercises
              : exercises
                  .where((e) => e.name.toLowerCase().contains(_query))
                  .toList();

          if (filtered.isEmpty) {
            return EmptyState(
              icon: Icons.search_off,
              message: 'No se encontraron ejercicios',
              actionLabel: 'Crear ejercicio',
              onAction: () => _createCustomExercise(initialName: _query),
            );
          }

          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final exercise = filtered[index];
              return ListTile(
                leading: const Icon(Icons.fitness_center),
                title: Text(exercise.name),
                subtitle: Text(
                  [exercise.muscleGroup, exercise.equipment]
                      .where((s) => s != null && s.isNotEmpty)
                      .join(' · '),
                ),
                onTap: () => Navigator.of(context).pop(exercise),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isCreating ? null : () => _createCustomExercise(),
        icon: _isCreating
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.add),
        label: const Text('Nuevo ejercicio'),
      ),
    );
  }
}

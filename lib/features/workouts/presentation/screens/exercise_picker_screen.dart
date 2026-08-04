import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
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
  ConsumerState<ExercisePickerScreen> createState() => _ExercisePickerScreenState();
}

class _ExercisePickerScreenState extends ConsumerState<ExercisePickerScreen> {
  String _query = '';

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
              onChanged: (value) => setState(() => _query = value.toLowerCase()),
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
              : exercises.where((e) => e.name.toLowerCase().contains(_query)).toList();

          if (filtered.isEmpty) {
            return const EmptyState(
              icon: Icons.search_off,
              message: 'No se encontraron ejercicios',
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
    );
  }
}

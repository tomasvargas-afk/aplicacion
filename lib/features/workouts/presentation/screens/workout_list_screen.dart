import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../providers/workout_provider.dart';
import '../widgets/workout_card.dart';
import 'create_edit_workout_screen.dart';
import 'workout_calendar_screen.dart';
import 'workout_detail_screen.dart';

class WorkoutListScreen extends ConsumerWidget {
  const WorkoutListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutsAsync = ref.watch(workoutsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrenamiento'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            tooltip: 'Calendario',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const WorkoutCalendarScreen()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const CreateEditWorkoutScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Crear rutina'),
      ),
      body: workoutsAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorView(
          message: describeError(error),
          onRetry: () => ref.invalidate(workoutsProvider),
        ),
        data: (workouts) {
          if (workouts.isEmpty) {
            return const EmptyState(
              icon: Icons.fitness_center_outlined,
              message: 'Todavía no tienes rutinas.\nCrea la primera con el botón de abajo',
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(workoutsProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSizes.md),
              itemCount: workouts.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSizes.sm),
              itemBuilder: (context, index) {
                final workout = workouts[index];
                return WorkoutCard(
                  workout: workout,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => WorkoutDetailScreen(workout: workout),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

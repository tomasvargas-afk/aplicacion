import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/icon_badge.dart';
import '../../../sleep/presentation/providers/sleep_provider.dart';
import '../../../water/presentation/providers/water_provider.dart';
import '../providers/reminders_provider.dart';

class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workout = ref.watch(workoutReminderProvider);
    final meal = ref.watch(mealReminderProvider);
    final water = ref.watch(waterRemindersProvider);
    final sleep = ref.watch(sleepReminderProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.md),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.sm),
            child: Text(
              'Recordatorios inteligentes para mantenerte en tu rutina.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          _ReminderTile(
            icon: Icons.fitness_center,
            color: AppColors.workout,
            title: 'Entrenamiento',
            subtitle: 'Es hora de entrenar 💪',
            enabled: workout.enabled,
            time: workout.time,
            onToggle: (v) => ref.read(workoutReminderProvider.notifier).toggle(v),
            onPickTime: (t) => ref.read(workoutReminderProvider.notifier).setTime(t),
          ),
          const SizedBox(height: AppSizes.sm),
          _ReminderTile(
            icon: Icons.restaurant,
            color: AppColors.protein,
            title: 'Comida',
            subtitle: 'No olvides almorzar 🍗',
            enabled: meal.enabled,
            time: meal.time,
            onToggle: (v) => ref.read(mealReminderProvider.notifier).toggle(v),
            onPickTime: (t) => ref.read(mealReminderProvider.notifier).setTime(t),
          ),
          const SizedBox(height: AppSizes.sm),
          AppCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const IconBadge(icon: Icons.water_drop, color: AppColors.water),
              title: const Text('Agua', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('4 veces al día (10, 13, 16 y 19 h)'),
              trailing: Switch(
                value: water,
                onChanged: (v) => ref.read(waterRemindersProvider.notifier).toggle(v),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          _ReminderTile(
            icon: Icons.bedtime,
            color: AppColors.sleep,
            title: 'Sueño',
            subtitle: 'Hora de dormir 😴',
            enabled: sleep.enabled,
            time: sleep.time,
            onToggle: (v) => ref.read(sleepReminderProvider.notifier).toggle(v),
            onPickTime: (t) => ref.read(sleepReminderProvider.notifier).setTime(t),
          ),
          const SizedBox(height: AppSizes.lg),
          AppCard(
            child: Row(
              children: [
                const IconBadge(icon: Icons.local_fire_department, color: AppColors.workout),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Celebración de racha',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Recibes un aviso automático cada 5 días seguidos entrenando',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.enabled,
    required this.time,
    required this.onToggle,
    required this.onPickTime,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final bool enabled;
  final TimeOfDay time;
  final ValueChanged<bool> onToggle;
  final ValueChanged<TimeOfDay> onPickTime;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: IconBadge(icon: icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text('$subtitle · ${time.format(context)} · toca para cambiar'),
        onTap: () async {
          final picked = await showTimePicker(context: context, initialTime: time);
          if (picked != null) onPickTime(picked);
        },
        trailing: Switch(value: enabled, onChanged: onToggle),
      ),
    );
  }
}

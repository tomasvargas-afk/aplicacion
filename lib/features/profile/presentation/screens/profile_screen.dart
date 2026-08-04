import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/units/unit_converter.dart';
import '../../../../core/units/unit_preference_provider.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/icon_badge.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../body_tracking/presentation/providers/body_tracking_provider.dart';
import '../../../diet_generator/domain/usecases/diet_calculator.dart';
import '../../domain/entities/profile.dart';
import '../providers/profile_provider.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final user = ref.watch(currentUserProvider);
    final measurementsAsync = ref.watch(bodyMeasurementHistoryProvider);
    final useLb = ref.watch(unitPreferenceProvider) == WeightUnit.lb;

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: profileAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorView(
          message: describeError(error),
          onRetry: () => ref.invalidate(profileProvider),
        ),
        data: (profile) {
          final withWeight =
              (measurementsAsync.valueOrNull ?? const []).where((m) => m.weightKg != null);
          final latestWeight = withWeight.isEmpty ? null : withWeight.last.weightKg;

          return ListView(
            padding: const EdgeInsets.all(AppSizes.md),
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundImage: profile?.avatarUrl != null
                          ? NetworkImage(profile!.avatarUrl!)
                          : null,
                      child: profile?.avatarUrl == null
                          ? const Icon(Icons.person, size: 48)
                          : null,
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Text(
                      profile?.fullName?.isNotEmpty == true
                          ? profile!.fullName!
                          : (user?.email ?? ''),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    if (profile?.fullName?.isNotEmpty == true)
                      Text(user?.email ?? '', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              AppCard(
                child: Column(
                  children: [
                    _InfoRow(
                      icon: Icons.cake_outlined,
                      label: 'Edad',
                      value: profile?.age != null ? '${profile!.age} años' : 'Sin definir',
                    ),
                    const Divider(),
                    _InfoRow(
                      icon: Icons.height,
                      label: 'Estatura',
                      value: profile?.heightCm != null
                          ? '${profile!.heightCm!.toStringAsFixed(0)} cm'
                          : 'Sin definir',
                    ),
                    const Divider(),
                    _InfoRow(
                      icon: Icons.monitor_weight_outlined,
                      label: 'Peso actual',
                      value: latestWeight != null
                          ? UnitConverter.formatWeight(latestWeight, useLb: useLb)
                          : 'Sin registros',
                    ),
                    const Divider(),
                    _InfoRow(
                      icon: Icons.directions_run,
                      label: 'Actividad',
                      value: profile?.activityLevel != null
                          ? ActivityLevel.values
                              .firstWhere((a) => a.dbValue == profile!.activityLevel)
                              .label
                          : 'Sin definir',
                    ),
                    const Divider(),
                    _InfoRow(
                      icon: Icons.flag_outlined,
                      label: 'Objetivo',
                      value: profile?.goal != null
                          ? DietGoal.values.firstWhere((g) => g.dbValue == profile!.goal).label
                          : 'Sin definir',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.md),
              AppCard(
                onTap: () => context.push(RoutePaths.goals),
                child: const Row(
                  children: [
                    IconBadge(icon: Icons.flag, color: AppColors.seed),
                    SizedBox(width: AppSizes.md),
                    Expanded(
                      child: Text(
                        'Mis objetivos',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              AppCard(
                onTap: () => context.push(RoutePaths.reminders),
                child: const Row(
                  children: [
                    IconBadge(icon: Icons.notifications_outlined, color: AppColors.info),
                    SizedBox(width: AppSizes.md),
                    Expanded(
                      child: Text(
                        'Notificaciones',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              AppCard(
                onTap: () => context.push(RoutePaths.settings),
                child: const Row(
                  children: [
                    IconBadge(icon: Icons.tune, color: AppColors.workout),
                    SizedBox(width: AppSizes.md),
                    Expanded(
                      child: Text(
                        'Personalización',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.md),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EditProfileScreen(profile: profile),
                  ),
                ),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Editar perfil'),
              ),
              const SizedBox(height: AppSizes.sm),
              OutlinedButton.icon(
                onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesión'),
              ),
              const SizedBox(height: AppSizes.xxl),
            ],
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.xs),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: AppSizes.sm),
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

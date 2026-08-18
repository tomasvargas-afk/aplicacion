import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/body_tracking/presentation/screens/body_tracking_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/goals/presentation/screens/goals_screen.dart';
import '../../features/notifications/presentation/screens/reminders_screen.dart';
import '../../features/nutrition/presentation/screens/nutrition_home_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/sleep/presentation/screens/sleep_screen.dart';
import '../../features/statistics/presentation/screens/statistics_screen.dart';
import '../../features/water/presentation/screens/water_screen.dart';
import '../../features/workouts/presentation/screens/workout_list_screen.dart';
import '../onboarding/onboarding_provider.dart';
import '../widgets/bottom_nav_scaffold.dart';
import 'route_paths.dart';
import 'router_refresh_stream.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return GoRouter(
    initialLocation: RoutePaths.splash,
    refreshListenable: RouterRefreshStream(authRepository.authStateChanges),
    redirect: (context, state) {
      final isLoggedIn = authRepository.currentUser != null;
      final hasSeenOnboarding = ref.read(onboardingSeenProvider);
      final path = state.matchedLocation;
      final isAuthRoute = path == RoutePaths.login ||
          path == RoutePaths.register ||
          path == RoutePaths.forgotPassword;
      final isOnboarding = path == RoutePaths.onboarding;
      final isSplash = path == RoutePaths.splash;

      if (isLoggedIn) {
        if (isAuthRoute || isSplash || isOnboarding)
          return RoutePaths.dashboard;
        return null;
      }

      // Not logged in from here on.
      if (!hasSeenOnboarding) {
        return isOnboarding ? null : RoutePaths.onboarding;
      }
      if (isOnboarding || isSplash) return RoutePaths.login;
      if (!isAuthRoute) return RoutePaths.login;
      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: RoutePaths.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RoutePaths.bodyTracking,
        builder: (context, state) => const BodyTrackingScreen(),
      ),
      GoRoute(
        path: RoutePaths.water,
        builder: (context, state) => const WaterScreen(),
      ),
      GoRoute(
        path: RoutePaths.sleep,
        builder: (context, state) => const SleepScreen(),
      ),
      GoRoute(
        path: RoutePaths.goals,
        builder: (context, state) => const GoalsScreen(),
      ),
      GoRoute(
        path: RoutePaths.reminders,
        builder: (context, state) => const RemindersScreen(),
      ),
      GoRoute(
        path: RoutePaths.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            BottomNavScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.dashboard,
              builder: (context, state) => const DashboardScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.workouts,
              builder: (context, state) => const WorkoutListScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.nutrition,
              builder: (context, state) => const NutritionHomeScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.progress,
              builder: (context, state) => const StatisticsScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.profile,
              builder: (context, state) => const ProfileScreen(),
            ),
          ]),
        ],
      ),
    ],
  );
});

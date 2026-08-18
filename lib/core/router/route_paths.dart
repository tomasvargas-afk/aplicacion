/// Centralized route path constants consumed by `app_router.dart` and by
/// any `context.go`/`context.push` call across features.
abstract class RoutePaths {
  RoutePaths._();

  // Auth
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';

  // Shell tabs
  static const dashboard = '/dashboard';
  static const workouts = '/workouts';
  static const nutrition = '/nutrition';
  static const progress = '/progress';
  static const profile = '/profile';

  // Workouts
  static const workoutDetail = 'detail';
  static const createWorkout = 'create';
  static const editWorkout = 'edit';
  static const exercisePicker = 'exercises';
  static const workoutStats = 'stats';

  // Nutrition
  static const addMealLog = 'add-meal';
  static const recipes = 'recipes';
  static const recipeDetail = 'detail';
  static const recipeForm = 'form';
  static const dietGenerator = '/diet-generator';
  static const dietGeneratorResult = 'result';
  static const dietPlanHistory = 'history';

  // Body tracking / water / sleep / goals
  static const bodyTracking = '/body-tracking';
  static const addMeasurement = 'add';
  static const water = '/water';
  static const sleep = '/sleep';
  static const goals = '/goals';
  static const addEditGoal = 'edit';
  static const reminders = '/reminders';

  // Profile / settings
  static const editProfile = 'edit';
  static const settings = '/settings';
  static const notificationSettings = 'notifications';
  static const unitsTheme = 'units-theme';
}

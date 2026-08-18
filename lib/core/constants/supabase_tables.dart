/// Table/bucket name constants so a typo shows up as a compile-time
/// reference error instead of a silent runtime Postgres failure.
abstract class SupabaseTables {
  SupabaseTables._();

  static const profiles = 'profiles';
  static const exercisesLibrary = 'exercises_library';
  static const workouts = 'workouts';
  static const workoutExercises = 'workout_exercises';
  static const workoutSchedule = 'workout_schedule';
  static const workoutLogs = 'workout_logs';
  static const workoutLogSets = 'workout_log_sets';
  static const recipes = 'recipes';
  static const meals = 'meals';
  static const mealLogs = 'meal_logs';
  static const dietPlans = 'diet_plans';
  static const dietPlanMeals = 'diet_plan_meals';
  static const bodyMeasurements = 'body_measurements';
  static const waterLogs = 'water_logs';
  static const sleepLogs = 'sleep_logs';
  static const goals = 'goals';
  static const notificationSettings = 'notification_settings';
  static const reminders = 'reminders';
}

abstract class SupabaseBuckets {
  SupabaseBuckets._();

  static const avatars = 'avatars';
  static const recipeImages = 'recipe-images';
  static const progressPhotos = 'progress-photos';
}

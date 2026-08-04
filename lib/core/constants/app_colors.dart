import 'package:flutter/material.dart';

/// Central color palette. Keep this as the single source of truth for
/// brand and semantic colors so the light/dark themes and charts stay
/// consistent everywhere in the app.
abstract class AppColors {
  AppColors._();

  // Brand
  static const Color seed = Color(0xFF10B981); // emerald
  static const Color seedDark = Color(0xFF34D399);

  // Semantic
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Macro nutrients (used consistently in MacroBar / charts)
  static const Color protein = Color(0xFFEF4444);
  static const Color carbs = Color(0xFFF59E0B);
  static const Color fat = Color(0xFF3B82F6);
  static const Color calories = Color(0xFF10B981);

  // Feature accents (dashboard quick stats, charts)
  static const Color water = Color(0xFF0EA5E9);
  static const Color sleep = Color(0xFF8B5CF6);
  static const Color workout = Color(0xFFF97316);

  // Neutral surfaces
  static const Color lightBackground = Color(0xFFF7F8FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color darkBackground = Color(0xFF0F1115);
  static const Color darkSurface = Color(0xFF1A1D23);
}

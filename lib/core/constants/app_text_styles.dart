import 'package:flutter/material.dart';

/// Standalone text styles for places that can't reach a [BuildContext]
/// (e.g. CustomPainter labels in charts). Everywhere else, prefer
/// `Theme.of(context).textTheme`.
abstract class AppTextStyles {
  AppTextStyles._();

  static const TextStyle chartLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: Colors.grey,
  );

  static const TextStyle statValue = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle statLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.grey,
  );
}

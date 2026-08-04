import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';

/// Base card used across every feature so spacing/radius/tap behavior
/// stays consistent instead of each screen rolling its own `Container`.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSizes.md),
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final card = Card(
      child: Padding(padding: padding, child: child),
    );
    if (onTap == null) return card;
    return InkWell(
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      onTap: onTap,
      child: card,
    );
  }
}

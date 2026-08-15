import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';

/// Icon on a soft, tinted rounded backdrop — the small recurring visual
/// motif used instead of bare icons across cards (dashboard, progress,
/// goals, etc.) so every list row/card reads as part of one system.
class IconBadge extends StatelessWidget {
  const IconBadge({
    super.key,
    required this.icon,
    required this.color,
    this.size = 40,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.24),
            color.withValues(alpha: 0.10)
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm + 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: size * 0.5),
    );
  }
}

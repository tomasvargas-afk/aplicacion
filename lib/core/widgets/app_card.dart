import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';

/// Base card used across every feature so spacing/radius/tap behavior
/// stays consistent instead of each screen rolling its own `Container`.
/// Scales down slightly on press for tactile feedback when [onTap] is set.
class AppCard extends StatefulWidget {
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
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final card = AnimatedScale(
      scale: _pressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Card(
        child: Padding(padding: widget.padding, child: widget.child),
      ),
    );

    if (widget.onTap == null) return card;

    return InkWell(
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      onTap: widget.onTap,
      onHighlightChanged: (value) => setState(() => _pressed = value),
      child: card,
    );
  }
}

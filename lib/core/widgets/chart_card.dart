import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';
import 'app_card.dart';
import 'empty_state.dart';

/// Wraps any chart widget (fl_chart) with a title and a consistent empty
/// state so every stats screen looks/behaves the same when there's no data.
class ChartCard extends StatelessWidget {
  const ChartCard({
    super.key,
    required this.title,
    required this.child,
    this.height = 200,
    this.isEmpty = false,
    this.emptyMessage = 'Todavía no hay datos suficientes',
    this.trailing,
  });

  final String title;
  final Widget child;
  final double height;
  final bool isEmpty;
  final String emptyMessage;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: AppSizes.md),
          SizedBox(
            height: height,
            child: isEmpty ? Center(child: EmptyState(message: emptyMessage)) : child,
          ),
        ],
      ),
    );
  }
}

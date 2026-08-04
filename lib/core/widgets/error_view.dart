import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';
import '../constants/app_strings.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    this.message = AppStrings.somethingWentWrong,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: scheme.error),
          const SizedBox(height: AppSizes.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppSizes.md),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text(AppStrings.retry),
            ),
          ],
        ],
      ),
    );
  }
}

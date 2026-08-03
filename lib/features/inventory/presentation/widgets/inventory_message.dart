import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Compact centered spinner used while an inventory section is loading.
class InventoryLoading extends StatelessWidget {
  const InventoryLoading({this.height = 96, super.key});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: const Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

/// Compact inline error for an inventory section, with an optional retry.
class InventoryError extends StatelessWidget {
  const InventoryError({this.onRetry, super.key});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s6),
      child: Column(
        children: [
          Icon(Icons.cloud_off_outlined, size: 32, color: colors.textTertiary),
          const SizedBox(height: AppSpacing.s2),
          Text(
            l10n.inventoryLoadError,
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(color: colors.textSecondary),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppSpacing.s2),
            TextButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
          ],
        ],
      ),
    );
  }
}

/// Centered "nothing here yet" line for an empty inventory section.
class InventoryEmptyLine extends StatelessWidget {
  const InventoryEmptyLine(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s5),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: AppTypography.caption.copyWith(
            color: context.colors.textTertiary,
          ),
        ),
      ),
    );
  }
}

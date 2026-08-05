import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../application/shopping_providers.dart';
import '../../application/shopping_view.dart';
import '../shopping_error_message.dart';

/// A shopping-list row with a tappable round checkbox, as in the design.
///
/// Ticking the checkbox persists through the [ShoppingListController] and the
/// realtime stream re-emits, so every member sees the change. Checked items show
/// a filled circle and a struck-through name. Tapping the row opens the edit
/// sheet via [onTap].
class ShoppingItemRow extends ConsumerWidget {
  const ShoppingItemRow(this.resolved, {this.onTap, super.key});

  final ResolvedShoppingItem resolved;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final item = resolved.item;
    final subtitle = _subtitle();

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s4,
          vertical: AppSpacing.s3 + 2,
        ),
        child: Row(
          children: [
            _CheckboxButton(
              checked: item.checked,
              onTap: () => _toggle(context, ref),
            ),
            const SizedBox(width: AppSpacing.s4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMedium.copyWith(
                      color: item.checked
                          ? colors.textTertiary
                          : colors.textPrimary,
                      decoration: item.checked
                          ? TextDecoration.lineThrough
                          : null,
                      decorationColor: colors.textTertiary,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// The subtitle line: the quantity and category name joined by a dot,
  /// whichever are present; null when the item has neither.
  String? _subtitle() {
    final parts = [
      ?resolved.item.quantity,
      ?resolved.category?.name,
    ].where((part) => part.isNotEmpty).toList();
    return parts.isEmpty ? null : parts.join(' · ');
  }

  Future<void> _toggle(BuildContext context, WidgetRef ref) async {
    final ok = await ref
        .read(shoppingListControllerProvider.notifier)
        .toggle(id: resolved.item.id, checked: !resolved.item.checked);
    if (!ok && context.mounted) showShoppingErrorSnackBar(context, ref);
  }
}

class _CheckboxButton extends StatelessWidget {
  const _CheckboxButton({required this.checked, required this.onTap});

  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkResponse(
      onTap: onTap,
      radius: 22,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: checked ? colors.accent : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: checked ? colors.accent : colors.textTertiary,
            width: 2,
          ),
        ),
        child: checked
            ? Icon(Icons.check, size: 14, color: colors.onAccent)
            : null,
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../shopping_demo_data.dart';

/// A shopping-list row with a tappable round checkbox, as in the design.
/// Toggling is local (demo); checked items show a filled circle and a
/// struck-through name.
class ShoppingItemRow extends StatefulWidget {
  const ShoppingItemRow(this.item, {super.key});

  final ShoppingItem item;

  @override
  State<ShoppingItemRow> createState() => _ShoppingItemRowState();
}

class _ShoppingItemRowState extends State<ShoppingItemRow> {
  late bool _checked = widget.item.checked;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final item = widget.item;

    return InkWell(
      onTap: () => setState(() => _checked = !_checked),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s4,
          vertical: AppSpacing.s3 + 2,
        ),
        child: Row(
          children: [
            _Checkbox(checked: _checked),
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
                      color: _checked
                          ? colors.textTertiary
                          : colors.textPrimary,
                      decoration: _checked ? TextDecoration.lineThrough : null,
                      decorationColor: colors.textTertiary,
                    ),
                  ),
                  Text(
                    '${item.detail} · ${item.category}',
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
}

class _Checkbox extends StatelessWidget {
  const _Checkbox({required this.checked});

  final bool checked;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AnimatedContainer(
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
    );
  }
}

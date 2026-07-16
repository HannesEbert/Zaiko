import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../shopping_demo_data.dart';

/// A shopping-list row with a tappable checkbox. Toggling is local (demo);
/// checked items show a filled box and a struck-through name.
class ShoppingItemRow extends StatefulWidget {
  const ShoppingItemRow(this.item, {this.initialChecked = false, super.key});

  final ShoppingItem item;
  final bool initialChecked;

  @override
  State<ShoppingItemRow> createState() => _ShoppingItemRowState();
}

class _ShoppingItemRowState extends State<ShoppingItemRow> {
  late bool _checked = widget.initialChecked;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final item = widget.item;

    return InkWell(
      onTap: () => setState(() => _checked = !_checked),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s3 + 2,
          vertical: AppSpacing.s3 + 1,
        ),
        child: Row(
          children: [
            _Checkbox(checked: _checked),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Text(
                item.name,
                style: AppTypography.body.copyWith(
                  color: _checked ? colors.textTertiary : colors.textPrimary,
                  decoration: _checked ? TextDecoration.lineThrough : null,
                  decorationColor: colors.textTertiary,
                ),
              ),
            ),
            if (!_checked) _Trailing(item: item),
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
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: checked ? colors.accent : Colors.transparent,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: checked ? colors.accent : colors.borderStrong,
          width: 1.5,
        ),
      ),
      child: checked
          ? Icon(Icons.check, size: 14, color: colors.onAccent)
          : null,
    );
  }
}

class _Trailing extends StatelessWidget {
  const _Trailing({required this.item});

  final ShoppingItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (item.memberInitial != null) {
      return UserAvatar(
        initial: item.memberInitial!,
        size: 20,
        accent: item.memberInitial == 'H',
      );
    }
    if (item.trailing != null) {
      return Text(
        item.trailing!,
        style: AppTypography.caption.copyWith(
          fontSize: 13,
          color: colors.textTertiary,
          fontFeatures: AppTypography.tabularFigures,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

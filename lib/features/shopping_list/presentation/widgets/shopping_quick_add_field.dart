import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../application/shopping_providers.dart';
import '../shopping_error_message.dart';

/// The inline quick-add field: type an item name and submit to add it to the
/// list by name only. Details (quantity, category) can be added later via the
/// edit sheet. Mirrors the [PillField] look but is editable.
class ShoppingQuickAddField extends ConsumerStatefulWidget {
  const ShoppingQuickAddField({super.key});

  @override
  ConsumerState<ShoppingQuickAddField> createState() =>
      _ShoppingQuickAddFieldState();
}

class _ShoppingQuickAddFieldState extends ConsumerState<ShoppingQuickAddField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    final ok = await ref
        .read(shoppingListControllerProvider.notifier)
        .add(name: name);
    if (!mounted) return;
    if (ok) {
      _controller.clear();
    } else {
      showShoppingErrorSnackBar(context, ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Container(
      height: AppSpacing.s12,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      decoration: BoxDecoration(
        color: colors.field,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Row(
        children: [
          Icon(Icons.add, size: 16, color: colors.textTertiary),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              style: AppTypography.body.copyWith(color: colors.textPrimary),
              decoration: InputDecoration.collapsed(
                hintText: l10n.shoppingAddHint,
                hintStyle: AppTypography.body.copyWith(
                  color: colors.textTertiary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

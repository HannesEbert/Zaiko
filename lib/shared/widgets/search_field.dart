import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// An editable search field styled like [PillField]: a rounded, bordered pill
/// with a leading search icon and a trailing clear button that appears once the
/// field holds text.
///
/// Unlike [PillField] (a tappable entry point that opens a search flow), this is
/// the real input used inside the search surfaces themselves.
class SearchField extends StatelessWidget {
  const SearchField({
    required this.controller,
    required this.hint,
    this.onChanged,
    this.autofocus = false,
    super.key,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.field,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        height: AppSpacing.s12,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colors.borderSubtle),
        ),
        child: Row(
          children: [
            Icon(Icons.search, size: 16, color: colors.textTertiary),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                autofocus: autofocus,
                textInputAction: TextInputAction.search,
                style: AppTypography.body.copyWith(color: colors.textPrimary),
                cursorColor: colors.accentText,
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: AppTypography.body.copyWith(
                    color: colors.textTertiary,
                  ),
                ),
              ),
            ),
            // Rebuild the clear button as the text changes so it tracks empties.
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                if (value.text.isEmpty) return const SizedBox.shrink();
                return InkResponse(
                  onTap: () {
                    controller.clear();
                    onChanged?.call('');
                  },
                  radius: 18,
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: colors.textTertiary,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/card_list.dart';

/// Lead-time options, in days. Bounded to the scheduler's 14-day planning
/// horizon (see NotificationIds.expiryHorizonDays).
const List<int> _leadDayOptions = [1, 2, 3, 5, 7, 10, 14];

/// Shows the lead-time picker as a modal bottom sheet and resolves to the
/// chosen number of days, or null when dismissed.
Future<int?> showReminderLeadDaysSheet(BuildContext context, int current) {
  return showModalBottomSheet<int>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => _ReminderLeadDaysSheet(current: current),
  );
}

class _ReminderLeadDaysSheet extends StatelessWidget {
  const _ReminderLeadDaysSheet({required this.current});

  final int current;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.lg),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s5,
            AppSpacing.s2,
            AppSpacing.s5,
            AppSpacing.s5,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.s3),
                  decoration: BoxDecoration(
                    color: colors.borderStrong,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
              ),
              Text(
                l10n.remindersLeadDaysLabel,
                style: AppTypography.headline.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s4),
              Flexible(
                child: SingleChildScrollView(
                  child: CardList(
                    children: [
                      for (final days in _leadDayOptions)
                        _LeadDaysOption(
                          label: l10n.remindersLeadDaysValue(days),
                          selected: days == current,
                          onTap: () => Navigator.of(context).pop(days),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeadDaysOption extends StatelessWidget {
  const _LeadDaysOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s3 + 2),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  color: selected ? colors.accentText : colors.textPrimary,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
            if (selected) Icon(Icons.check, size: 18, color: colors.accentText),
          ],
        ),
      ),
    );
  }
}

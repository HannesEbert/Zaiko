import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/reminder_time.dart';

/// Shows the daily-reminder-time picker as a modal bottom sheet with hour and
/// minute wheels, resolving to the chosen [ReminderTime] or null when dismissed.
Future<ReminderTime?> showReminderTimeSheet(
  BuildContext context,
  ReminderTime current,
) {
  return showModalBottomSheet<ReminderTime>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => _ReminderTimeSheet(current: current),
  );
}

class _ReminderTimeSheet extends StatefulWidget {
  const _ReminderTimeSheet({required this.current});

  final ReminderTime current;

  @override
  State<_ReminderTimeSheet> createState() => _ReminderTimeSheetState();
}

class _ReminderTimeSheetState extends State<_ReminderTimeSheet> {
  static const double _itemExtent = 40;

  late int _hour = widget.current.hour;
  late int _minute = widget.current.minute;
  late final FixedExtentScrollController _hourController =
      FixedExtentScrollController(initialItem: _hour);
  late final FixedExtentScrollController _minuteController =
      FixedExtentScrollController(initialItem: _minute);

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

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
                l10n.remindersTimeLabel,
                style: AppTypography.headline.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s4),
              SizedBox(
                height: _itemExtent * 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _wheel(
                      controller: _hourController,
                      count: 24,
                      onChanged: (value) => setState(() => _hour = value),
                    ),
                    Text(
                      ':',
                      style: AppTypography.display.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    _wheel(
                      controller: _minuteController,
                      count: 60,
                      onChanged: (value) => setState(() => _minute = value),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s5),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(
                    context,
                  ).pop(ReminderTime(hour: _hour, minute: _minute)),
                  child: Text(l10n.commonDone),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _wheel({
    required FixedExtentScrollController controller,
    required int count,
    required ValueChanged<int> onChanged,
  }) {
    final colors = context.colors;

    return SizedBox(
      width: 64,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: _itemExtent,
        physics: const FixedExtentScrollPhysics(),
        overAndUnderCenterOpacity: 0.35,
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: count,
          builder: (context, index) => Center(
            child: Text(
              index.toString().padLeft(2, '0'),
              style: AppTypography.title.copyWith(
                color: colors.textPrimary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

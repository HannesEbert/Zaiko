import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/notifications/notification_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/app_switch.dart';
import '../../../../shared/widgets/card_list.dart';
import '../../application/profile_providers.dart';
import '../../domain/reminder_time.dart';
import '../profile_error_message.dart';
import '../widgets/reminder_lead_days_sheet.dart';
import '../widgets/reminder_time_sheet.dart';

/// Configures the per-user expiry reminders: on/off, lead time and daily time.
///
/// Reached from the profile tab. Seeds its edit state once from the current
/// profile, then persists via [ReminderSettingsController]. Enabling asks for
/// notification permission; a denial leaves the toggle on (the scheduler simply
/// has nothing to deliver until permission is granted in system settings).
class RemindersPage extends ConsumerStatefulWidget {
  const RemindersPage({super.key});

  /// Relative segment under the profile branch (`/profile/reminders`).
  static const String routeSegment = 'reminders';
  static const String routeName = 'profile-reminders';

  @override
  ConsumerState<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends ConsumerState<RemindersPage> {
  bool _enabled = false;
  int _leadDays = 3;
  ReminderTime _time = ReminderTime.defaultTime;
  bool _seeded = false;

  Future<void> _onToggle(bool value) async {
    setState(() => _enabled = value);
    if (!value) return;
    final granted = await ref
        .read(notificationServiceProvider)
        .requestPermission();
    if (!granted && mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(context.l10n.remindersPermissionDenied)),
        );
    }
  }

  Future<void> _pickLeadDays() async {
    final days = await showReminderLeadDaysSheet(context, _leadDays);
    if (days != null) setState(() => _leadDays = days);
  }

  Future<void> _pickTime() async {
    final time = await showReminderTimeSheet(context, _time);
    if (time != null) setState(() => _time = time);
  }

  Future<void> _submit() async {
    final ok = await ref
        .read(reminderSettingsControllerProvider.notifier)
        .save(
          enabled: _enabled,
          leadDays: _leadDays,
          reminderTime: _time.format(),
        );

    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(context.l10n.remindersSavedSnack)),
        );
      context.pop();
    } else {
      showProfileErrorSnackBar(
        context,
        ref,
        error: ref.read(reminderSettingsControllerProvider).error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final profileAsync = ref.watch(myProfileProvider);
    final isBusy = ref.watch(reminderSettingsControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileReminders)),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.pageInset),
            child: Text(
              l10n.profileErrorGeneric,
              style: AppTypography.body.copyWith(color: colors.textSecondary),
            ),
          ),
        ),
        data: (profile) {
          if (profile == null) return const SizedBox.shrink();
          if (!_seeded) {
            _enabled = profile.remindersEnabled;
            _leadDays = profile.reminderLeadDays;
            _time = ReminderTime.parse(profile.reminderTime);
            _seeded = true;
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pageInset,
              AppSpacing.s5,
              AppSpacing.pageInset,
              AppSpacing.s10,
            ),
            children: [
              Text(
                l10n.remindersSubtitle,
                style: AppTypography.body.copyWith(color: colors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.s6),
              CardList(
                children: [
                  _ReminderRow(
                    icon: Icons.notifications_outlined,
                    label: l10n.remindersEnableLabel,
                    trailing: AppSwitch(value: _enabled, onChanged: _onToggle),
                  ),
                  _ReminderRow(
                    icon: Icons.schedule_outlined,
                    label: l10n.remindersLeadDaysLabel,
                    value: l10n.remindersLeadDaysValue(_leadDays),
                    onTap: _enabled ? _pickLeadDays : null,
                  ),
                  _ReminderRow(
                    icon: Icons.access_time,
                    label: l10n.remindersTimeLabel,
                    value: _time.format(),
                    onTap: _enabled ? _pickTime : null,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s6),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: isBusy ? null : _submit,
                  child: isBusy
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.commonSave),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// A settings line inside the reminders card: leading [icon], [label] and an
/// optional [value] caption or [trailing] accessory. Mirrors the shared
/// SettingRow but scoped to this page so its disabled (untappable) state reads
/// clearly.
class _ReminderRow extends StatelessWidget {
  const _ReminderRow({
    required this.icon,
    required this.label,
    this.value,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimmed = trailing == null && onTap == null;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s3 + 2,
          vertical: AppSpacing.s3,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 19,
              color: dimmed ? colors.textTertiary : colors.textStrong,
            ),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Text(
                label,
                style: AppTypography.body.copyWith(
                  color: dimmed ? colors.textTertiary : colors.textPrimary,
                ),
              ),
            ),
            if (trailing != null)
              trailing!
            else if (value != null) ...[
              Text(
                value!,
                style: AppTypography.caption.copyWith(
                  fontSize: 14,
                  color: dimmed ? colors.textTertiary : colors.textSecondary,
                ),
              ),
              if (onTap != null) ...[
                const SizedBox(width: AppSpacing.s1 + 2),
                Icon(Icons.chevron_right, size: 16, color: colors.borderStrong),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

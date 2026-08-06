import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/avatar_presets.dart';
import '../../../../shared/widgets/user_avatar.dart';

/// A grid of selectable avatars: the colour+initial default first, then every
/// preset. The current selection is ringed. [selectedPreset] is `null` for the
/// default; a preset key otherwise.
class AvatarPicker extends StatelessWidget {
  const AvatarPicker({
    required this.initial,
    required this.userId,
    required this.selectedPreset,
    required this.onSelected,
    super.key,
  });

  /// Initial shown on the default (colour+initial) option.
  final String initial;

  /// Drives the default option's stable colour.
  final String userId;

  /// The currently selected preset key, or `null` for the default avatar.
  final String? selectedPreset;

  /// Called with the chosen preset key, or `null` for the default avatar.
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s3,
      runSpacing: AppSpacing.s3,
      children: [
        _Option(
          selected: selectedPreset == null,
          onTap: () => onSelected(null),
          child: UserAvatar(
            initial: initial,
            backgroundColor: avatarColorForId(userId),
            size: _avatarSize,
          ),
        ),
        for (final preset in avatarPresets)
          _Option(
            selected: selectedPreset == preset.key,
            onTap: () => onSelected(preset.key),
            child: UserAvatar(
              initial: initial,
              preset: preset,
              size: _avatarSize,
            ),
          ),
      ],
    );
  }
}

const double _avatarSize = 52;

class _Option extends StatelessWidget {
  const _Option({
    required this.selected,
    required this.onTap,
    required this.child,
  });

  final bool selected;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? colors.accent : Colors.transparent,
            width: 2,
          ),
        ),
        child: child,
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../shared/widgets/avatar_presets.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../domain/profile.dart';

/// Renders a [Profile]'s avatar: its chosen preset, or a stable colour+initial
/// default. Bridges the profile domain to the feature-agnostic [UserAvatar].
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    required this.profile,
    this.size = 36,
    this.borderColor,
    super.key,
  });

  final Profile profile;
  final double size;
  final Color? borderColor;

  /// First letter of a display name, uppercased; `?` when empty.
  static String initialOf(String displayName) {
    final trimmed = displayName.trim();
    return trimmed.isEmpty ? '?' : trimmed[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final preset = avatarPresetForKey(profile.avatarPreset);
    return UserAvatar(
      initial: initialOf(profile.displayName),
      preset: preset,
      backgroundColor: preset == null ? avatarColorForId(profile.id) : null,
      size: size,
      borderColor: borderColor,
    );
  }
}

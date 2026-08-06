import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// A selectable preset avatar: a fixed palette colour and a motif glyph.
///
/// Rendered entirely in-app (no image assets), so a member's avatar shows the
/// same everywhere and adding presets needs no bundled art. The [key] is what is
/// persisted in `profiles.avatar_preset`.
@immutable
class AvatarPreset {
  const AvatarPreset(this.key, this.colorKey, this.icon);

  /// Stable identifier stored in the database.
  final String key;

  /// A palette key from [AppColors.paletteKeys], resolved via
  /// [AppColors.categoryForKey].
  final String colorKey;

  /// The motif drawn on the avatar.
  final IconData icon;

  /// The resolved background colour.
  Color get color => AppColors.categoryForKey(colorKey);
}

/// The preset avatars offered in the picker, in display order.
const List<AvatarPreset> avatarPresets = [
  AvatarPreset('sprout', 'green', Icons.eco),
  AvatarPreset('herb', 'lime', Icons.local_florist),
  AvatarPreset('citrus', 'amber', Icons.emoji_nature),
  AvatarPreset('honey', 'yellow', Icons.spa),
  AvatarPreset('pumpkin', 'orange', Icons.bakery_dining),
  AvatarPreset('berry', 'red', Icons.cake),
  AvatarPreset('blossom', 'pink', Icons.icecream),
  AvatarPreset('grape', 'purple', Icons.local_cafe),
  AvatarPreset('ocean', 'blue', Icons.ramen_dining),
  AvatarPreset('mint', 'cyan', Icons.cookie),
  AvatarPreset('stone', 'slate', Icons.pets),
  AvatarPreset('cocoa', 'brown', Icons.egg),
  AvatarPreset('oat', 'beige', Icons.local_pizza),
];

/// The preset for [key], or `null` for an unknown or missing key (the caller
/// then falls back to the colour+initial default avatar).
AvatarPreset? avatarPresetForKey(String? key) {
  if (key == null) return null;
  for (final preset in avatarPresets) {
    if (preset.key == key) return preset;
  }
  return null;
}

/// A stable per-id palette colour for the default (colour+initial) avatar, so a
/// given user keeps the same colour on every device. Uses a deterministic hash
/// (String.hashCode is not stable across runs).
Color avatarColorForId(String? id) {
  if (id == null || id.isEmpty) return AppColors.categoryForKey(null);
  var hash = 0;
  for (final unit in id.codeUnits) {
    hash = (hash * 31 + unit) & 0x7fffffff;
  }
  final key = AppColors.paletteKeys[hash % AppColors.paletteKeys.length];
  return AppColors.categoryForKey(key);
}

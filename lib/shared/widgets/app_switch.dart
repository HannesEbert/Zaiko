import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// The app's toggle switch: a thin [Switch.adaptive] wrapper themed with the
/// accent colour, so every toggle looks the same. Pass a null [onChanged] to
/// render it disabled.
class AppSwitch extends StatelessWidget {
  const AppSwitch({required this.value, required this.onChanged, super.key});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: value,
      onChanged: onChanged,
      activeTrackColor: context.colors.accent,
    );
  }
}

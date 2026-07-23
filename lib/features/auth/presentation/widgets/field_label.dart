import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Small caption label rendered above an auth form field.
///
/// Shared by the sign-in and registration screens so both style their field
/// labels identically.
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.caption.copyWith(
        fontWeight: FontWeight.w500,
        color: context.colors.textStrong,
      ),
    );
  }
}

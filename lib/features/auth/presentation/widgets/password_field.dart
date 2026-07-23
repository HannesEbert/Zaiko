import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Obscured password input with a show/hide toggle.
///
/// Owns its own obscure state so each instance (e.g. password and its
/// confirmation) toggles independently. Shared by the sign-in and registration
/// screens so the eye toggle behaves identically everywhere.
class PasswordField extends StatefulWidget {
  const PasswordField({
    required this.controller,
    required this.validator,
    this.enabled = true,
    this.textInputAction = TextInputAction.done,
    this.autofillHints = const [AutofillHints.password],
    this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final bool enabled;
  final TextInputAction textInputAction;
  final Iterable<String> autofillHints;
  final VoidCallback? onSubmitted;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return TextFormField(
      controller: widget.controller,
      enabled: widget.enabled,
      obscureText: _obscure,
      autofillHints: widget.autofillHints,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onSubmitted == null
          ? null
          : (_) => widget.onSubmitted!(),
      style: AppTypography.body.copyWith(color: colors.textPrimary),
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () => setState(() => _obscure = !_obscure),
          icon: Icon(
            _obscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: colors.textTertiary,
            size: 20,
          ),
        ),
      ),
      validator: widget.validator,
    );
  }
}

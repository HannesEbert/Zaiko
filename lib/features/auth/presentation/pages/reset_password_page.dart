import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/zaiko_buttons.dart';
import '../../application/auth_providers.dart';
import '../../domain/auth_repository.dart';
import '../auth_validators.dart';
import '../widgets/field_label.dart';
import '../widgets/password_field.dart';

/// Set-new-password screen, reached after the user opens a recovery deep link.
///
/// The router routes an active recovery session here; on success the controller
/// signs the user out, so the router returns them to sign-in to log in with the
/// new password. This page therefore never navigates by hand.
class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key});

  static const String routePath = '/reset-password';
  static const String routeName = 'reset-password';

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final updated = await ref
        .read(passwordResetControllerProvider.notifier)
        .updatePassword(_passwordController.text);
    if (!mounted || !updated) return;
    // Sign-out flips the auth state, so the router redirects to sign-in; the
    // root messenger keeps this confirmation visible across that transition.
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(context.l10n.resetPasswordSuccess)),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final state = ref.watch(passwordResetControllerProvider);
    final isLoading = state.isLoading;

    // Surface failures as a snack bar without rebuilding into an error UI.
    ref.listen(passwordResetControllerProvider, (_, next) {
      if (next case AsyncError(:final error)) {
        final message = error is AuthFailure
            ? error.message
            : context.l10n.loginGenericError;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.resetPasswordTitle)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s8,
              vertical: AppSpacing.s6,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.resetPasswordSubtitle,
                      style: AppTypography.body.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    FieldLabel(l10n.resetPasswordNewPasswordLabel),
                    const SizedBox(height: AppSpacing.s1 + 2),
                    PasswordField(
                      controller: _passwordController,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.newPassword],
                      validator: (value) =>
                          AuthValidators.password(l10n, value),
                    ),
                    const SizedBox(height: AppSpacing.s3),
                    FieldLabel(l10n.resetPasswordConfirmLabel),
                    const SizedBox(height: AppSpacing.s1 + 2),
                    PasswordField(
                      controller: _confirmPasswordController,
                      enabled: !isLoading,
                      autofillHints: const [AutofillHints.newPassword],
                      onSubmitted: _submit,
                      validator: (value) => AuthValidators.confirmPassword(
                        l10n,
                        value,
                        _passwordController.text,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s5),
                    ZaikoPrimaryButton(
                      label: l10n.resetPasswordSaveButton,
                      isLoading: isLoading,
                      onPressed: _submit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

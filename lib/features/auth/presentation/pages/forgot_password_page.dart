import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/zaiko_buttons.dart';
import '../../application/auth_providers.dart';
import '../../domain/auth_repository.dart';
import '../auth_validators.dart';
import '../widgets/field_label.dart';

/// Password-reset request screen.
///
/// Collects the account email and asks Supabase to send a recovery link. On
/// success it swaps the form for a "check your email" confirmation offering to
/// resend the link or return to sign-in; the actual new-password step happens
/// on [ResetPasswordPage] after the user opens the emailed deep link.
class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  static const String routePath = '/forgot-password';
  static const String routeName = 'forgot-password';

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  /// The address the link was sent to; non-null switches the page from the
  /// request form to the confirmation view.
  String? _sentToEmail;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final email = _emailController.text.trim();
    final sent = await ref
        .read(passwordResetControllerProvider.notifier)
        .sendResetEmail(email);
    if (!mounted || !sent) return;
    setState(() => _sentToEmail = email);
  }

  Future<void> _resend() async {
    final email = _sentToEmail;
    if (email == null) return;
    final sent = await ref
        .read(passwordResetControllerProvider.notifier)
        .sendResetEmail(email);
    if (!mounted || !sent) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(context.l10n.forgotPasswordEmailSent)),
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
      appBar: AppBar(title: Text(l10n.forgotPasswordTitle)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s8,
              vertical: AppSpacing.s6,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: _sentToEmail == null
                  ? _buildForm(l10n, colors, isLoading)
                  : _buildConfirmation(l10n, colors, isLoading),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(AppLocalizations l10n, AppColors colors, bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.forgotPasswordSubtitle,
            style: AppTypography.body.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.s8),
          FieldLabel(l10n.loginEmailLabel),
          const SizedBox(height: AppSpacing.s1 + 2),
          TextFormField(
            controller: _emailController,
            enabled: !isLoading,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            style: AppTypography.body.copyWith(color: colors.textPrimary),
            decoration: InputDecoration(hintText: l10n.loginEmailHint),
            validator: (value) => AuthValidators.email(l10n, value),
          ),
          const SizedBox(height: AppSpacing.s5),
          ZaikoPrimaryButton(
            label: l10n.forgotPasswordSendButton,
            isLoading: isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmation(
    AppLocalizations l10n,
    AppColors colors,
    bool isLoading,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          Icons.mark_email_read_outlined,
          size: AppSpacing.s12,
          color: colors.accent,
        ),
        const SizedBox(height: AppSpacing.s6),
        Text(
          l10n.forgotPasswordSentTitle,
          textAlign: TextAlign.center,
          style: AppTypography.title.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.s3),
        Text(
          l10n.forgotPasswordSentBody(_sentToEmail!),
          textAlign: TextAlign.center,
          style: AppTypography.body.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.s8),
        ZaikoPrimaryButton(
          label: l10n.forgotPasswordResend,
          isLoading: isLoading,
          onPressed: _resend,
        ),
        const SizedBox(height: AppSpacing.s3),
        ZaikoSecondaryButton(
          label: l10n.forgotPasswordBackToLogin,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ],
    );
  }
}

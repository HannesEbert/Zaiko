import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/zaiko_buttons.dart';
import '../../../profile/presentation/pages/privacy_page.dart';
import '../../application/auth_providers.dart';
import '../../data/auth_repository.dart';
import '../auth_validators.dart';
import '../widgets/field_label.dart';
import '../widgets/password_field.dart';

/// Dedicated account-creation screen.
///
/// Separate from [sign-in](LoginPage): it collects email, password and a
/// password confirmation, and requires accepting the privacy policy before the
/// account can be created. Registration itself flows through
/// [LoginController.signUp]; a completed sign-up updates the auth state, which
/// the router's redirect reacts to — so this page never navigates home by hand.
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  static const String routePath = '/register';
  static const String routeName = 'register';

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _acceptedPrivacy = false;

  late final TapGestureRecognizer _privacyTapRecognizer;

  @override
  void initState() {
    super.initState();
    _privacyTapRecognizer = TapGestureRecognizer()..onTap = _openPrivacyPolicy;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _privacyTapRecognizer.dispose();
    super.dispose();
  }

  void _openPrivacyPolicy() {
    // The route-based `/profile/privacy` is unreachable before sign-in, so open
    // the existing page directly on the root navigator, bypassing the guard.
    Navigator.of(
      context,
      rootNavigator: true,
    ).push(MaterialPageRoute<void>(builder: (_) => const PrivacyPage()));
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final outcome = await ref
        .read(loginControllerProvider.notifier)
        .signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
    if (!mounted) return;
    // A created-and-signed-in account flips the auth state, so the router
    // redirects to home on its own. Only email confirmation needs a nudge.
    if (outcome == SignUpOutcome.emailConfirmationRequired) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(context.l10n.loginConfirmEmailSent)),
        );
      unawaited(Navigator.of(context).maybePop());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final state = ref.watch(loginControllerProvider);
    final isLoading = state.isLoading;

    // Surface auth failures as a snack bar without rebuilding into an error UI.
    ref.listen(loginControllerProvider, (_, next) {
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
      appBar: AppBar(title: Text(l10n.registerTitle)),
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
                      l10n.registerSubtitle,
                      style: AppTypography.body.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    FieldLabel(l10n.loginEmailLabel),
                    const SizedBox(height: AppSpacing.s1 + 2),
                    TextFormField(
                      controller: _emailController,
                      enabled: !isLoading,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      textInputAction: TextInputAction.next,
                      style: AppTypography.body.copyWith(
                        color: colors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.loginEmailHint,
                      ),
                      validator: (value) => AuthValidators.email(l10n, value),
                    ),
                    const SizedBox(height: AppSpacing.s3),
                    FieldLabel(l10n.loginPasswordLabel),
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
                    FieldLabel(l10n.registerConfirmPasswordLabel),
                    const SizedBox(height: AppSpacing.s1 + 2),
                    PasswordField(
                      controller: _confirmPasswordController,
                      enabled: !isLoading,
                      autofillHints: const [AutofillHints.newPassword],
                      onSubmitted: _acceptedPrivacy ? _submit : null,
                      validator: (value) => AuthValidators.confirmPassword(
                        l10n,
                        value,
                        _passwordController.text,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    _PrivacyConsent(
                      accepted: _acceptedPrivacy,
                      enabled: !isLoading,
                      recognizer: _privacyTapRecognizer,
                      onChanged: (value) =>
                          setState(() => _acceptedPrivacy = value),
                    ),
                    const SizedBox(height: AppSpacing.s5),
                    ZaikoPrimaryButton(
                      label: l10n.loginCreateAccountButton,
                      isLoading: isLoading,
                      onPressed: _acceptedPrivacy ? _submit : null,
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

/// Privacy-policy consent: a required checkbox whose label links to the policy.
class _PrivacyConsent extends StatelessWidget {
  const _PrivacyConsent({
    required this.accepted,
    required this.enabled,
    required this.recognizer,
    required this.onChanged,
  });

  final bool accepted;
  final bool enabled;
  final GestureRecognizer recognizer;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final consent = l10n.registerPrivacyConsent;
    final link = l10n.registerPrivacyPolicyLink;
    final linkStart = consent.indexOf(link);

    final baseStyle = AppTypography.caption.copyWith(
      color: colors.textSecondary,
    );
    final linkStyle = baseStyle.copyWith(
      color: colors.accentText,
      fontWeight: FontWeight.w600,
    );

    final spans = linkStart < 0
        ? [TextSpan(text: consent, style: baseStyle)]
        : [
            TextSpan(text: consent.substring(0, linkStart), style: baseStyle),
            TextSpan(text: link, style: linkStyle, recognizer: recognizer),
            TextSpan(
              text: consent.substring(linkStart + link.length),
              style: baseStyle,
            ),
          ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox.square(
          dimension: 24,
          child: Checkbox(
            value: accepted,
            onChanged: enabled ? (value) => onChanged(value ?? false) : null,
            activeColor: colors.accent,
            checkColor: colors.onAccent,
            side: BorderSide(color: colors.borderSubtle),
          ),
        ),
        const SizedBox(width: AppSpacing.s3),
        Expanded(child: Text.rich(TextSpan(children: spans))),
      ],
    );
  }
}

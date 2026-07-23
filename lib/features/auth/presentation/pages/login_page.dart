import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/zaiko_buttons.dart';
import '../../application/auth_providers.dart';
import '../../data/auth_repository.dart';
import '../auth_validators.dart';
import '../widgets/field_label.dart';
import '../widgets/password_field.dart';
import 'register_page.dart';

/// Email/password sign-in screen.
///
/// A successful sign-in flows through the auth state stream, which triggers the
/// router's redirect — so this page never navigates by hand. It only collects
/// credentials and reflects the [LoginController]'s loading/error state.
/// Account creation lives on its own [RegisterPage], reached via the
/// "create account" action below.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  static const String routePath = '/login';
  static const String routeName = 'login';

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref
        .read(loginControllerProvider.notifier)
        .signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Header(),
                    const SizedBox(height: AppSpacing.s10),
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
                      onSubmitted: _signIn,
                      validator: (value) =>
                          AuthValidators.password(l10n, value),
                    ),
                    const SizedBox(height: AppSpacing.s5),
                    ZaikoPrimaryButton(
                      label: l10n.loginSignInButton,
                      isLoading: isLoading,
                      onPressed: _signIn,
                    ),
                    const SizedBox(height: AppSpacing.s2),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () => context.pushNamed(RegisterPage.routeName),
                      style: TextButton.styleFrom(
                        foregroundColor: colors.accentText,
                        textStyle: AppTypography.bodyMedium,
                      ),
                      child: Text(l10n.loginCreateAccountButton),
                    ),
                    const SizedBox(height: AppSpacing.s5),
                    Text(
                      l10n.loginTerms,
                      textAlign: TextAlign.center,
                      style: AppTypography.caption.copyWith(
                        color: colors.textTertiary,
                      ),
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

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Column(
      children: [
        Text(
          AppConstants.appName,
          style: AppTypography.display.copyWith(
            fontSize: 34,
            color: colors.accentText,
          ),
        ),
        const SizedBox(height: AppSpacing.s1),
        Text(
          l10n.loginTagline,
          style: AppTypography.caption.copyWith(color: colors.textTertiary),
        ),
        const SizedBox(height: AppSpacing.s6),
        Text(
          l10n.loginHeadline,
          textAlign: TextAlign.center,
          style: AppTypography.title.copyWith(
            fontSize: 20,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.s2),
        Text(
          l10n.loginSubtitle,
          textAlign: TextAlign.center,
          style: AppTypography.body.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/zaiko_buttons.dart';
import '../../../../shared/widgets/zaiko_card.dart';
import '../../../auth/presentation/widgets/field_label.dart';
import '../../application/households_providers.dart';
import '../household_error_message.dart';

/// Which onboarding action is currently in flight, so only the pressed button
/// shows a spinner while both stay disabled.
enum _OnboardingAction { create, join }

/// First screen after sign-in for a user without a household: create one, or
/// join an existing one by invite code.
///
/// A successful action invalidates the household providers; the resulting
/// membership change flows through the router redirect, so this screen never
/// navigates away by hand.
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  static const String routePath = '/onboarding';
  static const String routeName = 'onboarding';

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _createFormKey = GlobalKey<FormState>();
  final _joinFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();

  _OnboardingAction? _pending;

  @override
  void initState() {
    super.initState();
    // Consume a code carried over from a join link opened before sign-in.
    final pending = ref.read(pendingInviteCodeProvider);
    if (pending != null) {
      _codeController.text = pending;
      ref.read(pendingInviteCodeProvider.notifier).clear();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (!(_createFormKey.currentState?.validate() ?? false)) return;
    setState(() => _pending = _OnboardingAction.create);
    await ref
        .read(onboardingControllerProvider.notifier)
        .createHousehold(_nameController.text.trim());
    if (mounted) setState(() => _pending = null);
  }

  Future<void> _join() async {
    if (!(_joinFormKey.currentState?.validate() ?? false)) return;
    setState(() => _pending = _OnboardingAction.join);
    await ref
        .read(onboardingControllerProvider.notifier)
        .joinByCode(_codeController.text.trim().toUpperCase());
    if (mounted) setState(() => _pending = null);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final isBusy = ref.watch(onboardingControllerProvider).isLoading;

    // Surface failures (e.g. an invalid or expired code) as a snack bar.
    ref.listen(onboardingControllerProvider, (_, next) {
      if (next case AsyncError(:final error)) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(householdErrorMessage(l10n, error))),
          );
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.onboardingTitle)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s6,
              vertical: AppSpacing.s6,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.onboardingSubtitle,
                    style: AppTypography.body.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s6),
                  _CreateCard(
                    formKey: _createFormKey,
                    controller: _nameController,
                    enabled: !isBusy,
                    isLoading: _pending == _OnboardingAction.create,
                    onSubmit: _create,
                  ),
                  const SizedBox(height: AppSpacing.s5),
                  _JoinCard(
                    formKey: _joinFormKey,
                    controller: _codeController,
                    enabled: !isBusy,
                    isLoading: _pending == _OnboardingAction.join,
                    onSubmit: _join,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// "Create a household" card: a name field and a primary action.
class _CreateCard extends StatelessWidget {
  const _CreateCard({
    required this.formKey,
    required this.controller,
    required this.enabled,
    required this.isLoading,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final bool enabled;
  final bool isLoading;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return ZaikoCard(
      padding: const EdgeInsets.all(AppSpacing.s5),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.onboardingCreateTitle,
              style: AppTypography.headline.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.s1),
            Text(
              l10n.onboardingCreateSubtitle,
              style: AppTypography.caption.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.s4),
            FieldLabel(l10n.onboardingNameLabel),
            const SizedBox(height: AppSpacing.s1 + 2),
            TextFormField(
              controller: controller,
              enabled: enabled,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.words,
              style: AppTypography.body.copyWith(color: colors.textPrimary),
              decoration: InputDecoration(hintText: l10n.onboardingNameHint),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? l10n.onboardingNameEmpty
                  : null,
              onFieldSubmitted: (_) => enabled ? onSubmit() : null,
            ),
            const SizedBox(height: AppSpacing.s4),
            ZaikoPrimaryButton(
              label: l10n.onboardingCreateButton,
              isLoading: isLoading,
              onPressed: enabled ? onSubmit : null,
            ),
          ],
        ),
      ),
    );
  }
}

/// "Join a household" card: an invite-code field and a primary action.
class _JoinCard extends StatelessWidget {
  const _JoinCard({
    required this.formKey,
    required this.controller,
    required this.enabled,
    required this.isLoading,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final bool enabled;
  final bool isLoading;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return ZaikoCard(
      padding: const EdgeInsets.all(AppSpacing.s5),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.onboardingJoinTitle,
              style: AppTypography.headline.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.s1),
            Text(
              l10n.onboardingJoinSubtitle,
              style: AppTypography.caption.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.s4),
            FieldLabel(l10n.onboardingCodeLabel),
            const SizedBox(height: AppSpacing.s1 + 2),
            TextFormField(
              controller: controller,
              enabled: enabled,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [UpperCaseTextFormatter()],
              style: AppTypography.body.copyWith(
                color: colors.textPrimary,
                letterSpacing: 2,
              ),
              decoration: InputDecoration(hintText: l10n.onboardingCodeHint),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? l10n.onboardingCodeEmpty
                  : null,
              onFieldSubmitted: (_) => enabled ? onSubmit() : null,
            ),
            const SizedBox(height: AppSpacing.s4),
            ZaikoPrimaryButton(
              label: l10n.onboardingJoinButton,
              isLoading: isLoading,
              onPressed: enabled ? onSubmit : null,
            ),
          ],
        ),
      ),
    );
  }
}

/// Forces invite-code input to upper case as the user types, matching the
/// server-generated code alphabet.
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) => TextEditingValue(
    text: newValue.text.toUpperCase(),
    selection: newValue.selection,
  );
}

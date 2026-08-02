import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/zaiko_buttons.dart';
import '../../../auth/application/auth_providers.dart';
import '../../../auth/domain/auth_status.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../application/households_providers.dart';
import '../household_error_message.dart';

/// Deep-link target for household invitations (`/join/:code`).
///
/// Reachable before sign-in. What it offers depends on the viewer:
///   * signed out          → prompt to sign in (the code is stashed and applied
///                           after onboarding),
///   * signed in, no household → confirm and join,
///   * signed in, has household → explain they must leave theirs first.
class JoinHouseholdPage extends ConsumerStatefulWidget {
  const JoinHouseholdPage({required this.connectionCode, super.key});

  /// Prefix shared by [routePath] and [location] so the path is defined once.
  static const String pathPrefix = '/join';
  static const String routePath = '$pathPrefix/:code';
  static const String routeName = 'join';

  /// Builds a concrete deep-link location for [code], e.g. `/join/ABC123`.
  static String location(String code) => '$pathPrefix/$code';

  /// The invite/connection code parsed from the deep link.
  final String connectionCode;

  @override
  ConsumerState<JoinHouseholdPage> createState() => _JoinHouseholdPageState();
}

class _JoinHouseholdPageState extends ConsumerState<JoinHouseholdPage> {
  String get _code => widget.connectionCode.trim().toUpperCase();

  Future<void> _accept() async {
    final joined = await ref
        .read(onboardingControllerProvider.notifier)
        .joinByCode(_code);
    // Joining flips membership to `joined`; leave the public join route by hand
    // since the redirect keeps invite links reachable.
    if (joined && mounted) context.go(HomePage.routePath);
  }

  void _signInToJoin() {
    ref.read(pendingInviteCodeProvider.notifier).set(_code);
    context.go(LoginPage.routePath);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // Surface join failures (invalid/expired/used code) as a snack bar.
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
      appBar: AppBar(title: Text(l10n.joinTitle)),
      body: SafeArea(child: Center(child: _buildBody(context))),
    );
  }

  Widget _buildBody(BuildContext context) {
    final l10n = context.l10n;
    final auth = ref.watch(authStateProvider);

    if (auth == AuthStatus.unauthenticated) {
      return _JoinMessage(
        icon: Icons.group_add_outlined,
        title: l10n.joinInvited,
        message: l10n.joinSignInPrompt,
        action: ZaikoPrimaryButton(
          label: l10n.joinSignInButton,
          onPressed: _signInToJoin,
        ),
      );
    }

    final membership = ref.watch(householdMembershipProvider);
    switch (membership) {
      case HouseholdMembership.joined:
        return _JoinMessage(
          icon: Icons.info_outline,
          title: l10n.joinTitle,
          message: l10n.householdErrorAlreadyMember,
          action: ZaikoSecondaryButton(
            label: l10n.joinToProfileButton,
            onPressed: () => context.go(ProfilePage.routePath),
          ),
        );
      case HouseholdMembership.none:
        final isLoading = ref.watch(onboardingControllerProvider).isLoading;
        return _JoinMessage(
          icon: Icons.group_add_outlined,
          title: l10n.joinInvited,
          message: l10n.joinConnectionCode(_code),
          action: ZaikoPrimaryButton(
            label: l10n.joinAcceptButton,
            isLoading: isLoading,
            onPressed: _accept,
          ),
        );
      case HouseholdMembership.unknown:
        return const CircularProgressIndicator();
    }
  }
}

/// Centered icon + title + message with a single call-to-action, shared by the
/// join page's states.
class _JoinMessage extends StatelessWidget {
  const _JoinMessage({
    required this.icon,
    required this.title,
    required this.message,
    required this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: colors.accent),
            const SizedBox(height: AppSpacing.s4),
            Text(
              title,
              style: AppTypography.title.copyWith(color: colors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s2),
            Text(
              message,
              style: AppTypography.body.copyWith(color: colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s6),
            SizedBox(width: double.infinity, child: action),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/zaiko_buttons.dart';
import '../../application/households_providers.dart';
import '../../presentation/household_error_message.dart';
import '../pages/join_household_page.dart';

/// Opens the invite bottom sheet for [householdId], generating a fresh code.
Future<void> showInviteSheet(BuildContext context, String householdId) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.colors.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
    ),
    builder: (_) => _InviteSheet(householdId: householdId),
  );
}

/// Sheet that shows a short-lived invite code and its QR so another member can
/// join the household. The code is generated when the sheet opens.
class _InviteSheet extends ConsumerStatefulWidget {
  const _InviteSheet({required this.householdId});

  final String householdId;

  @override
  ConsumerState<_InviteSheet> createState() => _InviteSheetState();
}

class _InviteSheetState extends ConsumerState<_InviteSheet> {
  @override
  void initState() {
    super.initState();
    // Generate the first code once the sheet is on screen.
    WidgetsBinding.instance.addPostFrameCallback((_) => _generate());
  }

  void _generate() {
    ref
        .read(inviteControllerProvider.notifier)
        .createInvite(widget.householdId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final state = ref.watch(inviteControllerProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.s6,
          AppSpacing.s5,
          AppSpacing.s6,
          AppSpacing.s6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.inviteTitle,
              style: AppTypography.title.copyWith(color: colors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s2),
            Text(
              l10n.inviteSubtitle,
              style: AppTypography.caption.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s5),
            switch (state) {
              AsyncData(:final value?) => _InviteContent(
                code: value,
                onRegenerate: _generate,
              ),
              AsyncError(:final error) => _InviteError(
                message: householdErrorMessage(l10n, error),
                onRetry: _generate,
              ),
              _ => const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.s8),
                child: Center(child: CircularProgressIndicator()),
              ),
            },
          ],
        ),
      ),
    );
  }
}

/// The generated code, its QR, and a button to create a fresh code.
class _InviteContent extends StatelessWidget {
  const _InviteContent({required this.code, required this.onRegenerate});

  final String code;
  final VoidCallback onRegenerate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.s4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: QrImageView(
              data: JoinHouseholdPage.location(code),
              version: QrVersions.auto,
              size: 180,
              backgroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s5),
        Text(
          code,
          textAlign: TextAlign.center,
          style: AppTypography.display.copyWith(
            color: colors.textPrimary,
            letterSpacing: 8,
          ),
        ),
        const SizedBox(height: AppSpacing.s2),
        Text(
          l10n.inviteExpiresHint,
          textAlign: TextAlign.center,
          style: AppTypography.caption.copyWith(color: colors.textTertiary),
        ),
        const SizedBox(height: AppSpacing.s5),
        ZaikoSecondaryButton(
          label: l10n.inviteRegenerate,
          icon: Icons.refresh,
          onPressed: onRegenerate,
        ),
      ],
    );
  }
}

/// Error state with a retry action.
class _InviteError extends StatelessWidget {
  const _InviteError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          message,
          textAlign: TextAlign.center,
          style: AppTypography.body.copyWith(color: colors.error),
        ),
        const SizedBox(height: AppSpacing.s5),
        ZaikoPrimaryButton(label: l10n.inviteCreateButton, onPressed: onRetry),
      ],
    );
  }
}

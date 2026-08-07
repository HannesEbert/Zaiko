import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n_extension.dart';
import '../../../l10n/app_localizations.dart';
import '../application/profile_providers.dart';
import '../domain/profile_repository.dart';

/// Maps a profile [error] to a localized, user-facing message.
///
/// Anything that is not a [ProfileFailure] (or has no dedicated message) falls
/// back to a generic error string.
String profileErrorMessage(AppLocalizations l10n, Object? error) {
  if (error is! ProfileFailure) return l10n.profileErrorGeneric;
  return switch (error.reason) {
    ProfileFailureReason.notAllowed => l10n.profileErrorGeneric,
    ProfileFailureReason.unknown => l10n.profileErrorGeneric,
  };
}

/// Shows a snackbar with the localized message for a failed profile operation —
/// the shared handler for a save that returned `false`.
///
/// Pass the failing controller's [error]; it defaults to the profile-edit
/// controller's last error so existing callers stay unchanged.
void showProfileErrorSnackBar(
  BuildContext context,
  WidgetRef ref, {
  Object? error,
}) {
  final failure = error ?? ref.read(profileEditControllerProvider).error;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(profileErrorMessage(context.l10n, failure))),
    );
}

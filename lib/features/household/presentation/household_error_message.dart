import '../../../l10n/app_localizations.dart';
import '../domain/household_repository.dart';

/// Maps a household [error] to a localized, user-facing message.
///
/// Anything that is not a [HouseholdFailure] (or has no dedicated message) falls
/// back to a generic error string.
String householdErrorMessage(AppLocalizations l10n, Object? error) {
  if (error is! HouseholdFailure) return l10n.householdErrorGeneric;
  return switch (error.reason) {
    HouseholdFailureReason.alreadyInHousehold =>
      l10n.householdErrorAlreadyMember,
    HouseholdFailureReason.inviteNotFound => l10n.householdErrorInviteNotFound,
    HouseholdFailureReason.inviteUsed => l10n.householdErrorInviteUsed,
    HouseholdFailureReason.inviteExpired => l10n.householdErrorInviteExpired,
    HouseholdFailureReason.notMember => l10n.householdErrorGeneric,
    HouseholdFailureReason.unknown => l10n.householdErrorGeneric,
  };
}

import '../../../l10n/app_localizations.dart';

/// Form validators shared by the sign-in and registration screens.
///
/// Pure functions that take the localizations explicitly (rather than a
/// `BuildContext`) so they stay UI-agnostic and are trivial to unit-test. The
/// backend remains the source of truth for validity; these only catch obvious
/// input mistakes before a network call.
abstract final class AuthValidators {
  /// Minimum password length accepted by the sign-up form.
  static const int minPasswordLength = 6;

  /// Requires a non-empty, plausibly shaped email address.
  static String? email(AppLocalizations l10n, String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return l10n.loginEmailEmpty;
    // Deliberately loose: the backend is the source of truth for validity.
    if (!email.contains('@') || !email.contains('.')) {
      return l10n.loginEmailInvalid;
    }
    return null;
  }

  /// Requires a non-empty password of at least [minPasswordLength] characters.
  static String? password(AppLocalizations l10n, String? value) {
    final password = value ?? '';
    if (password.isEmpty) return l10n.loginPasswordEmpty;
    if (password.length < minPasswordLength) {
      return l10n.loginPasswordTooShort(minPasswordLength);
    }
    return null;
  }

  /// Requires the confirmation to be non-empty and identical to [original].
  static String? confirmPassword(
    AppLocalizations l10n,
    String? value,
    String original,
  ) {
    final confirmation = value ?? '';
    if (confirmation.isEmpty) return l10n.loginPasswordEmpty;
    if (confirmation != original) return l10n.registerPasswordMismatch;
    return null;
  }
}

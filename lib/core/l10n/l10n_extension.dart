import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';

/// Convenience access to the generated localizations via `context.l10n`.
///
/// Keeps call sites terse (`context.l10n.navHome`) instead of the verbose
/// `AppLocalizations.of(context)`. The getter is non-null because
/// `AppLocalizations` is always injected by [MaterialApp] (see `app.dart`).
extension L10nX on BuildContext {
  /// The localized strings for the current locale.
  AppLocalizations get l10n => AppLocalizations.of(this);
}

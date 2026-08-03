import '../../../core/constants/app_constants.dart';

/// The expiry state of an inventory item, derived from its best-before date.
enum ExpiryStatus {
  /// No best-before date — the item shows no expiry status.
  none,

  /// More than [AppConstants.expiryWarningDays] days left.
  fresh,

  /// Due within the warning window (best-before today or up to the window).
  soon,

  /// Best-before date is in the past.
  expired,
}

/// Classifies [bestBefore] relative to [now] (defaults to the current time).
///
/// Comparison is by calendar day, so the time of day never flips the result.
/// A null [bestBefore] yields [ExpiryStatus.none]. Best-before *today* counts
/// as [ExpiryStatus.soon] (not yet expired); only a past date is
/// [ExpiryStatus.expired].
ExpiryStatus expiryStatus(DateTime? bestBefore, {DateTime? now}) {
  if (bestBefore == null) return ExpiryStatus.none;

  final today = _dateOnly(now ?? DateTime.now());
  final due = _dateOnly(bestBefore);
  final daysLeft = due.difference(today).inDays;

  if (daysLeft < 0) return ExpiryStatus.expired;
  if (daysLeft <= AppConstants.expiryWarningDays) return ExpiryStatus.soon;
  return ExpiryStatus.fresh;
}

/// Whether [bestBefore] lies in the past (before today).
bool isExpired(DateTime? bestBefore, {DateTime? now}) =>
    expiryStatus(bestBefore, now: now) == ExpiryStatus.expired;

/// Whether [bestBefore] falls within the warning window (today included).
bool isExpiringSoon(DateTime? bestBefore, {DateTime? now}) =>
    expiryStatus(bestBefore, now: now) == ExpiryStatus.soon;

/// Whole days from today until [bestBefore] (negative when overdue), or null
/// when there is no date. Drives the relative labels ("in 2 days", "tomorrow").
int? daysUntilExpiry(DateTime? bestBefore, {DateTime? now}) {
  if (bestBefore == null) return null;
  return _dateOnly(
    bestBefore,
  ).difference(_dateOnly(now ?? DateTime.now())).inDays;
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

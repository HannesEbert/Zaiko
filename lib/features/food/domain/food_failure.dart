/// Why a food lookup or catalog operation failed.
///
/// Mapped from HTTP/parse errors (Open Food Facts) and `PostgrestException`s
/// (the `foods` cache) at the data boundary, so the UI never sees a raw
/// transport error. Mirrors `InventoryFailure`'s reason-plus-message shape.
enum FoodFailureReason {
  /// No connection, timeout, or an unexpected/unparseable response.
  network,

  /// Open Food Facts rejected the request for rate limiting (HTTP 429).
  rateLimited,

  /// Any other backend or lookup error.
  unknown,
}

/// Domain-level food error with a [reason] and a user-presentable [message]
/// fallback. Keeps Open Food Facts and Supabase exception types out of the UI.
///
/// A product that Open Food Facts simply does not know is *not* a failure: a
/// barcode lookup returns `null` and a name search returns an empty list.
class FoodFailure implements Exception {
  const FoodFailure(this.reason, this.message);

  /// The categorized cause, used to pick a localized message.
  final FoodFailureReason reason;

  /// Human-readable reason, used when no specific localized message applies.
  final String message;

  @override
  String toString() => 'FoodFailure(${reason.name}): $message';
}

import 'shopping_item.dart';

/// Why a [ShoppingRepository] operation failed.
///
/// Mapped from backend errors at the data boundary so the UI never sees a raw
/// `PostgrestException`.
enum ShoppingFailureReason {
  /// The user is not a member of the household they tried to read or write.
  notMember,

  /// The targeted row does not exist (or is not visible to the caller).
  notFound,

  /// Any other backend or network error.
  unknown,
}

/// Domain-level shopping-list error with a [reason] and a user-presentable
/// [message] fallback. Keeps Supabase exceptions out of the UI layer.
class ShoppingFailure implements Exception {
  const ShoppingFailure(this.reason, this.message);

  /// The categorized cause, used to pick a localized message.
  final ShoppingFailureReason reason;

  /// Human-readable reason, used when no specific localized message applies.
  final String message;

  @override
  String toString() => 'ShoppingFailure(${reason.name}): $message';
}

/// Abstraction over the household's shopping list.
///
/// The app depends on this interface, not on Supabase directly, so tests can
/// substitute a fake and the backend can be swapped without touching callers.
///
/// Every method throws [ShoppingFailure] on backend errors; the realtime
/// [watchItems] stream is the single source of truth for the list, so mutating
/// an item never needs a manual refresh — the stream re-emits.
abstract interface class ShoppingRepository {
  /// Emits the household's shopping items whenever they change, most recently
  /// added first.
  Stream<List<ShoppingItem>> watchItems(String householdId);

  /// Inserts a new item into [householdId] and returns the created row.
  Future<ShoppingItem> addItem({
    required String householdId,
    required String name,
    String? quantity,
    String? categoryId,
  });

  /// Overwrites the editable fields of the item with [id].
  Future<void> updateItem({
    required String id,
    required String name,
    String? quantity,
    String? categoryId,
  });

  /// Ticks the item with [id] on or off the list.
  Future<void> setChecked({required String id, required bool checked});

  /// Permanently removes the item with [id] (shopping items are hard-deleted).
  Future<void> deleteItem(String id);

  /// Permanently removes every already-checked item in [householdId].
  Future<void> clearChecked(String householdId);
}

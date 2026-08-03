import 'category.dart';
import 'inventory_item.dart';
import 'storage_location.dart';

/// Why an [InventoryRepository] operation failed.
///
/// Mapped from backend errors at the data boundary so the UI never sees a raw
/// `PostgrestException`.
enum InventoryFailureReason {
  /// The user is not a member of the household they tried to read.
  notMember,

  /// Any other backend or network error.
  unknown,
}

/// Domain-level inventory error with a [reason] and a user-presentable
/// [message] fallback. Keeps Supabase exceptions out of the UI layer.
class InventoryFailure implements Exception {
  const InventoryFailure(this.reason, this.message);

  /// The categorized cause, used to pick a localized message.
  final InventoryFailureReason reason;

  /// Human-readable reason, used when no specific localized message applies.
  final String message;

  @override
  String toString() => 'InventoryFailure(${reason.name}): $message';
}

/// Abstraction over inventory storage.
///
/// The app depends on this interface, not on Supabase directly, so tests can
/// substitute a fake and the backend can be swapped without touching callers.
/// This slice is read-only (display screens); writes arrive with E1.2.
abstract interface class InventoryRepository {
  /// Emits the household's non-deleted inventory items whenever they change,
  /// most recently added first.
  Stream<List<InventoryItem>> watchItems(String householdId);

  /// Loads the household's storage locations, ordered by their sort order.
  /// Throws [InventoryFailure] on backend errors.
  Future<List<StorageLocation>> loadStorageLocations(String householdId);

  /// Loads the categories visible to the household: the app-wide defaults plus
  /// the household's own custom ones. Throws [InventoryFailure] on failure.
  Future<List<Category>> loadCategories(String householdId);
}

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

  /// The targeted row does not exist (or is not visible to the caller).
  notFound,

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
///
/// Every method throws [InventoryFailure] on backend errors; the realtime
/// [watchItems] stream is the single source of truth for the item list, so
/// mutating an item never needs a manual refresh — the stream re-emits.
abstract interface class InventoryRepository {
  /// Emits the household's non-deleted inventory items whenever they change,
  /// most recently added first.
  Stream<List<InventoryItem>> watchItems(String householdId);

  /// Loads the household's storage locations, ordered by their sort order.
  Future<List<StorageLocation>> loadStorageLocations(String householdId);

  /// Loads the categories visible to the household: the app-wide defaults plus
  /// the household's own custom ones.
  Future<List<Category>> loadCategories(String householdId);

  /// Loads the household's soft-deleted items (the trash), most recently
  /// removed first.
  Future<List<InventoryItem>> loadDeletedItems(String householdId);

  // --- Item mutations -------------------------------------------------------

  /// Inserts a new item into [householdId] and returns the created row.
  Future<InventoryItem> addItem({
    required String householdId,
    required String name,
    required num quantity,
    String? unit,
    String? categoryId,
    String? storageLocationId,
    DateTime? bestBefore,
  });

  /// Overwrites the editable fields of the item with [id].
  Future<void> updateItem({
    required String id,
    required String name,
    required num quantity,
    String? unit,
    String? categoryId,
    String? storageLocationId,
    DateTime? bestBefore,
  });

  /// Sets the item's [quantity] (used by the detail-page stepper).
  Future<void> setItemQuantity({required String id, required num quantity});

  /// Soft-deletes the item (moves it to the 30-day trash).
  Future<void> softDeleteItem(String id);

  /// Restores a soft-deleted item back into the active inventory.
  Future<void> restoreItem(String id);

  // --- Storage-location mutations -------------------------------------------

  /// Creates a storage location for [householdId] and returns it.
  Future<StorageLocation> addStorageLocation({
    required String householdId,
    required String name,
    String? icon,
    String? color,
  });

  /// Renames / re-styles the storage location with [id].
  Future<void> updateStorageLocation({
    required String id,
    required String name,
    String? icon,
    String? color,
  });

  /// Deletes the storage location with [id]. Items that referenced it keep
  /// existing but lose their location (the schema's `on delete set null`).
  Future<void> deleteStorageLocation(String id);

  // --- Category mutations ---------------------------------------------------

  /// Creates a custom category for [householdId] and returns it.
  Future<Category> addCategory({
    required String householdId,
    required String name,
    String? icon,
    String? color,
  });

  /// Renames / re-styles the custom category with [id].
  Future<void> updateCategory({
    required String id,
    required String name,
    String? icon,
    String? color,
  });

  /// Deletes the custom category with [id]. Items that referenced it lose their
  /// category (the schema's `on delete set null`). Default categories are global
  /// and cannot be deleted.
  Future<void> deleteCategory(String id);
}

import 'food.dart';
import 'food_failure.dart';

/// The household-visible product catalog (the `foods` table): the shared
/// Open Food Facts cache plus a household's own custom products.
///
/// Every method throws [FoodFailure] on backend errors.
abstract interface class FoodCatalogRepository {
  /// Stores a resolved Open Food Facts [product] in the shared catalog
  /// (`household_id = null`), deduplicated by barcode, and returns the stored
  /// row — the existing one when the barcode was already cached, otherwise the
  /// freshly inserted one. Lets a re-scan of the same barcode resolve offline.
  Future<Food> cacheOffProduct(Food product);

  /// Creates a household-owned custom product (`source: custom`) and returns
  /// it. Used by the fallback path when a scanned barcode is unknown, so the
  /// barcode is still persisted and linkable via `inventory_items.food_id`.
  Future<Food> addCustomFood({
    required String householdId,
    required String name,
    String? barcode,
  });
}

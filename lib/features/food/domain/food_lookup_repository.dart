import 'food.dart';
import 'food_failure.dart';

/// Resolves products from an external catalog (Open Food Facts) by barcode or
/// name. Implemented in `data/` over HTTP; the app depends on this interface so
/// tests can substitute a fake and the source can be swapped.
///
/// Every method throws [FoodFailure] on transport errors. "Not found" is a
/// normal result, not a failure: [lookupByBarcode] returns `null` and
/// [searchByName] returns an empty list.
abstract interface class FoodLookupRepository {
  /// Resolves the product for [barcode], or `null` when the catalog has no
  /// entry for it.
  Future<Food?> lookupByBarcode(String barcode);

  /// Searches the catalog for products matching [query], most relevant first.
  /// Returns an empty list when nothing matches.
  Future<List<Food>> searchByName(String query);
}

import 'package:zaiko/features/food/domain/food.dart';
import 'package:zaiko/features/food/domain/food_failure.dart';
import 'package:zaiko/features/food/domain/food_lookup_repository.dart';

/// In-memory [FoodLookupRepository] for tests: no HTTP, fully scriptable.
///
/// Set [barcodeResult] / [searchResults] for the happy path, or [lookupError] /
/// [searchError] to make the next call throw.
class FakeFoodLookupRepository implements FoodLookupRepository {
  Food? barcodeResult;
  List<Food> searchResults = const [];

  FoodFailure? lookupError;
  FoodFailure? searchError;

  int lookupCalls = 0;
  int searchCalls = 0;
  String? lastBarcode;
  String? lastQuery;

  @override
  Future<Food?> lookupByBarcode(String barcode) async {
    lookupCalls++;
    lastBarcode = barcode;
    final error = lookupError;
    if (error != null) throw error;
    return barcodeResult;
  }

  @override
  Future<List<Food>> searchByName(String query) async {
    searchCalls++;
    lastQuery = query;
    final error = searchError;
    if (error != null) throw error;
    return searchResults;
  }
}

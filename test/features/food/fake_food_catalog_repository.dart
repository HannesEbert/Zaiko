import 'package:zaiko/features/food/domain/food.dart';
import 'package:zaiko/features/food/domain/food_catalog_repository.dart';
import 'package:zaiko/features/food/domain/food_failure.dart';

/// In-memory [FoodCatalogRepository] for tests: no Supabase, fully scriptable.
///
/// [cacheOffProduct] deduplicates by barcode against [cached], mirroring the
/// real repository's insert-or-return behavior.
class FakeFoodCatalogRepository implements FoodCatalogRepository {
  final List<Food> cached = [];
  final List<Food> customs = [];

  FoodFailure? cacheError;
  FoodFailure? customError;

  int cacheCalls = 0;
  int customCalls = 0;

  @override
  Future<Food> cacheOffProduct(Food product) async {
    cacheCalls++;
    final error = cacheError;
    if (error != null) throw error;
    final barcode = product.barcode;
    if (barcode != null) {
      for (final existing in cached) {
        if (existing.barcode == barcode) return existing;
      }
    }
    cached.add(product);
    return product;
  }

  @override
  Future<Food> addCustomFood({
    required String householdId,
    required String name,
    String? barcode,
  }) async {
    customCalls++;
    final error = customError;
    if (error != null) throw error;
    final food = Food.create(
      name: name,
      source: FoodSource.custom,
      barcode: barcode,
      householdId: householdId,
    );
    customs.add(food);
    return food;
  }
}

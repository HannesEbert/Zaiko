import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../household/application/households_providers.dart';
import '../data/open_food_facts_repository.dart';
import '../data/supabase_food_repository.dart';
import '../domain/food.dart';
import '../domain/food_catalog_repository.dart';
import '../domain/food_failure.dart';
import '../domain/food_lookup_repository.dart';

part 'food_providers.g.dart';

/// Resolves products from Open Food Facts. Overridden with a fake in tests.
@riverpod
FoodLookupRepository foodLookupRepository(Ref ref) => OpenFoodFactsRepository();

/// The household-visible product catalog (`foods` table). Overridden in tests.
@riverpod
FoodCatalogRepository foodCatalogRepository(Ref ref) =>
    SupabaseFoodRepository();

/// The active household's id, or throws a [FoodFailure] when there is none.
/// Read synchronously: creating a custom food is only reachable from the add
/// form, where the household is already resolved.
String _requireActiveHouseholdId(Ref ref) {
  final id = ref.read(currentHouseholdProvider).asData?.value?.id;
  if (id == null) {
    throw const FoodFailure(FoodFailureReason.unknown, 'No active household.');
  }
  return id;
}

/// Orchestrates product resolution for the add flow: Open Food Facts lookup
/// plus caching into the shared `foods` catalog. Methods return the resolved
/// [Food] (or null / an empty list on a catalog miss) and throw [FoodFailure]
/// on transport errors, which the UI maps to a message.
///
/// Kept alive: it is only reached through `ref.read(...notifier)` and never
/// watched, so an autoDispose notifier could be disposed during the OFF request
/// and its post-`await` `ref.read` of the catalog repository would then throw.
@Riverpod(keepAlive: true)
class ProductResolver extends _$ProductResolver {
  @override
  void build() {}

  /// Resolves [barcode] against Open Food Facts and, on a hit, caches it in the
  /// shared catalog. Returns the stored [Food], or null when Open Food Facts
  /// has no product (the caller falls back to manual entry).
  Future<Food?> resolveByBarcode(String barcode) async {
    final product = await ref
        .read(foodLookupRepositoryProvider)
        .lookupByBarcode(barcode);
    if (product == null) return null;
    final cached = await ref
        .read(foodCatalogRepositoryProvider)
        .cacheOffProduct(product);
    return _withPackageSize(cached, product);
  }

  /// Searches Open Food Facts by product name. Results are not cached until the
  /// user picks one via [selectSearchResult].
  Future<List<Food>> search(String query) =>
      ref.read(foodLookupRepositoryProvider).searchByName(query);

  /// Caches the [product] the user picked from search results and returns the
  /// stored catalog row.
  Future<Food> selectSearchResult(Food product) async {
    final cached = await ref
        .read(foodCatalogRepositoryProvider)
        .cacheOffProduct(product);
    return _withPackageSize(cached, product);
  }

  /// Re-attaches the transient package size (used for the add-form prefill)
  /// from the freshly resolved [source] onto the [cached] catalog row, which
  /// caching returns size-agnostic (and with a different id on a dedupe hit).
  Food _withPackageSize(Food cached, Food source) => cached.copyWith(
    packagedAmount: source.packagedAmount,
    packagedUnit: source.packagedUnit,
  );

  /// Fallback for an unknown scanned barcode: creates a household-owned custom
  /// product carrying [name] and [barcode], so the barcode is still persisted
  /// and linkable from the inventory item.
  Future<Food> createCustom({required String name, String? barcode}) => ref
      .read(foodCatalogRepositoryProvider)
      .addCustomFood(
        householdId: _requireActiveHouseholdId(ref),
        name: name,
        barcode: barcode,
      );
}

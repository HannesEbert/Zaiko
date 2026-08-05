import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/food.dart';
import '../domain/food_catalog_repository.dart';
import '../domain/food_failure.dart';

/// [FoodCatalogRepository] backed by the Supabase `foods` table.
///
/// The Open Food Facts cache lives in the shared catalog (`household_id = null`)
/// and is deduplicated by barcode. RLS lets an authenticated user *insert* a
/// shared row but not *update* one, so caching is insert-only: look up by
/// barcode first, insert on a miss, and re-read on a lost insert race — never an
/// upsert (see ADR-0012). A partial unique index on `barcode` backs the dedupe.
class SupabaseFoodRepository implements FoodCatalogRepository {
  SupabaseFoodRepository([SupabaseClient? client])
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<Food> cacheOffProduct(Food product) async {
    final barcode = product.barcode;
    try {
      if (barcode != null) {
        final existing = await _sharedByBarcode(barcode);
        if (existing != null) return existing;
      }
      final row = await _client
          .from('foods')
          .insert(product.toJson())
          .select()
          .single();
      return Food.fromJson(row);
    } on PostgrestException catch (e) {
      // Another scan of the same barcode won the insert race between our lookup
      // and insert; the partial unique index rejected ours. Re-read theirs.
      if (e.code == '23505' && barcode != null) {
        final existing = await _sharedByBarcode(barcode);
        if (existing != null) return existing;
      }
      throw _mapError(e);
    }
  }

  @override
  Future<Food> addCustomFood({
    required String householdId,
    required String name,
    String? barcode,
  }) async {
    try {
      final food = Food.create(
        name: name,
        source: FoodSource.custom,
        barcode: barcode,
        householdId: householdId,
      );
      final row = await _client
          .from('foods')
          .insert(food.toJson())
          .select()
          .single();
      return Food.fromJson(row);
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  /// The shared-catalog Open Food Facts entry for [barcode], or null when it has
  /// not been cached yet. At most one row exists thanks to the partial unique
  /// index.
  Future<Food?> _sharedByBarcode(String barcode) async {
    final row = await _client
        .from('foods')
        .select()
        .eq('barcode', barcode)
        .eq('source', 'openFoodFacts')
        .isFilter('household_id', null)
        .isFilter('deleted_at', null)
        .maybeSingle();
    return row == null ? null : Food.fromJson(row);
  }

  FoodFailure _mapError(PostgrestException e) =>
      FoodFailure(FoodFailureReason.unknown, e.message);
}

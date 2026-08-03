import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/category.dart';
import '../domain/inventory_item.dart';
import '../domain/inventory_repository.dart';
import '../domain/storage_location.dart';

/// [InventoryRepository] backed by Supabase Postgres.
///
/// Reads are gated by RLS (a member only ever sees their own household's rows).
/// Every backend exception is translated to an [InventoryFailure] so callers
/// never see a raw `PostgrestException`.
class SupabaseInventoryRepository implements InventoryRepository {
  SupabaseInventoryRepository([SupabaseClient? client])
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Stream<List<InventoryItem>> watchItems(String householdId) => _client
      .from('inventory_items')
      .stream(primaryKey: ['id'])
      .eq('household_id', householdId)
      .order('created_at', ascending: false)
      // A realtime stream can only filter on one column, so soft-deleted rows
      // are dropped here rather than in the query.
      .map(
        (rows) => rows
            .where((row) => row['deleted_at'] == null)
            .map(InventoryItem.fromJson)
            .toList(),
      );

  @override
  Future<List<StorageLocation>> loadStorageLocations(String householdId) async {
    try {
      final rows = await _client
          .from('storage_locations')
          .select()
          .eq('household_id', householdId)
          .order('sort_order');
      return rows.map(StorageLocation.fromJson).toList();
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<List<Category>> loadCategories(String householdId) async {
    try {
      // The app-wide defaults (null household) plus this household's own ones.
      final rows = await _client
          .from('categories')
          .select()
          .or('household_id.is.null,household_id.eq.$householdId')
          .order('name');
      return rows.map(Category.fromJson).toList();
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  InventoryFailure _mapError(PostgrestException e) {
    final reason = switch (e.code) {
      '42501' => InventoryFailureReason.notMember,
      _ => InventoryFailureReason.unknown,
    };
    return InventoryFailure(reason, e.message);
  }
}

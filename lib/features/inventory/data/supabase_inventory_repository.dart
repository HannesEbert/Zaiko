import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/category.dart';
import '../domain/inventory_item.dart';
import '../domain/inventory_repository.dart';
import '../domain/storage_location.dart';

/// [InventoryRepository] backed by Supabase Postgres.
///
/// Reads and writes are gated by RLS (a member only ever touches their own
/// household's rows). Every backend exception is translated to an
/// [InventoryFailure] so callers never see a raw `PostgrestException`.
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

  @override
  Future<List<InventoryItem>> loadDeletedItems(String householdId) async {
    try {
      final rows = await _client
          .from('inventory_items')
          .select()
          .eq('household_id', householdId)
          .not('deleted_at', 'is', null)
          .order('deleted_at', ascending: false);
      return rows.map(InventoryItem.fromJson).toList();
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<InventoryItem> addItem({
    required String householdId,
    required String name,
    required num quantity,
    required int count,
    String? unit,
    String? categoryId,
    String? storageLocationId,
    DateTime? bestBefore,
    String? foodId,
  }) async {
    try {
      final row = await _client
          .from('inventory_items')
          .insert({
            'household_id': householdId,
            'name': name,
            'quantity': quantity,
            'count': count,
            'unit': unit,
            'category_id': categoryId,
            'storage_location_id': storageLocationId,
            'best_before': _dateOnly(bestBefore),
            'food_id': foodId,
            'added_by': _client.auth.currentUser?.id,
          })
          .select()
          .single();
      return InventoryItem.fromJson(row);
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> updateItem({
    required String id,
    required String name,
    required num quantity,
    required int count,
    String? unit,
    String? categoryId,
    String? storageLocationId,
    DateTime? bestBefore,
  }) async {
    try {
      await _client
          .from('inventory_items')
          .update({
            'name': name,
            'quantity': quantity,
            'count': count,
            'unit': unit,
            'category_id': categoryId,
            'storage_location_id': storageLocationId,
            'best_before': _dateOnly(bestBefore),
          })
          .eq('id', id);
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> setItemCount({required String id, required int count}) async {
    try {
      await _client
          .from('inventory_items')
          .update({'count': count})
          .eq('id', id);
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> softDeleteItem(String id) async {
    try {
      await _client
          .from('inventory_items')
          .update({'deleted_at': DateTime.now().toUtc().toIso8601String()})
          .eq('id', id);
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> restoreItem(String id) async {
    try {
      await _client
          .from('inventory_items')
          .update({'deleted_at': null})
          .eq('id', id);
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<StorageLocation> addStorageLocation({
    required String householdId,
    required String name,
    String? icon,
    String? color,
  }) async {
    try {
      final row = await _client
          .from('storage_locations')
          .insert({
            'household_id': householdId,
            'name': name,
            'icon': icon,
            'color': color,
            'sort_order': await _nextLocationSortOrder(householdId),
          })
          .select()
          .single();
      return StorageLocation.fromJson(row);
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> updateStorageLocation({
    required String id,
    required String name,
    String? icon,
    String? color,
  }) async {
    try {
      await _client
          .from('storage_locations')
          .update({'name': name, 'icon': icon, 'color': color})
          .eq('id', id);
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> deleteStorageLocation(String id) async {
    try {
      await _client.from('storage_locations').delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<Category> addCategory({
    required String householdId,
    required String name,
    String? icon,
    String? color,
  }) async {
    try {
      final row = await _client
          .from('categories')
          .insert({
            'household_id': householdId,
            'name': name,
            'icon': icon,
            'color': color,
            // A category tied to a household is always custom, never a default.
            'is_default': false,
          })
          .select()
          .single();
      return Category.fromJson(row);
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> updateCategory({
    required String id,
    required String name,
    String? icon,
    String? color,
  }) async {
    try {
      await _client
          .from('categories')
          .update({'name': name, 'icon': icon, 'color': color})
          .eq('id', id);
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      await _client.from('categories').delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  /// The next `sort_order` for a new location: one past the household's current
  /// maximum, so new locations append to the end of the grid.
  Future<int> _nextLocationSortOrder(String householdId) async {
    final rows = await _client
        .from('storage_locations')
        .select('sort_order')
        .eq('household_id', householdId)
        .order('sort_order', ascending: false)
        .limit(1);
    if (rows.isEmpty) return 0;
    return (rows.first['sort_order'] as int) + 1;
  }

  /// Formats a [DateTime] as a `yyyy-MM-dd` string for a Postgres `date` column,
  /// dropping the time-of-day so no timezone shift can move the day. Null passes
  /// through to clear the column.
  String? _dateOnly(DateTime? value) =>
      value?.toIso8601String().split('T').first;

  InventoryFailure _mapError(PostgrestException e) {
    final reason = switch (e.code) {
      '42501' => InventoryFailureReason.notMember,
      // PostgREST returns PGRST116 when a single-row request matched no row.
      'PGRST116' => InventoryFailureReason.notFound,
      _ => InventoryFailureReason.unknown,
    };
    return InventoryFailure(reason, e.message);
  }
}

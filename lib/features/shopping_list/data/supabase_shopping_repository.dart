import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/shopping_item.dart';
import '../domain/shopping_repository.dart';

/// [ShoppingRepository] backed by Supabase Postgres.
///
/// Reads and writes are gated by RLS (a member only ever touches their own
/// household's rows). Every backend exception is translated to a
/// [ShoppingFailure] so callers never see a raw `PostgrestException`.
class SupabaseShoppingRepository implements ShoppingRepository {
  SupabaseShoppingRepository([SupabaseClient? client])
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Stream<List<ShoppingItem>> watchItems(String householdId) => _client
      .from('shopping_items')
      .stream(primaryKey: ['id'])
      .eq('household_id', householdId)
      .order('created_at', ascending: false)
      .map((rows) => rows.map(ShoppingItem.fromJson).toList());

  @override
  Future<ShoppingItem> addItem({
    required String householdId,
    required String name,
    String? quantity,
    String? categoryId,
  }) async {
    try {
      final row = await _client
          .from('shopping_items')
          .insert({
            'household_id': householdId,
            'name': name,
            'quantity': quantity,
            'category_id': categoryId,
            'added_by': _client.auth.currentUser?.id,
          })
          .select()
          .single();
      return ShoppingItem.fromJson(row);
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> updateItem({
    required String id,
    required String name,
    String? quantity,
    String? categoryId,
  }) async {
    try {
      await _client
          .from('shopping_items')
          .update({
            'name': name,
            'quantity': quantity,
            'category_id': categoryId,
          })
          .eq('id', id);
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> setChecked({required String id, required bool checked}) async {
    try {
      await _client
          .from('shopping_items')
          .update({'checked': checked})
          .eq('id', id);
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> deleteItem(String id) async {
    try {
      await _client.from('shopping_items').delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> clearChecked(String householdId) async {
    try {
      await _client
          .from('shopping_items')
          .delete()
          .eq('household_id', householdId)
          .eq('checked', true);
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  ShoppingFailure _mapError(PostgrestException e) {
    final reason = switch (e.code) {
      '42501' => ShoppingFailureReason.notMember,
      // PostgREST returns PGRST116 when a single-row request matched no row.
      'PGRST116' => ShoppingFailureReason.notFound,
      _ => ShoppingFailureReason.unknown,
    };
    return ShoppingFailure(reason, e.message);
  }
}

import 'dart:async';

import 'package:zaiko/features/shopping_list/domain/shopping_item.dart';
import 'package:zaiko/features/shopping_list/domain/shopping_repository.dart';

/// In-memory [ShoppingRepository] for tests: no Supabase, fully controllable.
///
/// [watchItems] replays the current [items] to every new subscriber, then
/// forwards later changes. Mutations update the in-memory state and re-emit, so
/// provider tests observe the same "stream re-emits" behavior as production.
/// Scripting a failure is done via the [writeError] field.
class FakeShoppingRepository implements ShoppingRepository {
  List<ShoppingItem> items = const [];

  /// When set, every mutation throws it — for failure-path tests.
  ShoppingFailure? writeError;

  int addItemCalls = 0;
  int updateItemCalls = 0;
  int setCheckedCalls = 0;
  int deleteItemCalls = 0;
  int clearCheckedCalls = 0;

  int _seq = 0;

  final StreamController<List<ShoppingItem>> _updates =
      StreamController<List<ShoppingItem>>.broadcast();

  /// Pushes a new item list to active [watchItems] subscribers.
  void emit(List<ShoppingItem> next) {
    items = next;
    _updates.add(next);
  }

  void dispose() => _updates.close();

  @override
  Stream<List<ShoppingItem>> watchItems(String householdId) async* {
    yield items;
    yield* _updates.stream;
  }

  @override
  Future<ShoppingItem> addItem({
    required String householdId,
    required String name,
    String? quantity,
    String? categoryId,
  }) async {
    addItemCalls++;
    _throwIfScripted();
    final now = DateTime.now();
    final item = ShoppingItem(
      id: 'shop-${++_seq}',
      householdId: householdId,
      name: name,
      createdAt: now,
      updatedAt: now,
      quantity: quantity,
      categoryId: categoryId,
    );
    emit([item, ...items]);
    return item;
  }

  @override
  Future<void> updateItem({
    required String id,
    required String name,
    String? quantity,
    String? categoryId,
  }) async {
    updateItemCalls++;
    _throwIfScripted();
    emit([
      for (final item in items)
        if (item.id == id)
          item.copyWith(name: name, quantity: quantity, categoryId: categoryId)
        else
          item,
    ]);
  }

  @override
  Future<void> setChecked({required String id, required bool checked}) async {
    setCheckedCalls++;
    _throwIfScripted();
    emit([
      for (final item in items)
        if (item.id == id) item.copyWith(checked: checked) else item,
    ]);
  }

  @override
  Future<void> deleteItem(String id) async {
    deleteItemCalls++;
    _throwIfScripted();
    emit(items.where((item) => item.id != id).toList());
  }

  @override
  Future<void> clearChecked(String householdId) async {
    clearCheckedCalls++;
    _throwIfScripted();
    emit(items.where((item) => !item.checked).toList());
  }

  void _throwIfScripted() {
    final error = writeError;
    if (error != null) throw error;
  }
}

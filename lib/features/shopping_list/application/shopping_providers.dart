import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../household/application/households_providers.dart';
import '../../inventory/application/inventory_providers.dart';
import '../../inventory/domain/category.dart';
import '../data/supabase_shopping_repository.dart';
import '../domain/shopping_item.dart';
import '../domain/shopping_repository.dart';
import 'shopping_view.dart';

part 'shopping_providers.g.dart';

/// The app's [ShoppingRepository]. Overridden with a fake in tests.
@riverpod
ShoppingRepository shoppingRepository(Ref ref) => SupabaseShoppingRepository();

/// The active household's shopping items, newest first, kept live. Emits an
/// empty list while the user has no household.
@riverpod
Stream<List<ShoppingItem>> shoppingItems(Ref ref) async* {
  final household = await ref.watch(currentHouseholdProvider.future);
  if (household == null) {
    yield const [];
    return;
  }
  yield* ref.watch(shoppingRepositoryProvider).watchItems(household.id);
}

/// Shopping items joined with their category, open items before checked ones.
/// Every display provider derives from this single source. The category
/// taxonomy is household-wide, so it is reused from the inventory providers.
@riverpod
Future<List<ResolvedShoppingItem>> resolvedShoppingItems(Ref ref) async {
  final items = await ref.watch(shoppingItemsProvider.future);
  final categoriesById = await ref.watch(categoriesByIdProvider.future);
  final resolved = [
    for (final item in items)
      ResolvedShoppingItem(
        item: item,
        category: categoriesById[item.categoryId],
      ),
  ];
  // Stable partition: open items first, checked (bought) items last; the stream
  // already orders each group newest-first.
  return [
    ...resolved.where((r) => !r.item.checked),
    ...resolved.where((r) => r.item.checked),
  ];
}

/// How many items are still open (not yet bought) — the header subtitle count.
@riverpod
Future<int> shoppingOpenCount(Ref ref) async {
  final items = await ref.watch(shoppingItemsProvider.future);
  return items.where((item) => !item.checked).length;
}

/// The distinct categories present on the current list, ordered by name — the
/// source for the filter chips (only categories that actually appear).
@riverpod
Future<List<Category>> shoppingFilterCategories(Ref ref) async {
  final resolved = await ref.watch(resolvedShoppingItemsProvider.future);
  final byId = <String, Category>{};
  for (final item in resolved) {
    final category = item.category;
    if (category != null) byId[category.id] = category;
  }
  final categories = byId.values.toList()
    ..sort((a, b) => a.name.compareTo(b.name));
  return categories;
}

/// The active household's id, or throws a [ShoppingFailure] when there is none
/// — the guard every create action shares. Read synchronously: a mutation is
/// only reachable from the shopping screen where the household is resolved.
String _requireActiveHouseholdId(Ref ref) {
  final id = ref.read(currentHouseholdProvider).asData?.value?.id;
  if (id == null) {
    throw const ShoppingFailure(
      ShoppingFailureReason.unknown,
      'No active household.',
    );
  }
  return id;
}

/// Drives add/edit/check/delete/clear for shopping items with loading/error
/// state. The list itself refreshes through the realtime [shoppingItemsProvider]
/// stream, so a mutation never needs a manual refresh — the stream re-emits.
@riverpod
class ShoppingListController extends _$ShoppingListController {
  @override
  FutureOr<void> build() {}

  /// Adds a new item to the active household. Returns whether it succeeded.
  Future<bool> add({
    required String name,
    String? quantity,
    String? categoryId,
  }) => _run(
    () => ref
        .read(shoppingRepositoryProvider)
        .addItem(
          householdId: _requireActiveHouseholdId(ref),
          name: name,
          quantity: quantity,
          categoryId: categoryId,
        ),
  );

  /// Overwrites the editable fields of the item with [id].
  Future<bool> save({
    required String id,
    required String name,
    String? quantity,
    String? categoryId,
  }) => _run(
    () => ref
        .read(shoppingRepositoryProvider)
        .updateItem(
          id: id,
          name: name,
          quantity: quantity,
          categoryId: categoryId,
        ),
  );

  /// Ticks the item with [id] on or off the list.
  Future<bool> toggle({required String id, required bool checked}) => _run(
    () => ref
        .read(shoppingRepositoryProvider)
        .setChecked(id: id, checked: checked),
  );

  /// Permanently removes the item with [id].
  Future<bool> delete(String id) =>
      _run(() => ref.read(shoppingRepositoryProvider).deleteItem(id));

  /// Permanently removes every already-checked (bought) item.
  Future<bool> clearChecked() => _run(
    () => ref
        .read(shoppingRepositoryProvider)
        .clearChecked(_requireActiveHouseholdId(ref)),
  );

  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      state = const AsyncData(null);
      return true;
    } on ShoppingFailure catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

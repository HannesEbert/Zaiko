import 'dart:async';

import 'package:zaiko/features/inventory/domain/category.dart';
import 'package:zaiko/features/inventory/domain/inventory_item.dart';
import 'package:zaiko/features/inventory/domain/inventory_repository.dart';
import 'package:zaiko/features/inventory/domain/storage_location.dart';

/// In-memory [InventoryRepository] for tests: no Supabase, fully controllable.
///
/// [watchItems] replays the current [items] to every new subscriber, then
/// forwards later changes. Mutations update the in-memory state and re-emit, so
/// provider tests observe the same "stream re-emits" behavior as production.
/// Scripting a failure is done via the `*Error` fields.
class FakeInventoryRepository implements InventoryRepository {
  List<InventoryItem> items = const [];
  List<InventoryItem> deletedItems = const [];
  List<StorageLocation> locations = const [];
  List<Category> categories = const [];

  InventoryFailure? locationsError;
  InventoryFailure? categoriesError;
  InventoryFailure? deletedItemsError;

  /// When set, every mutation throws it — for failure-path tests.
  InventoryFailure? writeError;

  int addItemCalls = 0;
  int updateItemCalls = 0;
  int setQuantityCalls = 0;
  int softDeleteCalls = 0;
  int restoreCalls = 0;
  int addLocationCalls = 0;
  int updateLocationCalls = 0;
  int deleteLocationCalls = 0;
  int addCategoryCalls = 0;
  int updateCategoryCalls = 0;
  int deleteCategoryCalls = 0;

  int _seq = 0;

  final StreamController<List<InventoryItem>> _updates =
      StreamController<List<InventoryItem>>.broadcast();

  /// Pushes a new item list to active [watchItems] subscribers.
  void emit(List<InventoryItem> next) {
    items = next;
    _updates.add(next);
  }

  void dispose() => _updates.close();

  @override
  Stream<List<InventoryItem>> watchItems(String householdId) async* {
    yield items;
    yield* _updates.stream;
  }

  @override
  Future<List<StorageLocation>> loadStorageLocations(String householdId) async {
    final error = locationsError;
    if (error != null) throw error;
    return locations;
  }

  @override
  Future<List<Category>> loadCategories(String householdId) async {
    final error = categoriesError;
    if (error != null) throw error;
    return categories;
  }

  @override
  Future<List<InventoryItem>> loadDeletedItems(String householdId) async {
    final error = deletedItemsError;
    if (error != null) throw error;
    return deletedItems;
  }

  @override
  Future<InventoryItem> addItem({
    required String householdId,
    required String name,
    required num quantity,
    String? unit,
    String? categoryId,
    String? storageLocationId,
    DateTime? bestBefore,
    String? foodId,
  }) async {
    addItemCalls++;
    _throwIfScripted();
    final now = DateTime.now();
    final item = InventoryItem(
      id: 'item-${++_seq}',
      householdId: householdId,
      name: name,
      quantity: quantity,
      createdAt: now,
      updatedAt: now,
      foodId: foodId,
      unit: unit,
      categoryId: categoryId,
      storageLocationId: storageLocationId,
      bestBefore: bestBefore,
    );
    emit([item, ...items]);
    return item;
  }

  @override
  Future<void> updateItem({
    required String id,
    required String name,
    required num quantity,
    String? unit,
    String? categoryId,
    String? storageLocationId,
    DateTime? bestBefore,
  }) async {
    updateItemCalls++;
    _throwIfScripted();
    emit([
      for (final item in items)
        if (item.id == id)
          item.copyWith(
            name: name,
            quantity: quantity,
            unit: unit,
            categoryId: categoryId,
            storageLocationId: storageLocationId,
            bestBefore: bestBefore,
          )
        else
          item,
    ]);
  }

  @override
  Future<void> setItemQuantity({
    required String id,
    required num quantity,
  }) async {
    setQuantityCalls++;
    _throwIfScripted();
    emit([
      for (final item in items)
        if (item.id == id) item.copyWith(quantity: quantity) else item,
    ]);
  }

  @override
  Future<void> softDeleteItem(String id) async {
    softDeleteCalls++;
    _throwIfScripted();
    final removed = items.where((item) => item.id == id).toList();
    deletedItems = [
      for (final item in removed) item.copyWith(deletedAt: DateTime.now()),
      ...deletedItems,
    ];
    emit(items.where((item) => item.id != id).toList());
  }

  @override
  Future<void> restoreItem(String id) async {
    restoreCalls++;
    _throwIfScripted();
    final restored = deletedItems.where((item) => item.id == id).toList();
    deletedItems = deletedItems.where((item) => item.id != id).toList();
    emit([
      for (final item in restored) item.copyWith(deletedAt: null),
      ...items,
    ]);
  }

  @override
  Future<StorageLocation> addStorageLocation({
    required String householdId,
    required String name,
    String? icon,
    String? color,
  }) async {
    addLocationCalls++;
    _throwIfScripted();
    final location = StorageLocation(
      id: 'loc-${++_seq}',
      householdId: householdId,
      name: name,
      icon: icon,
      color: color,
    );
    locations = [...locations, location];
    return location;
  }

  @override
  Future<void> updateStorageLocation({
    required String id,
    required String name,
    String? icon,
    String? color,
  }) async {
    updateLocationCalls++;
    _throwIfScripted();
    locations = [
      for (final location in locations)
        if (location.id == id)
          location.copyWith(name: name, icon: icon, color: color)
        else
          location,
    ];
  }

  @override
  Future<void> deleteStorageLocation(String id) async {
    deleteLocationCalls++;
    _throwIfScripted();
    locations = locations.where((location) => location.id != id).toList();
  }

  @override
  Future<Category> addCategory({
    required String householdId,
    required String name,
    String? icon,
    String? color,
  }) async {
    addCategoryCalls++;
    _throwIfScripted();
    final category = Category(
      id: 'cat-${++_seq}',
      name: name,
      householdId: householdId,
      icon: icon,
      color: color,
    );
    categories = [...categories, category];
    return category;
  }

  @override
  Future<void> updateCategory({
    required String id,
    required String name,
    String? icon,
    String? color,
  }) async {
    updateCategoryCalls++;
    _throwIfScripted();
    categories = [
      for (final category in categories)
        if (category.id == id)
          category.copyWith(name: name, icon: icon, color: color)
        else
          category,
    ];
  }

  @override
  Future<void> deleteCategory(String id) async {
    deleteCategoryCalls++;
    _throwIfScripted();
    categories = categories.where((category) => category.id != id).toList();
  }

  void _throwIfScripted() {
    final error = writeError;
    if (error != null) throw error;
  }
}

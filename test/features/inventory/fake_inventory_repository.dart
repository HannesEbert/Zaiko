import 'dart:async';

import 'package:zaiko/features/inventory/domain/category.dart';
import 'package:zaiko/features/inventory/domain/inventory_item.dart';
import 'package:zaiko/features/inventory/domain/inventory_repository.dart';
import 'package:zaiko/features/inventory/domain/storage_location.dart';

/// In-memory [InventoryRepository] for tests: no Supabase, fully controllable.
///
/// [watchItems] replays the current [items] to every new subscriber, then
/// forwards later [emit]s. Storage locations and categories are plain lists;
/// scripting a failure is done via the `*Error` fields.
class FakeInventoryRepository implements InventoryRepository {
  List<InventoryItem> items = const [];
  List<StorageLocation> locations = const [];
  List<Category> categories = const [];

  InventoryFailure? locationsError;
  InventoryFailure? categoriesError;

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
}

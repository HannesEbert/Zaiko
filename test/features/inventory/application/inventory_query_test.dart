import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/features/inventory/application/inventory_query.dart';
import 'package:zaiko/features/inventory/application/inventory_view.dart';
import 'package:zaiko/features/inventory/domain/expiry.dart';
import 'package:zaiko/features/inventory/domain/inventory_item.dart';

ResolvedItem _item({
  required String name,
  DateTime? createdAt,
  DateTime? bestBefore,
}) {
  final created = createdAt ?? DateTime(2026, 1, 1);
  return ResolvedItem(
    item: InventoryItem(
      id: name,
      householdId: 'h1',
      name: name,
      quantity: 1,
      createdAt: created,
      updatedAt: created,
      bestBefore: bestBefore,
    ),
    status: ExpiryStatus.none,
  );
}

List<String> _names(List<ResolvedItem> items) =>
    items.map((item) => item.item.name).toList();

void main() {
  group('filterResolvedItemsByQuery', () {
    final items = [
      _item(name: 'Milch'),
      _item(name: 'Butter'),
      _item(name: 'Buttermilch'),
    ];

    test('matches a case-insensitive substring', () {
      expect(_names(filterResolvedItemsByQuery(items, 'milch')), [
        'Milch',
        'Buttermilch',
      ]);
    });

    test('trims the query before matching', () {
      expect(_names(filterResolvedItemsByQuery(items, '  BUTTER ')), [
        'Butter',
        'Buttermilch',
      ]);
    });

    test('returns the full list for an empty or whitespace query', () {
      expect(filterResolvedItemsByQuery(items, ''), items);
      expect(filterResolvedItemsByQuery(items, '   '), items);
    });

    test('returns empty when nothing matches', () {
      expect(filterResolvedItemsByQuery(items, 'brot'), isEmpty);
    });
  });

  group('sortResolvedItems', () {
    test('nameAsc orders case-insensitively', () {
      final items = [
        _item(name: 'banana'),
        _item(name: 'Apple'),
        _item(name: 'cherry'),
      ];
      expect(_names(sortResolvedItems(items, InventorySortMode.nameAsc)), [
        'Apple',
        'banana',
        'cherry',
      ]);
    });

    test('expiry orders soonest first with missing dates last', () {
      final items = [
        _item(name: 'none'),
        _item(name: 'late', bestBefore: DateTime(2026, 3, 1)),
        _item(name: 'soon', bestBefore: DateTime(2026, 1, 15)),
      ];
      expect(_names(sortResolvedItems(items, InventorySortMode.expiry)), [
        'soon',
        'late',
        'none',
      ]);
    });

    test('recentlyAdded orders newest first', () {
      final items = [
        _item(name: 'old', createdAt: DateTime(2026, 1, 1)),
        _item(name: 'new', createdAt: DateTime(2026, 1, 10)),
        _item(name: 'mid', createdAt: DateTime(2026, 1, 5)),
      ];
      expect(
        _names(sortResolvedItems(items, InventorySortMode.recentlyAdded)),
        ['new', 'mid', 'old'],
      );
    });

    test('does not mutate the input list', () {
      final items = [_item(name: 'b'), _item(name: 'a')];
      sortResolvedItems(items, InventorySortMode.nameAsc);
      expect(_names(items), ['b', 'a']);
    });
  });

  group('recentlyAddedWithin', () {
    final now = DateTime(2026, 1, 10, 12);

    test('keeps items within the window and drops older ones', () {
      final items = [
        _item(name: 'today', createdAt: DateTime(2026, 1, 10)),
        _item(name: 'old', createdAt: DateTime(2026, 1, 1)),
        _item(name: 'twoDays', createdAt: DateTime(2026, 1, 8, 12)),
      ];
      expect(_names(recentlyAddedWithin(items, now)), ['today', 'twoDays']);
    });

    test('includes an item exactly at the window boundary', () {
      final items = [
        _item(
          name: 'boundary',
          createdAt: now.subtract(const Duration(days: 3)),
        ),
      ];
      expect(_names(recentlyAddedWithin(items, now)), ['boundary']);
    });

    test('returns the kept items newest first', () {
      final items = [
        _item(name: 'older', createdAt: DateTime(2026, 1, 8)),
        _item(name: 'newer', createdAt: DateTime(2026, 1, 10)),
      ];
      expect(_names(recentlyAddedWithin(items, now)), ['newer', 'older']);
    });
  });
}

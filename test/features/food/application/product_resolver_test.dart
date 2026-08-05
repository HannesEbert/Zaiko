import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/features/food/application/food_providers.dart';
import 'package:zaiko/features/food/domain/food.dart';

import '../fake_food_catalog_repository.dart';
import '../fake_food_lookup_repository.dart';

void main() {
  late FakeFoodLookupRepository lookup;
  late FakeFoodCatalogRepository catalog;
  late ProviderContainer container;

  setUp(() {
    lookup = FakeFoodLookupRepository();
    catalog = FakeFoodCatalogRepository();
    container = ProviderContainer(
      overrides: [
        foodLookupRepositoryProvider.overrideWithValue(lookup),
        foodCatalogRepositoryProvider.overrideWithValue(catalog),
      ],
    );
    addTearDown(container.dispose);
  });

  ProductResolver resolver() =>
      container.read(productResolverProvider.notifier);

  test('resolveByBarcode caches the resolved product and returns it', () async {
    final product = Food.create(
      name: 'Milk',
      source: FoodSource.openFoodFacts,
      barcode: '111',
    );
    lookup.barcodeResult = product;

    final result = await resolver().resolveByBarcode('111');

    expect(result?.name, 'Milk');
    expect(lookup.lastBarcode, '111');
    expect(catalog.cacheCalls, 1);
    expect(catalog.cached, contains(product));
  });

  test('resolveByBarcode returns null and skips caching on a miss', () async {
    lookup.barcodeResult = null;

    final result = await resolver().resolveByBarcode('999');

    expect(result, isNull);
    expect(catalog.cacheCalls, 0);
  });

  test('resolveByBarcode dedupes: a re-scan returns the cached row', () async {
    final cachedRow = Food.create(
      name: 'Milk',
      source: FoodSource.openFoodFacts,
      barcode: '111',
    );
    catalog.cached.add(cachedRow);
    lookup.barcodeResult = Food.create(
      name: 'Milk',
      source: FoodSource.openFoodFacts,
      barcode: '111',
    );

    final result = await resolver().resolveByBarcode('111');

    // The already-cached row wins over the freshly resolved one (returned as a
    // value-equal copy, since the resolver re-attaches the transient size).
    expect(result, cachedRow);
  });

  test('search delegates to the lookup repository', () async {
    lookup.searchResults = [
      Food.create(name: 'Bread', source: FoodSource.openFoodFacts),
    ];

    final results = await resolver().search('bread');

    expect(results, hasLength(1));
    expect(lookup.lastQuery, 'bread');
    // Search results are not cached until one is picked.
    expect(catalog.cacheCalls, 0);
  });

  test('selectSearchResult caches the chosen product', () async {
    final product = Food.create(
      name: 'Bread',
      source: FoodSource.openFoodFacts,
      barcode: '222',
    );

    final result = await resolver().selectSearchResult(product);

    expect(result, product);
    expect(catalog.cacheCalls, 1);
  });

  test(
    'resolveByBarcode keeps the package size on an already-cached row',
    () async {
      final cachedRow = Food.create(
        name: 'Milk',
        source: FoodSource.openFoodFacts,
        barcode: '111',
      );
      catalog.cached.add(cachedRow); // pre-cached, size-agnostic
      lookup.barcodeResult = Food.create(
        name: 'Milk',
        source: FoodSource.openFoodFacts,
        barcode: '111',
      ).copyWith(packagedAmount: 500, packagedUnit: 'g');

      final result = await resolver().resolveByBarcode('111');

      // The cached row (same id) is returned, but with the fresh package size
      // re-attached for the form prefill.
      expect(result?.id, cachedRow.id);
      expect(result?.packagedAmount, 500);
      expect(result?.packagedUnit, 'g');
    },
  );

  test('selectSearchResult keeps the package size', () async {
    final product = Food.create(
      name: 'Bread',
      source: FoodSource.openFoodFacts,
      barcode: '222',
    ).copyWith(packagedAmount: 750, packagedUnit: 'g');

    final result = await resolver().selectSearchResult(product);

    expect(result.packagedAmount, 750);
    expect(result.packagedUnit, 'g');
  });
}

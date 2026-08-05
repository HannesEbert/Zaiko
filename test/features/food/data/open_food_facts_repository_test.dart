import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:zaiko/features/food/data/open_food_facts_repository.dart';
import 'package:zaiko/features/food/domain/food.dart';
import 'package:zaiko/features/food/domain/food_failure.dart';

/// Builds a repository whose HTTP client is a [MockClient] driven by [handler].
OpenFoodFactsRepository _repo(
  Future<http.Response> Function(http.Request request) handler,
) => OpenFoodFactsRepository(MockClient(handler));

void main() {
  group('lookupByBarcode', () {
    test('maps a found product to a Food', () async {
      late Uri requested;
      final repo = _repo((request) async {
        requested = request.url;
        return http.Response(
          jsonEncode({
            'status': 1,
            'product': {
              'code': '3017620422003',
              'product_name': 'Nutella',
              'brands': 'Ferrero, Nutella',
              'image_url': 'https://images.test/nutella.png',
            },
          }),
          200,
        );
      });

      final food = await repo.lookupByBarcode('3017620422003');

      expect(requested.path, '/api/v2/product/3017620422003.json');
      expect(food, isNotNull);
      expect(food!.name, 'Nutella');
      // Only the first of the comma-separated brands is kept.
      expect(food.brand, 'Ferrero');
      expect(food.barcode, '3017620422003');
      expect(food.imageUrl, 'https://images.test/nutella.png');
      expect(food.source, FoodSource.openFoodFacts);
    });

    test('returns null when the barcode is unknown (status 0)', () async {
      final repo = _repo(
        (_) async => http.Response(jsonEncode({'status': 0}), 200),
      );

      expect(await repo.lookupByBarcode('0000000000000'), isNull);
    });

    test('returns null when the product has no usable name', () async {
      final repo = _repo(
        (_) async => http.Response(
          jsonEncode({
            'status': 1,
            'product': {'code': '123', 'product_name': ''},
          }),
          200,
        ),
      );

      expect(await repo.lookupByBarcode('123'), isNull);
    });

    test('maps HTTP 429 to a rateLimited failure', () async {
      final repo = _repo((_) async => http.Response('', 429));

      await expectLater(
        repo.lookupByBarcode('123'),
        throwsA(
          isA<FoodFailure>().having(
            (e) => e.reason,
            'reason',
            FoodFailureReason.rateLimited,
          ),
        ),
      );
    });

    test('maps a transport error to a network failure', () async {
      final repo = _repo((_) async => throw http.ClientException('offline'));

      await expectLater(
        repo.lookupByBarcode('123'),
        throwsA(
          isA<FoodFailure>().having(
            (e) => e.reason,
            'reason',
            FoodFailureReason.network,
          ),
        ),
      );
    });
  });

  group('searchByName', () {
    test('maps results and drops entries without a name', () async {
      final repo = _repo(
        (_) async => http.Response(
          jsonEncode({
            'products': [
              {'code': '1', 'product_name': 'Bread', 'brands': 'Baker'},
              {'code': '2', 'product_name': ''},
              {'code': '3', 'product_name': 'Butter'},
            ],
          }),
          200,
        ),
      );

      final results = await repo.searchByName('br');

      expect(results.map((f) => f.name), ['Bread', 'Butter']);
      expect(results.first.brand, 'Baker');
    });

    test('returns an empty list when there are no products', () async {
      final repo = _repo(
        (_) async => http.Response(jsonEncode({'products': <dynamic>[]}), 200),
      );

      expect(await repo.searchByName('zzz'), isEmpty);
    });

    test('restricts to Germany and sorts by popularity', () async {
      late Uri requested;
      final repo = _repo((request) async {
        requested = request.url;
        return http.Response(jsonEncode({'products': <dynamic>[]}), 200);
      });

      await repo.searchByName('wasser');

      final params = requested.queryParameters;
      expect(params['sort_by'], 'unique_scans_n');
      expect(params['tagtype_0'], 'countries');
      expect(params['tag_0'], 'germany');
      expect(params['cc'], 'de');
      expect(params['lc'], 'de');
    });
  });

  group('package quantity', () {
    // Resolves a barcode whose product carries the given quantity fields.
    Future<Food?> lookupWith(Map<String, dynamic> quantityFields) {
      final repo = _repo(
        (_) async => http.Response(
          jsonEncode({
            'status': 1,
            'product': {'code': '1', 'product_name': 'X', ...quantityFields},
          }),
          200,
        ),
      );
      return repo.lookupByBarcode('1');
    }

    test('keeps a sub-litre volume as millilitres', () async {
      final food = await lookupWith({
        'product_quantity': 330,
        'product_quantity_unit': 'ml',
      });
      expect(food!.packagedAmount, 330);
      expect(food.packagedUnit, 'ml');
    });

    test('scales a full litre up to l, and a kilo up to kg', () async {
      final litre = await lookupWith({
        'product_quantity': 1000,
        'product_quantity_unit': 'ml',
      });
      expect(litre!.packagedAmount, 1);
      expect(litre.packagedUnit, 'l');

      final kilo = await lookupWith({
        'product_quantity': 1500,
        'product_quantity_unit': 'g',
      });
      expect(kilo!.packagedAmount, 1.5);
      expect(kilo.packagedUnit, 'kg');
    });

    test('keeps a sub-kilo weight in grams', () async {
      final food = await lookupWith({
        'product_quantity': '500',
        'product_quantity_unit': 'g',
      });
      expect(food!.packagedAmount, 500);
      expect(food.packagedUnit, 'g');
    });

    test('converts centilitres to millilitres', () async {
      final food = await lookupWith({
        'product_quantity': 33,
        'product_quantity_unit': 'cl',
      });
      expect(food!.packagedAmount, 330);
      expect(food.packagedUnit, 'ml');
    });

    test('leaves the quantity unset when absent or an unknown unit', () async {
      final none = await lookupWith(const {});
      expect(none!.packagedAmount, isNull);
      expect(none.packagedUnit, isNull);

      final ounces = await lookupWith({
        'product_quantity': 12,
        'product_quantity_unit': 'oz',
      });
      expect(ounces!.packagedAmount, isNull);
      expect(ounces.packagedUnit, isNull);
    });
  });

  group('resilience', () {
    test('retries once on a transient 503, then succeeds', () async {
      var calls = 0;
      final repo = _repo((_) async {
        calls++;
        if (calls == 1) return http.Response('', 503);
        return http.Response(jsonEncode({'products': <dynamic>[]}), 200);
      });

      await repo.searchByName('wasser');

      expect(calls, 2);
    });

    test('maps a persistent 5xx to a network failure', () async {
      var calls = 0;
      final repo = _repo((_) async {
        calls++;
        return http.Response('', 503);
      });

      await expectLater(
        repo.searchByName('wasser'),
        throwsA(
          isA<FoodFailure>().having(
            (e) => e.reason,
            'reason',
            FoodFailureReason.network,
          ),
        ),
      );
      // One retry after the first failure.
      expect(calls, 2);
    });
  });
}

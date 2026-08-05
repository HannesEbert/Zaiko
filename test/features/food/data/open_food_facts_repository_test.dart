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
  });
}

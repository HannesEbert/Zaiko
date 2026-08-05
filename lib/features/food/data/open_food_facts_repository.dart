import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../core/config/app_config.dart';
import '../domain/food.dart';
import '../domain/food_failure.dart';
import '../domain/food_lookup_repository.dart';

/// [FoodLookupRepository] backed by the Open Food Facts REST API.
///
/// Sends only the barcode or search term plus the configured
/// [AppConfig.offUserAgent] — no user or household data (see ADR-0012). HTTP,
/// timeout and parse errors are translated to [FoodFailure] so callers never
/// see a transport exception.
class OpenFoodFactsRepository implements FoodLookupRepository {
  OpenFoodFactsRepository([http.Client? client])
    : _client = client ?? http.Client();

  final http.Client _client;

  /// Open Food Facts world instance. The `.net` staging host mirrors it but
  /// production data lives here.
  static const String _host = 'world.openfoodfacts.org';

  /// Product fields requested from the API — everything the add form pre-fills,
  /// nothing more, to keep responses small.
  static const String _fields = 'code,product_name,brands,image_url';

  /// Guards against a hung connection so being offline surfaces promptly as a
  /// [FoodFailureReason.network] rather than blocking the scan flow.
  static const Duration _timeout = Duration(seconds: 10);

  @override
  Future<Food?> lookupByBarcode(String barcode) => _guard(() async {
    final uri = Uri.https(_host, '/api/v2/product/$barcode.json', {
      'fields': _fields,
    });
    final json = await _getJson(uri);
    // status 0 means the barcode is not in the database — a normal miss.
    if (json['status'] != 1) return null;
    final product = json['product'];
    if (product is! Map<String, dynamic>) return null;
    return _foodFromProduct(product);
  });

  @override
  Future<List<Food>> searchByName(String query) => _guard(() async {
    final uri = Uri.https(_host, '/cgi/search.pl', {
      'search_terms': query,
      'search_simple': '1',
      'action': 'process',
      'json': '1',
      'page_size': '20',
      'fields': _fields,
    });
    final json = await _getJson(uri);
    final products = json['products'];
    if (products is! List) return const [];
    return [
      for (final product in products)
        if (product is Map<String, dynamic>) ?_foodFromProduct(product),
    ];
  });

  /// Performs the GET and decodes a JSON object, mapping HTTP status codes to
  /// failures. 429 is surfaced distinctly so the UI can suggest retrying later.
  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    final response = await _client
        .get(uri, headers: {'User-Agent': AppConfig.offUserAgent})
        .timeout(_timeout);
    if (response.statusCode == 429) {
      throw const FoodFailure(
        FoodFailureReason.rateLimited,
        'Open Food Facts rate limit reached.',
      );
    }
    if (response.statusCode != 200) {
      throw FoodFailure(
        FoodFailureReason.unknown,
        'Open Food Facts returned HTTP ${response.statusCode}.',
      );
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FoodFailure(
        FoodFailureReason.unknown,
        'Unexpected Open Food Facts response shape.',
      );
    }
    return decoded;
  }

  /// Maps an Open Food Facts product object to a [Food], or `null` when it has
  /// no usable name (nothing to pre-fill from).
  Food? _foodFromProduct(Map<String, dynamic> product) {
    final name = (product['product_name'] as String?)?.trim();
    if (name == null || name.isEmpty) return null;
    return Food.create(
      name: name,
      source: FoodSource.openFoodFacts,
      brand: _firstBrand(product['brands'] as String?),
      barcode: (product['code'] as String?)?.trim(),
      imageUrl: _nullIfEmpty(product['image_url'] as String?),
    );
  }

  /// Open Food Facts stores brands as a comma-separated list; the first entry
  /// is the primary brand.
  String? _firstBrand(String? brands) {
    final first = brands?.split(',').first.trim();
    return _nullIfEmpty(first);
  }

  String? _nullIfEmpty(String? value) =>
      (value == null || value.isEmpty) ? null : value;

  /// Runs [op], translating transport-level errors into a [FoodFailure] while
  /// letting a [FoodFailure] thrown inside (e.g. a mapped status code) pass
  /// through unchanged.
  Future<T> _guard<T>(Future<T> Function() op) async {
    try {
      return await op();
    } on FoodFailure {
      rethrow;
    } on SocketException catch (e) {
      throw FoodFailure(FoodFailureReason.network, e.message);
    } on TimeoutException {
      throw const FoodFailure(
        FoodFailureReason.network,
        'Open Food Facts request timed out.',
      );
    } on http.ClientException catch (e) {
      throw FoodFailure(FoodFailureReason.network, e.message);
    } on FormatException catch (e) {
      throw FoodFailure(FoodFailureReason.unknown, e.message);
    }
  }
}

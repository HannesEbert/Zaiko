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
  static const String _fields =
      'code,product_name,brands,image_url,product_quantity,product_quantity_unit';

  /// Sort search results by scan count, so the best-known products rank first.
  static const String _popularitySort = 'unique_scans_n';

  /// DACH focus: restrict text search to products sold in Germany and set the
  /// German country/language context (see ADR-0012). Germany is the pragmatic
  /// proxy — the major Austrian/Swiss brands are listed there too, and
  /// `search.pl` cannot OR several countries cleanly.
  static const String _country = 'germany';
  static const String _countryCode = 'de';
  static const String _languageCode = 'de';

  /// The `cgi/search.pl` endpoint is slow, so allow more time before treating a
  /// request as failed.
  static const Duration _timeout = Duration(seconds: 15);

  /// Open Food Facts returns transient 5xx/timeouts under load; retry this many
  /// times before surfacing a failure.
  static const int _maxRetries = 1;

  /// Backoff between attempts.
  static const Duration _retryDelay = Duration(milliseconds: 400);

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
      // Focus on Germany, best-known products first, so the DACH audience sees
      // mainstream local brands instead of global imports.
      'sort_by': _popularitySort,
      'tagtype_0': 'countries',
      'tag_contains_0': 'contains',
      'tag_0': _country,
      'cc': _countryCode,
      'lc': _languageCode,
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
  /// failures. A timeout or a transient 5xx is retried once before failing; 429
  /// is surfaced distinctly so the UI can suggest retrying later.
  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    for (var attempt = 0; ; attempt++) {
      final http.Response response;
      try {
        response = await _client
            .get(uri, headers: {'User-Agent': AppConfig.offUserAgent})
            .timeout(_timeout);
      } on TimeoutException {
        if (attempt < _maxRetries) {
          await Future<void>.delayed(_retryDelay);
          continue;
        }
        rethrow; // Mapped to a network failure in _guard.
      }

      if (response.statusCode == 429) {
        throw const FoodFailure(
          FoodFailureReason.rateLimited,
          'Open Food Facts rate limit reached.',
        );
      }
      // Transient server errors (e.g. 503 under load): retry, then surface as a
      // temporary-unavailability network failure.
      if (response.statusCode >= 500) {
        if (attempt < _maxRetries) {
          await Future<void>.delayed(_retryDelay);
          continue;
        }
        throw FoodFailure(
          FoodFailureReason.network,
          'Open Food Facts is unavailable (HTTP ${response.statusCode}).',
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
  }

  /// Maps an Open Food Facts product object to a [Food], or `null` when it has
  /// no usable name (nothing to pre-fill from). Attaches the parsed package
  /// size (transient, for the add-form prefill) when Open Food Facts has one.
  Food? _foodFromProduct(Map<String, dynamic> product) {
    final name = (product['product_name'] as String?)?.trim();
    if (name == null || name.isEmpty) return null;
    final packaged = _parsePackagedQuantity(product);
    return Food.create(
      name: name,
      source: FoodSource.openFoodFacts,
      brand: _firstBrand(product['brands'] as String?),
      barcode: (product['code'] as String?)?.trim(),
      imageUrl: _nullIfEmpty(product['image_url'] as String?),
    ).copyWith(packagedAmount: packaged?.amount, packagedUnit: packaged?.unit);
  }

  /// Parses the product's package size into a display amount plus an
  /// [InventoryUnit] key (`g`/`kg`/`ml`/`l`), or null when Open Food Facts has
  /// no usable value (the form then keeps its default of 1 piece).
  ///
  /// Uses the structured `product_quantity` (grams or millilitres) +
  /// `product_quantity_unit` rather than the free-text `quantity` string, and
  /// scales up to the friendlier unit (1000 ml → 1 l, 1500 g → 1.5 kg).
  ({num amount, String unit})? _parsePackagedQuantity(
    Map<String, dynamic> product,
  ) {
    final raw = product['product_quantity'];
    final amount = raw is num
        ? raw
        : raw is String
        ? num.tryParse(raw.trim().replaceAll(',', '.'))
        : null;
    final unit = (product['product_quantity_unit'] as String?)
        ?.trim()
        .toLowerCase();
    if (amount == null || amount <= 0 || unit == null || unit.isEmpty) {
      return null;
    }
    return switch (unit) {
      'cl' => _scale(amount * 10, 'ml'),
      'ml' => _scale(amount, 'ml'),
      'l' || 'liter' || 'litre' => (amount: amount, unit: 'l'),
      'g' => _scale(amount, 'g'),
      'kg' => (amount: amount, unit: 'kg'),
      // Unknown units (oz, lb, …) have no InventoryUnit — let the form default.
      _ => null,
    };
  }

  /// Scales a base-unit amount up to the friendlier unit once it reaches 1000
  /// (1000 ml → 1 l, 1500 g → 1.5 kg); smaller amounts stay as-is.
  ({num amount, String unit}) _scale(num amount, String baseUnit) {
    final bigUnit = baseUnit == 'ml' ? 'l' : 'kg';
    return amount >= 1000
        ? (amount: amount / 1000, unit: bigUnit)
        : (amount: amount, unit: baseUnit);
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

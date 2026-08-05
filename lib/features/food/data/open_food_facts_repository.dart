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

  /// Open Food Facts world instance, used for the fast v2 barcode lookup. The
  /// `.net` staging host mirrors it but production data lives here.
  static const String _host = 'world.openfoodfacts.org';

  /// Dedicated full-text search service (Search-a-licious). It replaces the
  /// legacy, slow `cgi/search.pl` and is markedly faster and more reliable
  /// (see ADR-0012).
  static const String _searchHost = 'search.openfoodfacts.org';

  /// Product fields requested from the v2 barcode endpoint — everything the add
  /// form pre-fills, nothing more, to keep responses small.
  static const String _fields =
      'code,product_name,brands,image_url,product_quantity,product_quantity_unit';

  /// Fields requested from the search endpoint. It does not expose the
  /// structured `product_quantity`, only the free-text `quantity` string, and
  /// returns `brands` as a list.
  static const String _searchFields =
      'code,product_name,brands,image_url,quantity';

  /// Sort search results by scan count, so the best-known products rank first.
  /// The search endpoint expects a leading `-` for descending order.
  static const String _popularitySort = 'unique_scans_n';

  /// DACH focus: restrict text search to products sold in Germany (see
  /// ADR-0012). Germany is the pragmatic proxy — the major Austrian/Swiss
  /// brands are listed there too. Applied as a Lucene filter inside `q`.
  static const String _countryTag = 'en:germany';
  static const String _languageCode = 'de';

  /// Both endpoints answer quickly in the normal case; cap the wait so a hung
  /// request surfaces as an error promptly instead of blocking the search UI.
  static const Duration _timeout = Duration(seconds: 8);

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
    final uri = Uri.https(_searchHost, '/search', {
      // Lucene syntax: the sanitized term plus a country filter, so the DACH
      // audience sees mainstream local products instead of global imports.
      'q': '${_sanitizeQuery(query)} countries_tags:"$_countryTag"',
      'langs': _languageCode,
      'page_size': '20',
      'fields': _searchFields,
      // Best-known products first (descending scan count).
      'sort_by': '-$_popularitySort',
    });
    final json = await _getJson(uri);
    final hits = json['hits'];
    if (hits is! List) return const [];
    return [
      for (final product in hits)
        if (product is Map<String, dynamic>) ?_foodFromProduct(product),
    ];
  });

  /// Strips Lucene control characters from the user's query so free-text input
  /// can never break the search expression it is embedded into.
  String _sanitizeQuery(String query) =>
      query.replaceAll(RegExp(r'[+\-!(){}\[\]^"~*?:\\/&|<>=]'), ' ').trim();

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
    // Barcode lookups carry the structured quantity; search hits expose only
    // the free-text `quantity`, so fall back to parsing that.
    final packaged =
        _parsePackagedQuantity(product) ??
        _parseQuantityText(product['quantity']);
    return Food.create(
      name: name,
      source: FoodSource.openFoodFacts,
      brand: _firstBrand(product['brands']),
      barcode: (product['code'] as String?)?.trim(),
      imageUrl: _nullIfEmpty(product['image_url'] as String?),
    ).copyWith(packagedAmount: packaged?.amount, packagedUnit: packaged?.unit);
  }

  /// Parses the structured package size (`product_quantity` in grams or
  /// millilitres + `product_quantity_unit`) into a display amount plus an
  /// [InventoryUnit] key, or null when there is no usable value (the form then
  /// keeps its default of 1 piece). Returned by the v2 barcode endpoint.
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
    return _normalizeUnit(amount, unit);
  }

  /// Parses the search endpoint's free-text `quantity` (e.g. `"1,5 L"`,
  /// `"330 ml"`, `"500 g"`) into an amount plus [InventoryUnit] key. Only a
  /// single, unambiguous `<number> <metric-unit>` is accepted — bare numbers,
  /// multipacks (`"6 x 1,5 L"`) and non-metric values yield null, so the form
  /// is never pre-filled with a misread size.
  ({num amount, String unit})? _parseQuantityText(Object? quantity) {
    if (quantity is! String) return null;
    final match = _quantityPattern.firstMatch(quantity.trim());
    if (match == null) return null;
    final amount = num.tryParse(match.group(1)!.replaceAll(',', '.'));
    if (amount == null || amount <= 0) return null;
    return _normalizeUnit(amount, match.group(2)!.toLowerCase());
  }

  /// Matches a lone `<number> <unit>` (optional decimal comma/point, optional
  /// space). Anchored on both ends so anything extra — a leading `6 x`, a
  /// trailing `℮`, a second value — fails to match.
  static final RegExp _quantityPattern = RegExp(
    r'^(\d+(?:[.,]\d+)?)\s*(g|kg|ml|cl|l|liter|litre)$',
    caseSensitive: false,
  );

  /// Maps a raw amount + unit onto an [InventoryUnit] key, scaling up to the
  /// friendlier unit (1000 ml → 1 l, 1500 g → 1.5 kg) and converting
  /// centilitres to millilitres. Unknown units (oz, lb, …) yield null.
  ({num amount, String unit})? _normalizeUnit(num amount, String unit) =>
      switch (unit) {
        'cl' => _scale(amount * 10, 'ml'),
        'ml' => _scale(amount, 'ml'),
        'l' || 'liter' || 'litre' => (amount: amount, unit: 'l'),
        'g' => _scale(amount, 'g'),
        'kg' => (amount: amount, unit: 'kg'),
        _ => null,
      };

  /// Scales a base-unit amount up to the friendlier unit once it reaches 1000
  /// (1000 ml → 1 l, 1500 g → 1.5 kg); smaller amounts stay as-is.
  ({num amount, String unit}) _scale(num amount, String baseUnit) {
    final bigUnit = baseUnit == 'ml' ? 'l' : 'kg';
    return amount >= 1000
        ? (amount: amount / 1000, unit: bigUnit)
        : (amount: amount, unit: baseUnit);
  }

  /// The primary brand. Open Food Facts returns brands as a comma-separated
  /// string (v2 barcode endpoint) or a list (search endpoint); the first entry
  /// is the primary brand in both cases.
  String? _firstBrand(Object? brands) {
    if (brands is List) {
      final first = brands.isEmpty ? null : brands.first?.toString().trim();
      return _nullIfEmpty(first);
    }
    if (brands is String) {
      return _nullIfEmpty(brands.split(',').first.trim());
    }
    return null;
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

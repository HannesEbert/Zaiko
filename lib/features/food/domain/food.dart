import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'food.freezed.dart';
part 'food.g.dart';

/// Where a [Food] record originated. Persisted as a stable string so the
/// enum can be reordered or extended without breaking stored/synced data.
enum FoodSource {
  @JsonValue('openFoodFacts')
  openFoodFacts,
  @JsonValue('custom')
  custom,
}

/// A single food product the household can stock.
///
/// This is the reference model that proves the code-generation chain
/// (freezed + json_serializable) end to end. The last three fields exist for
/// offline-first sync: soft deletes via [deletedAt] and last-write-wins via
/// [updatedAt].
@freezed
abstract class Food with _$Food {
  const factory Food({
    /// Client-generated UUID. Never reuse an external product's id — see
    /// [Food.create], which mints one.
    required String id,
    required String name,
    required FoodSource source,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? brand,
    String? barcode,
    String? imageUrl,
    String? householdId,
    DateTime? deletedAt,
  }) = _Food;

  /// Creates a new [Food] with a freshly generated UUID and matching
  /// `createdAt`/`updatedAt` timestamps (UTC). Use this instead of the default
  /// constructor when adding a brand-new record; the default constructor is
  /// reserved for reconstructing existing records (e.g. from [fromJson]).
  factory Food.create({
    required String name,
    required FoodSource source,
    String? brand,
    String? barcode,
    String? imageUrl,
    String? householdId,
  }) {
    final now = DateTime.now().toUtc();
    return Food(
      id: const Uuid().v4(),
      name: name,
      source: source,
      createdAt: now,
      updatedAt: now,
      brand: brand,
      barcode: barcode,
      imageUrl: imageUrl,
      householdId: householdId,
    );
  }

  factory Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);
}

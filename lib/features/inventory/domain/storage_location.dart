import 'package:freezed_annotation/freezed_annotation.dart';

part 'storage_location.freezed.dart';
part 'storage_location.g.dart';

/// A place a household stores food (fridge, freezer, pantry, …).
///
/// Mirrors a `public.storage_locations` row. [color] is a stable palette key
/// (not a hex value) and [icon] a Material icon identifier; the presentation
/// layer maps both to `AppColors`/`AppIcons`.
@freezed
abstract class StorageLocation with _$StorageLocation {
  const factory StorageLocation({
    required String id,
    @JsonKey(name: 'household_id') required String householdId,
    required String name,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    String? icon,
    String? color,
  }) = _StorageLocation;

  factory StorageLocation.fromJson(Map<String, dynamic> json) =>
      _$StorageLocationFromJson(json);

  /// Sentinel id for the synthetic bucket that groups items without a real
  /// storage location in the grid. Never persisted — the presentation layer
  /// resolves its localized name and the inventory providers map it to
  /// `storageLocationId == null`.
  static const String unassignedId = '__unassigned__';
}

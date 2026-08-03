import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

/// A food category. Hybrid: app-wide defaults ([isDefault] true, no
/// [householdId]) plus a household's own custom categories.
///
/// Mirrors a `public.categories` row. [color] is a stable palette key and
/// [icon] a Material icon identifier, resolved in the presentation layer.
@freezed
abstract class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
    @JsonKey(name: 'household_id') String? householdId,
    String? icon,
    String? color,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}

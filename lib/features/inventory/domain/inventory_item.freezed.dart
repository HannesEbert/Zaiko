// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InventoryItem {

 String get id;@JsonKey(name: 'household_id') String get householdId; String get name; num get quantity;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;/// Optional link to the product catalog (`foods`); null for ad-hoc items.
@JsonKey(name: 'food_id') String? get foodId;/// App-owned unit key (g/kg/ml/l/piece/package); null when unitless.
 String? get unit;@JsonKey(name: 'category_id') String? get categoryId;@JsonKey(name: 'storage_location_id') String? get storageLocationId;/// Best-before date. Null means the item has no expiry and shows no status.
@JsonKey(name: 'best_before') DateTime? get bestBefore;/// The user who added the item; nulled out if their account is deleted.
@JsonKey(name: 'added_by') String? get addedBy;@JsonKey(name: 'deleted_at') DateTime? get deletedAt;
/// Create a copy of InventoryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryItemCopyWith<InventoryItem> get copyWith => _$InventoryItemCopyWithImpl<InventoryItem>(this as InventoryItem, _$identity);

  /// Serializes this InventoryItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.householdId, householdId) || other.householdId == householdId)&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.foodId, foodId) || other.foodId == foodId)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.storageLocationId, storageLocationId) || other.storageLocationId == storageLocationId)&&(identical(other.bestBefore, bestBefore) || other.bestBefore == bestBefore)&&(identical(other.addedBy, addedBy) || other.addedBy == addedBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,householdId,name,quantity,createdAt,updatedAt,foodId,unit,categoryId,storageLocationId,bestBefore,addedBy,deletedAt);

@override
String toString() {
  return 'InventoryItem(id: $id, householdId: $householdId, name: $name, quantity: $quantity, createdAt: $createdAt, updatedAt: $updatedAt, foodId: $foodId, unit: $unit, categoryId: $categoryId, storageLocationId: $storageLocationId, bestBefore: $bestBefore, addedBy: $addedBy, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class $InventoryItemCopyWith<$Res>  {
  factory $InventoryItemCopyWith(InventoryItem value, $Res Function(InventoryItem) _then) = _$InventoryItemCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'household_id') String householdId, String name, num quantity,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt,@JsonKey(name: 'food_id') String? foodId, String? unit,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'storage_location_id') String? storageLocationId,@JsonKey(name: 'best_before') DateTime? bestBefore,@JsonKey(name: 'added_by') String? addedBy,@JsonKey(name: 'deleted_at') DateTime? deletedAt
});




}
/// @nodoc
class _$InventoryItemCopyWithImpl<$Res>
    implements $InventoryItemCopyWith<$Res> {
  _$InventoryItemCopyWithImpl(this._self, this._then);

  final InventoryItem _self;
  final $Res Function(InventoryItem) _then;

/// Create a copy of InventoryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? householdId = null,Object? name = null,Object? quantity = null,Object? createdAt = null,Object? updatedAt = null,Object? foodId = freezed,Object? unit = freezed,Object? categoryId = freezed,Object? storageLocationId = freezed,Object? bestBefore = freezed,Object? addedBy = freezed,Object? deletedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,householdId: null == householdId ? _self.householdId : householdId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as num,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,foodId: freezed == foodId ? _self.foodId : foodId // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,storageLocationId: freezed == storageLocationId ? _self.storageLocationId : storageLocationId // ignore: cast_nullable_to_non_nullable
as String?,bestBefore: freezed == bestBefore ? _self.bestBefore : bestBefore // ignore: cast_nullable_to_non_nullable
as DateTime?,addedBy: freezed == addedBy ? _self.addedBy : addedBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryItem].
extension InventoryItemPatterns on InventoryItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryItem value)  $default,){
final _that = this;
switch (_that) {
case _InventoryItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryItem value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'household_id')  String householdId,  String name,  num quantity, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(name: 'food_id')  String? foodId,  String? unit, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'storage_location_id')  String? storageLocationId, @JsonKey(name: 'best_before')  DateTime? bestBefore, @JsonKey(name: 'added_by')  String? addedBy, @JsonKey(name: 'deleted_at')  DateTime? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryItem() when $default != null:
return $default(_that.id,_that.householdId,_that.name,_that.quantity,_that.createdAt,_that.updatedAt,_that.foodId,_that.unit,_that.categoryId,_that.storageLocationId,_that.bestBefore,_that.addedBy,_that.deletedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'household_id')  String householdId,  String name,  num quantity, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(name: 'food_id')  String? foodId,  String? unit, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'storage_location_id')  String? storageLocationId, @JsonKey(name: 'best_before')  DateTime? bestBefore, @JsonKey(name: 'added_by')  String? addedBy, @JsonKey(name: 'deleted_at')  DateTime? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _InventoryItem():
return $default(_that.id,_that.householdId,_that.name,_that.quantity,_that.createdAt,_that.updatedAt,_that.foodId,_that.unit,_that.categoryId,_that.storageLocationId,_that.bestBefore,_that.addedBy,_that.deletedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'household_id')  String householdId,  String name,  num quantity, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(name: 'food_id')  String? foodId,  String? unit, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'storage_location_id')  String? storageLocationId, @JsonKey(name: 'best_before')  DateTime? bestBefore, @JsonKey(name: 'added_by')  String? addedBy, @JsonKey(name: 'deleted_at')  DateTime? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _InventoryItem() when $default != null:
return $default(_that.id,_that.householdId,_that.name,_that.quantity,_that.createdAt,_that.updatedAt,_that.foodId,_that.unit,_that.categoryId,_that.storageLocationId,_that.bestBefore,_that.addedBy,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventoryItem implements InventoryItem {
  const _InventoryItem({required this.id, @JsonKey(name: 'household_id') required this.householdId, required this.name, required this.quantity, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, @JsonKey(name: 'food_id') this.foodId, this.unit, @JsonKey(name: 'category_id') this.categoryId, @JsonKey(name: 'storage_location_id') this.storageLocationId, @JsonKey(name: 'best_before') this.bestBefore, @JsonKey(name: 'added_by') this.addedBy, @JsonKey(name: 'deleted_at') this.deletedAt});
  factory _InventoryItem.fromJson(Map<String, dynamic> json) => _$InventoryItemFromJson(json);

@override final  String id;
@override@JsonKey(name: 'household_id') final  String householdId;
@override final  String name;
@override final  num quantity;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;
/// Optional link to the product catalog (`foods`); null for ad-hoc items.
@override@JsonKey(name: 'food_id') final  String? foodId;
/// App-owned unit key (g/kg/ml/l/piece/package); null when unitless.
@override final  String? unit;
@override@JsonKey(name: 'category_id') final  String? categoryId;
@override@JsonKey(name: 'storage_location_id') final  String? storageLocationId;
/// Best-before date. Null means the item has no expiry and shows no status.
@override@JsonKey(name: 'best_before') final  DateTime? bestBefore;
/// The user who added the item; nulled out if their account is deleted.
@override@JsonKey(name: 'added_by') final  String? addedBy;
@override@JsonKey(name: 'deleted_at') final  DateTime? deletedAt;

/// Create a copy of InventoryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryItemCopyWith<_InventoryItem> get copyWith => __$InventoryItemCopyWithImpl<_InventoryItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.householdId, householdId) || other.householdId == householdId)&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.foodId, foodId) || other.foodId == foodId)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.storageLocationId, storageLocationId) || other.storageLocationId == storageLocationId)&&(identical(other.bestBefore, bestBefore) || other.bestBefore == bestBefore)&&(identical(other.addedBy, addedBy) || other.addedBy == addedBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,householdId,name,quantity,createdAt,updatedAt,foodId,unit,categoryId,storageLocationId,bestBefore,addedBy,deletedAt);

@override
String toString() {
  return 'InventoryItem(id: $id, householdId: $householdId, name: $name, quantity: $quantity, createdAt: $createdAt, updatedAt: $updatedAt, foodId: $foodId, unit: $unit, categoryId: $categoryId, storageLocationId: $storageLocationId, bestBefore: $bestBefore, addedBy: $addedBy, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$InventoryItemCopyWith<$Res> implements $InventoryItemCopyWith<$Res> {
  factory _$InventoryItemCopyWith(_InventoryItem value, $Res Function(_InventoryItem) _then) = __$InventoryItemCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'household_id') String householdId, String name, num quantity,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt,@JsonKey(name: 'food_id') String? foodId, String? unit,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'storage_location_id') String? storageLocationId,@JsonKey(name: 'best_before') DateTime? bestBefore,@JsonKey(name: 'added_by') String? addedBy,@JsonKey(name: 'deleted_at') DateTime? deletedAt
});




}
/// @nodoc
class __$InventoryItemCopyWithImpl<$Res>
    implements _$InventoryItemCopyWith<$Res> {
  __$InventoryItemCopyWithImpl(this._self, this._then);

  final _InventoryItem _self;
  final $Res Function(_InventoryItem) _then;

/// Create a copy of InventoryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? householdId = null,Object? name = null,Object? quantity = null,Object? createdAt = null,Object? updatedAt = null,Object? foodId = freezed,Object? unit = freezed,Object? categoryId = freezed,Object? storageLocationId = freezed,Object? bestBefore = freezed,Object? addedBy = freezed,Object? deletedAt = freezed,}) {
  return _then(_InventoryItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,householdId: null == householdId ? _self.householdId : householdId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as num,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,foodId: freezed == foodId ? _self.foodId : foodId // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,storageLocationId: freezed == storageLocationId ? _self.storageLocationId : storageLocationId // ignore: cast_nullable_to_non_nullable
as String?,bestBefore: freezed == bestBefore ? _self.bestBefore : bestBefore // ignore: cast_nullable_to_non_nullable
as DateTime?,addedBy: freezed == addedBy ? _self.addedBy : addedBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

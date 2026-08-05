// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shopping_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShoppingItem {

 String get id;@JsonKey(name: 'household_id') String get householdId; String get name;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;/// Free-form quantity text (e.g. "2 × 1 l"); null when unspecified. A
/// structured quantity/unit is deferred (see ADR-0011).
 String? get quantity;@JsonKey(name: 'category_id') String? get categoryId;/// Whether the item has already been bought (ticked off the list).
 bool get checked;/// The user who added the item; nulled out if their account is deleted.
@JsonKey(name: 'added_by') String? get addedBy;
/// Create a copy of ShoppingItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShoppingItemCopyWith<ShoppingItem> get copyWith => _$ShoppingItemCopyWithImpl<ShoppingItem>(this as ShoppingItem, _$identity);

  /// Serializes this ShoppingItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShoppingItem&&(identical(other.id, id) || other.id == id)&&(identical(other.householdId, householdId) || other.householdId == householdId)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.checked, checked) || other.checked == checked)&&(identical(other.addedBy, addedBy) || other.addedBy == addedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,householdId,name,createdAt,updatedAt,quantity,categoryId,checked,addedBy);

@override
String toString() {
  return 'ShoppingItem(id: $id, householdId: $householdId, name: $name, createdAt: $createdAt, updatedAt: $updatedAt, quantity: $quantity, categoryId: $categoryId, checked: $checked, addedBy: $addedBy)';
}


}

/// @nodoc
abstract mixin class $ShoppingItemCopyWith<$Res>  {
  factory $ShoppingItemCopyWith(ShoppingItem value, $Res Function(ShoppingItem) _then) = _$ShoppingItemCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'household_id') String householdId, String name,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt, String? quantity,@JsonKey(name: 'category_id') String? categoryId, bool checked,@JsonKey(name: 'added_by') String? addedBy
});




}
/// @nodoc
class _$ShoppingItemCopyWithImpl<$Res>
    implements $ShoppingItemCopyWith<$Res> {
  _$ShoppingItemCopyWithImpl(this._self, this._then);

  final ShoppingItem _self;
  final $Res Function(ShoppingItem) _then;

/// Create a copy of ShoppingItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? householdId = null,Object? name = null,Object? createdAt = null,Object? updatedAt = null,Object? quantity = freezed,Object? categoryId = freezed,Object? checked = null,Object? addedBy = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,householdId: null == householdId ? _self.householdId : householdId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,checked: null == checked ? _self.checked : checked // ignore: cast_nullable_to_non_nullable
as bool,addedBy: freezed == addedBy ? _self.addedBy : addedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ShoppingItem].
extension ShoppingItemPatterns on ShoppingItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShoppingItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShoppingItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShoppingItem value)  $default,){
final _that = this;
switch (_that) {
case _ShoppingItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShoppingItem value)?  $default,){
final _that = this;
switch (_that) {
case _ShoppingItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'household_id')  String householdId,  String name, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt,  String? quantity, @JsonKey(name: 'category_id')  String? categoryId,  bool checked, @JsonKey(name: 'added_by')  String? addedBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShoppingItem() when $default != null:
return $default(_that.id,_that.householdId,_that.name,_that.createdAt,_that.updatedAt,_that.quantity,_that.categoryId,_that.checked,_that.addedBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'household_id')  String householdId,  String name, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt,  String? quantity, @JsonKey(name: 'category_id')  String? categoryId,  bool checked, @JsonKey(name: 'added_by')  String? addedBy)  $default,) {final _that = this;
switch (_that) {
case _ShoppingItem():
return $default(_that.id,_that.householdId,_that.name,_that.createdAt,_that.updatedAt,_that.quantity,_that.categoryId,_that.checked,_that.addedBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'household_id')  String householdId,  String name, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt,  String? quantity, @JsonKey(name: 'category_id')  String? categoryId,  bool checked, @JsonKey(name: 'added_by')  String? addedBy)?  $default,) {final _that = this;
switch (_that) {
case _ShoppingItem() when $default != null:
return $default(_that.id,_that.householdId,_that.name,_that.createdAt,_that.updatedAt,_that.quantity,_that.categoryId,_that.checked,_that.addedBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShoppingItem implements ShoppingItem {
  const _ShoppingItem({required this.id, @JsonKey(name: 'household_id') required this.householdId, required this.name, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, this.quantity, @JsonKey(name: 'category_id') this.categoryId, this.checked = false, @JsonKey(name: 'added_by') this.addedBy});
  factory _ShoppingItem.fromJson(Map<String, dynamic> json) => _$ShoppingItemFromJson(json);

@override final  String id;
@override@JsonKey(name: 'household_id') final  String householdId;
@override final  String name;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;
/// Free-form quantity text (e.g. "2 × 1 l"); null when unspecified. A
/// structured quantity/unit is deferred (see ADR-0011).
@override final  String? quantity;
@override@JsonKey(name: 'category_id') final  String? categoryId;
/// Whether the item has already been bought (ticked off the list).
@override@JsonKey() final  bool checked;
/// The user who added the item; nulled out if their account is deleted.
@override@JsonKey(name: 'added_by') final  String? addedBy;

/// Create a copy of ShoppingItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShoppingItemCopyWith<_ShoppingItem> get copyWith => __$ShoppingItemCopyWithImpl<_ShoppingItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShoppingItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShoppingItem&&(identical(other.id, id) || other.id == id)&&(identical(other.householdId, householdId) || other.householdId == householdId)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.checked, checked) || other.checked == checked)&&(identical(other.addedBy, addedBy) || other.addedBy == addedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,householdId,name,createdAt,updatedAt,quantity,categoryId,checked,addedBy);

@override
String toString() {
  return 'ShoppingItem(id: $id, householdId: $householdId, name: $name, createdAt: $createdAt, updatedAt: $updatedAt, quantity: $quantity, categoryId: $categoryId, checked: $checked, addedBy: $addedBy)';
}


}

/// @nodoc
abstract mixin class _$ShoppingItemCopyWith<$Res> implements $ShoppingItemCopyWith<$Res> {
  factory _$ShoppingItemCopyWith(_ShoppingItem value, $Res Function(_ShoppingItem) _then) = __$ShoppingItemCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'household_id') String householdId, String name,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt, String? quantity,@JsonKey(name: 'category_id') String? categoryId, bool checked,@JsonKey(name: 'added_by') String? addedBy
});




}
/// @nodoc
class __$ShoppingItemCopyWithImpl<$Res>
    implements _$ShoppingItemCopyWith<$Res> {
  __$ShoppingItemCopyWithImpl(this._self, this._then);

  final _ShoppingItem _self;
  final $Res Function(_ShoppingItem) _then;

/// Create a copy of ShoppingItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? householdId = null,Object? name = null,Object? createdAt = null,Object? updatedAt = null,Object? quantity = freezed,Object? categoryId = freezed,Object? checked = null,Object? addedBy = freezed,}) {
  return _then(_ShoppingItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,householdId: null == householdId ? _self.householdId : householdId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,checked: null == checked ? _self.checked : checked // ignore: cast_nullable_to_non_nullable
as bool,addedBy: freezed == addedBy ? _self.addedBy : addedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

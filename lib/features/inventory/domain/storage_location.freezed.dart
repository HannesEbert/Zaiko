// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'storage_location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StorageLocation {

 String get id;@JsonKey(name: 'household_id') String get householdId; String get name;@JsonKey(name: 'sort_order') int get sortOrder; String? get icon; String? get color;
/// Create a copy of StorageLocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageLocationCopyWith<StorageLocation> get copyWith => _$StorageLocationCopyWithImpl<StorageLocation>(this as StorageLocation, _$identity);

  /// Serializes this StorageLocation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageLocation&&(identical(other.id, id) || other.id == id)&&(identical(other.householdId, householdId) || other.householdId == householdId)&&(identical(other.name, name) || other.name == name)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,householdId,name,sortOrder,icon,color);

@override
String toString() {
  return 'StorageLocation(id: $id, householdId: $householdId, name: $name, sortOrder: $sortOrder, icon: $icon, color: $color)';
}


}

/// @nodoc
abstract mixin class $StorageLocationCopyWith<$Res>  {
  factory $StorageLocationCopyWith(StorageLocation value, $Res Function(StorageLocation) _then) = _$StorageLocationCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'household_id') String householdId, String name,@JsonKey(name: 'sort_order') int sortOrder, String? icon, String? color
});




}
/// @nodoc
class _$StorageLocationCopyWithImpl<$Res>
    implements $StorageLocationCopyWith<$Res> {
  _$StorageLocationCopyWithImpl(this._self, this._then);

  final StorageLocation _self;
  final $Res Function(StorageLocation) _then;

/// Create a copy of StorageLocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? householdId = null,Object? name = null,Object? sortOrder = null,Object? icon = freezed,Object? color = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,householdId: null == householdId ? _self.householdId : householdId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageLocation].
extension StorageLocationPatterns on StorageLocation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageLocation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageLocation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageLocation value)  $default,){
final _that = this;
switch (_that) {
case _StorageLocation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageLocation value)?  $default,){
final _that = this;
switch (_that) {
case _StorageLocation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'household_id')  String householdId,  String name, @JsonKey(name: 'sort_order')  int sortOrder,  String? icon,  String? color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageLocation() when $default != null:
return $default(_that.id,_that.householdId,_that.name,_that.sortOrder,_that.icon,_that.color);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'household_id')  String householdId,  String name, @JsonKey(name: 'sort_order')  int sortOrder,  String? icon,  String? color)  $default,) {final _that = this;
switch (_that) {
case _StorageLocation():
return $default(_that.id,_that.householdId,_that.name,_that.sortOrder,_that.icon,_that.color);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'household_id')  String householdId,  String name, @JsonKey(name: 'sort_order')  int sortOrder,  String? icon,  String? color)?  $default,) {final _that = this;
switch (_that) {
case _StorageLocation() when $default != null:
return $default(_that.id,_that.householdId,_that.name,_that.sortOrder,_that.icon,_that.color);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageLocation implements StorageLocation {
  const _StorageLocation({required this.id, @JsonKey(name: 'household_id') required this.householdId, required this.name, @JsonKey(name: 'sort_order') this.sortOrder = 0, this.icon, this.color});
  factory _StorageLocation.fromJson(Map<String, dynamic> json) => _$StorageLocationFromJson(json);

@override final  String id;
@override@JsonKey(name: 'household_id') final  String householdId;
@override final  String name;
@override@JsonKey(name: 'sort_order') final  int sortOrder;
@override final  String? icon;
@override final  String? color;

/// Create a copy of StorageLocation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageLocationCopyWith<_StorageLocation> get copyWith => __$StorageLocationCopyWithImpl<_StorageLocation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageLocationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageLocation&&(identical(other.id, id) || other.id == id)&&(identical(other.householdId, householdId) || other.householdId == householdId)&&(identical(other.name, name) || other.name == name)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,householdId,name,sortOrder,icon,color);

@override
String toString() {
  return 'StorageLocation(id: $id, householdId: $householdId, name: $name, sortOrder: $sortOrder, icon: $icon, color: $color)';
}


}

/// @nodoc
abstract mixin class _$StorageLocationCopyWith<$Res> implements $StorageLocationCopyWith<$Res> {
  factory _$StorageLocationCopyWith(_StorageLocation value, $Res Function(_StorageLocation) _then) = __$StorageLocationCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'household_id') String householdId, String name,@JsonKey(name: 'sort_order') int sortOrder, String? icon, String? color
});




}
/// @nodoc
class __$StorageLocationCopyWithImpl<$Res>
    implements _$StorageLocationCopyWith<$Res> {
  __$StorageLocationCopyWithImpl(this._self, this._then);

  final _StorageLocation _self;
  final $Res Function(_StorageLocation) _then;

/// Create a copy of StorageLocation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? householdId = null,Object? name = null,Object? sortOrder = null,Object? icon = freezed,Object? color = freezed,}) {
  return _then(_StorageLocation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,householdId: null == householdId ? _self.householdId : householdId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

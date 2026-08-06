// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Recipe {

 String get id;@JsonKey(name: 'household_id') String get householdId; String get title;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;/// Total time in minutes; null when unspecified. Drives the "under 30 min"
/// filter.
@JsonKey(name: 'total_minutes') int? get totalMinutes; int? get servings;@JsonKey(name: 'image_url') String? get imageUrl;/// Ordered step-by-step instructions; empty until the author adds any.
 List<RecipeStep> get steps;/// The recipe's ingredients, ordered by their `sort_order`.
@JsonKey(name: 'recipe_ingredients') List<RecipeIngredient> get ingredients;/// The user who created the recipe; nulled out if their account is deleted.
@JsonKey(name: 'created_by') String? get createdBy;@JsonKey(name: 'deleted_at') DateTime? get deletedAt;
/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipeCopyWith<Recipe> get copyWith => _$RecipeCopyWithImpl<Recipe>(this as Recipe, _$identity);

  /// Serializes this Recipe to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Recipe&&(identical(other.id, id) || other.id == id)&&(identical(other.householdId, householdId) || other.householdId == householdId)&&(identical(other.title, title) || other.title == title)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.totalMinutes, totalMinutes) || other.totalMinutes == totalMinutes)&&(identical(other.servings, servings) || other.servings == servings)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other.steps, steps)&&const DeepCollectionEquality().equals(other.ingredients, ingredients)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,householdId,title,createdAt,updatedAt,totalMinutes,servings,imageUrl,const DeepCollectionEquality().hash(steps),const DeepCollectionEquality().hash(ingredients),createdBy,deletedAt);

@override
String toString() {
  return 'Recipe(id: $id, householdId: $householdId, title: $title, createdAt: $createdAt, updatedAt: $updatedAt, totalMinutes: $totalMinutes, servings: $servings, imageUrl: $imageUrl, steps: $steps, ingredients: $ingredients, createdBy: $createdBy, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class $RecipeCopyWith<$Res>  {
  factory $RecipeCopyWith(Recipe value, $Res Function(Recipe) _then) = _$RecipeCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'household_id') String householdId, String title,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt,@JsonKey(name: 'total_minutes') int? totalMinutes, int? servings,@JsonKey(name: 'image_url') String? imageUrl, List<RecipeStep> steps,@JsonKey(name: 'recipe_ingredients') List<RecipeIngredient> ingredients,@JsonKey(name: 'created_by') String? createdBy,@JsonKey(name: 'deleted_at') DateTime? deletedAt
});




}
/// @nodoc
class _$RecipeCopyWithImpl<$Res>
    implements $RecipeCopyWith<$Res> {
  _$RecipeCopyWithImpl(this._self, this._then);

  final Recipe _self;
  final $Res Function(Recipe) _then;

/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? householdId = null,Object? title = null,Object? createdAt = null,Object? updatedAt = null,Object? totalMinutes = freezed,Object? servings = freezed,Object? imageUrl = freezed,Object? steps = null,Object? ingredients = null,Object? createdBy = freezed,Object? deletedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,householdId: null == householdId ? _self.householdId : householdId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,totalMinutes: freezed == totalMinutes ? _self.totalMinutes : totalMinutes // ignore: cast_nullable_to_non_nullable
as int?,servings: freezed == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as int?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<RecipeStep>,ingredients: null == ingredients ? _self.ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<RecipeIngredient>,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Recipe].
extension RecipePatterns on Recipe {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Recipe value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Recipe() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Recipe value)  $default,){
final _that = this;
switch (_that) {
case _Recipe():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Recipe value)?  $default,){
final _that = this;
switch (_that) {
case _Recipe() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'household_id')  String householdId,  String title, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(name: 'total_minutes')  int? totalMinutes,  int? servings, @JsonKey(name: 'image_url')  String? imageUrl,  List<RecipeStep> steps, @JsonKey(name: 'recipe_ingredients')  List<RecipeIngredient> ingredients, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'deleted_at')  DateTime? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Recipe() when $default != null:
return $default(_that.id,_that.householdId,_that.title,_that.createdAt,_that.updatedAt,_that.totalMinutes,_that.servings,_that.imageUrl,_that.steps,_that.ingredients,_that.createdBy,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'household_id')  String householdId,  String title, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(name: 'total_minutes')  int? totalMinutes,  int? servings, @JsonKey(name: 'image_url')  String? imageUrl,  List<RecipeStep> steps, @JsonKey(name: 'recipe_ingredients')  List<RecipeIngredient> ingredients, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'deleted_at')  DateTime? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _Recipe():
return $default(_that.id,_that.householdId,_that.title,_that.createdAt,_that.updatedAt,_that.totalMinutes,_that.servings,_that.imageUrl,_that.steps,_that.ingredients,_that.createdBy,_that.deletedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'household_id')  String householdId,  String title, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(name: 'total_minutes')  int? totalMinutes,  int? servings, @JsonKey(name: 'image_url')  String? imageUrl,  List<RecipeStep> steps, @JsonKey(name: 'recipe_ingredients')  List<RecipeIngredient> ingredients, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'deleted_at')  DateTime? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _Recipe() when $default != null:
return $default(_that.id,_that.householdId,_that.title,_that.createdAt,_that.updatedAt,_that.totalMinutes,_that.servings,_that.imageUrl,_that.steps,_that.ingredients,_that.createdBy,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Recipe implements Recipe {
  const _Recipe({required this.id, @JsonKey(name: 'household_id') required this.householdId, required this.title, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, @JsonKey(name: 'total_minutes') this.totalMinutes, this.servings, @JsonKey(name: 'image_url') this.imageUrl, final  List<RecipeStep> steps = const <RecipeStep>[], @JsonKey(name: 'recipe_ingredients') final  List<RecipeIngredient> ingredients = const <RecipeIngredient>[], @JsonKey(name: 'created_by') this.createdBy, @JsonKey(name: 'deleted_at') this.deletedAt}): _steps = steps,_ingredients = ingredients;
  factory _Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

@override final  String id;
@override@JsonKey(name: 'household_id') final  String householdId;
@override final  String title;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;
/// Total time in minutes; null when unspecified. Drives the "under 30 min"
/// filter.
@override@JsonKey(name: 'total_minutes') final  int? totalMinutes;
@override final  int? servings;
@override@JsonKey(name: 'image_url') final  String? imageUrl;
/// Ordered step-by-step instructions; empty until the author adds any.
 final  List<RecipeStep> _steps;
/// Ordered step-by-step instructions; empty until the author adds any.
@override@JsonKey() List<RecipeStep> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}

/// The recipe's ingredients, ordered by their `sort_order`.
 final  List<RecipeIngredient> _ingredients;
/// The recipe's ingredients, ordered by their `sort_order`.
@override@JsonKey(name: 'recipe_ingredients') List<RecipeIngredient> get ingredients {
  if (_ingredients is EqualUnmodifiableListView) return _ingredients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ingredients);
}

/// The user who created the recipe; nulled out if their account is deleted.
@override@JsonKey(name: 'created_by') final  String? createdBy;
@override@JsonKey(name: 'deleted_at') final  DateTime? deletedAt;

/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipeCopyWith<_Recipe> get copyWith => __$RecipeCopyWithImpl<_Recipe>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecipeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Recipe&&(identical(other.id, id) || other.id == id)&&(identical(other.householdId, householdId) || other.householdId == householdId)&&(identical(other.title, title) || other.title == title)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.totalMinutes, totalMinutes) || other.totalMinutes == totalMinutes)&&(identical(other.servings, servings) || other.servings == servings)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other._steps, _steps)&&const DeepCollectionEquality().equals(other._ingredients, _ingredients)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,householdId,title,createdAt,updatedAt,totalMinutes,servings,imageUrl,const DeepCollectionEquality().hash(_steps),const DeepCollectionEquality().hash(_ingredients),createdBy,deletedAt);

@override
String toString() {
  return 'Recipe(id: $id, householdId: $householdId, title: $title, createdAt: $createdAt, updatedAt: $updatedAt, totalMinutes: $totalMinutes, servings: $servings, imageUrl: $imageUrl, steps: $steps, ingredients: $ingredients, createdBy: $createdBy, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$RecipeCopyWith<$Res> implements $RecipeCopyWith<$Res> {
  factory _$RecipeCopyWith(_Recipe value, $Res Function(_Recipe) _then) = __$RecipeCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'household_id') String householdId, String title,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt,@JsonKey(name: 'total_minutes') int? totalMinutes, int? servings,@JsonKey(name: 'image_url') String? imageUrl, List<RecipeStep> steps,@JsonKey(name: 'recipe_ingredients') List<RecipeIngredient> ingredients,@JsonKey(name: 'created_by') String? createdBy,@JsonKey(name: 'deleted_at') DateTime? deletedAt
});




}
/// @nodoc
class __$RecipeCopyWithImpl<$Res>
    implements _$RecipeCopyWith<$Res> {
  __$RecipeCopyWithImpl(this._self, this._then);

  final _Recipe _self;
  final $Res Function(_Recipe) _then;

/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? householdId = null,Object? title = null,Object? createdAt = null,Object? updatedAt = null,Object? totalMinutes = freezed,Object? servings = freezed,Object? imageUrl = freezed,Object? steps = null,Object? ingredients = null,Object? createdBy = freezed,Object? deletedAt = freezed,}) {
  return _then(_Recipe(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,householdId: null == householdId ? _self.householdId : householdId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,totalMinutes: freezed == totalMinutes ? _self.totalMinutes : totalMinutes // ignore: cast_nullable_to_non_nullable
as int?,servings: freezed == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as int?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<RecipeStep>,ingredients: null == ingredients ? _self._ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<RecipeIngredient>,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

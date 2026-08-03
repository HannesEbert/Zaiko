import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/food.dart';

part 'food_providers.g.dart';

/// Trivial provider that confirms the `riverpod_generator` pipeline works.
///
/// Returns an empty sample list for now; it is replaced by a real,
/// repository-backed provider once the data layer lands.
@riverpod
List<Food> sampleFoods(Ref ref) => const <Food>[];

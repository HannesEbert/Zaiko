import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/features/food/domain/food_failure.dart';
import 'package:zaiko/features/food/presentation/food_error_message.dart';
import 'package:zaiko/l10n/app_localizations_en.dart';

void main() {
  final l10n = AppLocalizationsEn();

  test('maps each failure reason to its localized message', () {
    expect(
      foodErrorMessage(l10n, const FoodFailure(FoodFailureReason.network, '')),
      l10n.foodErrorNetwork,
    );
    expect(
      foodErrorMessage(
        l10n,
        const FoodFailure(FoodFailureReason.rateLimited, ''),
      ),
      l10n.foodErrorRateLimited,
    );
    expect(
      foodErrorMessage(l10n, const FoodFailure(FoodFailureReason.unknown, '')),
      l10n.foodErrorGeneric,
    );
  });

  test('falls back to the generic message for a non-FoodFailure', () {
    expect(foodErrorMessage(l10n, Exception('boom')), l10n.foodErrorGeneric);
    expect(foodErrorMessage(l10n, null), l10n.foodErrorGeneric);
  });
}

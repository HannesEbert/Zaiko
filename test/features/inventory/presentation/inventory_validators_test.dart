import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/features/inventory/presentation/inventory_validators.dart';
import 'package:zaiko/l10n/app_localizations_en.dart';

void main() {
  final l10n = AppLocalizationsEn();

  group('name', () {
    test('rejects an empty or whitespace value', () {
      expect(InventoryValidators.name(l10n, ''), l10n.itemFormNameEmpty);
      expect(InventoryValidators.name(l10n, '   '), l10n.itemFormNameEmpty);
      expect(InventoryValidators.name(l10n, null), l10n.itemFormNameEmpty);
    });

    test('accepts a non-empty value', () {
      expect(InventoryValidators.name(l10n, 'Milch'), isNull);
    });
  });

  group('quantity', () {
    test('rejects missing, zero, negative or unparseable values', () {
      expect(
        InventoryValidators.quantity(l10n, ''),
        l10n.itemFormQuantityInvalid,
      );
      expect(
        InventoryValidators.quantity(l10n, '0'),
        l10n.itemFormQuantityInvalid,
      );
      expect(
        InventoryValidators.quantity(l10n, '-2'),
        l10n.itemFormQuantityInvalid,
      );
      expect(
        InventoryValidators.quantity(l10n, 'abc'),
        l10n.itemFormQuantityInvalid,
      );
    });

    test('accepts a positive value', () {
      expect(InventoryValidators.quantity(l10n, '2'), isNull);
    });

    test('accepts a comma decimal separator', () {
      expect(InventoryValidators.quantity(l10n, '1,5'), isNull);
      expect(InventoryValidators.parseQuantity('1,5'), 1.5);
    });
  });
}

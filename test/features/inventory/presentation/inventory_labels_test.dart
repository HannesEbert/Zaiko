import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/features/inventory/presentation/inventory_labels.dart';
import 'package:zaiko/l10n/app_localizations_en.dart';

void main() {
  final l10n = AppLocalizationsEn();
  final now = DateTime(2026, 8, 3, 9);

  // DateFormat needs the binding initialized for the widget-less test.
  setUpAll(WidgetsFlutterBinding.ensureInitialized);

  group('formatQuantity', () {
    test('shows a single sized item without a count prefix', () {
      expect(formatQuantity(count: 1, quantity: 1, unit: 'l'), '1 l');
      expect(formatQuantity(count: 1, quantity: 250, unit: 'g'), '250 g');
    });

    test('prefixes the count for a multipack', () {
      expect(formatQuantity(count: 6, quantity: 1.5, unit: 'l'), '6 × 1.5 l');
      expect(formatQuantity(count: 5, quantity: 500, unit: 'ml'), '5 × 500 ml');
    });

    test('shows just the count when there is no measurable size', () {
      expect(formatQuantity(count: 3, quantity: 1, unit: null), '3');
      expect(formatQuantity(count: 1, quantity: 1, unit: null), '1');
    });
  });

  group('expiryShortLabel', () {
    test('picks the right phrasing per day delta', () {
      expect(expiryShortLabel(l10n, DateTime(2026, 8, 1), now: now), 'Expired');
      expect(expiryShortLabel(l10n, DateTime(2026, 8, 3), now: now), 'Today');
      expect(
        expiryShortLabel(l10n, DateTime(2026, 8, 4), now: now),
        'Tomorrow',
      );
      expect(
        expiryShortLabel(l10n, DateTime(2026, 8, 6), now: now),
        'In 3 days',
      );
    });

    test('is null without a date', () {
      expect(expiryShortLabel(l10n, null, now: now), isNull);
    });
  });

  group('addedRelativeLabel', () {
    test('uses relative words for recent days', () {
      expect(addedRelativeLabel(l10n, DateTime(2026, 8, 3), now: now), 'Today');
      expect(
        addedRelativeLabel(l10n, DateTime(2026, 8, 2), now: now),
        'Yesterday',
      );
      expect(
        addedRelativeLabel(l10n, DateTime(2026, 7, 31), now: now),
        '3 days ago',
      );
    });

    test('falls back to a short date for older items', () {
      expect(
        addedRelativeLabel(l10n, DateTime(2026, 7, 1), now: now),
        '01.07.26',
      );
    });
  });

  test('formatBestBefore renders a full day.month.year date', () {
    expect(formatBestBefore(DateTime(2026, 7, 17)), '17.07.2026');
  });
}

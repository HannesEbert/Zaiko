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
    test('drops the trailing .0 on whole numbers', () {
      expect(formatQuantity(l10n, 1, 'l'), '1 l');
      expect(formatQuantity(l10n, 6, 'piece'), '6 pcs');
    });

    test('localizes piece and package but passes symbols through', () {
      expect(formatQuantity(l10n, 2, 'package'), '2 pack');
      expect(formatQuantity(l10n, 250, 'g'), '250 g');
    });

    test('omits the unit when there is none', () {
      expect(formatQuantity(l10n, 3, null), '3');
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

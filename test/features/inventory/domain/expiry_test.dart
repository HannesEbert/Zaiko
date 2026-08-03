import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/features/inventory/domain/expiry.dart';

void main() {
  // A fixed reference "now" so the day maths never depends on the wall clock.
  final now = DateTime(2026, 8, 3, 14, 30);

  group('expiryStatus', () {
    test('is none when there is no best-before date', () {
      expect(expiryStatus(null, now: now), ExpiryStatus.none);
    });

    test('is expired when the date is in the past', () {
      expect(
        expiryStatus(DateTime(2026, 8, 2), now: now),
        ExpiryStatus.expired,
      );
    });

    test('is soon when the date is today (not yet expired)', () {
      expect(expiryStatus(DateTime(2026, 8, 3), now: now), ExpiryStatus.soon);
    });

    test('is soon on the last day of the warning window', () {
      // expiryWarningDays == 3, so three days out is still "soon".
      expect(expiryStatus(DateTime(2026, 8, 6), now: now), ExpiryStatus.soon);
    });

    test('is fresh just beyond the warning window', () {
      expect(expiryStatus(DateTime(2026, 8, 7), now: now), ExpiryStatus.fresh);
    });

    test('ignores the time of day when comparing', () {
      // Best-before at 00:01 today, "now" at 14:30 today → still soon, not
      // expired.
      expect(
        expiryStatus(DateTime(2026, 8, 3, 0, 1), now: now),
        ExpiryStatus.soon,
      );
    });
  });

  group('boolean helpers', () {
    test('isExpired / isExpiringSoon agree with expiryStatus', () {
      expect(isExpired(DateTime(2026, 8, 1), now: now), isTrue);
      expect(isExpiringSoon(DateTime(2026, 8, 1), now: now), isFalse);

      expect(isExpiringSoon(DateTime(2026, 8, 4), now: now), isTrue);
      expect(isExpired(DateTime(2026, 8, 4), now: now), isFalse);

      expect(isExpired(null, now: now), isFalse);
      expect(isExpiringSoon(null, now: now), isFalse);
    });
  });

  group('daysUntilExpiry', () {
    test('is null without a date', () {
      expect(daysUntilExpiry(null, now: now), isNull);
    });

    test('counts whole calendar days, negative when overdue', () {
      expect(daysUntilExpiry(DateTime(2026, 8, 6), now: now), 3);
      expect(daysUntilExpiry(DateTime(2026, 8, 3), now: now), 0);
      expect(daysUntilExpiry(DateTime(2026, 8, 1), now: now), -2);
    });
  });
}

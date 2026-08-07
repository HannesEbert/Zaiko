import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/features/profile/domain/reminder_time.dart';

void main() {
  group('ReminderTime.parse', () {
    test('parses a zero-padded HH:mm string', () {
      expect(
        ReminderTime.parse('08:05'),
        const ReminderTime(hour: 8, minute: 5),
      );
      expect(
        ReminderTime.parse('20:00'),
        const ReminderTime(hour: 20, minute: 0),
      );
    });

    test('falls back to the default on malformed input', () {
      for (final bad in ['', '20', '20:', 'ab:cd', '24:00', '10:60', '-1:00']) {
        expect(
          ReminderTime.parse(bad),
          ReminderTime.defaultTime,
          reason: 'input "$bad" should fall back',
        );
      }
    });
  });

  test('format is the inverse of parse', () {
    for (final value in ['00:00', '07:09', '13:30', '23:59']) {
      expect(ReminderTime.parse(value).format(), value);
    }
  });

  test('value equality by hour and minute', () {
    expect(
      const ReminderTime(hour: 9, minute: 15),
      const ReminderTime(hour: 9, minute: 15),
    );
    expect(
      const ReminderTime(hour: 9, minute: 15),
      isNot(const ReminderTime(hour: 9, minute: 16)),
    );
  });
}

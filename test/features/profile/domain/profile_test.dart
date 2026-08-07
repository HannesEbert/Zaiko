import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/features/profile/domain/profile.dart';

void main() {
  group('Profile.fromJson', () {
    test('reads the reminder settings from their snake_case columns', () {
      final profile = Profile.fromJson({
        'id': 'u1',
        'display_name': 'Dev',
        'created_at': '2026-01-01T00:00:00.000Z',
        'reminders_enabled': true,
        'reminder_lead_days': 5,
        'reminder_time': '08:30',
      });

      expect(profile.remindersEnabled, isTrue);
      expect(profile.reminderLeadDays, 5);
      expect(profile.reminderTime, '08:30');
    });

    test('defaults the reminder settings when the columns are absent', () {
      final profile = Profile.fromJson({
        'id': 'u1',
        'display_name': 'Dev',
        'created_at': '2026-01-01T00:00:00.000Z',
      });

      expect(profile.remindersEnabled, isFalse);
      expect(profile.reminderLeadDays, 3);
      expect(profile.reminderTime, '20:00');
    });
  });

  test('toJson round-trips the reminder settings', () {
    final profile = Profile(
      id: 'u1',
      displayName: 'Dev',
      createdAt: DateTime.utc(2026),
      remindersEnabled: true,
      reminderLeadDays: 7,
      reminderTime: '09:15',
    );

    final json = profile.toJson();
    expect(json['reminders_enabled'], true);
    expect(json['reminder_lead_days'], 7);
    expect(json['reminder_time'], '09:15');

    expect(Profile.fromJson(json), profile);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/core/config/app_config.dart';

void main() {
  group('AppConfig', () {
    test('required values are empty without --dart-define injection', () {
      // A plain `flutter test` run injects no environment values.
      expect(AppConfig.supabaseUrl, isEmpty);
      expect(AppConfig.supabaseAnonKey, isEmpty);
      expect(AppConfig.offUserAgent, isEmpty);
    });

    test('debugAssertValid throws a clear error when config is missing', () {
      expect(AppConfig.debugAssertValid, throwsA(isA<AssertionError>()));
    });

    group('validate', () {
      const validUrl = 'https://abc123.supabase.co';
      const validKey = 'ey.some.jwt';
      const validAgent = 'Zaiko/0.1 (me@example.com)';

      test('returns null when all values are set and real', () {
        expect(
          AppConfig.validate(
            url: validUrl,
            anonKey: validKey,
            userAgent: validAgent,
          ),
          isNull,
        );
      });

      test('flags empty values', () {
        expect(
          AppConfig.validate(url: '', anonKey: validKey, userAgent: validAgent),
          contains('SUPABASE_URL'),
        );
        expect(
          AppConfig.validate(url: validUrl, anonKey: '', userAgent: validAgent),
          contains('SUPABASE_ANON_KEY'),
        );
        expect(
          AppConfig.validate(url: validUrl, anonKey: validKey, userAgent: ''),
          contains('OFF_USER_AGENT'),
        );
      });

      test('flags leftover template placeholders', () {
        expect(
          AppConfig.validate(
            url: 'https://your-project-ref.supabase.co',
            anonKey: validKey,
            userAgent: validAgent,
          ),
          contains('placeholder'),
        );
        expect(
          AppConfig.validate(
            url: validUrl,
            anonKey: 'your-supabase-anon-key',
            userAgent: validAgent,
          ),
          contains('placeholder'),
        );
        expect(
          AppConfig.validate(
            url: validUrl,
            anonKey: validKey,
            userAgent: 'Zaiko/0.1 (your-contact@example.com)',
          ),
          contains('placeholder'),
        );
      });
    });
  });
}

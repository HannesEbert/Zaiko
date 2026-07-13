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
  });
}

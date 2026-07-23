import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/features/auth/presentation/auth_validators.dart';
import 'package:zaiko/l10n/app_localizations_en.dart';

void main() {
  final l10n = AppLocalizationsEn();

  group('email', () {
    test('rejects an empty value', () {
      expect(AuthValidators.email(l10n, ''), l10n.loginEmailEmpty);
      expect(AuthValidators.email(l10n, '   '), l10n.loginEmailEmpty);
      expect(AuthValidators.email(l10n, null), l10n.loginEmailEmpty);
    });

    test('rejects a value without @ and a dot', () {
      expect(
        AuthValidators.email(l10n, 'not-an-email'),
        l10n.loginEmailInvalid,
      );
    });

    test('accepts a plausible address', () {
      expect(AuthValidators.email(l10n, 'user@example.com'), isNull);
    });
  });

  group('password', () {
    test('rejects an empty value', () {
      expect(AuthValidators.password(l10n, ''), l10n.loginPasswordEmpty);
    });

    test('rejects a value shorter than the minimum length', () {
      final short = 'a' * (AuthValidators.minPasswordLength - 1);
      expect(
        AuthValidators.password(l10n, short),
        l10n.loginPasswordTooShort(AuthValidators.minPasswordLength),
      );
    });

    test('accepts a value at the minimum length', () {
      final ok = 'a' * AuthValidators.minPasswordLength;
      expect(AuthValidators.password(l10n, ok), isNull);
    });
  });

  group('confirmPassword', () {
    test('rejects an empty confirmation', () {
      expect(
        AuthValidators.confirmPassword(l10n, '', 'secret123'),
        l10n.loginPasswordEmpty,
      );
    });

    test('rejects a mismatching confirmation', () {
      expect(
        AuthValidators.confirmPassword(l10n, 'secret124', 'secret123'),
        l10n.registerPasswordMismatch,
      );
    });

    test('accepts a matching confirmation', () {
      expect(
        AuthValidators.confirmPassword(l10n, 'secret123', 'secret123'),
        isNull,
      );
    });
  });
}

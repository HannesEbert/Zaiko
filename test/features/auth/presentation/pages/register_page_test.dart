import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/core/theme/app_theme.dart';
import 'package:zaiko/features/auth/application/auth_providers.dart';
import 'package:zaiko/features/auth/presentation/pages/register_page.dart';
import 'package:zaiko/l10n/app_localizations.dart';

import '../../fake_auth_repository.dart';

void main() {
  Future<void> pumpRegisterPage(
    WidgetTester tester,
    FakeAuthRepository repository,
  ) {
    return tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const RegisterPage(),
        ),
      ),
    );
  }

  // Fields are, in order: email, password, confirm password.
  Future<void> fillForm(
    WidgetTester tester, {
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), email);
    await tester.enterText(fields.at(1), password);
    await tester.enterText(fields.at(2), confirmPassword);
  }

  Future<void> acceptPrivacy(WidgetTester tester) async {
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
  }

  testWidgets('create-account button is disabled until privacy is accepted', (
    tester,
  ) async {
    final repository = FakeAuthRepository();
    addTearDown(repository.dispose);
    await pumpRegisterPage(tester, repository);

    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Create account'),
    );
    expect(button.onPressed, isNull);

    await acceptPrivacy(tester);

    final enabledButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Create account'),
    );
    expect(enabledButton.onPressed, isNotNull);
  });

  testWidgets('shows validation errors when submitting an empty form', (
    tester,
  ) async {
    final repository = FakeAuthRepository();
    addTearDown(repository.dispose);
    await pumpRegisterPage(tester, repository);

    await acceptPrivacy(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pump();

    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsWidgets);
    expect(repository.signUpCalls, 0);
  });

  testWidgets('rejects mismatching passwords without calling sign-up', (
    tester,
  ) async {
    final repository = FakeAuthRepository();
    addTearDown(repository.dispose);
    await pumpRegisterPage(tester, repository);

    await fillForm(
      tester,
      email: 'user@example.com',
      password: 'secret123',
      confirmPassword: 'secret124',
    );
    await acceptPrivacy(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pump();

    expect(find.text("The passwords don't match"), findsOneWidget);
    expect(repository.signUpCalls, 0);
  });

  testWidgets('signs up through the repository with valid input', (
    tester,
  ) async {
    final repository = FakeAuthRepository();
    addTearDown(repository.dispose);
    await pumpRegisterPage(tester, repository);

    await fillForm(
      tester,
      email: 'new@example.com',
      password: 'secret123',
      confirmPassword: 'secret123',
    );
    await acceptPrivacy(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pump();

    expect(repository.signUpCalls, 1);
  });
}

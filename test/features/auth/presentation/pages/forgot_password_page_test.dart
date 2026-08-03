import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/core/theme/app_theme.dart';
import 'package:zaiko/features/auth/application/auth_providers.dart';
import 'package:zaiko/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:zaiko/l10n/app_localizations.dart';

import '../../fake_auth_repository.dart';

void main() {
  Future<void> pumpForgotPasswordPage(
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
          home: const ForgotPasswordPage(),
        ),
      ),
    );
  }

  testWidgets('shows a validation error when submitting an empty form', (
    tester,
  ) async {
    final repository = FakeAuthRepository();
    addTearDown(repository.dispose);
    await pumpForgotPasswordPage(tester, repository);

    await tester.tap(find.widgetWithText(FilledButton, 'Send reset link'));
    await tester.pump();

    expect(find.text('Please enter your email'), findsOneWidget);
    expect(repository.sendResetCalls, 0);
  });

  testWidgets('sends a reset email through the repository with valid input', (
    tester,
  ) async {
    final repository = FakeAuthRepository();
    addTearDown(repository.dispose);
    await pumpForgotPasswordPage(tester, repository);

    await tester.enterText(find.byType(TextFormField), 'user@example.com');
    await tester.tap(find.widgetWithText(FilledButton, 'Send reset link'));
    await tester.pump();

    expect(repository.sendResetCalls, 1);
  });

  testWidgets('swaps the form for a confirmation after sending', (
    tester,
  ) async {
    final repository = FakeAuthRepository();
    addTearDown(repository.dispose);
    await pumpForgotPasswordPage(tester, repository);

    await tester.enterText(find.byType(TextFormField), 'user@example.com');
    await tester.tap(find.widgetWithText(FilledButton, 'Send reset link'));
    await tester.pump();

    expect(find.text('Check your email'), findsOneWidget);
    expect(find.byType(TextFormField), findsNothing);
    expect(
      find.widgetWithText(OutlinedButton, 'Back to login'),
      findsOneWidget,
    );
  });

  testWidgets('resends the reset email from the confirmation', (tester) async {
    final repository = FakeAuthRepository();
    addTearDown(repository.dispose);
    await pumpForgotPasswordPage(tester, repository);

    await tester.enterText(find.byType(TextFormField), 'user@example.com');
    await tester.tap(find.widgetWithText(FilledButton, 'Send reset link'));
    await tester.pump();

    await tester.tap(find.widgetWithText(FilledButton, 'Resend email'));
    await tester.pump();

    expect(repository.sendResetCalls, 2);
  });
}

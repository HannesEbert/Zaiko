import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/core/theme/app_theme.dart';
import 'package:zaiko/features/auth/application/auth_providers.dart';
import 'package:zaiko/features/auth/presentation/pages/reset_password_page.dart';
import 'package:zaiko/l10n/app_localizations.dart';

import '../../fake_auth_repository.dart';

void main() {
  Future<void> pumpResetPasswordPage(
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
          home: const ResetPasswordPage(),
        ),
      ),
    );
  }

  testWidgets('shows a validation error when submitting an empty form', (
    tester,
  ) async {
    final repository = FakeAuthRepository();
    addTearDown(repository.dispose);
    await pumpResetPasswordPage(tester, repository);

    await tester.tap(find.widgetWithText(FilledButton, 'Save new password'));
    await tester.pump();

    // Both the new-password and confirmation fields reject an empty value.
    expect(find.text('Please enter your password'), findsNWidgets(2));
    expect(repository.updatePasswordCalls, 0);
  });

  testWidgets('rejects a mismatched confirmation', (tester) async {
    final repository = FakeAuthRepository();
    addTearDown(repository.dispose);
    await pumpResetPasswordPage(tester, repository);

    // The two fields are, in order, new password then confirmation.
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'secret123');
    await tester.enterText(fields.at(1), 'different123');
    await tester.tap(find.widgetWithText(FilledButton, 'Save new password'));
    await tester.pump();

    expect(find.text("The passwords don't match"), findsOneWidget);
    expect(repository.updatePasswordCalls, 0);
  });

  testWidgets('updates the password through the repository with valid input', (
    tester,
  ) async {
    final repository = FakeAuthRepository();
    addTearDown(repository.dispose);
    await pumpResetPasswordPage(tester, repository);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'newSecret123');
    await tester.enterText(fields.at(1), 'newSecret123');
    await tester.tap(find.widgetWithText(FilledButton, 'Save new password'));
    await tester.pump();

    expect(repository.updatePasswordCalls, 1);
  });
}

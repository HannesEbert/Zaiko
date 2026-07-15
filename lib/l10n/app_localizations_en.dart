// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navInventory => 'Inventory';

  @override
  String get navShopping => 'Shopping';

  @override
  String get navRecipes => 'Recipes';

  @override
  String get navProfile => 'Profile';

  @override
  String get loginTitle => 'Sign in';

  @override
  String loginWelcome(String appName) {
    return 'Welcome to $appName';
  }

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginSignInButton => 'Sign in';

  @override
  String get loginCreateAccountButton => 'Create account';

  @override
  String get loginEmailEmpty => 'Please enter your email';

  @override
  String get loginEmailInvalid => 'Please enter a valid email';

  @override
  String get loginPasswordEmpty => 'Please enter your password';

  @override
  String loginPasswordTooShort(int count) {
    return 'Password must be at least $count characters';
  }

  @override
  String get loginConfirmEmailSent =>
      'Check your email to confirm your account.';

  @override
  String get loginGenericError => 'Something went wrong. Please try again.';

  @override
  String get inventoryEmptyTitle => 'Your inventory is empty';

  @override
  String get inventoryEmptyMessage =>
      'Items you add to your fridge and pantry will show up here.';

  @override
  String get shoppingTitle => 'Shopping list';

  @override
  String get shoppingEmptyTitle => 'Your shopping list is empty';

  @override
  String get shoppingEmptyMessage => 'Items you need to buy will show up here.';

  @override
  String get recipesTitle => 'Recipes';

  @override
  String get recipesEmptyTitle => 'No recipes yet';

  @override
  String get recipesEmptyMessage =>
      'Recipe ideas from what you have in stock will show up here.';

  @override
  String get joinTitle => 'Join household';

  @override
  String get joinInvited => 'You have been invited to a household';

  @override
  String joinConnectionCode(String code) {
    return 'Connection code: $code';
  }

  @override
  String get homeTitle => 'Home';

  @override
  String get homeEmptyTitle => 'Your overview is coming soon';

  @override
  String get homeEmptyMessage =>
      'Expiring items, quick stats and shortcuts will show up here.';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileManageAccount => 'Manage profile';

  @override
  String get profilePersonalData => 'Personal data';

  @override
  String get profileReminders => 'Expiry reminders';

  @override
  String get profileHousehold => 'Household';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profilePrivacy => 'Privacy';

  @override
  String get profileHelp => 'Help';

  @override
  String get profileSignOut => 'Sign out';

  @override
  String get profileSignOutDialogTitle => 'Sign out?';

  @override
  String get profileSignOutDialogMessage =>
      'You\'ll need to sign in again to access your household.';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get profileManageAccountEmptyTitle => 'Manage your profile';

  @override
  String get profileManageAccountEmptyMessage =>
      'Editing your profile details will be available here.';

  @override
  String get profilePersonalDataEmptyTitle => 'Your personal data';

  @override
  String get profilePersonalDataEmptyMessage =>
      'Your stored personal information will be shown here.';

  @override
  String get profileRemindersEmptyTitle => 'Expiry reminders';

  @override
  String get profileRemindersEmptyMessage =>
      'Choose when to be reminded before your food expires.';

  @override
  String get profileHouseholdEmptyTitle => 'Your household';

  @override
  String get profileHouseholdEmptyMessage =>
      'Link and manage the household you share here.';

  @override
  String get profileSettingsEmptyTitle => 'Settings';

  @override
  String get profileSettingsEmptyMessage =>
      'App settings will be available here.';

  @override
  String get profilePrivacyEmptyTitle => 'Privacy';

  @override
  String get profilePrivacyEmptyMessage =>
      'The privacy policy and data settings will be shown here.';

  @override
  String get profileHelpEmptyTitle => 'Help';

  @override
  String get profileHelpEmptyMessage =>
      'Help and support will be available here.';
}

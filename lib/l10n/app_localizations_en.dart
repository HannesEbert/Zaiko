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

  @override
  String get loginTagline => '在庫 · Inventory';

  @override
  String get loginHeadline => 'Keep track of your groceries.';

  @override
  String get loginSubtitle =>
      'Waste less, shop smarter — together as a household.';

  @override
  String get loginEmailHint => 'name@example.com';

  @override
  String get loginTerms =>
      'By signing in you accept our Terms of Use and Privacy Policy.';

  @override
  String inventorySubtitle(int count, int places) {
    return '$count items in $places places';
  }

  @override
  String get inventorySearchHint => 'Search everything…';

  @override
  String get inventoryRecentlyAdded => 'Recently added';

  @override
  String inventoryItemsCount(int count) {
    return '$count items';
  }

  @override
  String get inventoryAllFresh => 'All fresh';

  @override
  String get addItemTitle => 'Add item';

  @override
  String get addItemScanTitle => 'Scan barcode';

  @override
  String get addItemScanSubtitle => 'Fastest — the product is recognized';

  @override
  String get addItemSearchTitle => 'Search product';

  @override
  String get addItemSearchSubtitle => 'Open Food Facts database';

  @override
  String get addItemManualTitle => 'Enter manually';

  @override
  String get addItemManualSubtitle => 'Create your own product';

  @override
  String get addItemAddAgain => 'Add again';

  @override
  String get itemDetailHeader => 'Item';

  @override
  String get itemDetailQuantity => 'Quantity';

  @override
  String get itemDetailLocation => 'Location';

  @override
  String get itemDetailCategory => 'Category';

  @override
  String get itemDetailBestBefore => 'Best before';

  @override
  String get itemDetailMarkConsumed => 'Mark as consumed';

  @override
  String get itemDetailAddToList => 'Add to shopping list';

  @override
  String get itemDetailRemove => 'Remove item';

  @override
  String get itemDetailPhoto => 'Product photo';

  @override
  String shoppingProgress(int done, int total) {
    return '$done of $total done';
  }

  @override
  String get shoppingAddHint => 'Add item…';

  @override
  String shoppingDoneSection(int count) {
    return 'Done ($count)';
  }

  @override
  String get recipesSubtitle => 'Cookable with your stock';

  @override
  String get recipesMissing => 'Missing:';

  @override
  String get recipesAddToList => 'To list';

  @override
  String get recipesPhoto => 'Recipe photo';

  @override
  String get profileHouseholdSection => 'Household';

  @override
  String get profileSettingsSection => 'Settings';

  @override
  String get profileInviteMember => 'Invite member';

  @override
  String profileMembersCount(int count) {
    return '$count members';
  }

  @override
  String profileVersion(String version) {
    return 'Zaiko $version';
  }

  @override
  String get settingNotifications => 'Notifications';

  @override
  String get settingReminder => 'Reminder before expiry';

  @override
  String get settingReminderValue => '3 days before';

  @override
  String get settingAppearance => 'Appearance';

  @override
  String get settingAppearanceSystem => 'System';

  @override
  String get settingLanguage => 'Language';

  @override
  String get settingLanguageGerman => 'German';

  @override
  String homeGreeting(String name) {
    return 'Hi $name';
  }

  @override
  String homeSubtitle(String household) {
    return 'Household $household';
  }

  @override
  String get homeStatItems => 'Items';

  @override
  String get homeStatExpiring => 'Expiring soon';

  @override
  String get homeStatShopping => 'On the list';

  @override
  String get homeExpiringSoon => 'Expiring soon';
}

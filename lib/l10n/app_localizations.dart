import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// Bottom navigation label for the home/overview tab
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Bottom navigation label for the inventory tab
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get navInventory;

  /// Bottom navigation label for the shopping list tab
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get navShopping;

  /// Bottom navigation label for the recipes tab
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get navRecipes;

  /// Bottom navigation label for the profile tab
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitle;

  /// No description provided for @loginWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to {appName}'**
  String loginWelcome(String appName);

  /// No description provided for @loginEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmailLabel;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginSignInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginSignInButton;

  /// No description provided for @loginCreateAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get loginCreateAccountButton;

  /// No description provided for @loginEmailEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get loginEmailEmpty;

  /// No description provided for @loginEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get loginEmailInvalid;

  /// No description provided for @loginPasswordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get loginPasswordEmpty;

  /// No description provided for @loginPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least {count} characters'**
  String loginPasswordTooShort(int count);

  /// No description provided for @loginConfirmEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Check your email to confirm your account.'**
  String get loginConfirmEmailSent;

  /// No description provided for @loginGenericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get loginGenericError;

  /// No description provided for @inventoryEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your inventory is empty'**
  String get inventoryEmptyTitle;

  /// No description provided for @inventoryEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Items you add to your fridge and pantry will show up here.'**
  String get inventoryEmptyMessage;

  /// No description provided for @shoppingTitle.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get shoppingTitle;

  /// No description provided for @shoppingEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your shopping list is empty'**
  String get shoppingEmptyTitle;

  /// No description provided for @shoppingEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Items you need to buy will show up here.'**
  String get shoppingEmptyMessage;

  /// No description provided for @recipesTitle.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get recipesTitle;

  /// No description provided for @recipesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No recipes yet'**
  String get recipesEmptyTitle;

  /// No description provided for @recipesEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Recipe ideas from what you have in stock will show up here.'**
  String get recipesEmptyMessage;

  /// No description provided for @joinTitle.
  ///
  /// In en, this message translates to:
  /// **'Join household'**
  String get joinTitle;

  /// No description provided for @joinInvited.
  ///
  /// In en, this message translates to:
  /// **'You have been invited to a household'**
  String get joinInvited;

  /// No description provided for @joinConnectionCode.
  ///
  /// In en, this message translates to:
  /// **'Connection code: {code}'**
  String joinConnectionCode(String code);

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your overview is coming soon'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Expiring items, quick stats and shortcuts will show up here.'**
  String get homeEmptyMessage;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileManageAccount.
  ///
  /// In en, this message translates to:
  /// **'Manage profile'**
  String get profileManageAccount;

  /// No description provided for @profilePersonalData.
  ///
  /// In en, this message translates to:
  /// **'Personal data'**
  String get profilePersonalData;

  /// No description provided for @profileReminders.
  ///
  /// In en, this message translates to:
  /// **'Expiry reminders'**
  String get profileReminders;

  /// No description provided for @profileHousehold.
  ///
  /// In en, this message translates to:
  /// **'Household'**
  String get profileHousehold;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettings;

  /// No description provided for @profilePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get profilePrivacy;

  /// No description provided for @profileHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get profileHelp;

  /// No description provided for @profileSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get profileSignOut;

  /// No description provided for @profileSignOutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get profileSignOutDialogTitle;

  /// No description provided for @profileSignOutDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need to sign in again to access your household.'**
  String get profileSignOutDialogMessage;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @profileManageAccountEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your profile'**
  String get profileManageAccountEmptyTitle;

  /// No description provided for @profileManageAccountEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Editing your profile details will be available here.'**
  String get profileManageAccountEmptyMessage;

  /// No description provided for @profilePersonalDataEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your personal data'**
  String get profilePersonalDataEmptyTitle;

  /// No description provided for @profilePersonalDataEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Your stored personal information will be shown here.'**
  String get profilePersonalDataEmptyMessage;

  /// No description provided for @profileRemindersEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Expiry reminders'**
  String get profileRemindersEmptyTitle;

  /// No description provided for @profileRemindersEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Choose when to be reminded before your food expires.'**
  String get profileRemindersEmptyMessage;

  /// No description provided for @profileHouseholdEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your household'**
  String get profileHouseholdEmptyTitle;

  /// No description provided for @profileHouseholdEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Link and manage the household you share here.'**
  String get profileHouseholdEmptyMessage;

  /// No description provided for @profileSettingsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettingsEmptyTitle;

  /// No description provided for @profileSettingsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'App settings will be available here.'**
  String get profileSettingsEmptyMessage;

  /// No description provided for @profilePrivacyEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get profilePrivacyEmptyTitle;

  /// No description provided for @profilePrivacyEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'The privacy policy and data settings will be shown here.'**
  String get profilePrivacyEmptyMessage;

  /// No description provided for @profileHelpEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get profileHelpEmptyTitle;

  /// No description provided for @profileHelpEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Help and support will be available here.'**
  String get profileHelpEmptyMessage;

  /// No description provided for @loginTagline.
  ///
  /// In en, this message translates to:
  /// **'在庫 · Inventory'**
  String get loginTagline;

  /// No description provided for @loginHeadline.
  ///
  /// In en, this message translates to:
  /// **'Keep track of your groceries.'**
  String get loginHeadline;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Waste less, shop smarter — together as a household.'**
  String get loginSubtitle;

  /// No description provided for @loginEmailHint.
  ///
  /// In en, this message translates to:
  /// **'name@example.com'**
  String get loginEmailHint;

  /// No description provided for @loginTerms.
  ///
  /// In en, this message translates to:
  /// **'By signing in you accept our Terms of Use and Privacy Policy.'**
  String get loginTerms;

  /// No description provided for @inventorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} items in {places} places'**
  String inventorySubtitle(int count, int places);

  /// No description provided for @inventorySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search everything…'**
  String get inventorySearchHint;

  /// No description provided for @inventoryRecentlyAdded.
  ///
  /// In en, this message translates to:
  /// **'Recently added'**
  String get inventoryRecentlyAdded;

  /// No description provided for @inventoryItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String inventoryItemsCount(int count);

  /// No description provided for @inventoryAllFresh.
  ///
  /// In en, this message translates to:
  /// **'All fresh'**
  String get inventoryAllFresh;

  /// No description provided for @inventoryStatExpiring.
  ///
  /// In en, this message translates to:
  /// **'Expiring soon'**
  String get inventoryStatExpiring;

  /// No description provided for @inventoryStatExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get inventoryStatExpired;

  /// No description provided for @inventoryStatFresh.
  ///
  /// In en, this message translates to:
  /// **'Fresh'**
  String get inventoryStatFresh;

  /// No description provided for @locationSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search in {name}…'**
  String locationSearchHint(String name);

  /// No description provided for @addItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get addItemTitle;

  /// No description provided for @addItemScanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan barcode'**
  String get addItemScanTitle;

  /// No description provided for @addItemScanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fastest — the product is recognized'**
  String get addItemScanSubtitle;

  /// No description provided for @addItemSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search product'**
  String get addItemSearchTitle;

  /// No description provided for @addItemSearchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open Food Facts database'**
  String get addItemSearchSubtitle;

  /// No description provided for @addItemManualTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter manually'**
  String get addItemManualTitle;

  /// No description provided for @addItemManualSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your own product'**
  String get addItemManualSubtitle;

  /// No description provided for @addItemAddAgain.
  ///
  /// In en, this message translates to:
  /// **'Add again'**
  String get addItemAddAgain;

  /// No description provided for @itemDetailHeader.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get itemDetailHeader;

  /// No description provided for @itemDetailQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get itemDetailQuantity;

  /// No description provided for @itemDetailLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get itemDetailLocation;

  /// No description provided for @itemDetailCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get itemDetailCategory;

  /// No description provided for @itemDetailBestBefore.
  ///
  /// In en, this message translates to:
  /// **'Best before'**
  String get itemDetailBestBefore;

  /// No description provided for @itemDetailMarkConsumed.
  ///
  /// In en, this message translates to:
  /// **'Mark as consumed'**
  String get itemDetailMarkConsumed;

  /// No description provided for @itemDetailAddToList.
  ///
  /// In en, this message translates to:
  /// **'Add to shopping list'**
  String get itemDetailAddToList;

  /// No description provided for @itemDetailRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove item'**
  String get itemDetailRemove;

  /// No description provided for @itemDetailPhoto.
  ///
  /// In en, this message translates to:
  /// **'Product photo'**
  String get itemDetailPhoto;

  /// No description provided for @shoppingAddHint.
  ///
  /// In en, this message translates to:
  /// **'Add item…'**
  String get shoppingAddHint;

  /// No description provided for @shoppingListCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items on the list'**
  String shoppingListCount(int count);

  /// No description provided for @recipesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Cookable with your stock'**
  String get recipesSubtitle;

  /// No description provided for @recipesMissing.
  ///
  /// In en, this message translates to:
  /// **'Missing:'**
  String get recipesMissing;

  /// No description provided for @recipesAddToList.
  ///
  /// In en, this message translates to:
  /// **'To list'**
  String get recipesAddToList;

  /// No description provided for @recipesPhoto.
  ///
  /// In en, this message translates to:
  /// **'Recipe photo'**
  String get recipesPhoto;

  /// No description provided for @profileHouseholdSection.
  ///
  /// In en, this message translates to:
  /// **'Household'**
  String get profileHouseholdSection;

  /// No description provided for @profileSettingsSection.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettingsSection;

  /// No description provided for @profileInviteMember.
  ///
  /// In en, this message translates to:
  /// **'Invite member'**
  String get profileInviteMember;

  /// No description provided for @profileMembersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} members'**
  String profileMembersCount(int count);

  /// No description provided for @profileVersion.
  ///
  /// In en, this message translates to:
  /// **'Zaiko {version}'**
  String profileVersion(String version);

  /// No description provided for @settingNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingNotifications;

  /// No description provided for @settingReminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder before expiry'**
  String get settingReminder;

  /// No description provided for @settingReminderValue.
  ///
  /// In en, this message translates to:
  /// **'3 days before'**
  String get settingReminderValue;

  /// No description provided for @settingAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingAppearance;

  /// No description provided for @settingAppearanceSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingAppearanceSystem;

  /// No description provided for @settingLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingLanguage;

  /// No description provided for @settingLanguageGerman.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get settingLanguageGerman;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name}'**
  String homeGreeting(String name);

  /// No description provided for @homeExpiringCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items expiring soon'**
  String homeExpiringCount(int count);

  /// No description provided for @homeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search your stock…'**
  String get homeSearchHint;

  /// No description provided for @homeCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get homeCategories;

  /// No description provided for @homeExpiringSoon.
  ///
  /// In en, this message translates to:
  /// **'Expiring soon'**
  String get homeExpiringSoon;

  /// No description provided for @commonAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get commonAll;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

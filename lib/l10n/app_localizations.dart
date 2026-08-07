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

  /// Title of the dedicated account registration screen
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerTitle;

  /// Short intro shown under the registration screen title
  ///
  /// In en, this message translates to:
  /// **'Create your account to get started.'**
  String get registerSubtitle;

  /// Label for the password confirmation field
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get registerConfirmPasswordLabel;

  /// Validation error when password and confirmation differ
  ///
  /// In en, this message translates to:
  /// **'The passwords don\'t match'**
  String get registerPasswordMismatch;

  /// Consent checkbox label; must contain registerPrivacyPolicyLink verbatim as the tappable part
  ///
  /// In en, this message translates to:
  /// **'I accept the Privacy Policy.'**
  String get registerPrivacyConsent;

  /// Substring of registerPrivacyConsent rendered as a tappable link to the privacy policy
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get registerPrivacyPolicyLink;

  /// Link on the login screen that opens the password-reset request screen
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPasswordLink;

  /// Title of the password-reset request screen
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get forgotPasswordTitle;

  /// Instructions on the password-reset request screen
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a link to reset your password.'**
  String get forgotPasswordSubtitle;

  /// Button that sends the password-reset email
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get forgotPasswordSendButton;

  /// Confirmation shown after the reset email was sent
  ///
  /// In en, this message translates to:
  /// **'Check your email for a link to reset your password.'**
  String get forgotPasswordEmailSent;

  /// Heading of the confirmation screen shown after the reset email was sent
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get forgotPasswordSentTitle;

  /// Body of the reset-email confirmation screen, naming the recipient address
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a password reset link to {email}. Open it to choose a new password.'**
  String forgotPasswordSentBody(String email);

  /// Button that sends the password-reset email again
  ///
  /// In en, this message translates to:
  /// **'Resend email'**
  String get forgotPasswordResend;

  /// Button that returns from the confirmation screen to sign-in
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get forgotPasswordBackToLogin;

  /// Title of the screen where the user sets a new password
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get resetPasswordTitle;

  /// Instructions on the set-new-password screen
  ///
  /// In en, this message translates to:
  /// **'Choose a new password for your account.'**
  String get resetPasswordSubtitle;

  /// Label for the new password field
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get resetPasswordNewPasswordLabel;

  /// Label for the new password confirmation field
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get resetPasswordConfirmLabel;

  /// Button that saves the new password
  ///
  /// In en, this message translates to:
  /// **'Save new password'**
  String get resetPasswordSaveButton;

  /// Confirmation shown after the password was changed successfully
  ///
  /// In en, this message translates to:
  /// **'Password updated. Please sign in with your new password.'**
  String get resetPasswordSuccess;

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

  /// No description provided for @profileDietary.
  ///
  /// In en, this message translates to:
  /// **'Diet & preferences'**
  String get profileDietary;

  /// No description provided for @profileInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get profileInfoSection;

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

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @profileDisplayNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get profileDisplayNameLabel;

  /// No description provided for @profileDisplayNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a display name'**
  String get profileDisplayNameRequired;

  /// No description provided for @profileEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmailLabel;

  /// No description provided for @profileEmailChangeHint.
  ///
  /// In en, this message translates to:
  /// **'Changing your email and password will be available soon.'**
  String get profileEmailChangeHint;

  /// No description provided for @profileAvatarSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Avatar'**
  String get profileAvatarSectionTitle;

  /// No description provided for @profileAvatarDefault.
  ///
  /// In en, this message translates to:
  /// **'Initial'**
  String get profileAvatarDefault;

  /// No description provided for @profileErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save your profile. Please try again.'**
  String get profileErrorGeneric;

  /// No description provided for @profileMemberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since'**
  String get profileMemberSince;

  /// No description provided for @profilePersonalDataNoHousehold.
  ///
  /// In en, this message translates to:
  /// **'No household'**
  String get profilePersonalDataNoHousehold;

  /// Local notification title for the daily expiry reminder, counting items within the lead window
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item is expiring soon} other{{count} items are expiring soon}}'**
  String remindersNotificationTitle(int count);

  /// No description provided for @remindersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get a daily reminder before your food expires. Reminders live on this device.'**
  String get remindersSubtitle;

  /// No description provided for @remindersEnableLabel.
  ///
  /// In en, this message translates to:
  /// **'Expiry reminders'**
  String get remindersEnableLabel;

  /// No description provided for @remindersLeadDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Warn me before'**
  String get remindersLeadDaysLabel;

  /// Lead-time value: how many days before a best-before date to warn
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day before} other{{days} days before}}'**
  String remindersLeadDaysValue(int days);

  /// No description provided for @remindersTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get remindersTimeLabel;

  /// No description provided for @remindersSavedSnack.
  ///
  /// In en, this message translates to:
  /// **'Reminders saved'**
  String get remindersSavedSnack;

  /// No description provided for @remindersPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are turned off. Enable them in system settings.'**
  String get remindersPermissionDenied;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

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

  /// No description provided for @locationUnassignedName.
  ///
  /// In en, this message translates to:
  /// **'No location'**
  String get locationUnassignedName;

  /// No description provided for @locationSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search in {name}…'**
  String locationSearchHint(String name);

  /// No description provided for @inventoryAllItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'All items'**
  String get inventoryAllItemsTitle;

  /// No description provided for @inventorySearchEmpty.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get inventorySearchEmpty;

  /// No description provided for @inventorySortTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get inventorySortTitle;

  /// No description provided for @inventorySortRecent.
  ///
  /// In en, this message translates to:
  /// **'Recently added'**
  String get inventorySortRecent;

  /// No description provided for @inventorySortName.
  ///
  /// In en, this message translates to:
  /// **'Name A–Z'**
  String get inventorySortName;

  /// No description provided for @inventorySortExpiry.
  ///
  /// In en, this message translates to:
  /// **'Expiry date'**
  String get inventorySortExpiry;

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
  /// **'Count'**
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

  /// No description provided for @shoppingAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add to list'**
  String get shoppingAddTitle;

  /// No description provided for @shoppingEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get shoppingEditTitle;

  /// No description provided for @shoppingQuantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get shoppingQuantityLabel;

  /// No description provided for @shoppingQuantityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 2 × 1 l'**
  String get shoppingQuantityHint;

  /// No description provided for @shoppingAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get shoppingAddButton;

  /// No description provided for @shoppingSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get shoppingSaveButton;

  /// No description provided for @shoppingClearCheckedTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear bought items'**
  String get shoppingClearCheckedTooltip;

  /// No description provided for @shoppingDoneSection.
  ///
  /// In en, this message translates to:
  /// **'Bought'**
  String get shoppingDoneSection;

  /// No description provided for @shoppingLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your shopping list.'**
  String get shoppingLoadError;

  /// No description provided for @shoppingErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get shoppingErrorGeneric;

  /// No description provided for @shoppingErrorNotMember.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have access to this list.'**
  String get shoppingErrorNotMember;

  /// No description provided for @shoppingErrorNotFound.
  ///
  /// In en, this message translates to:
  /// **'This item no longer exists.'**
  String get shoppingErrorNotFound;

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

  /// No description provided for @settingReminderOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get settingReminderOff;

  /// No description provided for @settingAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingAppearance;

  /// No description provided for @settingAppearanceDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingAppearanceDark;

  /// No description provided for @settingAppearanceHint.
  ///
  /// In en, this message translates to:
  /// **'Zaiko is dark-only for now. A light theme and a toggle will come in a later update.'**
  String get settingAppearanceHint;

  /// No description provided for @settingLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingLanguage;

  /// No description provided for @settingLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingLanguageSystem;

  /// No description provided for @settingLanguageGerman.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get settingLanguageGerman;

  /// No description provided for @settingLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingLanguageEnglish;

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

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up your household'**
  String get onboardingTitle;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a household to start tracking, or join one you were invited to.'**
  String get onboardingSubtitle;

  /// No description provided for @onboardingCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a household'**
  String get onboardingCreateTitle;

  /// No description provided for @onboardingCreateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start fresh — you can invite others afterwards.'**
  String get onboardingCreateSubtitle;

  /// No description provided for @onboardingNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Household name'**
  String get onboardingNameLabel;

  /// No description provided for @onboardingNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Lindenhof'**
  String get onboardingNameHint;

  /// No description provided for @onboardingNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter a household name'**
  String get onboardingNameEmpty;

  /// No description provided for @onboardingCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Create household'**
  String get onboardingCreateButton;

  /// No description provided for @onboardingJoinTitle.
  ///
  /// In en, this message translates to:
  /// **'Join a household'**
  String get onboardingJoinTitle;

  /// No description provided for @onboardingJoinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the invite code you received.'**
  String get onboardingJoinSubtitle;

  /// No description provided for @onboardingCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Invite code'**
  String get onboardingCodeLabel;

  /// No description provided for @onboardingCodeHint.
  ///
  /// In en, this message translates to:
  /// **'6-character code'**
  String get onboardingCodeHint;

  /// No description provided for @onboardingCodeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter an invite code'**
  String get onboardingCodeEmpty;

  /// No description provided for @onboardingJoinButton.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get onboardingJoinButton;

  /// No description provided for @inviteTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite member'**
  String get inviteTitle;

  /// No description provided for @inviteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share this code, or let them scan the QR. It expires in 15 minutes.'**
  String get inviteSubtitle;

  /// No description provided for @inviteExpiresHint.
  ///
  /// In en, this message translates to:
  /// **'Valid for 15 minutes'**
  String get inviteExpiresHint;

  /// No description provided for @inviteCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Create invite code'**
  String get inviteCreateButton;

  /// No description provided for @inviteRegenerate.
  ///
  /// In en, this message translates to:
  /// **'New code'**
  String get inviteRegenerate;

  /// No description provided for @householdMembersTitle.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get householdMembersTitle;

  /// No description provided for @householdRoleOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get householdRoleOwner;

  /// No description provided for @householdRoleMember.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get householdRoleMember;

  /// No description provided for @householdYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get householdYou;

  /// No description provided for @householdRename.
  ///
  /// In en, this message translates to:
  /// **'Rename household'**
  String get householdRename;

  /// No description provided for @householdRenameSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get householdRenameSave;

  /// No description provided for @householdRemoveMember.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get householdRemoveMember;

  /// No description provided for @householdRemoveMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove member?'**
  String get householdRemoveMemberTitle;

  /// No description provided for @householdRemoveMemberMessage.
  ///
  /// In en, this message translates to:
  /// **'They will lose access to this household.'**
  String get householdRemoveMemberMessage;

  /// No description provided for @householdLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave household'**
  String get householdLeave;

  /// No description provided for @householdLeaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave household?'**
  String get householdLeaveTitle;

  /// No description provided for @householdLeaveMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ll lose access to its inventory and shopping list.'**
  String get householdLeaveMessage;

  /// No description provided for @householdLeaveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get householdLeaveConfirm;

  /// No description provided for @joinConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you want to join this household?'**
  String get joinConfirmMessage;

  /// No description provided for @joinAcceptButton.
  ///
  /// In en, this message translates to:
  /// **'Join household'**
  String get joinAcceptButton;

  /// No description provided for @joinSignInPrompt.
  ///
  /// In en, this message translates to:
  /// **'Sign in or create an account to join this household.'**
  String get joinSignInPrompt;

  /// No description provided for @joinSignInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in & join'**
  String get joinSignInButton;

  /// No description provided for @joinSuccess.
  ///
  /// In en, this message translates to:
  /// **'You joined the household.'**
  String get joinSuccess;

  /// No description provided for @joinToProfileButton.
  ///
  /// In en, this message translates to:
  /// **'Back to profile'**
  String get joinToProfileButton;

  /// No description provided for @householdErrorAlreadyMember.
  ///
  /// In en, this message translates to:
  /// **'You\'re already in a household. Leave it first to join another.'**
  String get householdErrorAlreadyMember;

  /// No description provided for @householdErrorInviteNotFound.
  ///
  /// In en, this message translates to:
  /// **'This invite code doesn\'t exist.'**
  String get householdErrorInviteNotFound;

  /// No description provided for @householdErrorInviteUsed.
  ///
  /// In en, this message translates to:
  /// **'This invite has already been used.'**
  String get householdErrorInviteUsed;

  /// No description provided for @householdErrorInviteExpired.
  ///
  /// In en, this message translates to:
  /// **'This invite has expired. Ask for a new one.'**
  String get householdErrorInviteExpired;

  /// No description provided for @householdErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get householdErrorGeneric;

  /// Home header greeting shown before the household name is known
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get homeGreetingGeneric;

  /// Storage-location card status when items are close to expiry
  ///
  /// In en, this message translates to:
  /// **'{count} expiring soon'**
  String inventoryLocationExpiringSoon(int count);

  /// Storage-location card status when items are past their best-before date
  ///
  /// In en, this message translates to:
  /// **'{count} expired'**
  String inventoryLocationExpired(int count);

  /// Error shown when the inventory data fails to load
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your inventory.'**
  String get inventoryLoadError;

  /// Empty state on a storage-location detail screen
  ///
  /// In en, this message translates to:
  /// **'No items in this location yet.'**
  String get inventoryLocationEmpty;

  /// Empty state for the recently-added list on the inventory tab
  ///
  /// In en, this message translates to:
  /// **'Nothing added yet.'**
  String get inventoryRecentlyAddedEmpty;

  /// Empty state for the home tab's expiring-soon rail
  ///
  /// In en, this message translates to:
  /// **'Nothing expiring soon.'**
  String get homeExpiringEmpty;

  /// Generic retry button label
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonRetry;

  /// Short expiry label for an item past its best-before date
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expiryExpired;

  /// Short expiry label when the best-before date is today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get expiryToday;

  /// Short expiry label when the best-before date is tomorrow
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get expiryTomorrow;

  /// Short expiry label a few days before the best-before date
  ///
  /// In en, this message translates to:
  /// **'In {count} days'**
  String expiryInDays(int count);

  /// Expiry status pill on the item detail screen, best-before today
  ///
  /// In en, this message translates to:
  /// **'Expires today'**
  String get itemDetailExpiresToday;

  /// Expiry status pill on the item detail screen, best-before tomorrow
  ///
  /// In en, this message translates to:
  /// **'Expires tomorrow'**
  String get itemDetailExpiresTomorrow;

  /// Expiry status pill on the item detail screen, best-before soon
  ///
  /// In en, this message translates to:
  /// **'Expires in {count} days'**
  String itemDetailExpiresInDays(int count);

  /// Placeholder value for an item detail row without a date
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get itemDetailNoDate;

  /// Relative label for something that happened today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get relativeToday;

  /// Relative label for something that happened yesterday
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get relativeYesterday;

  /// Relative label for something that happened a few days ago
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String relativeDaysAgo(int count);

  /// Short unit label for individual pieces of an item
  ///
  /// In en, this message translates to:
  /// **'pcs'**
  String get unitPiece;

  /// Short unit label for a packaged item
  ///
  /// In en, this message translates to:
  /// **'pack'**
  String get unitPackage;

  /// No description provided for @itemFormAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get itemFormAddTitle;

  /// No description provided for @itemFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get itemFormEditTitle;

  /// No description provided for @itemFormNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get itemFormNameLabel;

  /// No description provided for @itemFormNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Milk'**
  String get itemFormNameHint;

  /// No description provided for @itemFormNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get itemFormNameEmpty;

  /// No description provided for @itemFormQuantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get itemFormQuantityLabel;

  /// No description provided for @itemFormQuantityInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a quantity greater than 0'**
  String get itemFormQuantityInvalid;

  /// No description provided for @itemFormCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get itemFormCountLabel;

  /// No description provided for @itemFormCountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a count of at least 1'**
  String get itemFormCountInvalid;

  /// No description provided for @itemFormUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get itemFormUnitLabel;

  /// No description provided for @itemFormLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get itemFormLocationLabel;

  /// No description provided for @itemFormCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get itemFormCategoryLabel;

  /// No description provided for @itemFormBestBeforeLabel.
  ///
  /// In en, this message translates to:
  /// **'Best before'**
  String get itemFormBestBeforeLabel;

  /// No description provided for @itemFormNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get itemFormNone;

  /// No description provided for @itemFormAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get itemFormAddButton;

  /// No description provided for @itemFormSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get itemFormSaveButton;

  /// No description provided for @itemFormAddedSnack.
  ///
  /// In en, this message translates to:
  /// **'Item added'**
  String get itemFormAddedSnack;

  /// No description provided for @itemFormSavedSnack.
  ///
  /// In en, this message translates to:
  /// **'Changes saved'**
  String get itemFormSavedSnack;

  /// No description provided for @itemMovedToTrash.
  ///
  /// In en, this message translates to:
  /// **'Moved to trash'**
  String get itemMovedToTrash;

  /// No description provided for @itemRestoredSnack.
  ///
  /// In en, this message translates to:
  /// **'Item restored'**
  String get itemRestoredSnack;

  /// No description provided for @pickerLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose location'**
  String get pickerLocationTitle;

  /// No description provided for @pickerCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose category'**
  String get pickerCategoryTitle;

  /// No description provided for @pickerNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get pickerNone;

  /// No description provided for @pickerNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get pickerNew;

  /// No description provided for @pickerManage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get pickerManage;

  /// No description provided for @taxonomyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get taxonomyNameLabel;

  /// No description provided for @taxonomyColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get taxonomyColorLabel;

  /// No description provided for @taxonomyIconLabel.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get taxonomyIconLabel;

  /// No description provided for @taxonomyNewLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'New location'**
  String get taxonomyNewLocationTitle;

  /// No description provided for @taxonomyEditLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit location'**
  String get taxonomyEditLocationTitle;

  /// No description provided for @taxonomyNewCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get taxonomyNewCategoryTitle;

  /// No description provided for @taxonomyEditCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get taxonomyEditCategoryTitle;

  /// No description provided for @taxonomyNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get taxonomyNameEmpty;

  /// No description provided for @taxonomyCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get taxonomyCreateButton;

  /// No description provided for @taxonomySaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get taxonomySaveButton;

  /// No description provided for @manageLocationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Storage locations'**
  String get manageLocationsTitle;

  /// No description provided for @manageCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get manageCategoriesTitle;

  /// No description provided for @manageAddLocation.
  ///
  /// In en, this message translates to:
  /// **'Add location'**
  String get manageAddLocation;

  /// No description provided for @manageAddCategory.
  ///
  /// In en, this message translates to:
  /// **'Add category'**
  String get manageAddCategory;

  /// No description provided for @manageLocationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No storage locations yet.'**
  String get manageLocationsEmpty;

  /// No description provided for @manageCategoriesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No custom categories yet.'**
  String get manageCategoriesEmpty;

  /// No description provided for @manageEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get manageEdit;

  /// No description provided for @manageDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get manageDelete;

  /// No description provided for @manageDefaultBadge.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get manageDefaultBadge;

  /// No description provided for @manageDeleteLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete location?'**
  String get manageDeleteLocationTitle;

  /// No description provided for @manageDeleteCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete category?'**
  String get manageDeleteCategoryTitle;

  /// Warning in the delete-location/category dialog, counting affected items
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{This isn\'t used by any item yet.} =1{1 item will lose this assignment.} other{{count} items will lose this assignment.}}'**
  String manageDeleteItemsWarning(int count);

  /// No description provided for @manageDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get manageDeleteConfirm;

  /// No description provided for @trashTitle.
  ///
  /// In en, this message translates to:
  /// **'Trash'**
  String get trashTitle;

  /// No description provided for @trashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Removed items are kept for 30 days, then deleted.'**
  String get trashSubtitle;

  /// No description provided for @trashEmpty.
  ///
  /// In en, this message translates to:
  /// **'Trash is empty.'**
  String get trashEmpty;

  /// No description provided for @trashRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get trashRestore;

  /// No description provided for @inventoryTrashTooltip.
  ///
  /// In en, this message translates to:
  /// **'Trash'**
  String get inventoryTrashTooltip;

  /// No description provided for @inventoryErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get inventoryErrorGeneric;

  /// No description provided for @inventoryErrorNotMember.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have access to this household.'**
  String get inventoryErrorNotMember;

  /// No description provided for @inventoryErrorNotFound.
  ///
  /// In en, this message translates to:
  /// **'This item no longer exists.'**
  String get inventoryErrorNotFound;

  /// No description provided for @scannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan barcode'**
  String get scannerTitle;

  /// No description provided for @scannerHint.
  ///
  /// In en, this message translates to:
  /// **'Point the camera at a product barcode'**
  String get scannerHint;

  /// No description provided for @scannerTorchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Torch'**
  String get scannerTorchTooltip;

  /// No description provided for @scannerResolving.
  ///
  /// In en, this message translates to:
  /// **'Looking up product…'**
  String get scannerResolving;

  /// No description provided for @scannerPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera access needed'**
  String get scannerPermissionTitle;

  /// No description provided for @scannerPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'Zaiko needs camera access to scan barcodes. You can enable it in Settings.'**
  String get scannerPermissionBody;

  /// No description provided for @scannerOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get scannerOpenSettings;

  /// No description provided for @scanNotFoundSnack.
  ///
  /// In en, this message translates to:
  /// **'Product not found — enter it manually.'**
  String get scanNotFoundSnack;

  /// No description provided for @productSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search product'**
  String get productSearchTitle;

  /// No description provided for @productSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by product name…'**
  String get productSearchHint;

  /// No description provided for @productSearchPrompt.
  ///
  /// In en, this message translates to:
  /// **'Type to search Open Food Facts.'**
  String get productSearchPrompt;

  /// No description provided for @productSearchEmpty.
  ///
  /// In en, this message translates to:
  /// **'No products found.'**
  String get productSearchEmpty;

  /// No description provided for @foodErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Open Food Facts is temporarily unavailable. Please try again shortly.'**
  String get foodErrorNetwork;

  /// No description provided for @foodErrorRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please try again in a moment.'**
  String get foodErrorRateLimited;

  /// No description provided for @foodErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach the product database. Please try again.'**
  String get foodErrorGeneric;

  /// No description provided for @recipesFilterAlmostComplete.
  ///
  /// In en, this message translates to:
  /// **'Almost complete'**
  String get recipesFilterAlmostComplete;

  /// No description provided for @recipesFilterUnder30.
  ///
  /// In en, this message translates to:
  /// **'Under 30 min'**
  String get recipesFilterUnder30;

  /// No description provided for @recipesMatchComplete.
  ///
  /// In en, this message translates to:
  /// **'All in stock'**
  String get recipesMatchComplete;

  /// How many of a recipe's ingredients are in stock
  ///
  /// In en, this message translates to:
  /// **'{matched}/{total} ingredients'**
  String recipesMatchCount(int matched, int total);

  /// No description provided for @recipesUsesExpiring.
  ///
  /// In en, this message translates to:
  /// **'Use up soon'**
  String get recipesUsesExpiring;

  /// No description provided for @recipesMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String recipesMinutes(int minutes);

  /// No description provided for @recipesServings.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 serving} other{{count} servings}}'**
  String recipesServings(int count);

  /// No description provided for @recipesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load recipes.'**
  String get recipesLoadError;

  /// No description provided for @recipesErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get recipesErrorGeneric;

  /// No description provided for @recipesErrorNotMember.
  ///
  /// In en, this message translates to:
  /// **'You\'re not a member of this household.'**
  String get recipesErrorNotMember;

  /// No description provided for @recipesErrorNotFound.
  ///
  /// In en, this message translates to:
  /// **'This recipe no longer exists.'**
  String get recipesErrorNotFound;

  /// No description provided for @recipesAddedToList.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Added 1 ingredient to the list} other{Added {count} ingredients to the list}}'**
  String recipesAddedToList(int count);

  /// No description provided for @recipesNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New recipe'**
  String get recipesNewTitle;

  /// No description provided for @recipesEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit recipe'**
  String get recipesEditTitle;

  /// No description provided for @recipesEditAction.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get recipesEditAction;

  /// No description provided for @recipesDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get recipesDeleteAction;

  /// No description provided for @recipesDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete recipe?'**
  String get recipesDeleteTitle;

  /// No description provided for @recipesDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'\"{title}\" will be removed for everyone in the household.'**
  String recipesDeleteMessage(String title);

  /// No description provided for @recipesIngredientsSection.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get recipesIngredientsSection;

  /// No description provided for @recipesIngredientsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No ingredients.'**
  String get recipesIngredientsEmpty;

  /// No description provided for @recipesStepsSection.
  ///
  /// In en, this message translates to:
  /// **'Preparation'**
  String get recipesStepsSection;

  /// No description provided for @recipesStepsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No steps yet.'**
  String get recipesStepsEmpty;

  /// No description provided for @recipesInStock.
  ///
  /// In en, this message translates to:
  /// **'In stock'**
  String get recipesInStock;

  /// No description provided for @recipesFormTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get recipesFormTitleLabel;

  /// No description provided for @recipesFormTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Tomato pasta'**
  String get recipesFormTitleHint;

  /// No description provided for @recipesFormMinutesLabel.
  ///
  /// In en, this message translates to:
  /// **'Time (minutes)'**
  String get recipesFormMinutesLabel;

  /// No description provided for @recipesFormServingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Servings'**
  String get recipesFormServingsLabel;

  /// No description provided for @recipesFormIngredientNameHint.
  ///
  /// In en, this message translates to:
  /// **'Ingredient'**
  String get recipesFormIngredientNameHint;

  /// No description provided for @recipesFormAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get recipesFormAmountHint;

  /// No description provided for @recipesFormAddIngredient.
  ///
  /// In en, this message translates to:
  /// **'Add ingredient'**
  String get recipesFormAddIngredient;

  /// No description provided for @recipesFormStepHint.
  ///
  /// In en, this message translates to:
  /// **'Step {number}'**
  String recipesFormStepHint(int number);

  /// No description provided for @recipesFormAddStep.
  ///
  /// In en, this message translates to:
  /// **'Add step'**
  String get recipesFormAddStep;

  /// No description provided for @recipesCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Create recipe'**
  String get recipesCreateButton;

  /// No description provided for @recipesSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get recipesSaveButton;

  /// No description provided for @recipesCookStart.
  ///
  /// In en, this message translates to:
  /// **'Start cooking'**
  String get recipesCookStart;

  /// Progress counter in cook mode
  ///
  /// In en, this message translates to:
  /// **'Step {current}/{total}'**
  String recipesCookStep(int current, int total);

  /// No description provided for @recipesCookNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get recipesCookNext;

  /// No description provided for @recipesCookFinish.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get recipesCookFinish;

  /// No description provided for @recipesCookEmpty.
  ///
  /// In en, this message translates to:
  /// **'This recipe has no steps yet.'**
  String get recipesCookEmpty;

  /// No description provided for @recipesCookTimerStart.
  ///
  /// In en, this message translates to:
  /// **'Start timer'**
  String get recipesCookTimerStart;

  /// No description provided for @recipesCookTimerReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get recipesCookTimerReset;

  /// No description provided for @recipesCookTimerDone.
  ///
  /// In en, this message translates to:
  /// **'Timer done'**
  String get recipesCookTimerDone;

  /// No description provided for @recipesCookTimerAddMinute.
  ///
  /// In en, this message translates to:
  /// **'+1 min'**
  String get recipesCookTimerAddMinute;

  /// No description provided for @recipesCookTimerRemoveMinute.
  ///
  /// In en, this message translates to:
  /// **'-1 min'**
  String get recipesCookTimerRemoveMinute;

  /// No description provided for @recipesCookTimerAddSecond.
  ///
  /// In en, this message translates to:
  /// **'+10 sec'**
  String get recipesCookTimerAddSecond;

  /// No description provided for @recipesCookTimerRemoveSecond.
  ///
  /// In en, this message translates to:
  /// **'-10 sec'**
  String get recipesCookTimerRemoveSecond;

  /// No description provided for @recipesCookTimerPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get recipesCookTimerPause;

  /// No description provided for @recipesCookTimerResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get recipesCookTimerResume;

  /// No description provided for @recipesFormStepTimerToggle.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get recipesFormStepTimerToggle;

  /// No description provided for @recipesFormStepTimerMinutes.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get recipesFormStepTimerMinutes;

  /// No description provided for @recipesFormStepTimerSeconds.
  ///
  /// In en, this message translates to:
  /// **'Sec'**
  String get recipesFormStepTimerSeconds;

  /// No description provided for @dietarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us what to keep out of your recipe suggestions. You can change this any time.'**
  String get dietarySubtitle;

  /// No description provided for @dietaryAllergensTitle.
  ///
  /// In en, this message translates to:
  /// **'Allergens'**
  String get dietaryAllergensTitle;

  /// No description provided for @dietaryDietsTitle.
  ///
  /// In en, this message translates to:
  /// **'Diets'**
  String get dietaryDietsTitle;

  /// No description provided for @dietaryDislikesTitle.
  ///
  /// In en, this message translates to:
  /// **'Dislikes'**
  String get dietaryDislikesTitle;

  /// No description provided for @dietaryNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Other dislikes'**
  String get dietaryNoteLabel;

  /// No description provided for @dietaryNoteHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. very spicy food'**
  String get dietaryNoteHint;

  /// No description provided for @dietarySavedSnack.
  ///
  /// In en, this message translates to:
  /// **'Preferences saved'**
  String get dietarySavedSnack;

  /// No description provided for @dietaryAllergenGluten.
  ///
  /// In en, this message translates to:
  /// **'Gluten'**
  String get dietaryAllergenGluten;

  /// No description provided for @dietaryAllergenCrustaceans.
  ///
  /// In en, this message translates to:
  /// **'Crustaceans'**
  String get dietaryAllergenCrustaceans;

  /// No description provided for @dietaryAllergenEggs.
  ///
  /// In en, this message translates to:
  /// **'Eggs'**
  String get dietaryAllergenEggs;

  /// No description provided for @dietaryAllergenFish.
  ///
  /// In en, this message translates to:
  /// **'Fish'**
  String get dietaryAllergenFish;

  /// No description provided for @dietaryAllergenPeanuts.
  ///
  /// In en, this message translates to:
  /// **'Peanuts'**
  String get dietaryAllergenPeanuts;

  /// No description provided for @dietaryAllergenSoy.
  ///
  /// In en, this message translates to:
  /// **'Soy'**
  String get dietaryAllergenSoy;

  /// No description provided for @dietaryAllergenMilk.
  ///
  /// In en, this message translates to:
  /// **'Milk'**
  String get dietaryAllergenMilk;

  /// No description provided for @dietaryAllergenTreeNuts.
  ///
  /// In en, this message translates to:
  /// **'Tree nuts'**
  String get dietaryAllergenTreeNuts;

  /// No description provided for @dietaryAllergenCelery.
  ///
  /// In en, this message translates to:
  /// **'Celery'**
  String get dietaryAllergenCelery;

  /// No description provided for @dietaryAllergenMustard.
  ///
  /// In en, this message translates to:
  /// **'Mustard'**
  String get dietaryAllergenMustard;

  /// No description provided for @dietaryAllergenSesame.
  ///
  /// In en, this message translates to:
  /// **'Sesame'**
  String get dietaryAllergenSesame;

  /// No description provided for @dietaryAllergenSulphites.
  ///
  /// In en, this message translates to:
  /// **'Sulphites'**
  String get dietaryAllergenSulphites;

  /// No description provided for @dietaryAllergenLupin.
  ///
  /// In en, this message translates to:
  /// **'Lupin'**
  String get dietaryAllergenLupin;

  /// No description provided for @dietaryAllergenMolluscs.
  ///
  /// In en, this message translates to:
  /// **'Molluscs'**
  String get dietaryAllergenMolluscs;

  /// No description provided for @dietaryDietVegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get dietaryDietVegetarian;

  /// No description provided for @dietaryDietVegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get dietaryDietVegan;

  /// No description provided for @dietaryDietPescetarian.
  ///
  /// In en, this message translates to:
  /// **'Pescetarian'**
  String get dietaryDietPescetarian;

  /// No description provided for @dietaryDietHalal.
  ///
  /// In en, this message translates to:
  /// **'Halal'**
  String get dietaryDietHalal;

  /// No description provided for @dietaryDietKosher.
  ///
  /// In en, this message translates to:
  /// **'Kosher'**
  String get dietaryDietKosher;

  /// No description provided for @dietaryDietGlutenFree.
  ///
  /// In en, this message translates to:
  /// **'Gluten-free'**
  String get dietaryDietGlutenFree;

  /// No description provided for @dietaryDietLactoseFree.
  ///
  /// In en, this message translates to:
  /// **'Lactose-free'**
  String get dietaryDietLactoseFree;

  /// No description provided for @dietaryDietLowCarb.
  ///
  /// In en, this message translates to:
  /// **'Low-carb'**
  String get dietaryDietLowCarb;

  /// No description provided for @dietaryDislikeCoriander.
  ///
  /// In en, this message translates to:
  /// **'Coriander'**
  String get dietaryDislikeCoriander;

  /// No description provided for @dietaryDislikeOlives.
  ///
  /// In en, this message translates to:
  /// **'Olives'**
  String get dietaryDislikeOlives;

  /// No description provided for @dietaryDislikeMushrooms.
  ///
  /// In en, this message translates to:
  /// **'Mushrooms'**
  String get dietaryDislikeMushrooms;

  /// No description provided for @dietaryDislikeOffal.
  ///
  /// In en, this message translates to:
  /// **'Offal'**
  String get dietaryDislikeOffal;

  /// No description provided for @dietaryDislikeBlueCheese.
  ///
  /// In en, this message translates to:
  /// **'Blue cheese'**
  String get dietaryDislikeBlueCheese;

  /// No description provided for @privacyDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This is a portfolio project. The text below explains how the app handles your data but is not a legally reviewed privacy policy.'**
  String get privacyDisclaimer;

  /// No description provided for @privacyDataTitle.
  ///
  /// In en, this message translates to:
  /// **'What we store'**
  String get privacyDataTitle;

  /// No description provided for @privacyDataBody.
  ///
  /// In en, this message translates to:
  /// **'Your account email, your display name and chosen avatar, and the household data you create: inventory items, shopping lists, recipes and your dietary preferences.'**
  String get privacyDataBody;

  /// No description provided for @privacyStorageTitle.
  ///
  /// In en, this message translates to:
  /// **'Where it\'s stored'**
  String get privacyStorageTitle;

  /// No description provided for @privacyStorageBody.
  ///
  /// In en, this message translates to:
  /// **'Your data lives in a Supabase backend (authentication and Postgres database). Access is protected by row-level security so only you and the members of your household can read it.'**
  String get privacyStorageBody;

  /// No description provided for @privacyConsentTitle.
  ///
  /// In en, this message translates to:
  /// **'Your consent'**
  String get privacyConsentTitle;

  /// No description provided for @privacyConsentBody.
  ///
  /// In en, this message translates to:
  /// **'You agree to this handling when you create an account. You can withdraw consent by deleting your account, which removes your profile and household data.'**
  String get privacyConsentBody;

  /// No description provided for @privacyRightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your rights & contact'**
  String get privacyRightsTitle;

  /// No description provided for @privacyRightsBody.
  ///
  /// In en, this message translates to:
  /// **'You can view and edit your personal data in the app. For any request about your data, reach out via the contact option on the help screen.'**
  String get privacyRightsBody;

  /// No description provided for @helpFaqAddQ.
  ///
  /// In en, this message translates to:
  /// **'How do I add an item?'**
  String get helpFaqAddQ;

  /// No description provided for @helpFaqAddA.
  ///
  /// In en, this message translates to:
  /// **'On the inventory tab, tap the add button. You can scan a barcode, search the Open Food Facts database, or enter a product manually.'**
  String get helpFaqAddA;

  /// No description provided for @helpFaqExpiryQ.
  ///
  /// In en, this message translates to:
  /// **'How do expiry reminders work?'**
  String get helpFaqExpiryQ;

  /// No description provided for @helpFaqExpiryA.
  ///
  /// In en, this message translates to:
  /// **'Items nearing their best-before date are highlighted across the app. Scheduled notifications before expiry are coming in a later update.'**
  String get helpFaqExpiryA;

  /// No description provided for @helpFaqHouseholdQ.
  ///
  /// In en, this message translates to:
  /// **'How do I share with my household?'**
  String get helpFaqHouseholdQ;

  /// No description provided for @helpFaqHouseholdA.
  ///
  /// In en, this message translates to:
  /// **'Open the household screen from your profile and invite members with a code. Everyone in the household shares the same inventory, shopping list and recipes.'**
  String get helpFaqHouseholdA;

  /// No description provided for @helpFaqOfflineQ.
  ///
  /// In en, this message translates to:
  /// **'Does Zaiko work offline?'**
  String get helpFaqOfflineQ;

  /// No description provided for @helpFaqOfflineA.
  ///
  /// In en, this message translates to:
  /// **'Not yet. Zaiko currently needs an internet connection to sync with the backend. Offline support is planned.'**
  String get helpFaqOfflineA;

  /// No description provided for @helpContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Still need help?'**
  String get helpContactTitle;

  /// No description provided for @helpContactBody.
  ///
  /// In en, this message translates to:
  /// **'Send us a message and we\'ll get back to you.'**
  String get helpContactBody;

  /// No description provided for @helpContactButton.
  ///
  /// In en, this message translates to:
  /// **'Email us'**
  String get helpContactButton;

  /// No description provided for @helpContactError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open your mail app. Please email us at support@zaiko.app.'**
  String get helpContactError;
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

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
  String get registerTitle => 'Create account';

  @override
  String get registerSubtitle => 'Create your account to get started.';

  @override
  String get registerConfirmPasswordLabel => 'Confirm password';

  @override
  String get registerPasswordMismatch => 'The passwords don\'t match';

  @override
  String get registerPrivacyConsent => 'I accept the Privacy Policy.';

  @override
  String get registerPrivacyPolicyLink => 'Privacy Policy';

  @override
  String get inventoryEmptyTitle => 'Your inventory is empty';

  @override
  String get inventoryEmptyMessage =>
      'Items you add to your fridge and pantry will show up here.';

  @override
  String get shoppingTitle => 'Shopping';

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
  String get inventoryStatExpiring => 'Expiring soon';

  @override
  String get inventoryStatExpired => 'Expired';

  @override
  String get inventoryStatFresh => 'Fresh';

  @override
  String locationSearchHint(String name) {
    return 'Search in $name…';
  }

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
  String get shoppingAddHint => 'Add item…';

  @override
  String shoppingListCount(int count) {
    return '$count items on the list';
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
    return 'Good morning, $name';
  }

  @override
  String homeExpiringCount(int count) {
    return '$count items expiring soon';
  }

  @override
  String get homeSearchHint => 'Search your stock…';

  @override
  String get homeCategories => 'Categories';

  @override
  String get homeExpiringSoon => 'Expiring soon';

  @override
  String get commonAll => 'All';

  @override
  String get commonBack => 'Back';

  @override
  String get onboardingTitle => 'Set up your household';

  @override
  String get onboardingSubtitle =>
      'Create a household to start tracking, or join one you were invited to.';

  @override
  String get onboardingCreateTitle => 'Create a household';

  @override
  String get onboardingCreateSubtitle =>
      'Start fresh — you can invite others afterwards.';

  @override
  String get onboardingNameLabel => 'Household name';

  @override
  String get onboardingNameHint => 'e.g. Lindenhof';

  @override
  String get onboardingNameEmpty => 'Please enter a household name';

  @override
  String get onboardingCreateButton => 'Create household';

  @override
  String get onboardingJoinTitle => 'Join a household';

  @override
  String get onboardingJoinSubtitle => 'Enter the invite code you received.';

  @override
  String get onboardingCodeLabel => 'Invite code';

  @override
  String get onboardingCodeHint => '6-character code';

  @override
  String get onboardingCodeEmpty => 'Please enter an invite code';

  @override
  String get onboardingJoinButton => 'Join';

  @override
  String get inviteTitle => 'Invite member';

  @override
  String get inviteSubtitle =>
      'Share this code, or let them scan the QR. It expires in 15 minutes.';

  @override
  String get inviteExpiresHint => 'Valid for 15 minutes';

  @override
  String get inviteCreateButton => 'Create invite code';

  @override
  String get inviteRegenerate => 'New code';

  @override
  String get householdMembersTitle => 'Members';

  @override
  String get householdRoleOwner => 'Owner';

  @override
  String get householdRoleMember => 'Member';

  @override
  String get householdYou => 'You';

  @override
  String get householdRename => 'Rename household';

  @override
  String get householdRenameSave => 'Save';

  @override
  String get householdRemoveMember => 'Remove';

  @override
  String get householdRemoveMemberTitle => 'Remove member?';

  @override
  String get householdRemoveMemberMessage =>
      'They will lose access to this household.';

  @override
  String get householdLeave => 'Leave household';

  @override
  String get householdLeaveTitle => 'Leave household?';

  @override
  String get householdLeaveMessage =>
      'You\'ll lose access to its inventory and shopping list.';

  @override
  String get householdLeaveConfirm => 'Leave';

  @override
  String get joinConfirmMessage => 'Do you want to join this household?';

  @override
  String get joinAcceptButton => 'Join household';

  @override
  String get joinSignInPrompt =>
      'Sign in or create an account to join this household.';

  @override
  String get joinSignInButton => 'Sign in & join';

  @override
  String get joinSuccess => 'You joined the household.';

  @override
  String get joinToProfileButton => 'Back to profile';

  @override
  String get householdErrorAlreadyMember =>
      'You\'re already in a household. Leave it first to join another.';

  @override
  String get householdErrorInviteNotFound => 'This invite code doesn\'t exist.';

  @override
  String get householdErrorInviteUsed => 'This invite has already been used.';

  @override
  String get householdErrorInviteExpired =>
      'This invite has expired. Ask for a new one.';

  @override
  String get householdErrorGeneric => 'Something went wrong. Please try again.';
}

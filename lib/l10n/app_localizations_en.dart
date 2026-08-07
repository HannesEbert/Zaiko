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
  String get forgotPasswordLink => 'Forgot password?';

  @override
  String get forgotPasswordTitle => 'Reset password';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your email and we\'ll send you a link to reset your password.';

  @override
  String get forgotPasswordSendButton => 'Send reset link';

  @override
  String get forgotPasswordEmailSent =>
      'Check your email for a link to reset your password.';

  @override
  String get forgotPasswordSentTitle => 'Check your email';

  @override
  String forgotPasswordSentBody(String email) {
    return 'We\'ve sent a password reset link to $email. Open it to choose a new password.';
  }

  @override
  String get forgotPasswordResend => 'Resend email';

  @override
  String get forgotPasswordBackToLogin => 'Back to login';

  @override
  String get resetPasswordTitle => 'New password';

  @override
  String get resetPasswordSubtitle => 'Choose a new password for your account.';

  @override
  String get resetPasswordNewPasswordLabel => 'New password';

  @override
  String get resetPasswordConfirmLabel => 'Confirm new password';

  @override
  String get resetPasswordSaveButton => 'Save new password';

  @override
  String get resetPasswordSuccess =>
      'Password updated. Please sign in with your new password.';

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
  String get profileDietary => 'Diet & preferences';

  @override
  String get profileInfoSection => 'Info';

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
  String get commonSave => 'Save';

  @override
  String get profileDisplayNameLabel => 'Display name';

  @override
  String get profileDisplayNameRequired => 'Please enter a display name';

  @override
  String get profileEmailLabel => 'Email';

  @override
  String get profileEmailChangeHint =>
      'Changing your email and password will be available soon.';

  @override
  String get profileAvatarSectionTitle => 'Avatar';

  @override
  String get profileAvatarDefault => 'Initial';

  @override
  String get profileErrorGeneric =>
      'Couldn\'t save your profile. Please try again.';

  @override
  String get profileMemberSince => 'Member since';

  @override
  String get profilePersonalDataNoHousehold => 'No household';

  @override
  String remindersNotificationTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items are expiring soon',
      one: '1 item is expiring soon',
    );
    return '$_temp0';
  }

  @override
  String get remindersSubtitle =>
      'Get a daily reminder before your food expires. Reminders live on this device.';

  @override
  String get remindersEnableLabel => 'Expiry reminders';

  @override
  String get remindersLeadDaysLabel => 'Warn me before';

  @override
  String remindersLeadDaysValue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days before',
      one: '1 day before',
    );
    return '$_temp0';
  }

  @override
  String get remindersTimeLabel => 'Reminder time';

  @override
  String get remindersSavedSnack => 'Reminders saved';

  @override
  String get remindersPermissionDenied =>
      'Notifications are turned off. Enable them in system settings.';

  @override
  String get commonDone => 'Done';

  @override
  String get profileHouseholdEmptyTitle => 'Your household';

  @override
  String get profileHouseholdEmptyMessage =>
      'Link and manage the household you share here.';

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
  String get locationUnassignedName => 'No location';

  @override
  String locationSearchHint(String name) {
    return 'Search in $name…';
  }

  @override
  String get inventoryAllItemsTitle => 'All items';

  @override
  String get inventorySearchEmpty => 'No matches';

  @override
  String get inventorySortTitle => 'Sort';

  @override
  String get inventorySortRecent => 'Recently added';

  @override
  String get inventorySortName => 'Name A–Z';

  @override
  String get inventorySortExpiry => 'Expiry date';

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
  String get itemDetailQuantity => 'Count';

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
  String get shoppingAddTitle => 'Add to list';

  @override
  String get shoppingEditTitle => 'Edit item';

  @override
  String get shoppingQuantityLabel => 'Quantity';

  @override
  String get shoppingQuantityHint => 'e.g. 2 × 1 l';

  @override
  String get shoppingAddButton => 'Add';

  @override
  String get shoppingSaveButton => 'Save';

  @override
  String get shoppingClearCheckedTooltip => 'Clear bought items';

  @override
  String get shoppingDoneSection => 'Bought';

  @override
  String get shoppingLoadError => 'Couldn\'t load your shopping list.';

  @override
  String get shoppingErrorGeneric => 'Something went wrong. Please try again.';

  @override
  String get shoppingErrorNotMember => 'You don\'t have access to this list.';

  @override
  String get shoppingErrorNotFound => 'This item no longer exists.';

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
  String get settingAppearanceDark => 'Dark';

  @override
  String get settingAppearanceHint =>
      'Zaiko is dark-only for now. A light theme and a toggle will come in a later update.';

  @override
  String get settingLanguage => 'Language';

  @override
  String get settingLanguageSystem => 'System';

  @override
  String get settingLanguageGerman => 'German';

  @override
  String get settingLanguageEnglish => 'English';

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

  @override
  String get homeGreetingGeneric => 'Good morning';

  @override
  String inventoryLocationExpiringSoon(int count) {
    return '$count expiring soon';
  }

  @override
  String inventoryLocationExpired(int count) {
    return '$count expired';
  }

  @override
  String get inventoryLoadError => 'Couldn\'t load your inventory.';

  @override
  String get inventoryLocationEmpty => 'No items in this location yet.';

  @override
  String get inventoryRecentlyAddedEmpty => 'Nothing added yet.';

  @override
  String get homeExpiringEmpty => 'Nothing expiring soon.';

  @override
  String get commonRetry => 'Try again';

  @override
  String get expiryExpired => 'Expired';

  @override
  String get expiryToday => 'Today';

  @override
  String get expiryTomorrow => 'Tomorrow';

  @override
  String expiryInDays(int count) {
    return 'In $count days';
  }

  @override
  String get itemDetailExpiresToday => 'Expires today';

  @override
  String get itemDetailExpiresTomorrow => 'Expires tomorrow';

  @override
  String itemDetailExpiresInDays(int count) {
    return 'Expires in $count days';
  }

  @override
  String get itemDetailNoDate => 'Not set';

  @override
  String get relativeToday => 'Today';

  @override
  String get relativeYesterday => 'Yesterday';

  @override
  String relativeDaysAgo(int count) {
    return '$count days ago';
  }

  @override
  String get unitPiece => 'pcs';

  @override
  String get unitPackage => 'pack';

  @override
  String get itemFormAddTitle => 'Add item';

  @override
  String get itemFormEditTitle => 'Edit item';

  @override
  String get itemFormNameLabel => 'Name';

  @override
  String get itemFormNameHint => 'e.g. Milk';

  @override
  String get itemFormNameEmpty => 'Please enter a name';

  @override
  String get itemFormQuantityLabel => 'Quantity';

  @override
  String get itemFormQuantityInvalid => 'Enter a quantity greater than 0';

  @override
  String get itemFormCountLabel => 'Count';

  @override
  String get itemFormCountInvalid => 'Enter a count of at least 1';

  @override
  String get itemFormUnitLabel => 'Unit';

  @override
  String get itemFormLocationLabel => 'Location';

  @override
  String get itemFormCategoryLabel => 'Category';

  @override
  String get itemFormBestBeforeLabel => 'Best before';

  @override
  String get itemFormNone => 'None';

  @override
  String get itemFormAddButton => 'Add item';

  @override
  String get itemFormSaveButton => 'Save changes';

  @override
  String get itemFormAddedSnack => 'Item added';

  @override
  String get itemFormSavedSnack => 'Changes saved';

  @override
  String get itemMovedToTrash => 'Moved to trash';

  @override
  String get itemRestoredSnack => 'Item restored';

  @override
  String get pickerLocationTitle => 'Choose location';

  @override
  String get pickerCategoryTitle => 'Choose category';

  @override
  String get pickerNone => 'None';

  @override
  String get pickerNew => 'New';

  @override
  String get pickerManage => 'Manage';

  @override
  String get taxonomyNameLabel => 'Name';

  @override
  String get taxonomyColorLabel => 'Color';

  @override
  String get taxonomyIconLabel => 'Icon';

  @override
  String get taxonomyNewLocationTitle => 'New location';

  @override
  String get taxonomyEditLocationTitle => 'Edit location';

  @override
  String get taxonomyNewCategoryTitle => 'New category';

  @override
  String get taxonomyEditCategoryTitle => 'Edit category';

  @override
  String get taxonomyNameEmpty => 'Please enter a name';

  @override
  String get taxonomyCreateButton => 'Create';

  @override
  String get taxonomySaveButton => 'Save';

  @override
  String get manageLocationsTitle => 'Storage locations';

  @override
  String get manageCategoriesTitle => 'Categories';

  @override
  String get manageAddLocation => 'Add location';

  @override
  String get manageAddCategory => 'Add category';

  @override
  String get manageLocationsEmpty => 'No storage locations yet.';

  @override
  String get manageCategoriesEmpty => 'No custom categories yet.';

  @override
  String get manageEdit => 'Edit';

  @override
  String get manageDelete => 'Delete';

  @override
  String get manageDefaultBadge => 'Default';

  @override
  String get manageDeleteLocationTitle => 'Delete location?';

  @override
  String get manageDeleteCategoryTitle => 'Delete category?';

  @override
  String manageDeleteItemsWarning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items will lose this assignment.',
      one: '1 item will lose this assignment.',
      zero: 'This isn\'t used by any item yet.',
    );
    return '$_temp0';
  }

  @override
  String get manageDeleteConfirm => 'Delete';

  @override
  String get trashTitle => 'Trash';

  @override
  String get trashSubtitle =>
      'Removed items are kept for 30 days, then deleted.';

  @override
  String get trashEmpty => 'Trash is empty.';

  @override
  String get trashRestore => 'Restore';

  @override
  String get inventoryTrashTooltip => 'Trash';

  @override
  String get inventoryErrorGeneric => 'Something went wrong. Please try again.';

  @override
  String get inventoryErrorNotMember =>
      'You don\'t have access to this household.';

  @override
  String get inventoryErrorNotFound => 'This item no longer exists.';

  @override
  String get scannerTitle => 'Scan barcode';

  @override
  String get scannerHint => 'Point the camera at a product barcode';

  @override
  String get scannerTorchTooltip => 'Torch';

  @override
  String get scannerResolving => 'Looking up product…';

  @override
  String get scannerPermissionTitle => 'Camera access needed';

  @override
  String get scannerPermissionBody =>
      'Zaiko needs camera access to scan barcodes. You can enable it in Settings.';

  @override
  String get scannerOpenSettings => 'Open Settings';

  @override
  String get scanNotFoundSnack => 'Product not found — enter it manually.';

  @override
  String get productSearchTitle => 'Search product';

  @override
  String get productSearchHint => 'Search by product name…';

  @override
  String get productSearchPrompt => 'Type to search Open Food Facts.';

  @override
  String get productSearchEmpty => 'No products found.';

  @override
  String get foodErrorNetwork =>
      'Open Food Facts is temporarily unavailable. Please try again shortly.';

  @override
  String get foodErrorRateLimited =>
      'Too many requests. Please try again in a moment.';

  @override
  String get foodErrorGeneric =>
      'Couldn\'t reach the product database. Please try again.';

  @override
  String get recipesFilterAlmostComplete => 'Almost complete';

  @override
  String get recipesFilterUnder30 => 'Under 30 min';

  @override
  String get recipesMatchComplete => 'All in stock';

  @override
  String recipesMatchCount(int matched, int total) {
    return '$matched/$total ingredients';
  }

  @override
  String get recipesUsesExpiring => 'Use up soon';

  @override
  String recipesMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String recipesServings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count servings',
      one: '1 serving',
    );
    return '$_temp0';
  }

  @override
  String get recipesLoadError => 'Couldn\'t load recipes.';

  @override
  String get recipesErrorGeneric => 'Something went wrong. Please try again.';

  @override
  String get recipesErrorNotMember => 'You\'re not a member of this household.';

  @override
  String get recipesErrorNotFound => 'This recipe no longer exists.';

  @override
  String recipesAddedToList(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Added $count ingredients to the list',
      one: 'Added 1 ingredient to the list',
    );
    return '$_temp0';
  }

  @override
  String get recipesNewTitle => 'New recipe';

  @override
  String get recipesEditTitle => 'Edit recipe';

  @override
  String get recipesEditAction => 'Edit';

  @override
  String get recipesDeleteAction => 'Delete';

  @override
  String get recipesDeleteTitle => 'Delete recipe?';

  @override
  String recipesDeleteMessage(String title) {
    return '\"$title\" will be removed for everyone in the household.';
  }

  @override
  String get recipesIngredientsSection => 'Ingredients';

  @override
  String get recipesIngredientsEmpty => 'No ingredients.';

  @override
  String get recipesStepsSection => 'Preparation';

  @override
  String get recipesStepsEmpty => 'No steps yet.';

  @override
  String get recipesInStock => 'In stock';

  @override
  String get recipesFormTitleLabel => 'Title';

  @override
  String get recipesFormTitleHint => 'e.g. Tomato pasta';

  @override
  String get recipesFormMinutesLabel => 'Time (minutes)';

  @override
  String get recipesFormServingsLabel => 'Servings';

  @override
  String get recipesFormIngredientNameHint => 'Ingredient';

  @override
  String get recipesFormAmountHint => 'Amount';

  @override
  String get recipesFormAddIngredient => 'Add ingredient';

  @override
  String recipesFormStepHint(int number) {
    return 'Step $number';
  }

  @override
  String get recipesFormAddStep => 'Add step';

  @override
  String get recipesCreateButton => 'Create recipe';

  @override
  String get recipesSaveButton => 'Save';

  @override
  String get recipesCookStart => 'Start cooking';

  @override
  String recipesCookStep(int current, int total) {
    return 'Step $current/$total';
  }

  @override
  String get recipesCookNext => 'Next';

  @override
  String get recipesCookFinish => 'Done';

  @override
  String get recipesCookEmpty => 'This recipe has no steps yet.';

  @override
  String get recipesCookTimerStart => 'Start timer';

  @override
  String get recipesCookTimerReset => 'Reset';

  @override
  String get recipesCookTimerDone => 'Timer done';

  @override
  String get recipesCookTimerAddMinute => '+1 min';

  @override
  String get recipesCookTimerRemoveMinute => '-1 min';

  @override
  String get recipesCookTimerAddSecond => '+10 sec';

  @override
  String get recipesCookTimerRemoveSecond => '-10 sec';

  @override
  String get recipesCookTimerPause => 'Pause';

  @override
  String get recipesCookTimerResume => 'Resume';

  @override
  String get recipesFormStepTimerToggle => 'Timer';

  @override
  String get recipesFormStepTimerMinutes => 'Min';

  @override
  String get recipesFormStepTimerSeconds => 'Sec';

  @override
  String get dietarySubtitle =>
      'Tell us what to keep out of your recipe suggestions. You can change this any time.';

  @override
  String get dietaryAllergensTitle => 'Allergens';

  @override
  String get dietaryDietsTitle => 'Diets';

  @override
  String get dietaryDislikesTitle => 'Dislikes';

  @override
  String get dietaryNoteLabel => 'Other dislikes';

  @override
  String get dietaryNoteHint => 'e.g. very spicy food';

  @override
  String get dietarySavedSnack => 'Preferences saved';

  @override
  String get dietaryAllergenGluten => 'Gluten';

  @override
  String get dietaryAllergenCrustaceans => 'Crustaceans';

  @override
  String get dietaryAllergenEggs => 'Eggs';

  @override
  String get dietaryAllergenFish => 'Fish';

  @override
  String get dietaryAllergenPeanuts => 'Peanuts';

  @override
  String get dietaryAllergenSoy => 'Soy';

  @override
  String get dietaryAllergenMilk => 'Milk';

  @override
  String get dietaryAllergenTreeNuts => 'Tree nuts';

  @override
  String get dietaryAllergenCelery => 'Celery';

  @override
  String get dietaryAllergenMustard => 'Mustard';

  @override
  String get dietaryAllergenSesame => 'Sesame';

  @override
  String get dietaryAllergenSulphites => 'Sulphites';

  @override
  String get dietaryAllergenLupin => 'Lupin';

  @override
  String get dietaryAllergenMolluscs => 'Molluscs';

  @override
  String get dietaryDietVegetarian => 'Vegetarian';

  @override
  String get dietaryDietVegan => 'Vegan';

  @override
  String get dietaryDietPescetarian => 'Pescetarian';

  @override
  String get dietaryDietHalal => 'Halal';

  @override
  String get dietaryDietKosher => 'Kosher';

  @override
  String get dietaryDietGlutenFree => 'Gluten-free';

  @override
  String get dietaryDietLactoseFree => 'Lactose-free';

  @override
  String get dietaryDietLowCarb => 'Low-carb';

  @override
  String get dietaryDislikeCoriander => 'Coriander';

  @override
  String get dietaryDislikeOlives => 'Olives';

  @override
  String get dietaryDislikeMushrooms => 'Mushrooms';

  @override
  String get dietaryDislikeOffal => 'Offal';

  @override
  String get dietaryDislikeBlueCheese => 'Blue cheese';

  @override
  String get privacyDisclaimer =>
      'This is a portfolio project. The text below explains how the app handles your data but is not a legally reviewed privacy policy.';

  @override
  String get privacyDataTitle => 'What we store';

  @override
  String get privacyDataBody =>
      'Your account email, your display name and chosen avatar, and the household data you create: inventory items, shopping lists, recipes and your dietary preferences.';

  @override
  String get privacyStorageTitle => 'Where it\'s stored';

  @override
  String get privacyStorageBody =>
      'Your data lives in a Supabase backend (authentication and Postgres database). Access is protected by row-level security so only you and the members of your household can read it.';

  @override
  String get privacyConsentTitle => 'Your consent';

  @override
  String get privacyConsentBody =>
      'You agree to this handling when you create an account. You can withdraw consent by deleting your account, which removes your profile and household data.';

  @override
  String get privacyRightsTitle => 'Your rights & contact';

  @override
  String get privacyRightsBody =>
      'You can view and edit your personal data in the app. For any request about your data, reach out via the contact option on the help screen.';

  @override
  String get helpFaqAddQ => 'How do I add an item?';

  @override
  String get helpFaqAddA =>
      'On the inventory tab, tap the add button. You can scan a barcode, search the Open Food Facts database, or enter a product manually.';

  @override
  String get helpFaqExpiryQ => 'How do expiry reminders work?';

  @override
  String get helpFaqExpiryA =>
      'Items nearing their best-before date are highlighted across the app. Scheduled notifications before expiry are coming in a later update.';

  @override
  String get helpFaqHouseholdQ => 'How do I share with my household?';

  @override
  String get helpFaqHouseholdA =>
      'Open the household screen from your profile and invite members with a code. Everyone in the household shares the same inventory, shopping list and recipes.';

  @override
  String get helpFaqOfflineQ => 'Does Zaiko work offline?';

  @override
  String get helpFaqOfflineA =>
      'Not yet. Zaiko currently needs an internet connection to sync with the backend. Offline support is planned.';

  @override
  String get helpContactTitle => 'Still need help?';

  @override
  String get helpContactBody => 'Send us a message and we\'ll get back to you.';

  @override
  String get helpContactButton => 'Email us';

  @override
  String get helpContactError =>
      'Couldn\'t open your mail app. Please email us at support@zaiko.app.';
}

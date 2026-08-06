// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get navHome => 'Start';

  @override
  String get navInventory => 'Inventar';

  @override
  String get navShopping => 'Einkauf';

  @override
  String get navRecipes => 'Rezepte';

  @override
  String get navProfile => 'Profil';

  @override
  String get loginTitle => 'Anmelden';

  @override
  String loginWelcome(String appName) {
    return 'Willkommen bei $appName';
  }

  @override
  String get loginEmailLabel => 'E-Mail';

  @override
  String get loginPasswordLabel => 'Passwort';

  @override
  String get loginSignInButton => 'Anmelden';

  @override
  String get loginCreateAccountButton => 'Konto erstellen';

  @override
  String get loginEmailEmpty => 'Bitte gib deine E-Mail-Adresse ein';

  @override
  String get loginEmailInvalid => 'Bitte gib eine gültige E-Mail-Adresse ein';

  @override
  String get loginPasswordEmpty => 'Bitte gib dein Passwort ein';

  @override
  String loginPasswordTooShort(int count) {
    return 'Das Passwort muss mindestens $count Zeichen lang sein';
  }

  @override
  String get loginConfirmEmailSent =>
      'Bitte bestätige dein Konto über die E-Mail in deinem Postfach.';

  @override
  String get loginGenericError =>
      'Etwas ist schiefgelaufen. Bitte versuche es erneut.';

  @override
  String get registerTitle => 'Konto erstellen';

  @override
  String get registerSubtitle => 'Erstelle dein Konto, um loszulegen.';

  @override
  String get registerConfirmPasswordLabel => 'Passwort bestätigen';

  @override
  String get registerPasswordMismatch => 'Die Passwörter stimmen nicht überein';

  @override
  String get registerPrivacyConsent =>
      'Ich akzeptiere die Datenschutzerklärung.';

  @override
  String get registerPrivacyPolicyLink => 'Datenschutzerklärung';

  @override
  String get forgotPasswordLink => 'Passwort vergessen?';

  @override
  String get forgotPasswordTitle => 'Passwort zurücksetzen';

  @override
  String get forgotPasswordSubtitle =>
      'Gib deine E-Mail-Adresse ein und wir senden dir einen Link zum Zurücksetzen deines Passworts.';

  @override
  String get forgotPasswordSendButton => 'Link senden';

  @override
  String get forgotPasswordEmailSent =>
      'Prüfe deine E-Mails für den Link zum Zurücksetzen deines Passworts.';

  @override
  String get forgotPasswordSentTitle => 'Prüfe deine E-Mails';

  @override
  String forgotPasswordSentBody(String email) {
    return 'Wir haben einen Link zum Zurücksetzen an $email gesendet. Öffne ihn, um ein neues Passwort zu wählen.';
  }

  @override
  String get forgotPasswordResend => 'E-Mail erneut senden';

  @override
  String get forgotPasswordBackToLogin => 'Zurück zur Anmeldung';

  @override
  String get resetPasswordTitle => 'Neues Passwort';

  @override
  String get resetPasswordSubtitle =>
      'Wähle ein neues Passwort für dein Konto.';

  @override
  String get resetPasswordNewPasswordLabel => 'Neues Passwort';

  @override
  String get resetPasswordConfirmLabel => 'Neues Passwort bestätigen';

  @override
  String get resetPasswordSaveButton => 'Neues Passwort speichern';

  @override
  String get resetPasswordSuccess =>
      'Passwort aktualisiert. Bitte melde dich mit deinem neuen Passwort an.';

  @override
  String get inventoryEmptyTitle => 'Dein Inventar ist leer';

  @override
  String get inventoryEmptyMessage =>
      'Lebensmittel, die du zu Kühlschrank und Vorrat hinzufügst, erscheinen hier.';

  @override
  String get shoppingTitle => 'Einkauf';

  @override
  String get shoppingEmptyTitle => 'Deine Einkaufsliste ist leer';

  @override
  String get shoppingEmptyMessage =>
      'Dinge, die du kaufen möchtest, erscheinen hier.';

  @override
  String get recipesTitle => 'Rezepte';

  @override
  String get recipesEmptyTitle => 'Noch keine Rezepte';

  @override
  String get recipesEmptyMessage =>
      'Rezeptideen aus deinem Vorrat erscheinen hier.';

  @override
  String get joinTitle => 'Haushalt beitreten';

  @override
  String get joinInvited => 'Du wurdest zu einem Haushalt eingeladen';

  @override
  String joinConnectionCode(String code) {
    return 'Verbindungscode: $code';
  }

  @override
  String get homeTitle => 'Start';

  @override
  String get homeEmptyTitle => 'Deine Übersicht folgt bald';

  @override
  String get homeEmptyMessage =>
      'Bald ablaufende Lebensmittel, Kurzstatistiken und Schnellzugriffe erscheinen hier.';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileManageAccount => 'Profil verwalten';

  @override
  String get profilePersonalData => 'Persönliche Daten';

  @override
  String get profileReminders => 'MHD-Erinnerungen';

  @override
  String get profileHousehold => 'Haushalt';

  @override
  String get profileSettings => 'Einstellungen';

  @override
  String get profilePrivacy => 'Datenschutz';

  @override
  String get profileHelp => 'Hilfe';

  @override
  String get profileSignOut => 'Abmelden';

  @override
  String get profileSignOutDialogTitle => 'Abmelden?';

  @override
  String get profileSignOutDialogMessage =>
      'Du musst dich erneut anmelden, um auf deinen Haushalt zuzugreifen.';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonSave => 'Speichern';

  @override
  String get profileDisplayNameLabel => 'Anzeigename';

  @override
  String get profileDisplayNameRequired => 'Bitte einen Anzeigenamen eingeben';

  @override
  String get profileEmailLabel => 'E-Mail';

  @override
  String get profileEmailChangeHint =>
      'Das Ändern von E-Mail und Passwort folgt bald.';

  @override
  String get profileAvatarSectionTitle => 'Avatar';

  @override
  String get profileAvatarDefault => 'Initiale';

  @override
  String get profileErrorGeneric =>
      'Profil konnte nicht gespeichert werden. Bitte erneut versuchen.';

  @override
  String get profileMemberSince => 'Mitglied seit';

  @override
  String get profilePersonalDataNoHousehold => 'Kein Haushalt';

  @override
  String get profileRemindersEmptyTitle => 'MHD-Erinnerungen';

  @override
  String get profileRemindersEmptyMessage =>
      'Lege fest, wann du vor dem Ablauf deiner Lebensmittel erinnert werden möchtest.';

  @override
  String get profileHouseholdEmptyTitle => 'Dein Haushalt';

  @override
  String get profileHouseholdEmptyMessage =>
      'Hier verknüpfst und verwaltest du deinen gemeinsamen Haushalt.';

  @override
  String get profileSettingsEmptyTitle => 'Einstellungen';

  @override
  String get profileSettingsEmptyMessage =>
      'App-Einstellungen erscheinen hier.';

  @override
  String get profilePrivacyEmptyTitle => 'Datenschutz';

  @override
  String get profilePrivacyEmptyMessage =>
      'Die Datenschutzerklärung und die Datenschutzeinstellungen erscheinen hier.';

  @override
  String get profileHelpEmptyTitle => 'Hilfe';

  @override
  String get profileHelpEmptyMessage => 'Hilfe und Support erscheinen hier.';

  @override
  String get loginTagline => '在庫 · Inventar';

  @override
  String get loginHeadline => 'Behalte den Überblick über deine Lebensmittel.';

  @override
  String get loginSubtitle =>
      'Weniger wegwerfen, smarter einkaufen — gemeinsam im Haushalt.';

  @override
  String get loginEmailHint => 'name@beispiel.de';

  @override
  String get loginTerms =>
      'Mit der Anmeldung akzeptierst du unsere Nutzungsbedingungen und die Datenschutzerklärung.';

  @override
  String inventorySubtitle(int count, int places) {
    return '$count Artikel an $places Orten';
  }

  @override
  String get inventorySearchHint => 'Alles durchsuchen…';

  @override
  String get inventoryRecentlyAdded => 'Zuletzt hinzugefügt';

  @override
  String inventoryItemsCount(int count) {
    return '$count Artikel';
  }

  @override
  String get inventoryAllFresh => 'Alles frisch';

  @override
  String get inventoryStatExpiring => 'Bald ablaufend';

  @override
  String get inventoryStatExpired => 'Abgelaufen';

  @override
  String get inventoryStatFresh => 'Frisch';

  @override
  String get locationUnassignedName => 'Ohne Lagerort';

  @override
  String locationSearchHint(String name) {
    return 'In $name suchen…';
  }

  @override
  String get inventoryAllItemsTitle => 'Alle Artikel';

  @override
  String get inventorySearchEmpty => 'Keine Treffer';

  @override
  String get inventorySortTitle => 'Sortieren';

  @override
  String get inventorySortRecent => 'Zuletzt hinzugefügt';

  @override
  String get inventorySortName => 'Name A–Z';

  @override
  String get inventorySortExpiry => 'Ablaufdatum';

  @override
  String get addItemTitle => 'Artikel hinzufügen';

  @override
  String get addItemScanTitle => 'Barcode scannen';

  @override
  String get addItemScanSubtitle => 'Am schnellsten — Produkt wird erkannt';

  @override
  String get addItemSearchTitle => 'Produkt suchen';

  @override
  String get addItemSearchSubtitle => 'Open-Food-Facts-Datenbank';

  @override
  String get addItemManualTitle => 'Manuell eingeben';

  @override
  String get addItemManualSubtitle => 'Eigenes Produkt anlegen';

  @override
  String get addItemAddAgain => 'Erneut hinzufügen';

  @override
  String get itemDetailHeader => 'Artikel';

  @override
  String get itemDetailQuantity => 'Anzahl';

  @override
  String get itemDetailLocation => 'Lagerort';

  @override
  String get itemDetailCategory => 'Kategorie';

  @override
  String get itemDetailBestBefore => 'Mindesthaltbarkeit';

  @override
  String get itemDetailMarkConsumed => 'Als verbraucht markieren';

  @override
  String get itemDetailAddToList => 'Auf die Einkaufsliste';

  @override
  String get itemDetailRemove => 'Artikel entfernen';

  @override
  String get itemDetailPhoto => 'Produktfoto';

  @override
  String get shoppingAddHint => 'Artikel hinzufügen…';

  @override
  String shoppingListCount(int count) {
    return '$count Artikel auf der Liste';
  }

  @override
  String get shoppingAddTitle => 'Zur Liste hinzufügen';

  @override
  String get shoppingEditTitle => 'Artikel bearbeiten';

  @override
  String get shoppingQuantityLabel => 'Menge';

  @override
  String get shoppingQuantityHint => 'z. B. 2 × 1 l';

  @override
  String get shoppingAddButton => 'Hinzufügen';

  @override
  String get shoppingSaveButton => 'Speichern';

  @override
  String get shoppingClearCheckedTooltip => 'Gekaufte entfernen';

  @override
  String get shoppingDoneSection => 'Gekauft';

  @override
  String get shoppingLoadError => 'Einkaufsliste konnte nicht geladen werden.';

  @override
  String get shoppingErrorGeneric =>
      'Etwas ist schiefgelaufen. Bitte erneut versuchen.';

  @override
  String get shoppingErrorNotMember =>
      'Du hast keinen Zugriff auf diese Liste.';

  @override
  String get shoppingErrorNotFound => 'Dieser Artikel existiert nicht mehr.';

  @override
  String get recipesSubtitle => 'Kochbar mit deinem Vorrat';

  @override
  String get recipesMissing => 'Fehlt:';

  @override
  String get recipesAddToList => 'Zur Liste';

  @override
  String get recipesPhoto => 'Rezeptfoto';

  @override
  String get profileHouseholdSection => 'Haushalt';

  @override
  String get profileSettingsSection => 'Einstellungen';

  @override
  String get profileInviteMember => 'Mitglied einladen';

  @override
  String profileMembersCount(int count) {
    return '$count Mitglieder';
  }

  @override
  String profileVersion(String version) {
    return 'Zaiko $version';
  }

  @override
  String get settingNotifications => 'Benachrichtigungen';

  @override
  String get settingReminder => 'Erinnerung vor Ablauf';

  @override
  String get settingReminderValue => '3 Tage vorher';

  @override
  String get settingAppearance => 'Darstellung';

  @override
  String get settingAppearanceSystem => 'System';

  @override
  String get settingLanguage => 'Sprache';

  @override
  String get settingLanguageGerman => 'Deutsch';

  @override
  String homeGreeting(String name) {
    return 'Guten Morgen, $name';
  }

  @override
  String homeExpiringCount(int count) {
    return '$count Artikel laufen bald ab';
  }

  @override
  String get homeSearchHint => 'Vorrat durchsuchen…';

  @override
  String get homeCategories => 'Kategorien';

  @override
  String get homeExpiringSoon => 'Bald ablaufend';

  @override
  String get commonAll => 'Alle';

  @override
  String get commonBack => 'Zurück';

  @override
  String get onboardingTitle => 'Haushalt einrichten';

  @override
  String get onboardingSubtitle =>
      'Erstelle einen Haushalt, um loszulegen, oder tritt einem bei, zu dem du eingeladen wurdest.';

  @override
  String get onboardingCreateTitle => 'Haushalt erstellen';

  @override
  String get onboardingCreateSubtitle =>
      'Neu anfangen — andere kannst du danach einladen.';

  @override
  String get onboardingNameLabel => 'Haushaltsname';

  @override
  String get onboardingNameHint => 'z. B. Lindenhof';

  @override
  String get onboardingNameEmpty => 'Bitte gib einen Haushaltsnamen ein';

  @override
  String get onboardingCreateButton => 'Haushalt erstellen';

  @override
  String get onboardingJoinTitle => 'Haushalt beitreten';

  @override
  String get onboardingJoinSubtitle =>
      'Gib den Einladungscode ein, den du erhalten hast.';

  @override
  String get onboardingCodeLabel => 'Einladungscode';

  @override
  String get onboardingCodeHint => '6-stelliger Code';

  @override
  String get onboardingCodeEmpty => 'Bitte gib einen Einladungscode ein';

  @override
  String get onboardingJoinButton => 'Beitreten';

  @override
  String get inviteTitle => 'Mitglied einladen';

  @override
  String get inviteSubtitle =>
      'Teile diesen Code oder lass den QR-Code scannen. Er läuft in 15 Minuten ab.';

  @override
  String get inviteExpiresHint => '15 Minuten gültig';

  @override
  String get inviteCreateButton => 'Einladungscode erstellen';

  @override
  String get inviteRegenerate => 'Neuer Code';

  @override
  String get householdMembersTitle => 'Mitglieder';

  @override
  String get householdRoleOwner => 'Eigentümer';

  @override
  String get householdRoleMember => 'Mitglied';

  @override
  String get householdYou => 'Du';

  @override
  String get householdRename => 'Haushalt umbenennen';

  @override
  String get householdRenameSave => 'Speichern';

  @override
  String get householdRemoveMember => 'Entfernen';

  @override
  String get householdRemoveMemberTitle => 'Mitglied entfernen?';

  @override
  String get householdRemoveMemberMessage =>
      'Es verliert den Zugriff auf diesen Haushalt.';

  @override
  String get householdLeave => 'Haushalt verlassen';

  @override
  String get householdLeaveTitle => 'Haushalt verlassen?';

  @override
  String get householdLeaveMessage =>
      'Du verlierst den Zugriff auf Inventar und Einkaufsliste.';

  @override
  String get householdLeaveConfirm => 'Verlassen';

  @override
  String get joinConfirmMessage => 'Möchtest du diesem Haushalt beitreten?';

  @override
  String get joinAcceptButton => 'Haushalt beitreten';

  @override
  String get joinSignInPrompt =>
      'Melde dich an oder erstelle ein Konto, um diesem Haushalt beizutreten.';

  @override
  String get joinSignInButton => 'Anmelden & beitreten';

  @override
  String get joinSuccess => 'Du bist dem Haushalt beigetreten.';

  @override
  String get joinToProfileButton => 'Zurück zum Profil';

  @override
  String get householdErrorAlreadyMember =>
      'Du bist bereits in einem Haushalt. Tritt erst aus, um einem anderen beizutreten.';

  @override
  String get householdErrorInviteNotFound =>
      'Diesen Einladungscode gibt es nicht.';

  @override
  String get householdErrorInviteUsed =>
      'Dieser Einladungscode wurde bereits verwendet.';

  @override
  String get householdErrorInviteExpired =>
      'Dieser Einladungscode ist abgelaufen. Bitte um einen neuen.';

  @override
  String get householdErrorGeneric =>
      'Etwas ist schiefgelaufen. Bitte versuche es erneut.';

  @override
  String get homeGreetingGeneric => 'Guten Morgen';

  @override
  String inventoryLocationExpiringSoon(int count) {
    return '$count laufen bald ab';
  }

  @override
  String inventoryLocationExpired(int count) {
    return '$count abgelaufen';
  }

  @override
  String get inventoryLoadError => 'Inventar konnte nicht geladen werden.';

  @override
  String get inventoryLocationEmpty => 'Noch keine Artikel an diesem Ort.';

  @override
  String get inventoryRecentlyAddedEmpty => 'Noch nichts hinzugefügt.';

  @override
  String get homeExpiringEmpty => 'Nichts läuft bald ab.';

  @override
  String get commonRetry => 'Erneut versuchen';

  @override
  String get expiryExpired => 'Abgelaufen';

  @override
  String get expiryToday => 'Heute';

  @override
  String get expiryTomorrow => 'Morgen';

  @override
  String expiryInDays(int count) {
    return 'In $count Tagen';
  }

  @override
  String get itemDetailExpiresToday => 'Läuft heute ab';

  @override
  String get itemDetailExpiresTomorrow => 'Läuft morgen ab';

  @override
  String itemDetailExpiresInDays(int count) {
    return 'Läuft in $count Tagen ab';
  }

  @override
  String get itemDetailNoDate => 'Nicht angegeben';

  @override
  String get relativeToday => 'Heute';

  @override
  String get relativeYesterday => 'Gestern';

  @override
  String relativeDaysAgo(int count) {
    return 'Vor $count Tagen';
  }

  @override
  String get unitPiece => 'Stück';

  @override
  String get unitPackage => 'Packung';

  @override
  String get itemFormAddTitle => 'Artikel hinzufügen';

  @override
  String get itemFormEditTitle => 'Artikel bearbeiten';

  @override
  String get itemFormNameLabel => 'Name';

  @override
  String get itemFormNameHint => 'z. B. Milch';

  @override
  String get itemFormNameEmpty => 'Bitte einen Namen eingeben';

  @override
  String get itemFormQuantityLabel => 'Menge';

  @override
  String get itemFormQuantityInvalid => 'Menge größer als 0 eingeben';

  @override
  String get itemFormCountLabel => 'Anzahl';

  @override
  String get itemFormCountInvalid => 'Anzahl von mindestens 1 eingeben';

  @override
  String get itemFormUnitLabel => 'Einheit';

  @override
  String get itemFormLocationLabel => 'Lagerort';

  @override
  String get itemFormCategoryLabel => 'Kategorie';

  @override
  String get itemFormBestBeforeLabel => 'Mindesthaltbarkeit';

  @override
  String get itemFormNone => 'Keine';

  @override
  String get itemFormAddButton => 'Hinzufügen';

  @override
  String get itemFormSaveButton => 'Änderungen speichern';

  @override
  String get itemFormAddedSnack => 'Artikel hinzugefügt';

  @override
  String get itemFormSavedSnack => 'Änderungen gespeichert';

  @override
  String get itemMovedToTrash => 'In den Papierkorb verschoben';

  @override
  String get itemRestoredSnack => 'Artikel wiederhergestellt';

  @override
  String get pickerLocationTitle => 'Lagerort wählen';

  @override
  String get pickerCategoryTitle => 'Kategorie wählen';

  @override
  String get pickerNone => 'Keine';

  @override
  String get pickerNew => 'Neu';

  @override
  String get pickerManage => 'Verwalten';

  @override
  String get taxonomyNameLabel => 'Name';

  @override
  String get taxonomyColorLabel => 'Farbe';

  @override
  String get taxonomyIconLabel => 'Symbol';

  @override
  String get taxonomyNewLocationTitle => 'Neuer Lagerort';

  @override
  String get taxonomyEditLocationTitle => 'Lagerort bearbeiten';

  @override
  String get taxonomyNewCategoryTitle => 'Neue Kategorie';

  @override
  String get taxonomyEditCategoryTitle => 'Kategorie bearbeiten';

  @override
  String get taxonomyNameEmpty => 'Bitte einen Namen eingeben';

  @override
  String get taxonomyCreateButton => 'Erstellen';

  @override
  String get taxonomySaveButton => 'Speichern';

  @override
  String get manageLocationsTitle => 'Lagerorte';

  @override
  String get manageCategoriesTitle => 'Kategorien';

  @override
  String get manageAddLocation => 'Lagerort hinzufügen';

  @override
  String get manageAddCategory => 'Kategorie hinzufügen';

  @override
  String get manageLocationsEmpty => 'Noch keine Lagerorte.';

  @override
  String get manageCategoriesEmpty => 'Noch keine eigenen Kategorien.';

  @override
  String get manageEdit => 'Bearbeiten';

  @override
  String get manageDelete => 'Löschen';

  @override
  String get manageDefaultBadge => 'Standard';

  @override
  String get manageDeleteLocationTitle => 'Lagerort löschen?';

  @override
  String get manageDeleteCategoryTitle => 'Kategorie löschen?';

  @override
  String manageDeleteItemsWarning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Artikel verlieren diese Zuordnung.',
      one: '1 Artikel verliert diese Zuordnung.',
      zero: 'Wird noch von keinem Artikel verwendet.',
    );
    return '$_temp0';
  }

  @override
  String get manageDeleteConfirm => 'Löschen';

  @override
  String get trashTitle => 'Papierkorb';

  @override
  String get trashSubtitle =>
      'Entfernte Artikel werden 30 Tage aufbewahrt und dann gelöscht.';

  @override
  String get trashEmpty => 'Der Papierkorb ist leer.';

  @override
  String get trashRestore => 'Wiederherstellen';

  @override
  String get inventoryTrashTooltip => 'Papierkorb';

  @override
  String get inventoryErrorGeneric =>
      'Etwas ist schiefgelaufen. Bitte erneut versuchen.';

  @override
  String get inventoryErrorNotMember =>
      'Du hast keinen Zugriff auf diesen Haushalt.';

  @override
  String get inventoryErrorNotFound => 'Dieser Artikel existiert nicht mehr.';

  @override
  String get scannerTitle => 'Barcode scannen';

  @override
  String get scannerHint => 'Kamera auf einen Produkt-Barcode richten';

  @override
  String get scannerTorchTooltip => 'Taschenlampe';

  @override
  String get scannerResolving => 'Produkt wird gesucht…';

  @override
  String get scannerPermissionTitle => 'Kamerazugriff erforderlich';

  @override
  String get scannerPermissionBody =>
      'Zaiko braucht Kamerazugriff, um Barcodes zu scannen. Du kannst ihn in den Einstellungen aktivieren.';

  @override
  String get scannerOpenSettings => 'Einstellungen öffnen';

  @override
  String get scanNotFoundSnack =>
      'Produkt nicht gefunden – bitte manuell eingeben.';

  @override
  String get productSearchTitle => 'Produkt suchen';

  @override
  String get productSearchHint => 'Nach Produktname suchen…';

  @override
  String get productSearchPrompt => 'Tippe, um Open Food Facts zu durchsuchen.';

  @override
  String get productSearchEmpty => 'Keine Produkte gefunden.';

  @override
  String get foodErrorNetwork =>
      'Open Food Facts ist gerade nicht erreichbar. Bitte versuche es gleich erneut.';

  @override
  String get foodErrorRateLimited =>
      'Zu viele Anfragen. Bitte versuche es gleich noch einmal.';

  @override
  String get foodErrorGeneric =>
      'Produktdatenbank nicht erreichbar. Bitte versuche es erneut.';

  @override
  String get recipesFilterAlmostComplete => 'Fast vollständig';

  @override
  String get recipesFilterUnder30 => 'Unter 30 Min';

  @override
  String get recipesMatchComplete => 'Alle Zutaten da';

  @override
  String recipesMatchCount(int matched, int total) {
    return '$matched/$total Zutaten';
  }

  @override
  String get recipesUsesExpiring => 'Bald verbrauchen';

  @override
  String recipesMinutes(int minutes) {
    return '$minutes Min';
  }

  @override
  String recipesServings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Portionen',
      one: '1 Portion',
    );
    return '$_temp0';
  }

  @override
  String get recipesLoadError => 'Rezepte konnten nicht geladen werden.';

  @override
  String get recipesErrorGeneric =>
      'Etwas ist schiefgelaufen. Bitte versuche es erneut.';

  @override
  String get recipesErrorNotMember => 'Du bist kein Mitglied dieses Haushalts.';

  @override
  String get recipesErrorNotFound => 'Dieses Rezept existiert nicht mehr.';

  @override
  String recipesAddedToList(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Zutaten zur Liste hinzugefügt',
      one: '1 Zutat zur Liste hinzugefügt',
    );
    return '$_temp0';
  }

  @override
  String get recipesNewTitle => 'Neues Rezept';

  @override
  String get recipesEditTitle => 'Rezept bearbeiten';

  @override
  String get recipesEditAction => 'Bearbeiten';

  @override
  String get recipesDeleteAction => 'Löschen';

  @override
  String get recipesDeleteTitle => 'Rezept löschen?';

  @override
  String recipesDeleteMessage(String title) {
    return '„$title“ wird für alle im Haushalt entfernt.';
  }

  @override
  String get recipesIngredientsSection => 'Zutaten';

  @override
  String get recipesIngredientsEmpty => 'Keine Zutaten.';

  @override
  String get recipesStepsSection => 'Zubereitung';

  @override
  String get recipesStepsEmpty => 'Noch keine Schritte.';

  @override
  String get recipesInStock => 'Im Vorrat';

  @override
  String get recipesFormTitleLabel => 'Titel';

  @override
  String get recipesFormTitleHint => 'z. B. Nudeln mit Tomatensauce';

  @override
  String get recipesFormMinutesLabel => 'Zeit (Minuten)';

  @override
  String get recipesFormServingsLabel => 'Portionen';

  @override
  String get recipesFormIngredientNameHint => 'Zutat';

  @override
  String get recipesFormAmountHint => 'Menge';

  @override
  String get recipesFormAddIngredient => 'Zutat hinzufügen';

  @override
  String recipesFormStepHint(int number) {
    return 'Schritt $number';
  }

  @override
  String get recipesFormAddStep => 'Schritt hinzufügen';

  @override
  String get recipesCreateButton => 'Rezept anlegen';

  @override
  String get recipesSaveButton => 'Speichern';

  @override
  String get recipesCookStart => 'Kochen starten';

  @override
  String recipesCookStep(int current, int total) {
    return 'Schritt $current/$total';
  }

  @override
  String get recipesCookNext => 'Weiter';

  @override
  String get recipesCookFinish => 'Fertig';

  @override
  String get recipesCookEmpty => 'Dieses Rezept hat noch keine Schritte.';

  @override
  String get recipesCookTimerStart => 'Timer starten';

  @override
  String get recipesCookTimerReset => 'Zurücksetzen';

  @override
  String get recipesCookTimerDone => 'Timer fertig';

  @override
  String get recipesCookTimerAddMinute => '+1 Min';

  @override
  String get recipesCookTimerRemoveMinute => '-1 Min';

  @override
  String get recipesCookTimerAddSecond => '+10 Sek';

  @override
  String get recipesCookTimerRemoveSecond => '-10 Sek';

  @override
  String get recipesCookTimerPause => 'Pause';

  @override
  String get recipesCookTimerResume => 'Fortsetzen';

  @override
  String get recipesFormStepTimerToggle => 'Timer';

  @override
  String get recipesFormStepTimerMinutes => 'Min';

  @override
  String get recipesFormStepTimerSeconds => 'Sek';
}

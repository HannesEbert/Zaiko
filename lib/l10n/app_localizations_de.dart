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
  String get profileManageAccountEmptyTitle => 'Profil verwalten';

  @override
  String get profileManageAccountEmptyMessage =>
      'Hier kannst du künftig deine Profildaten bearbeiten.';

  @override
  String get profilePersonalDataEmptyTitle => 'Deine persönlichen Daten';

  @override
  String get profilePersonalDataEmptyMessage =>
      'Deine gespeicherten persönlichen Informationen erscheinen hier.';

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
  String locationSearchHint(String name) {
    return 'In $name suchen…';
  }

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
  String get itemDetailQuantity => 'Menge';

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
}

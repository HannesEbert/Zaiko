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
  String get inventoryEmptyTitle => 'Dein Inventar ist leer';

  @override
  String get inventoryEmptyMessage =>
      'Lebensmittel, die du zu Kühlschrank und Vorrat hinzufügst, erscheinen hier.';

  @override
  String get shoppingTitle => 'Einkaufsliste';

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
  String shoppingProgress(int done, int total) {
    return '$done von $total erledigt';
  }

  @override
  String get shoppingAddHint => 'Artikel hinzufügen…';

  @override
  String shoppingDoneSection(int count) {
    return 'Erledigt ($count)';
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
    return 'Hallo $name';
  }

  @override
  String homeSubtitle(String household) {
    return 'Haushalt $household';
  }

  @override
  String get homeStatItems => 'Artikel';

  @override
  String get homeStatExpiring => 'Läuft bald ab';

  @override
  String get homeStatShopping => 'Auf der Liste';

  @override
  String get homeExpiringSoon => 'Läuft bald ab';
}

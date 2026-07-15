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
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'TriominoScore';

  @override
  String get scoreSuffix => 'Pkt.';

  @override
  String get adPlaceholder => 'Werbung';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonSave => 'Speichern';

  @override
  String get commonDelete => 'Löschen';

  @override
  String get commonConfirm => 'Bestätigen';

  @override
  String get commonClose => 'Schließen';

  @override
  String get commonStart => 'Start';

  @override
  String get commonAdd => 'Hinzufügen';

  @override
  String get commonBack => 'Zurück';

  @override
  String get commonNext => 'Weiter';

  @override
  String scoreUnit(int count) {
    return '$count Pkt.';
  }

  @override
  String get homeSubtitle => 'Dein professioneller Triominos-Punktezähler';

  @override
  String get homeNewGame => 'Neues Spiel';

  @override
  String get homeResumeGame => 'Spiel fortsetzen';

  @override
  String get homePlayers => 'Spieler';

  @override
  String get homeHistory => 'Verlauf';

  @override
  String get homeStatistics => 'Statistiken';

  @override
  String get homeRules => 'Regeln';

  @override
  String get homeSettings => 'Einstellungen';

  @override
  String get playersTitle => 'Spieler';

  @override
  String get playersAdd => 'Spieler hinzufügen';

  @override
  String get playersEmpty => 'Noch keine Spieler. Füge den ersten hinzu!';

  @override
  String get playerName => 'Name';

  @override
  String get playerNameHint => 'z. B. Anna';

  @override
  String get playerNew => 'Neuer Spieler';

  @override
  String get playerEdit => 'Spieler bearbeiten';

  @override
  String get playerColor => 'Farbe';

  @override
  String get playerPhoto => 'Foto';

  @override
  String get premiumPhotoHint => 'Profilfotos sind eine Premium-Funktion';

  @override
  String get playerDeleteConfirm =>
      'Diesen Spieler löschen? Die Spielhistorie bleibt erhalten.';

  @override
  String get playerErrorNameEmpty => 'Namen eingeben';

  @override
  String get playerErrorNameTooLong => 'Name ist zu lang (max. 32 Zeichen)';

  @override
  String get setupTitle => 'Neues Spiel';

  @override
  String get setupSelectPlayers => 'Spieler auswählen';

  @override
  String get setupOrder => 'Reihenfolge (zum Ändern ziehen)';

  @override
  String setupPlayersRange(int min, int max) {
    return 'Wähle $min–$max Spieler';
  }

  @override
  String get setupEndMode => 'Endbedingung';

  @override
  String get setupEndModeScoreLimit => 'Punktelimit';

  @override
  String get setupEndModeRounds => 'Anzahl der Runden';

  @override
  String get setupEndModeFreeform => 'Freies Spiel';

  @override
  String get setupEndModeScoreLimitDesc =>
      'Wer zuerst die Punktegrenze erreicht, gewinnt';

  @override
  String get setupEndModeRoundsDesc => 'Spiele eine feste Anzahl an Runden';

  @override
  String get setupEndModeFreeformDesc => 'Beende das Spiel jederzeit manuell';

  @override
  String get setupScoreLimit => 'Punktegrenze';

  @override
  String get setupRounds => 'Runden';

  @override
  String get setupStartGame => 'Spiel starten';

  @override
  String setupNeedMorePlayers(int min) {
    return 'Wähle mindestens $min Spieler';
  }

  @override
  String gameRound(int number) {
    return 'Runde $number';
  }

  @override
  String get gameYourTurn => 'DU BIST DRAN';

  @override
  String get gameAddMove => 'Zug hinzufügen';

  @override
  String get gamePass => 'Passen';

  @override
  String get gameEndHand => 'Hand leer';

  @override
  String get gameRoundHistory => 'Diese Runde';

  @override
  String get gameNoMoves => 'Noch keine Züge';

  @override
  String get gameUndoLast => 'Letzten Zug rückgängig';

  @override
  String gameLastMove(String points) {
    return 'zuletzt: $points';
  }

  @override
  String get gameFinish => 'Spiel beenden';

  @override
  String gameThresholdReached(String name) {
    return 'Grenze erreicht: $name';
  }

  @override
  String get gameNextRound => 'Nächste Runde';

  @override
  String inputTitle(String player) {
    return 'Zug von $player';
  }

  @override
  String inputContext(int round, int move) {
    return 'Runde $round · Zug #$move';
  }

  @override
  String get inputCorners => 'Eckzahlen des Steins';

  @override
  String get inputBonuses => 'Boni (zum Hinzufügen tippen)';

  @override
  String get inputBonusTriplet => 'Triplet';

  @override
  String get inputBonusBridge => 'Brücke';

  @override
  String get inputBonusHexagon => 'Hexagon';

  @override
  String get inputBonusDoubleHexagon => 'Doppel-Hex';

  @override
  String get bonusInfoTitle => 'Was bedeuten die Boni?';

  @override
  String get bonusTripletDesc =>
      'Ein Stein mit drei gleichen Zahlen (z. B. 4-4-4). +10, bei 0-0-0 +30.';

  @override
  String get bonusBridgeDesc =>
      'Verbindet zwei zuvor getrennte Bereiche an einer Ecke. +40.';

  @override
  String get bonusHexagonDesc =>
      'Vervollständigt ein Sechseck aus 6 Dreiecken. +50.';

  @override
  String get bonusDoubleHexagonDesc =>
      'Ein Stein vervollständigt zwei Sechsecke gleichzeitig. Insgesamt +110.';

  @override
  String get inputTripletDetected => 'Triplet erkannt';

  @override
  String get inputSummary => 'Zusammenfassung';

  @override
  String get inputBase => 'Basis';

  @override
  String get inputBonusLine => 'Bonus';

  @override
  String get inputTotal => 'Gesamt';

  @override
  String get inputConfirm => 'Bestätigen';

  @override
  String get inputOtherActions => 'Weitere Aktionen';

  @override
  String inputDrawPile(int penalty) {
    return 'Vom Stapel ziehen ($penalty)';
  }

  @override
  String inputPassPenalty(int penalty) {
    return 'Passen ($penalty)';
  }

  @override
  String get moveDraw => 'Ziehen';

  @override
  String get inputEndHand => 'Hand leer (Rundenende)';

  @override
  String get inputOpponentsHandSum => 'Summe der Gegnerhände';

  @override
  String get inputOpponentsHandSumHint =>
      'Summe der Eckzahlen in den Händen der Gegner';

  @override
  String get summaryTitle => 'Spiel vorbei';

  @override
  String summaryWinner(String name) {
    return '$name gewinnt!';
  }

  @override
  String get summaryScoreboard => 'Endstand';

  @override
  String get summaryRematch => 'Revanche';

  @override
  String get summaryHome => 'Start';

  @override
  String get summaryRoundsPlayed => 'Gespielte Runden';

  @override
  String get summaryDuration => 'Dauer';

  @override
  String get historyTitle => 'Verlauf';

  @override
  String get historyEmpty => 'Noch keine beendeten Spiele';

  @override
  String historyWinner(String name) {
    return 'Sieger: $name';
  }

  @override
  String get statsTitle => 'Statistiken';

  @override
  String get statsEmpty => 'Spiele ein paar Partien, um Statistiken zu sehen';

  @override
  String get statsTotalGames => 'Gespielte Spiele';

  @override
  String get statsBestScore => 'Bester Punktestand';

  @override
  String get statsMostHexagons => 'Meiste Hexagons in einem Spiel';

  @override
  String get rulesTitle => 'Regeln';

  @override
  String get onboardingSkip => 'Überspringen';

  @override
  String get onboardingStart => 'Los geht\'s';

  @override
  String get onb1Title => 'Willkommen bei TriominoScore';

  @override
  String get onb1Body =>
      'Dein professioneller Punktezähler für das Brettspiel Triominos.';

  @override
  String get onb2Title => 'Smart Input';

  @override
  String get onb2Body =>
      'Gib die drei Eckzahlen ein und tippe einen Bonus — fertig.';

  @override
  String get onb3Title => 'Auto-Boni';

  @override
  String get onb3Body =>
      'Die App zählt Triplet-, Brücken- und Hexagon-Boni für dich.';

  @override
  String get onb4Title => 'Bereit zum Spielen';

  @override
  String get onb4Body => 'Füge Spieler hinzu und starte dein erstes Spiel.';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsTheme => 'Design';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Hell';

  @override
  String get settingsThemeDark => 'Dunkel';

  @override
  String get settingsSounds => 'Soundeffekte';

  @override
  String get settingsHaptics => 'Haptik';

  @override
  String get settingsPremium => 'Premium';

  @override
  String get settingsPremiumDesc =>
      'Bearbeiten beliebiger Züge freischalten und Werbung entfernen';

  @override
  String get premiumEditHint =>
      'Das Bearbeiten beliebiger Züge ist eine Premium-Funktion';

  @override
  String get settingsDefaultScoreLimit => 'Standard-Punktegrenze';

  @override
  String get settingsAbout => 'Über';

  @override
  String get settingsResetData => 'Alle Daten zurücksetzen';

  @override
  String get settingsResetConfirm =>
      'Alle Spiele und Spieler löschen? Das kann nicht rückgängig gemacht werden.';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get languagePolish => 'Polski';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageItalian => 'Italiano';
}

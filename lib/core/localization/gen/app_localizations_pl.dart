// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'TriominoScore';

  @override
  String get commonCancel => 'Anuluj';

  @override
  String get commonSave => 'Zapisz';

  @override
  String get commonDelete => 'Usuń';

  @override
  String get commonConfirm => 'Zatwierdź';

  @override
  String get commonClose => 'Zamknij';

  @override
  String get commonStart => 'Start';

  @override
  String get commonAdd => 'Dodaj';

  @override
  String get commonBack => 'Wstecz';

  @override
  String get commonNext => 'Dalej';

  @override
  String scoreUnit(int count) {
    return '$count pkt';
  }

  @override
  String get homeSubtitle => 'Twój profesjonalny pomocnik do liczenia punktów';

  @override
  String get homeNewGame => 'Nowa gra';

  @override
  String get homeResumeGame => 'Wznów grę';

  @override
  String get homePlayers => 'Gracze';

  @override
  String get homeHistory => 'Historia';

  @override
  String get homeStatistics => 'Statystyki';

  @override
  String get homeRules => 'Zasady';

  @override
  String get homeSettings => 'Ustawienia';

  @override
  String get playersTitle => 'Gracze';

  @override
  String get playersAdd => 'Dodaj gracza';

  @override
  String get playersEmpty => 'Brak graczy. Dodaj pierwszego!';

  @override
  String get playerName => 'Imię';

  @override
  String get playerNameHint => 'np. Anna';

  @override
  String get playerNew => 'Nowy gracz';

  @override
  String get playerEdit => 'Edytuj gracza';

  @override
  String get playerColor => 'Kolor';

  @override
  String get playerDeleteConfirm =>
      'Usunąć tego gracza? Historia jego gier pozostanie nienaruszona.';

  @override
  String get playerErrorNameEmpty => 'Podaj imię';

  @override
  String get playerErrorNameTooLong => 'Imię jest za długie (maks. 32 znaki)';

  @override
  String get setupTitle => 'Nowa gra';

  @override
  String get setupSelectPlayers => 'Wybierz graczy';

  @override
  String get setupOrder => 'Kolejność (przeciągnij, aby zmienić)';

  @override
  String setupPlayersRange(int min, int max) {
    return 'Wybierz $min–$max graczy';
  }

  @override
  String get setupEndMode => 'Warunek końca';

  @override
  String get setupEndModeScoreLimit => 'Limit punktów';

  @override
  String get setupEndModeRounds => 'Liczba rund';

  @override
  String get setupEndModeFreeform => 'Dowolna';

  @override
  String get setupEndModeScoreLimitDesc =>
      'Wygrywa pierwszy gracz, który osiągnie próg punktów';

  @override
  String get setupEndModeRoundsDesc => 'Rozegraj ustaloną liczbę rund';

  @override
  String get setupEndModeFreeformDesc =>
      'Zakończ grę ręcznie w dowolnym momencie';

  @override
  String get setupScoreLimit => 'Próg punktowy';

  @override
  String get setupRounds => 'Rundy';

  @override
  String get setupStartGame => 'Rozpocznij grę';

  @override
  String setupNeedMorePlayers(int min) {
    return 'Wybierz co najmniej $min graczy';
  }

  @override
  String gameRound(int number) {
    return 'Runda $number';
  }

  @override
  String get gameYourTurn => 'TWÓJ RUCH';

  @override
  String get gameAddMove => 'Dodaj ruch';

  @override
  String get gamePass => 'Pas';

  @override
  String get gameEndHand => 'Wyjście';

  @override
  String get gameRoundHistory => 'Ta runda';

  @override
  String get gameNoMoves => 'Brak ruchów';

  @override
  String get gameUndoLast => 'Cofnij ostatni ruch';

  @override
  String gameLastMove(String points) {
    return 'ostatnio: $points';
  }

  @override
  String get gameFinish => 'Zakończ grę';

  @override
  String gameThresholdReached(String name) {
    return 'Próg osiągnięty: $name';
  }

  @override
  String get gameNextRound => 'Następna runda';

  @override
  String inputTitle(String player) {
    return 'Ruch gracza: $player';
  }

  @override
  String inputContext(int round, int move) {
    return 'Runda $round · ruch #$move';
  }

  @override
  String get inputCorners => 'Cyfry narożników płytki';

  @override
  String get inputBonuses => 'Bonusy (tap aby dodać)';

  @override
  String get inputBonusTriplet => 'Triplet';

  @override
  String get inputBonusBridge => 'Most';

  @override
  String get inputBonusHexagon => 'Hexagon';

  @override
  String get inputBonusDoubleHexagon => 'Podwójny hex';

  @override
  String get inputTripletDetected => 'Wykryto triplet';

  @override
  String get inputSummary => 'Podsumowanie';

  @override
  String get inputBase => 'Bazowo';

  @override
  String get inputBonusLine => 'Bonus';

  @override
  String get inputTotal => 'Razem';

  @override
  String get inputConfirm => 'Zatwierdź';

  @override
  String get inputOtherActions => 'Inne akcje';

  @override
  String inputDrawPile(int penalty) {
    return 'Dobranie z puli ($penalty)';
  }

  @override
  String inputPassPenalty(int penalty) {
    return 'Pas ($penalty)';
  }

  @override
  String get moveDraw => 'Dobranie';

  @override
  String get inputEndHand => 'Wyjście (koniec rundy)';

  @override
  String get inputOpponentsHandSum => 'Suma rąk przeciwników';

  @override
  String get inputOpponentsHandSumHint =>
      'Suma cyfr na płytkach pozostałych w rękach przeciwników';

  @override
  String get summaryTitle => 'Koniec gry';

  @override
  String summaryWinner(String name) {
    return 'Wygrywa $name!';
  }

  @override
  String get summaryScoreboard => 'Wyniki końcowe';

  @override
  String get summaryRematch => 'Rewanż';

  @override
  String get summaryHome => 'Home';

  @override
  String get summaryRoundsPlayed => 'Rozegrane rundy';

  @override
  String get summaryDuration => 'Czas trwania';

  @override
  String get historyTitle => 'Historia';

  @override
  String get historyEmpty => 'Brak zakończonych gier';

  @override
  String historyWinner(String name) {
    return 'Zwycięzca: $name';
  }

  @override
  String get statsTitle => 'Statystyki';

  @override
  String get statsEmpty => 'Rozegraj kilka gier, aby zobaczyć statystyki';

  @override
  String get statsTotalGames => 'Rozegrane gry';

  @override
  String get statsBestScore => 'Najlepszy wynik';

  @override
  String get statsMostHexagons => 'Najwięcej hexagonów w grze';

  @override
  String get rulesTitle => 'Zasady';

  @override
  String get onboardingSkip => 'Pomiń';

  @override
  String get onboardingStart => 'Zaczynamy';

  @override
  String get onb1Title => 'Witaj w TriominoScore';

  @override
  String get onb1Body =>
      'Twój profesjonalny pomocnik do liczenia punktów w grze Triominos.';

  @override
  String get onb2Title => 'Smart Input';

  @override
  String get onb2Body => 'Wpisz trzy cyfry narożników i tapnij bonus — gotowe.';

  @override
  String get onb3Title => 'Auto-bonusy';

  @override
  String get onb3Body =>
      'Aplikacja sama liczy premie za triplet, most i hexagon.';

  @override
  String get onb4Title => 'Gotowi do gry';

  @override
  String get onb4Body => 'Dodaj graczy i rozpocznij pierwszą grę.';

  @override
  String get settingsTitle => 'Ustawienia';

  @override
  String get settingsLanguage => 'Język';

  @override
  String get settingsTheme => 'Motyw';

  @override
  String get settingsThemeSystem => 'Systemowy';

  @override
  String get settingsThemeLight => 'Jasny';

  @override
  String get settingsThemeDark => 'Ciemny';

  @override
  String get settingsSounds => 'Dźwięki';

  @override
  String get settingsHaptics => 'Wibracje';

  @override
  String get settingsDefaultScoreLimit => 'Domyślny próg punktowy';

  @override
  String get settingsAbout => 'O aplikacji';

  @override
  String get settingsResetData => 'Wyczyść wszystkie dane';

  @override
  String get settingsResetConfirm =>
      'Usunąć wszystkie gry i graczy? Tej operacji nie można cofnąć.';

  @override
  String settingsVersion(String version) {
    return 'Wersja $version';
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

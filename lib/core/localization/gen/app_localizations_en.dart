// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TriominoScore';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonClose => 'Close';

  @override
  String get commonStart => 'Start';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonBack => 'Back';

  @override
  String get commonNext => 'Next';

  @override
  String scoreUnit(int count) {
    return '$count pts';
  }

  @override
  String get homeSubtitle => 'Your professional Triominos scorekeeper';

  @override
  String get homeNewGame => 'New game';

  @override
  String get homeResumeGame => 'Resume game';

  @override
  String get homePlayers => 'Players';

  @override
  String get homeHistory => 'History';

  @override
  String get homeStatistics => 'Statistics';

  @override
  String get homeRules => 'Rules';

  @override
  String get homeSettings => 'Settings';

  @override
  String get playersTitle => 'Players';

  @override
  String get playersAdd => 'Add player';

  @override
  String get playersEmpty => 'No players yet. Add the first one!';

  @override
  String get playerName => 'Name';

  @override
  String get playerNameHint => 'e.g. Anna';

  @override
  String get playerNew => 'New player';

  @override
  String get playerEdit => 'Edit player';

  @override
  String get playerColor => 'Color';

  @override
  String get playerDeleteConfirm =>
      'Delete this player? Their game history stays intact.';

  @override
  String get playerErrorNameEmpty => 'Enter a name';

  @override
  String get playerErrorNameTooLong => 'Name is too long (max 32 characters)';

  @override
  String get setupTitle => 'New game';

  @override
  String get setupSelectPlayers => 'Select players';

  @override
  String get setupOrder => 'Turn order (drag to reorder)';

  @override
  String setupPlayersRange(int min, int max) {
    return 'Pick $min–$max players';
  }

  @override
  String get setupEndMode => 'End condition';

  @override
  String get setupEndModeScoreLimit => 'Score limit';

  @override
  String get setupEndModeRounds => 'Number of rounds';

  @override
  String get setupEndModeFreeform => 'Free play';

  @override
  String get setupEndModeScoreLimitDesc =>
      'First to reach the points threshold wins';

  @override
  String get setupEndModeRoundsDesc => 'Play a fixed number of rounds';

  @override
  String get setupEndModeFreeformDesc => 'End the game manually anytime';

  @override
  String get setupScoreLimit => 'Score threshold';

  @override
  String get setupRounds => 'Rounds';

  @override
  String get setupStartGame => 'Start game';

  @override
  String setupNeedMorePlayers(int min) {
    return 'Select at least $min players';
  }

  @override
  String gameRound(int number) {
    return 'Round $number';
  }

  @override
  String get gameYourTurn => 'YOUR TURN';

  @override
  String get gameAddMove => 'Add move';

  @override
  String get gamePass => 'Pass';

  @override
  String get gameEndHand => 'Hand out';

  @override
  String get gameRoundHistory => 'This round';

  @override
  String get gameNoMoves => 'No moves yet';

  @override
  String get gameUndoLast => 'Undo last move';

  @override
  String gameLastMove(String points) {
    return 'last: $points';
  }

  @override
  String get gameFinish => 'Finish game';

  @override
  String gameThresholdReached(String name) {
    return 'Threshold reached: $name';
  }

  @override
  String get gameNextRound => 'Next round';

  @override
  String inputTitle(String player) {
    return '$player\'s move';
  }

  @override
  String inputContext(int round, int move) {
    return 'Round $round · move #$move';
  }

  @override
  String get inputCorners => 'Tile corner values';

  @override
  String get inputBonuses => 'Bonuses (tap to add)';

  @override
  String get inputBonusTriplet => 'Triplet';

  @override
  String get inputBonusBridge => 'Bridge';

  @override
  String get inputBonusHexagon => 'Hexagon';

  @override
  String get inputBonusDoubleHexagon => 'Double hex';

  @override
  String get inputTripletDetected => 'Triplet detected';

  @override
  String get inputSummary => 'Summary';

  @override
  String get inputBase => 'Base';

  @override
  String get inputBonusLine => 'Bonus';

  @override
  String get inputTotal => 'Total';

  @override
  String get inputConfirm => 'Confirm';

  @override
  String get inputOtherActions => 'Other actions';

  @override
  String inputDrawPile(int penalty) {
    return 'Draw from pile ($penalty)';
  }

  @override
  String inputPassPenalty(int penalty) {
    return 'Pass ($penalty)';
  }

  @override
  String get moveDraw => 'Draw';

  @override
  String get inputEndHand => 'Hand out (round end)';

  @override
  String get inputOpponentsHandSum => 'Sum of opponents\' hands';

  @override
  String get inputOpponentsHandSumHint =>
      'Total of corner digits left in opponents\' hands';

  @override
  String get summaryTitle => 'Game over';

  @override
  String summaryWinner(String name) {
    return '$name wins!';
  }

  @override
  String get summaryScoreboard => 'Final scoreboard';

  @override
  String get summaryRematch => 'Rematch';

  @override
  String get summaryHome => 'Home';

  @override
  String get summaryRoundsPlayed => 'Rounds played';

  @override
  String get summaryDuration => 'Duration';

  @override
  String get historyTitle => 'History';

  @override
  String get historyEmpty => 'No finished games yet';

  @override
  String historyWinner(String name) {
    return 'Winner: $name';
  }

  @override
  String get statsTitle => 'Statistics';

  @override
  String get statsEmpty => 'Play a few games to see statistics';

  @override
  String get statsTotalGames => 'Games played';

  @override
  String get statsBestScore => 'Best score';

  @override
  String get statsMostHexagons => 'Most hexagons in a game';

  @override
  String get rulesTitle => 'Rules';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingStart => 'Let\'s go';

  @override
  String get onb1Title => 'Welcome to TriominoScore';

  @override
  String get onb1Body =>
      'Your professional scorekeeper for the Triominos board game.';

  @override
  String get onb2Title => 'Smart Input';

  @override
  String get onb2Body =>
      'Enter the three corner digits and tap a bonus — done.';

  @override
  String get onb3Title => 'Auto bonuses';

  @override
  String get onb3Body =>
      'The app counts triplet, bridge and hexagon bonuses for you.';

  @override
  String get onb4Title => 'Ready to play';

  @override
  String get onb4Body => 'Add players and start your first game.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsSounds => 'Sound effects';

  @override
  String get settingsHaptics => 'Haptics';

  @override
  String get settingsDefaultScoreLimit => 'Default score threshold';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsResetData => 'Reset all data';

  @override
  String get settingsResetConfirm =>
      'Delete all games and players? This cannot be undone.';

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

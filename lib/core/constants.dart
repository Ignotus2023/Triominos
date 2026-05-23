/// Globalne stałe aplikacji.
abstract class AppConstants {
  static const int minPlayers = 2;
  static const int maxPlayers = 6;

  static const int minScoreLimit = 100;
  static const int maxScoreLimit = 1000;
  static const int scoreLimitStep = 50;

  static const int minRounds = 1;
  static const int maxRounds = 10;

  static const int maxPlayerNameLength = 32;

  /// Maksymalna liczba ruchów wstecz dla szybkiego undo (§8.6).
  static const int maxUndoDepth = 3;
}

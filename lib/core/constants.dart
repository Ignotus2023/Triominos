abstract class AppConstants {
  AppConstants._();

  static const int minPlayers = 2;
  static const int maxPlayers = 6;

  static const int cornerMin = 0;
  static const int cornerMax = 5;

  static const int totalTilesInSet = 56;

  static const int playerNameMinLength = 1;
  static const int playerNameMaxLength = 32;

  static const int defaultScoreLimit = 400;
  static const int minScoreLimit = 100;
  static const int maxScoreLimit = 1000;
  static const int scoreLimitStep = 50;

  static const int defaultRoundCount = 3;
  static const int minRoundCount = 1;
  static const int maxRoundCount = 10;

  static int initialHandSize(int playerCount) {
    if (playerCount <= 2) return 9;
    if (playerCount <= 4) return 7;
    return 6;
  }
}

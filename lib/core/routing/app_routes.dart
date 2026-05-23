/// Nazwane ścieżki aplikacji (go_router).
abstract class AppRoutes {
  static const home = 'home';
  static const homePath = '/';

  static const players = 'players';
  static const playersPath = '/players';

  static const gameSetup = 'gameSetup';
  static const gameSetupPath = '/setup';

  static const game = 'game';
  static const gamePath = '/game/:id';

  static const gameSummary = 'gameSummary';
  static const gameSummaryPath = '/game/:id/summary';

  static const history = 'history';
  static const historyPath = '/history';

  static const statistics = 'statistics';
  static const statisticsPath = '/statistics';

  static const rules = 'rules';
  static const rulesPath = '/rules';

  static const settings = 'settings';
  static const settingsPath = '/settings';

  static String gameLocation(String id) => '/game/$id';
  static String gameSummaryLocation(String id) => '/game/$id/summary';
}

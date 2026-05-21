abstract class AppRoute {
  AppRoute._();

  static const home = 'home';
  static const onboarding = 'onboarding';
  static const players = 'players';
  static const playerForm = 'playerForm';
  static const gameSetup = 'gameSetup';
  static const game = 'game';
  static const gameSummary = 'gameSummary';
  static const history = 'history';
  static const historyDetails = 'historyDetails';
  static const statistics = 'statistics';
  static const rules = 'rules';
  static const settings = 'settings';
}

abstract class AppPath {
  AppPath._();

  static const home = '/';
  static const onboarding = '/onboarding';
  static const players = '/players';
  static const playerForm = '/players/edit';
  static const gameSetup = '/game/setup';
  static const game = '/game/:gameId';
  static const gameSummary = '/game/:gameId/summary';
  static const history = '/history';
  static const historyDetails = '/history/:gameId';
  static const statistics = '/statistics';
  static const rules = '/rules';
  static const settings = '/settings';
}

/// Konfigurowalne wartości punktacji Triominos (wariant Goliath).
///
/// Zmiana dowolnej z tych stałych pozwala dostosować aplikację do lokalnych
/// wariantów ("house rules") bez ruszania logiki kalkulatora punktów.
abstract class ScoringRules {
  /// Premia za zagranie tripletu (z wyjątkiem 0-0-0).
  static const int tripletBonus = 10;

  /// Specjalna premia za 0-0-0 (triplet zer dający 0 punktów bazowych).
  static const int zeroTripletBonus = 30;

  /// Most: zagrana łącząca narożnikiem dwa wcześniej rozłączone regiony.
  static const int bridgeBonus = 40;

  /// Hexagon: domknięcie sześciokąta z 6 trójkątów.
  static const int hexagonBonus = 50;

  /// Dodatkowa premia, gdy jedna płytka domyka dwa hexagony naraz.
  ///
  /// Sumuje się z [hexagonBonus] (50 + 60 = 110 łącznie).
  static const int doubleHexagonBonus = 60;

  /// Bonus za pierwszy ruch w grze.
  static const int starterBonus = 10;

  /// Bonus za zakończenie rundy (wyczerpanie ręki).
  static const int endOfHandBonus = 25;

  /// Kara za dobranie płytki z puli.
  static const int drawPenalty = -5;

  /// Kara za spasowanie tury.
  static const int passPenalty = -10;

  /// Maksymalna liczba dobrań zanim gracz musi spasować.
  static const int maxDraws = 3;

  /// Domyślny próg punktowy dla trybu "limit punktów".
  static const int defaultScoreLimit = 400;

  /// Domyślna liczba rund dla trybu "liczba rund".
  static const int defaultRounds = 3;

  /// Zakres cyfr na narożniku płytki.
  static const int minCorner = 0;
  static const int maxCorner = 5;
}

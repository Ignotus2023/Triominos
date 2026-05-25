import 'move.dart';
import 'scoring_config.dart';
import 'scoring_rules.dart';

/// Czysta funkcja licząca punkty pojedynczego ruchu.
///
/// Cała logika punktacji żyje w [Move]; ta funkcja to stabilny, testowalny
/// punkt wejścia używany przez warstwę danych i kontrolery.
int calculateMoveScore(Move move) => move.totalScore;

/// Wynik punktacji ruchu rozbity na bazę i bonus.
class MoveScore {
  const MoveScore(this.base, this.bonus);

  final int base;
  final int bonus;

  int get total => base + bonus;
}

/// Liczy punkty ruchu według konfigurowalnych zasad ([ScoringConfig]).
///
/// Z [ScoringConfig.standard] wynik jest identyczny jak z getterów [Move].
MoveScore scoreMove(Move move, ScoringConfig config) {
  switch (move.type) {
    case MoveType.drawPenalty:
      return MoveScore(config.drawPenalty, 0);
    case MoveType.passPenalty:
      return MoveScore(config.passPenalty, 0);
    case MoveType.endOfHandBonus:
      return MoveScore(config.endOfHandBonus, move.opponentsHandSum ?? 0);
    case MoveType.play:
      final base = (move.corner1 ?? 0) + (move.corner2 ?? 0) + (move.corner3 ?? 0);
      var bonus = 0;
      if (move.isTriplet) {
        bonus += move.isZeroTriplet
            ? config.zeroTripletBonus
            : config.tripletBonus;
      }
      if (move.isDoubleHexagon) {
        bonus += config.hexagonBonus + config.doubleHexagonBonus;
      } else if (move.isHexagon) {
        bonus += config.hexagonBonus;
      }
      if (move.isBridge) bonus += config.bridgeBonus;
      if (move.isStarter) bonus += config.starterBonus;
      return MoveScore(base, bonus);
  }
}

/// Walidacja danych wejściowych ruchu (Smart Input).
abstract class MoveValidation {
  /// Triplet: wszystkie 3 narożniki takie same.
  static bool isTriplet(int c1, int c2, int c3) => c1 == c2 && c2 == c3;

  /// 0-0-0 — specjalny triplet (premia +30 zamiast +10).
  static bool isSpecialZeroTriplet(int c1, int c2, int c3) =>
      isTriplet(c1, c2, c3) && c1 == 0;

  /// Każdy narożnik musi być w zakresie 0-5.
  static bool isValidCorner(int value) =>
      value >= ScoringRules.minCorner && value <= ScoringRules.maxCorner;

  /// Wszystkie trzy narożniki w poprawnym zakresie.
  static bool isValidTile(int c1, int c2, int c3) =>
      isValidCorner(c1) && isValidCorner(c2) && isValidCorner(c3);
}

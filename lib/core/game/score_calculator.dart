import 'move.dart';
import 'scoring_rules.dart';

/// Czysta funkcja licząca punkty pojedynczego ruchu.
///
/// Cała logika punktacji żyje w [Move]; ta funkcja to stabilny, testowalny
/// punkt wejścia używany przez warstwę danych i kontrolery.
int calculateMoveScore(Move move) => move.totalScore;

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

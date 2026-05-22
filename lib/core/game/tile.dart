import 'scoring_rules.dart';

/// Trójkątna płytka Triominos opisana cyframi w trzech narożnikach.
class Tile {
  const Tile(this.a, this.b, this.c);

  final int a;
  final int b;
  final int c;

  /// Suma narożników (0-15) — punkty bazowe za zagranie.
  int get sum => a + b + c;

  /// Czy płytka jest tripletem (wszystkie narożniki równe).
  bool get isTriplet => a == b && b == c;

  bool get isValid => [a, b, c].every(
        (v) => v >= ScoringRules.minCorner && v <= ScoringRules.maxCorner,
      );

  @override
  bool operator ==(Object other) =>
      other is Tile && other.a == a && other.b == b && other.c == c;

  @override
  int get hashCode => Object.hash(a, b, c);

  @override
  String toString() => '$a-$b-$c';
}

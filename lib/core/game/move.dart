import 'scoring_rules.dart';

/// Rodzaj ruchu zapisywanego w historii rundy.
enum MoveType {
  /// Zwykłe zagranie płytki (3 narożniki).
  play,

  /// Dobranie płytki z puli (kara).
  drawPenalty,

  /// Spasowanie tury (kara).
  passPenalty,

  /// Zakończenie rundy przez wyczerpanie ręki (bonus + suma rąk przeciwników).
  endOfHandBonus,
}

/// Pojedynczy bonus możliwy do zaznaczenia w Smart Input.
enum BonusType { triplet, bridge, hexagon, doubleHexagon }

/// Niemutowalny, czysty model ruchu używany przez kalkulator punktów.
///
/// Nie zawiera identyfikatorów ani metadanych bazodanowych — to wyłącznie
/// dane potrzebne do policzenia punktów. Warstwa danych mapuje wiersz z bazy
/// na ten model.
class Move {
  const Move({
    required this.type,
    this.corner1,
    this.corner2,
    this.corner3,
    this.isTriplet = false,
    this.isBridge = false,
    this.isHexagon = false,
    this.isDoubleHexagon = false,
    this.isStarter = false,
    this.opponentsHandSum,
  });

  /// Zwykłe zagranie płytki z auto-detekcją tripletu.
  factory Move.play({
    required int corner1,
    required int corner2,
    required int corner3,
    bool isBridge = false,
    bool isHexagon = false,
    bool isDoubleHexagon = false,
    bool isStarter = false,
  }) {
    return Move(
      type: MoveType.play,
      corner1: corner1,
      corner2: corner2,
      corner3: corner3,
      isTriplet: corner1 == corner2 && corner2 == corner3,
      isBridge: isBridge,
      isHexagon: isHexagon,
      isDoubleHexagon: isDoubleHexagon,
      isStarter: isStarter,
    );
  }

  factory Move.drawPenalty() => const Move(type: MoveType.drawPenalty);

  factory Move.passPenalty() => const Move(type: MoveType.passPenalty);

  factory Move.endOfHand({required int opponentsHandSum}) =>
      Move(type: MoveType.endOfHandBonus, opponentsHandSum: opponentsHandSum);

  final MoveType type;
  final int? corner1;
  final int? corner2;
  final int? corner3;
  final bool isTriplet;
  final bool isBridge;
  final bool isHexagon;
  final bool isDoubleHexagon;
  final bool isStarter;

  /// Suma cyfr na rękach przeciwników (tylko dla [MoveType.endOfHandBonus]).
  final int? opponentsHandSum;

  /// Czy triplet składa się z samych zer (0-0-0) — premia specjalna.
  bool get isZeroTriplet =>
      isTriplet && corner1 == 0 && corner2 == 0 && corner3 == 0;

  /// Punkty bazowe (suma narożników lub stała kara/bonus startowy rundy).
  int get baseScore {
    switch (type) {
      case MoveType.play:
        return (corner1 ?? 0) + (corner2 ?? 0) + (corner3 ?? 0);
      case MoveType.drawPenalty:
        return ScoringRules.drawPenalty;
      case MoveType.passPenalty:
        return ScoringRules.passPenalty;
      case MoveType.endOfHandBonus:
        return ScoringRules.endOfHandBonus;
    }
  }

  /// Punkty bonusowe (premie za triplet/most/hex/start lub suma rąk).
  int get bonusScore {
    switch (type) {
      case MoveType.drawPenalty:
      case MoveType.passPenalty:
        return 0;
      case MoveType.endOfHandBonus:
        return opponentsHandSum ?? 0;
      case MoveType.play:
        var bonus = 0;
        if (isTriplet) {
          bonus += isZeroTriplet
              ? ScoringRules.zeroTripletBonus
              : ScoringRules.tripletBonus;
        }
        if (isDoubleHexagon) {
          bonus += ScoringRules.hexagonBonus + ScoringRules.doubleHexagonBonus;
        } else if (isHexagon) {
          bonus += ScoringRules.hexagonBonus;
        }
        if (isBridge) bonus += ScoringRules.bridgeBonus;
        if (isStarter) bonus += ScoringRules.starterBonus;
        return bonus;
    }
  }

  /// Łączna wartość ruchu.
  int get totalScore => baseScore + bonusScore;

  Move copyWith({
    MoveType? type,
    int? corner1,
    int? corner2,
    int? corner3,
    bool? isTriplet,
    bool? isBridge,
    bool? isHexagon,
    bool? isDoubleHexagon,
    bool? isStarter,
    int? opponentsHandSum,
  }) {
    return Move(
      type: type ?? this.type,
      corner1: corner1 ?? this.corner1,
      corner2: corner2 ?? this.corner2,
      corner3: corner3 ?? this.corner3,
      isTriplet: isTriplet ?? this.isTriplet,
      isBridge: isBridge ?? this.isBridge,
      isHexagon: isHexagon ?? this.isHexagon,
      isDoubleHexagon: isDoubleHexagon ?? this.isDoubleHexagon,
      isStarter: isStarter ?? this.isStarter,
      opponentsHandSum: opponentsHandSum ?? this.opponentsHandSum,
    );
  }
}

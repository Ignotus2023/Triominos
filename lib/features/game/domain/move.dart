import '../../../core/game/move_input.dart';
import '../../../core/game/score_breakdown.dart';
import '../../../core/utils/id.dart';

class Move {
  const Move({
    required this.id,
    required this.roundId,
    required this.playerId,
    required this.moveIndex,
    required this.type,
    required this.corner1,
    required this.corner2,
    required this.corner3,
    required this.tileKey,
    required this.baseScore,
    required this.bonusScore,
    required this.opponentsHandSum,
    required this.isTriplet,
    required this.isBridge,
    required this.isHexagon,
    required this.isDoubleHexagon,
    required this.isStarter,
    required this.createdAt,
  });

  factory Move.fromInput({
    required String roundId,
    required String playerId,
    required int moveIndex,
    required MoveInput input,
    required ScoreBreakdown breakdown,
  }) {
    return Move(
      id: newId(),
      roundId: roundId,
      playerId: playerId,
      moveIndex: moveIndex,
      type: input.type,
      corner1: input.corner1,
      corner2: input.corner2,
      corner3: input.corner3,
      tileKey: input.tileKey(),
      baseScore: breakdown.base + breakdown.penalty + breakdown.endOfHandBonus + breakdown.opponentsHandSum,
      bonusScore: breakdown.tripletBonus +
          breakdown.bridgeBonus +
          breakdown.hexagonBonus +
          breakdown.doubleHexagonBonus +
          breakdown.starterBonus,
      opponentsHandSum: breakdown.opponentsHandSum,
      isTriplet: input.isTriplet,
      isBridge: input.isBridge,
      isHexagon: input.isHexagon,
      isDoubleHexagon: input.isDoubleHexagon,
      isStarter: input.isStarter,
      createdAt: DateTime.now(),
    );
  }

  final String id;
  final String roundId;
  final String playerId;
  final int moveIndex;
  final MoveType type;
  final int? corner1;
  final int? corner2;
  final int? corner3;
  final String? tileKey;
  final int baseScore;
  final int bonusScore;
  final int opponentsHandSum;
  final bool isTriplet;
  final bool isBridge;
  final bool isHexagon;
  final bool isDoubleHexagon;
  final bool isStarter;
  final DateTime createdAt;

  int get totalScore => baseScore + bonusScore;

  Move withId(String newId) {
    return Move(
      id: newId,
      roundId: roundId,
      playerId: playerId,
      moveIndex: moveIndex,
      type: type,
      corner1: corner1,
      corner2: corner2,
      corner3: corner3,
      tileKey: tileKey,
      baseScore: baseScore,
      bonusScore: bonusScore,
      opponentsHandSum: opponentsHandSum,
      isTriplet: isTriplet,
      isBridge: isBridge,
      isHexagon: isHexagon,
      isDoubleHexagon: isDoubleHexagon,
      isStarter: isStarter,
      createdAt: createdAt,
    );
  }
}

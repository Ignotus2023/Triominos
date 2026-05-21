import '../constants.dart';

enum MoveType {
  play,
  drawPenalty,
  passPenalty,
  endOfHandBonus,
}

class MoveInput {
  const MoveInput({
    required this.type,
    this.corner1,
    this.corner2,
    this.corner3,
    this.isBridge = false,
    this.isHexagon = false,
    this.isDoubleHexagon = false,
    this.isStarter = false,
    this.opponentsHandSum,
  });

  factory MoveInput.play({
    required int corner1,
    required int corner2,
    required int corner3,
    bool isBridge = false,
    bool isHexagon = false,
    bool isDoubleHexagon = false,
    bool isStarter = false,
  }) {
    return MoveInput(
      type: MoveType.play,
      corner1: corner1,
      corner2: corner2,
      corner3: corner3,
      isBridge: isBridge,
      isHexagon: isHexagon,
      isDoubleHexagon: isDoubleHexagon,
      isStarter: isStarter,
    );
  }

  factory MoveInput.draw() => const MoveInput(type: MoveType.drawPenalty);

  factory MoveInput.pass() => const MoveInput(type: MoveType.passPenalty);

  factory MoveInput.endOfHand({required int opponentsHandSum}) {
    return MoveInput(type: MoveType.endOfHandBonus, opponentsHandSum: opponentsHandSum);
  }

  final MoveType type;
  final int? corner1;
  final int? corner2;
  final int? corner3;
  final bool isBridge;
  final bool isHexagon;
  final bool isDoubleHexagon;
  final bool isStarter;
  final int? opponentsHandSum;

  bool get isTriplet =>
      type == MoveType.play &&
      corner1 != null &&
      corner1 == corner2 &&
      corner2 == corner3;

  bool get isZeroTriplet => isTriplet && corner1 == 0;

  int? get cornerSum {
    if (type != MoveType.play) return null;
    return (corner1 ?? 0) + (corner2 ?? 0) + (corner3 ?? 0);
  }

  bool get isValidPlay {
    if (type != MoveType.play) return type != MoveType.play;
    final c1 = corner1;
    final c2 = corner2;
    final c3 = corner3;
    if (c1 == null || c2 == null || c3 == null) return false;
    bool inRange(int v) => v >= AppConstants.cornerMin && v <= AppConstants.cornerMax;
    if (!inRange(c1) || !inRange(c2) || !inRange(c3)) return false;
    if (isHexagon && isDoubleHexagon) return false;
    return true;
  }

  String? tileKey() {
    final c1 = corner1;
    final c2 = corner2;
    final c3 = corner3;
    if (c1 == null || c2 == null || c3 == null) return null;
    final sorted = [c1, c2, c3]..sort();
    return '${sorted[0]}-${sorted[1]}-${sorted[2]}';
  }
}

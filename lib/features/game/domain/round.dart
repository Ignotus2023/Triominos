import '../../../core/utils/id.dart';

class Round {
  const Round({
    required this.id,
    required this.gameId,
    required this.roundNumber,
    required this.starterPlayerId,
    required this.starterByTriplet,
    required this.finisherPlayerId,
    required this.startedAt,
    required this.finishedAt,
  });

  factory Round.start({
    required String gameId,
    required int roundNumber,
    required String starterPlayerId,
    required bool starterByTriplet,
  }) {
    return Round(
      id: newId(),
      gameId: gameId,
      roundNumber: roundNumber,
      starterPlayerId: starterPlayerId,
      starterByTriplet: starterByTriplet,
      finisherPlayerId: null,
      startedAt: DateTime.now(),
      finishedAt: null,
    );
  }

  final String id;
  final String gameId;
  final int roundNumber;
  final String starterPlayerId;
  final bool starterByTriplet;
  final String? finisherPlayerId;
  final DateTime startedAt;
  final DateTime? finishedAt;

  bool get isFinished => finishedAt != null;

  Round copyWith({String? finisherPlayerId, DateTime? finishedAt}) {
    return Round(
      id: id,
      gameId: gameId,
      roundNumber: roundNumber,
      starterPlayerId: starterPlayerId,
      starterByTriplet: starterByTriplet,
      finisherPlayerId: finisherPlayerId ?? this.finisherPlayerId,
      startedAt: startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
    );
  }
}

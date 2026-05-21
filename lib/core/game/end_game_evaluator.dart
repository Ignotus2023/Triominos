enum EndMode {
  scoreLimit,
  rounds,
  freeform,
}

class PlayerStanding {
  const PlayerStanding({required this.playerId, required this.totalScore});
  final String playerId;
  final int totalScore;
}

class EndGameDecision {
  const EndGameDecision({required this.shouldEnd, this.winnerPlayerId});
  final bool shouldEnd;
  final String? winnerPlayerId;
}

class EndGameEvaluator {
  const EndGameEvaluator();

  EndGameDecision evaluate({
    required EndMode mode,
    required int currentRoundNumber,
    required int? scoreLimit,
    required int? totalRounds,
    required List<PlayerStanding> standings,
    required bool roundJustFinished,
  }) {
    if (standings.isEmpty) {
      return const EndGameDecision(shouldEnd: false);
    }
    switch (mode) {
      case EndMode.scoreLimit:
        final threshold = scoreLimit;
        if (threshold == null) return const EndGameDecision(shouldEnd: false);
        if (!roundJustFinished) return const EndGameDecision(shouldEnd: false);
        final leader = _leader(standings);
        if (leader.totalScore >= threshold) {
          return EndGameDecision(shouldEnd: true, winnerPlayerId: leader.playerId);
        }
        return const EndGameDecision(shouldEnd: false);

      case EndMode.rounds:
        final total = totalRounds;
        if (total == null) return const EndGameDecision(shouldEnd: false);
        if (currentRoundNumber >= total && roundJustFinished) {
          final leader = _leader(standings);
          return EndGameDecision(shouldEnd: true, winnerPlayerId: leader.playerId);
        }
        return const EndGameDecision(shouldEnd: false);

      case EndMode.freeform:
        return const EndGameDecision(shouldEnd: false);
    }
  }

  PlayerStanding _leader(List<PlayerStanding> standings) {
    return standings.reduce((a, b) => a.totalScore >= b.totalScore ? a : b);
  }
}

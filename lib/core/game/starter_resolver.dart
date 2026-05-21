class HandClaim {
  const HandClaim({
    required this.playerId,
    this.highestTripletValue,
    this.highestTileSum,
  });

  final String playerId;
  final int? highestTripletValue;
  final int? highestTileSum;
}

class StarterResult {
  const StarterResult({
    required this.playerId,
    required this.byTriplet,
    this.tripletValue,
  });

  final String playerId;
  final bool byTriplet;
  final int? tripletValue;
}

class StarterResolver {
  const StarterResolver();

  StarterResult? resolve(List<HandClaim> claims) {
    if (claims.isEmpty) return null;

    HandClaim? tripletWinner;
    for (final claim in claims) {
      final value = claim.highestTripletValue;
      if (value == null) continue;
      final current = tripletWinner?.highestTripletValue;
      if (current == null || value > current) {
        tripletWinner = claim;
      }
    }

    if (tripletWinner != null) {
      return StarterResult(
        playerId: tripletWinner.playerId,
        byTriplet: true,
        tripletValue: tripletWinner.highestTripletValue,
      );
    }

    HandClaim? sumWinner;
    for (final claim in claims) {
      final sum = claim.highestTileSum;
      if (sum == null) continue;
      final current = sumWinner?.highestTileSum;
      if (current == null || sum > current) {
        sumWinner = claim;
      }
    }

    if (sumWinner == null) return null;
    return StarterResult(playerId: sumWinner.playerId, byTriplet: false);
  }
}

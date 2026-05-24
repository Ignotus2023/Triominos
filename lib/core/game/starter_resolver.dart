import 'tile.dart';

/// Najlepsza płytka startowa zgłoszona przez gracza.
class StarterCandidate {
  const StarterCandidate({required this.playerId, required this.bestTile});

  final String playerId;

  /// Najlepsza (najkorzystniejsza do otwarcia) płytka w ręce gracza.
  final Tile bestTile;
}

/// Rozstrzygnięcie, kto rozpoczyna grę.
class StarterResult {
  const StarterResult({
    required this.playerId,
    required this.tile,
    required this.startedWithTriplet,
  });

  final String playerId;
  final Tile tile;
  final bool startedWithTriplet;
}

/// Wyłania gracza rozpoczynającego rundę zgodnie z zasadami Triominos.
///
/// Pierwszeństwo (§2.3):
/// 1. Najwyższy triplet (5-5-5 > 4-4-4 > ... > 0-0-0).
/// 2. Jeśli nikt nie ma tripletu — najwyższa suma narożników dowolnej płytki.
///
/// Przy remisie wygrywa pierwszy zgłoszony kandydat (stabilny wybór).
abstract class StarterResolver {
  static StarterResult? resolve(List<StarterCandidate> candidates) {
    if (candidates.isEmpty) return null;

    StarterCandidate? best;
    for (final candidate in candidates) {
      if (best == null || _rank(candidate.bestTile) > _rank(best.bestTile)) {
        best = candidate;
      }
    }

    final tile = best!.bestTile;
    return StarterResult(
      playerId: best.playerId,
      tile: tile,
      startedWithTriplet: tile.isTriplet,
    );
  }

  /// Klucz porządkujący: triplety zawsze biją nie-triplety; w obrębie grupy
  /// decyduje wartość (face value tripletu lub suma narożników).
  static int _rank(Tile tile) {
    if (tile.isTriplet) {
      // Tripletom dajemy zakres ponad maksymalną sumą zwykłej płytki (15).
      return 100 + tile.a;
    }
    return tile.sum;
  }
}

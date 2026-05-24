import 'package:flutter_test/flutter_test.dart';
import 'package:triomino_score/core/game/starter_resolver.dart';
import 'package:triomino_score/core/game/tile.dart';

void main() {
  group('StarterResolver', () {
    test('wygrywa najwyższy triplet', () {
      final result = StarterResolver.resolve(const [
        StarterCandidate(playerId: 'a', bestTile: Tile(4, 4, 4)),
        StarterCandidate(playerId: 'b', bestTile: Tile(5, 5, 5)),
        StarterCandidate(playerId: 'c', bestTile: Tile(2, 2, 2)),
      ]);
      expect(result!.playerId, 'b');
      expect(result.startedWithTriplet, isTrue);
    });

    test('triplet bije nie-triplet o wyższej sumie', () {
      final result = StarterResolver.resolve(const [
        StarterCandidate(playerId: 'a', bestTile: Tile(5, 4, 5)),
        StarterCandidate(playerId: 'b', bestTile: Tile(0, 0, 0)),
      ]);
      expect(result!.playerId, 'b');
      expect(result.startedWithTriplet, isTrue);
    });

    test('bez tripletu wygrywa najwyższa suma narożników', () {
      final result = StarterResolver.resolve(const [
        StarterCandidate(playerId: 'a', bestTile: Tile(5, 3, 2)),
        StarterCandidate(playerId: 'b', bestTile: Tile(4, 4, 3)),
      ]);
      expect(result!.playerId, 'b');
      expect(result.startedWithTriplet, isFalse);
    });

    test('pusta lista zwraca null', () {
      expect(StarterResolver.resolve(const []), isNull);
    });

    test('przy remisie wygrywa pierwszy zgłoszony', () {
      final result = StarterResolver.resolve(const [
        StarterCandidate(playerId: 'a', bestTile: Tile(5, 2, 1)),
        StarterCandidate(playerId: 'b', bestTile: Tile(4, 4, 0)),
      ]);
      expect(result!.playerId, 'a');
    });
  });
}

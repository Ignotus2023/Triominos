import 'package:flutter_test/flutter_test.dart';
import 'package:triomino_score/core/game/starter_resolver.dart';

void main() {
  const resolver = StarterResolver();

  group('StarterResolver', () {
    test('zwraca null dla pustej listy', () {
      expect(resolver.resolve([]), isNull);
    });

    test('preferuje gracza z tripletem nad sumą', () {
      final result = resolver.resolve([
        const HandClaim(playerId: 'a', highestTripletValue: 3),
        const HandClaim(playerId: 'b', highestTileSum: 14),
      ]);
      expect(result?.playerId, 'a');
      expect(result?.byTriplet, isTrue);
      expect(result?.tripletValue, 3);
    });

    test('wybiera najwyższy triplet gdy kilku graczy ma triplety', () {
      final result = resolver.resolve([
        const HandClaim(playerId: 'a', highestTripletValue: 1),
        const HandClaim(playerId: 'b', highestTripletValue: 4),
        const HandClaim(playerId: 'c', highestTripletValue: 2),
      ]);
      expect(result?.playerId, 'b');
      expect(result?.tripletValue, 4);
    });

    test('gdy nikt nie ma tripleta wybiera najwyższą sumę', () {
      final result = resolver.resolve([
        const HandClaim(playerId: 'a', highestTileSum: 11),
        const HandClaim(playerId: 'b', highestTileSum: 13),
        const HandClaim(playerId: 'c', highestTileSum: 9),
      ]);
      expect(result?.playerId, 'b');
      expect(result?.byTriplet, isFalse);
    });

    test('zwraca null gdy brak tripletów i brak sum', () {
      final result = resolver.resolve([
        const HandClaim(playerId: 'a'),
        const HandClaim(playerId: 'b'),
      ]);
      expect(result, isNull);
    });

    test('triplet 0-0-0 (wartość 0) wygrywa jeśli to jedyny triplet', () {
      final result = resolver.resolve([
        const HandClaim(playerId: 'a', highestTripletValue: 0),
        const HandClaim(playerId: 'b', highestTileSum: 14),
      ]);
      expect(result?.playerId, 'a');
      expect(result?.byTriplet, isTrue);
      expect(result?.tripletValue, 0);
    });
  });
}

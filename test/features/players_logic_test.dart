import 'package:flutter_test/flutter_test.dart';
import 'package:triomino_score/features/players/players_providers.dart';

void main() {
  group('initialsFor', () {
    test('jedno słowo -> dwie litery', () {
      expect(initialsFor('Anna'), 'AN');
    });

    test('dwa słowa -> pierwsze litery', () {
      expect(initialsFor('Jan Kowalski'), 'JK');
    });

    test('jedna litera', () {
      expect(initialsFor('X'), 'X');
    });

    test('pusty string', () {
      expect(initialsFor('   '), '?');
    });
  });

  group('avatarColorFor', () {
    test('jest deterministyczny', () {
      expect(avatarColorFor('Anna'), avatarColorFor('Anna'));
    });

    test('zwraca poprawny hex', () {
      expect(avatarColorFor('Bob'), matches(r'^#[0-9A-Fa-f]{6}$'));
    });
  });
}

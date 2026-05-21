import 'package:flutter_test/flutter_test.dart';
import 'package:triomino_score/features/players/domain/player.dart';

void main() {
  group('PlayerValidator.validateName', () {
    test('zwraca required dla pustego stringa', () {
      expect(PlayerValidator.validateName(''), 'required');
      expect(PlayerValidator.validateName('   '), 'required');
      expect(PlayerValidator.validateName(null), 'required');
    });

    test('zwraca tooLong dla >32 znakow', () {
      expect(PlayerValidator.validateName('a' * 33), 'tooLong');
      expect(PlayerValidator.validateName('a' * 32), isNull);
    });

    test('akceptuje normalne imię', () {
      expect(PlayerValidator.validateName('Bartosz'), isNull);
      expect(PlayerValidator.validateName('Anna Maria'), isNull);
    });
  });

  group('PlayerValidator.initialsFromName', () {
    test('jednowyrazowe imię — bierze pierwsze 2 litery', () {
      expect(PlayerValidator.initialsFromName('Bartosz'), 'BA');
      expect(PlayerValidator.initialsFromName('Ed'), 'ED');
    });

    test('jedna litera — bierze tylko jedną', () {
      expect(PlayerValidator.initialsFromName('A'), 'A');
    });

    test('dwa słowa — bierze pierwszą literę każdego', () {
      expect(PlayerValidator.initialsFromName('Bartosz Wisniewski'), 'BW');
      expect(PlayerValidator.initialsFromName('anna maria'), 'AM');
    });

    test('trzy+ słowa — bierze pierwsze i ostatnie', () {
      expect(
        PlayerValidator.initialsFromName('Anna Maria Kowalska'),
        'AK',
      );
    });

    test('puste — zwraca ?', () {
      expect(PlayerValidator.initialsFromName(''), '?');
      expect(PlayerValidator.initialsFromName('   '), '?');
    });

    test('ignoruje wielokrotne spacje', () {
      expect(PlayerValidator.initialsFromName('Anna    Kowalska'), 'AK');
    });
  });
}

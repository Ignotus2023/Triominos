import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/game/end_game_evaluator.dart';
import '../../game/domain/game.dart';
import '../../game/domain/game_repository.dart';
import '../../game/presentation/game_providers.dart';
import '../../players/domain/player.dart';
import '../../players/domain/players_repository.dart';
import '../../players/presentation/players_providers.dart';
import 'game_setup_controller.dart';

class StartGameUseCase {
  StartGameUseCase({
    required PlayersRepository players,
    required GameRepository games,
  })  : _players = players,
        _games = games;

  final PlayersRepository _players;
  final GameRepository _games;

  Future<String> call(GameSetupState setup) async {
    for (final p in setup.players) {
      if (!p.fromProfile) {
        await _players.create(
          Player(
            id: p.id,
            name: p.name,
            initials: p.initials,
            avatarColor: p.avatarColor,
            isGuest: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
      }
    }

    final snapshots = <GamePlayerSnapshot>[];
    for (var i = 0; i < setup.players.length; i++) {
      final p = setup.players[i];
      snapshots.add(
        GamePlayerSnapshot(
          playerId: p.id,
          seatIndex: i,
          displayName: p.name,
          avatarColor: p.avatarColor,
          initials: p.initials,
          totalScore: 0,
        ),
      );
    }

    final game = Game.newDraft(
      endMode: setup.endMode,
      scoringVariant: setup.variant,
      scoreLimit: setup.endMode == EndMode.scoreLimit ? setup.scoreLimit : null,
      totalRounds: setup.endMode == EndMode.rounds ? setup.totalRounds : null,
      players: snapshots,
    );

    await _games.createGame(game);
    return game.id;
  }
}

final startGameUseCaseProvider = Provider<StartGameUseCase>((ref) {
  return StartGameUseCase(
    players: ref.watch(playersRepositoryProvider),
    games: ref.watch(gameRepositoryProvider),
  );
});

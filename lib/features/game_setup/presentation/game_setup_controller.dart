import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants.dart';
import '../../../core/game/end_game_evaluator.dart';
import '../../../core/game/scoring_rules.dart';
import '../../../core/settings/settings_provider.dart';
import '../../../core/utils/id.dart';
import '../../players/domain/player.dart';

class SetupPlayer {
  const SetupPlayer({
    required this.id,
    required this.name,
    required this.initials,
    required this.avatarColor,
    required this.isGuest,
    required this.fromProfile,
  });

  factory SetupPlayer.fromProfile(Player player) {
    return SetupPlayer(
      id: player.id,
      name: player.name,
      initials: player.initials,
      avatarColor: player.avatarColor,
      isGuest: player.isGuest,
      fromProfile: true,
    );
  }

  factory SetupPlayer.guest({
    required String name,
    required String initials,
    required String avatarColor,
  }) {
    return SetupPlayer(
      id: newId(),
      name: name,
      initials: initials,
      avatarColor: avatarColor,
      isGuest: true,
      fromProfile: false,
    );
  }

  final String id;
  final String name;
  final String initials;
  final String avatarColor;
  final bool isGuest;
  final bool fromProfile;
}

class GameSetupState {
  const GameSetupState({
    required this.players,
    required this.variant,
    required this.endMode,
    required this.scoreLimit,
    required this.totalRounds,
  });

  final List<SetupPlayer> players;
  final ScoringVariant variant;
  final EndMode endMode;
  final int scoreLimit;
  final int totalRounds;

  bool get canStart =>
      players.length >= AppConstants.minPlayers &&
      players.length <= AppConstants.maxPlayers;

  GameSetupState copyWith({
    List<SetupPlayer>? players,
    ScoringVariant? variant,
    EndMode? endMode,
    int? scoreLimit,
    int? totalRounds,
  }) {
    return GameSetupState(
      players: players ?? this.players,
      variant: variant ?? this.variant,
      endMode: endMode ?? this.endMode,
      scoreLimit: scoreLimit ?? this.scoreLimit,
      totalRounds: totalRounds ?? this.totalRounds,
    );
  }
}

class GameSetupController extends Notifier<GameSetupState> {
  @override
  GameSetupState build() {
    final settings = ref.read(settingsControllerProvider);
    return GameSetupState(
      players: const [],
      variant: settings.defaultScoringVariant,
      endMode: EndMode.scoreLimit,
      scoreLimit: settings.defaultScoreLimit,
      totalRounds: AppConstants.defaultRoundCount,
    );
  }

  void togglePlayer(SetupPlayer player) {
    final exists = state.players.any((p) => p.id == player.id);
    if (exists) {
      state = state.copyWith(
        players: state.players.where((p) => p.id != player.id).toList(),
      );
    } else {
      if (state.players.length >= AppConstants.maxPlayers) return;
      state = state.copyWith(players: [...state.players, player]);
    }
  }

  void addGuest(SetupPlayer guest) {
    if (state.players.length >= AppConstants.maxPlayers) return;
    state = state.copyWith(players: [...state.players, guest]);
  }

  void reorder(int oldIndex, int newIndex) {
    final list = [...state.players];
    var target = newIndex;
    if (target > oldIndex) target -= 1;
    final moved = list.removeAt(oldIndex);
    list.insert(target, moved);
    state = state.copyWith(players: list);
  }

  void setVariant(ScoringVariant variant) {
    state = state.copyWith(variant: variant);
  }

  void setEndMode(EndMode mode) {
    state = state.copyWith(endMode: mode);
  }

  void setScoreLimit(int value) {
    state = state.copyWith(scoreLimit: value);
  }

  void setTotalRounds(int value) {
    state = state.copyWith(totalRounds: value);
  }

  void reset() {
    state = build();
  }
}

final gameSetupControllerProvider =
    NotifierProvider<GameSetupController, GameSetupState>(GameSetupController.new);

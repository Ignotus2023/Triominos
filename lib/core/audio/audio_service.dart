import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../settings/settings_provider.dart';

/// Krótkie efekty dźwiękowe (§13.1).
enum AppSound {
  tap('assets/sounds/tap.wav'),
  triplet('assets/sounds/triplet.wav'),
  bridge('assets/sounds/bridge.wav'),
  hexagon('assets/sounds/hexagon.wav'),
  win('assets/sounds/win.wav'),
  roundEnd('assets/sounds/round_end.wav');

  const AppSound(this.asset);

  final String asset;
}

/// Odtwarza krótkie sample, respektując ustawienie `soundsEnabled`.
class AudioService {
  AudioService(this._ref);

  final Ref _ref;
  final Map<AppSound, AudioPlayer> _players = {};

  bool get _enabled => _ref.read(settingsProvider).soundsEnabled;

  Future<void> play(AppSound sound) async {
    if (!_enabled) return;
    try {
      final player = _players[sound] ??= AudioPlayer();
      if (player.audioSource == null) {
        await player.setAsset(sound.asset);
      }
      await player.seek(Duration.zero);
      unawaited(player.play());
    } catch (_) {
      // Dźwięk to dodatek — ignorujemy błędy (np. polityka autoplay w web).
    }
  }

  void dispose() {
    for (final player in _players.values) {
      player.dispose();
    }
  }
}

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService(ref);
  ref.onDispose(service.dispose);
  return service;
});

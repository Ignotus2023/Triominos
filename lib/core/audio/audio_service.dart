import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../settings/settings_provider.dart';

enum SoundEffect {
  tap,
  triplet,
  bridge,
  hexagon,
  roundEnd,
  win,
}

extension on SoundEffect {
  String get asset {
    switch (this) {
      case SoundEffect.tap:
        return 'assets/sounds/tap.mp3';
      case SoundEffect.triplet:
        return 'assets/sounds/triplet.mp3';
      case SoundEffect.bridge:
        return 'assets/sounds/bridge.mp3';
      case SoundEffect.hexagon:
        return 'assets/sounds/hexagon.mp3';
      case SoundEffect.roundEnd:
        return 'assets/sounds/round_end.mp3';
      case SoundEffect.win:
        return 'assets/sounds/win.mp3';
    }
  }

  double get volume {
    switch (this) {
      case SoundEffect.tap:
        return 0.3;
      case SoundEffect.triplet:
        return 0.6;
      case SoundEffect.bridge:
        return 0.6;
      case SoundEffect.hexagon:
        return 0.8;
      case SoundEffect.roundEnd:
        return 0.5;
      case SoundEffect.win:
        return 0.7;
    }
  }
}

class AudioService {
  AudioService({required this.enabled});

  final bool enabled;
  final Map<SoundEffect, AudioPlayer> _players = {};

  Future<void> play(SoundEffect effect) async {
    if (!enabled) return;
    final player = _players.putIfAbsent(effect, AudioPlayer.new);
    try {
      if (player.audioSource == null) {
        await player.setAsset(effect.asset);
      }
      await player.setVolume(effect.volume);
      await player.seek(Duration.zero);
      await player.play();
    } on Object {
      // Audio errors should never break gameplay flow.
    }
  }

  Future<void> dispose() async {
    for (final p in _players.values) {
      await p.dispose();
    }
    _players.clear();
  }
}

final audioServiceProvider = Provider<AudioService>((ref) {
  final enabled = ref.watch(
    settingsControllerProvider.select((s) => s.soundsEnabled),
  );
  final service = AudioService(enabled: enabled);
  ref.onDispose(service.dispose);
  return service;
});

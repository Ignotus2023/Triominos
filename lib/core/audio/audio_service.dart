import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../settings/settings_provider.dart';

/// Krótkie efekty dźwiękowe (§13.1).
///
/// Ścieżki są względne do katalogu `assets/` — `audioplayers` sam dokleja
/// prefiks `assets/`, a na web ładuje plik jako blob (odporne na base-href).
enum AppSound {
  tap('sounds/tap.wav'),
  triplet('sounds/triplet.wav'),
  bridge('sounds/bridge.wav'),
  hexagon('sounds/hexagon.wav'),
  win('sounds/win.wav'),
  roundEnd('sounds/round_end.wav');

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
      final player = _players[sound] ??=
          (AudioPlayer()..setReleaseMode(ReleaseMode.stop));
      await player.stop();
      await player.play(AssetSource(sound.asset));
    } catch (_) {
      // Dźwięk to dodatek — ignorujemy ewentualne błędy odtwarzania.
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

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../settings/settings_provider.dart';

/// Lekki serwis haptyki oparty o wbudowane [HapticFeedback] (§13.2).
/// Respektuje ustawienie `hapticsEnabled`.
class HapticsService {
  const HapticsService(this._enabled);

  final bool _enabled;

  void selection() {
    if (_enabled) HapticFeedback.selectionClick();
  }

  void light() {
    if (_enabled) HapticFeedback.lightImpact();
  }

  void medium() {
    if (_enabled) HapticFeedback.mediumImpact();
  }

  void heavy() {
    if (_enabled) HapticFeedback.heavyImpact();
  }

  Future<void> success() async {
    if (!_enabled) return;
    for (var i = 0; i < 3; i++) {
      await HapticFeedback.mediumImpact();
      await Future<void>.delayed(const Duration(milliseconds: 120));
    }
  }
}

final hapticsProvider = Provider<HapticsService>((ref) {
  final enabled = ref.watch(settingsProvider.select((s) => s.hapticsEnabled));
  return HapticsService(enabled);
});

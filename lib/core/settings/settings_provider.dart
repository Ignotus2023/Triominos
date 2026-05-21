import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_settings.dart';
import 'settings_repository.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main() with the initialized instance.',
  );
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(sharedPreferencesProvider));
});

class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    final repo = ref.watch(settingsRepositoryProvider);
    return repo.load();
  }

  Future<void> update(AppSettings Function(AppSettings) updater) async {
    final next = updater(state);
    state = next;
    await ref.read(settingsRepositoryProvider).save(next);
  }
}

final settingsControllerProvider = NotifierProvider<SettingsController, AppSettings>(
  SettingsController.new,
);

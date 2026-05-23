import 'package:flutter/material.dart';

import '../../core/localization/gen/app_localizations.dart';
import '../../core/theme/app_colors.dart';

extension BuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
  GlassColors get glass => Theme.of(this).extension<GlassColors>()!;

  bool get isTablet => MediaQuery.sizeOf(this).width >= 600;
}

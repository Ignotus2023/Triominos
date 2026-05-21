import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';

extension BuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textStyles => Theme.of(this).textTheme;
  MediaQueryData get media => MediaQuery.of(this);
  ThemeData get theme => Theme.of(this);
}

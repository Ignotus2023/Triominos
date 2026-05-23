/// Skala odstępów (§11.4). Zawsze używaj tych stałych zamiast magic numbers.
abstract class AppSpacing {
  static const double x4 = 4;
  static const double x8 = 8;
  static const double x12 = 12;
  static const double x16 = 16;
  static const double x24 = 24;
  static const double x32 = 32;
  static const double x48 = 48;
  static const double x64 = 64;
}

/// Promienie zaokrągleń używane w całej aplikacji.
abstract class AppRadii {
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double pill = 999;
}

/// Punkty łamania layoutu (§11.6).
abstract class Breakpoints {
  static const double phone = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

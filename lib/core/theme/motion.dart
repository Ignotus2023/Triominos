import 'package:flutter/animation.dart';

/// Czasy trwania i krzywe animacji (§11.5).
abstract class AppMotion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);

  static const Curve curve = Curves.easeOutCubic;
  static const Curve spring = Curves.elasticOut;
}

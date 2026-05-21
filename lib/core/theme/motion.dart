import 'package:flutter/animation.dart';

abstract class AppMotion {
  AppMotion._();

  static const Duration instant = Duration(milliseconds: 80);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration celebration = Duration(milliseconds: 800);

  static const Curve emphasized = Curves.easeOutCubic;
  static const Curve standard = Curves.easeInOutCubic;
  static const Curve spring = Curves.elasticOut;
  static const Curve sharp = Curves.easeOutQuart;
}

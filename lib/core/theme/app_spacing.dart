import 'package:flutter/widgets.dart';

abstract class AppSpacing {
  AppSpacing._();

  static const double x4 = 4;
  static const double x8 = 8;
  static const double x12 = 12;
  static const double x16 = 16;
  static const double x20 = 20;
  static const double x24 = 24;
  static const double x32 = 32;
  static const double x40 = 40;
  static const double x48 = 48;
  static const double x64 = 64;

  static const double radiusSm = 8;
  static const double radiusMd = 16;
  static const double radiusLg = 24;
  static const double radiusXl = 32;
  static const double radiusFull = 999;

  static const EdgeInsets pagePadding = EdgeInsets.symmetric(horizontal: x20);
  static const EdgeInsets cardPadding = EdgeInsets.all(x16);
  static const EdgeInsets sheetPadding = EdgeInsets.fromLTRB(x20, x24, x20, x32);

  static const SizedBox h4 = SizedBox(height: x4);
  static const SizedBox h8 = SizedBox(height: x8);
  static const SizedBox h12 = SizedBox(height: x12);
  static const SizedBox h16 = SizedBox(height: x16);
  static const SizedBox h20 = SizedBox(height: x20);
  static const SizedBox h24 = SizedBox(height: x24);
  static const SizedBox h32 = SizedBox(height: x32);
  static const SizedBox h48 = SizedBox(height: x48);

  static const SizedBox w4 = SizedBox(width: x4);
  static const SizedBox w8 = SizedBox(width: x8);
  static const SizedBox w12 = SizedBox(width: x12);
  static const SizedBox w16 = SizedBox(width: x16);
  static const SizedBox w24 = SizedBox(width: x24);
}

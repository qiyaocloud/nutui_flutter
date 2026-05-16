import 'package:flutter/material.dart';

class NutUIBorderRadius {
  NutUIBorderRadius._();

  static const double radius0 = 0.0;
  static const double radius1 = 2.0;
  static const double radius2 = 4.0;
  static const double radius3 = 8.0;
  static const double radius4 = 12.0;
  static const double radius5 = 16.0;
  static const double radius6 = 20.0;
  static const double radius7 = 24.0;
  static const double radiusRound = 999.0;
  static const double radiusCircle = 999.0; // 用 BorderRadius.circular 实现

  // 预设 BorderRadius
  static BorderRadius get none => BorderRadius.zero;
  static BorderRadius get small => BorderRadius.circular(radius1);
  static BorderRadius get normal => BorderRadius.circular(radius2);
  static BorderRadius get medium => BorderRadius.circular(radius3);
  static BorderRadius get large => BorderRadius.circular(radius4);
  static BorderRadius get xLarge => BorderRadius.circular(radius5);
  static BorderRadius get round => BorderRadius.circular(radiusRound);

  // 圆形：配合 SizedBox + DecoratedBox 使用
  static BorderRadius get circle => BorderRadius.circular(radiusCircle);
}
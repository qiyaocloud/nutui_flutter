import 'dart:ui';

import 'colors.dart';

class NutUITypography {
  NutUITypography._();

  // 字号
  static const double fontSize0 = 10.0; // 辅助文字
  static const double fontSize1 = 12.0; // 次要文字
  static const double fontSize2 = 14.0; // 常规文字
  static const double fontSize3 = 16.0; // 小标题
  static const double fontSize4 = 18.0; // 标题
  static const double fontSize5 = 20.0; // 大标题
  static const double fontSize6 = 22.0; // 特大标题

  // 字重
  static const FontWeight fontWeightNormal = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightBold = FontWeight.w700;
  static const FontWeight fontWeightHeavy = FontWeight.w900;

  // 行高
  static const double lineHeight0 = 14.0;
  static const double lineHeight1 = 18.0;
  static const double lineHeight2 = 20.0;
  static const double lineHeight3 = 22.0;
  static const double lineHeight4 = 24.0;
  static const double lineHeight5 = 28.0;
  static const double lineHeight6 = 30.0;

  // 预设 TextStyle
  static TextStyle get titleLarge => TextStyle(
    fontSize: fontSize6,
    fontWeight: fontWeightBold,
    color: NutUIColors.textTertiary,
    height: lineHeight0 / fontSize0,
  );

  // 按钮 TextStyle
  static TextStyle get buttonLarge => TextStyle(
    fontSize: fontSize3,
    fontWeight: fontWeightMedium,
    color: NutUIColors.white,
    height: 1.0,
  );

  static TextStyle get buttonMedium => TextStyle(
    fontSize: fontSize2,
    fontWeight: fontWeightMedium,
    color: NutUIColors.white,
    height: 1.0,
  );

  static TextStyle get buttonSmall => TextStyle(
    fontSize: fontSize1,
    fontWeight: FontWeight.w500,
    color: NutUIColors.white,
    height: 1.0,
  );
}
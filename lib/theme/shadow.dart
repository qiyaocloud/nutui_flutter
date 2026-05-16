import 'package:flutter/material.dart';

class NutUIShadow {
  NutUIShadow._();

  // 对应 NutUI 的 box-shadow
  static List<BoxShadow> get level0 => [];

  static List<BoxShadow> get level1 => [
    const BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 1),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get level2 => [
    const BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get level3 => [
    const BoxShadow(
      color: Color(0x26000000),
      offset: Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get level4 => [
    const BoxShadow(
      color: Color(0x33000000),
      offset: Offset(0, 8),
      blurRadius: 32,
      spreadRadius: 0,
    ),
  ];

  // Popup / Dialog 专用阴影
  static List<BoxShadow> get popup => [
    const BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  // Tab 固定底部阴影
  static List<BoxShadow> get tabbar => [
    const BoxShadow(
      color: Color(0x0D000000),
      offset: Offset(0, -1),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];
}
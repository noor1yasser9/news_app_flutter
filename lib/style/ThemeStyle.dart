import 'dart:ui';

import 'package:flutter/cupertino.dart';

class ThemeStyle {

  const ThemeStyle();

  static const Color mainColor = const Color(0xFF393939);
  static const Color secondColor = const Color(0xFF393939);
  static const Color grey = const Color(0xFFE5E5E5);
  static const Color background = const Color(0xFFf0f1f6);
  static const Color titleColor = const Color(0xFF6C6C6C);
  static const Color titleColor_100 = const Color(0x68383838);
  static const Color dark = const Color(0xFF2F2F2F);
  static const primaryGradient = const LinearGradient(
    colors: const [ Color(0xFF393939), Color(0xff000000)],
    stops: const [0.0, 1.0],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
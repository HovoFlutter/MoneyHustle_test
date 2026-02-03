import 'dart:ui';

import 'package:flutter/material.dart';

class MHColorStyles {
  static const onbBackground = Color(0xFFF2F2F2);
  
  static const primary = Color(0xFF1F7A5A);
  static const primaryWithOpacity = Color(0x261F7A5A);
  
  static const accent = Color(0xFF6B6EEA);
  static const accentWithOpacity = Color(0x266B6EEA);
  
  @Deprecated('Use primary instead')
  static const indigo = primary;
  @Deprecated('Use primaryWithOpacity instead')
  static const indigoWithOpacity = primaryWithOpacity;
  
  static const green = Color(0xFF34C759);
  static const greenWithOpacity = Color(0x3334C759);
  static const bgSecondary = Color(0xFFF2F2F7);
  static const primaryTxt = Color(0xFF131313);

  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const pink = Color(0xFFFF2D55);
  static const pinkWithOpacity = Color(0x33FF2D55);
  static const orange = Color(0xFFFF9500);
  static const orangeWithOpacity = Color(0x33FF9500);
  static const cyan = Color(0xFF32ADE6);
  static const cyanWithOpacity = Color(0x3332ADE6);
  static const yellow = Color(0xFFFFCC00);
  static const yellowWithOpacity = Color(0x33FFCC00);

  static const yellowDark = Color(0xFFFFD60A);

  static const color1 = Color(0xFFE7F3FF);
  static const color2 = Color(0x99FFFFFF);
  static const labelsSecondaryDark = Color(0x99EBEBF5);
  static const color4 = Color(0x4DEBEBF5);
  static const color5 = Color(0x29EBEBF5);
  static const color6 = Color(0x993C3C43);
  static const labelsTertiary = Color(0x4D3C3C43);
  static const color8 = Color(0x2E3C3C43);
  static const fillsTertiary = Color(0x1F767680);

  static const color0 = Color(0xFFC7C7CC);

  static const gray2Dark = Color(0xFF636366);
}

class MHThemeColors {
  static const splashBackground = MHColorStyles.primary;
  static const pageBackground = MHColorStyles.bgSecondary;
  static const appBarBackground = MHColorStyles.bgSecondary;
  static const appBarForeground = MHColorStyles.primaryTxt;

  static const filledButton = MHColorStyles.primary;
  static const filledButtonDisalbed = MHColorStyles.fillsTertiary;
  static const filledButtonForeground = MHColorStyles.white;
  static const filledButtonText = MHColorStyles.white;
  static const filledButtonDisableText = MHColorStyles.labelsTertiary;
  static const filledButtonDisableForeground = MHColorStyles.labelsTertiary;
  static const textFieldBackground = MHColorStyles.white;
  static const textFieldInput = MHColorStyles.primary;

  static const iconColor = MHColorStyles.primary;
  static const actionIconColor = MHColorStyles.primary;
  static const deleteColor = MHColorStyles.pink;
}

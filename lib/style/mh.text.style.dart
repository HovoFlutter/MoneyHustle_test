import 'package:flutter/material.dart';
import 'package:money_hustle/core/ui/mh.text.dart';

import 'mh.color.style.dart';

class MHTextStyles {
  static var onboarding = TextStyle(
    fontSize: 26,
    height: 32 / 26,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.4,
  ).rz;

  static var largeTitleRegular = TextStyle(
    fontSize: 34,
    height: 41 / 34,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.4,
  ).rz;

  static var largeTitleEmphasized = TextStyle(
    fontSize: 34,
    height: 41 / 34,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
  ).rz;

  static var title1Regular = TextStyle(
    fontSize: 28,
    height: 34 / 28,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.4,
  ).rz;

  static var title1Emphasized = TextStyle(
    fontSize: 28,
    height: 34 / 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
  ).rz;

  static var title2Regular = TextStyle(
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.4,
  ).rz;

  static var title2Emphasized = TextStyle(
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
  ).rz;

  static var title3Regular = TextStyle(
    fontSize: 20,
    height: 25 / 20,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.4,
  ).rz;

  static var title3Emphasized = TextStyle(
    fontSize: 20,
    height: 25 / 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
  ).rz;

  static var headlineRegular = TextStyle(
    fontSize: 17,
    height: 22 / 17,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
  ).rz;

  static var bodyRegular = TextStyle(
    fontSize: 17,
    height: 22 / 17,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.4,
  ).rz;

  static var bodyEmphasized = TextStyle(
    fontSize: 17,
    height: 22 / 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.4,
  ).rz;

  //body lato
  static var bodyLatoRegular = TextStyle(
    fontSize: 17,
    height: 22 / 17,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.4,
    fontStyle: FontStyle.italic,
  ).rz;

  static var bodyLatoEmphasized = TextStyle(
    fontSize: 17,
    height: 22 / 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.4,
    fontStyle: FontStyle.italic,
  ).rz;

  static var calloutRegular = TextStyle(
    fontSize: 16,
    height: 21 / 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.4,
  ).rz;

  static var calloutEmphasized = TextStyle(
    fontSize: 16,
    height: 21 / 16,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
  ).rz;

  static var calloutLatoRegular = TextStyle(
    fontSize: 16,
    height: 21 / 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.4,
    fontStyle: FontStyle.italic,
  ).rz;

  static var calloutLatoEmphasized = TextStyle(
    fontSize: 16,
    height: 21 / 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.4,
    fontStyle: FontStyle.italic,
  ).rz;

  static var subheadlineRegular = TextStyle(
    fontSize: 15,
    height: 20 / 15,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.4,
  ).rz;

  static var subheadlineEmphasized = TextStyle(
    fontSize: 15,
    height: 20 / 15,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
  ).rz;

  static var footnoteRegular = TextStyle(
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.4,
  ).rz;

  static var footnoteEmphasized = TextStyle(
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.4,
  ).rz;

  static var caption1Regular = TextStyle(
    fontSize: 12,
    height: 16 / 13,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.4,
  ).rz;

  static var caption1Emphasized = TextStyle(
    fontSize: 12,
    height: 16 / 13,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
  ).rz;

  static var caption2Regular = TextStyle(
    fontSize: 11,
    height: 13 / 11,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.4,
  ).rz;

  static var caption2Emphasized = TextStyle(
    fontSize: 11,
    height: 13 / 11,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
  ).rz;
}

class ThemeTextStyles {
  const ThemeTextStyles();

  static var appBarTitle = MHTextStyles.bodyEmphasized.copyWith(
    color: MHColorStyles.primaryTxt,
  );

  static var filledButttonText = MHTextStyles.headlineRegular;

  static var filledButttonDisabledText = MHTextStyles.headlineRegular;

  static var textFieldInput = const TextStyle(
    fontSize: 40,
    height: 47 / 40,
    fontWeight: FontWeight.w700,
    color: MHColorStyles.indigo,
    letterSpacing: -0.94,
  ).rz;
}

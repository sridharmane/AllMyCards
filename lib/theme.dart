import 'package:flutter/material.dart';

const kPrimaryColor = const Color(0xff006064);
const kPrimaryColorLight = const Color(0xff428e92);
const kPrimaryColorDark = const Color(0xff00363a);

ThemeData kThemeLight = ThemeData.light().copyWith(
  primaryColor: kPrimaryColor,
  primaryColorLight: kPrimaryColorLight,
  primaryColorDark: kPrimaryColorDark,
  primaryColorBrightness: Brightness.dark,
  accentColor: const Color(0xffe57373),
  accentColorBrightness: Brightness.light,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

ThemeData kThemeDark = ThemeData.dark().copyWith(
  primaryColor: kPrimaryColorDark,
  primaryColorLight: kPrimaryColor,
  primaryColorDark: kPrimaryColorDark,
  primaryColorBrightness: Brightness.dark,
  accentColor: const Color(0xffe57373),
  accentColorBrightness: Brightness.light,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

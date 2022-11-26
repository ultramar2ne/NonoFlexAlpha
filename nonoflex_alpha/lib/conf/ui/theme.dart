import 'package:flutter/material.dart';
import 'package:nonoflex_alpha/gen/fonts.gen.dart';

abstract class BNTheme {
  // Color
  Color get base;

  Color get baseDark;

  Color get error;

  Color get errorDisabled;

  Color get nonoBlue;

  Color get nonoOrange;

  Color get nonoYellow;

  Color get primary;

  Color get primaryDark;

  Color get primaryDisabled;

  Color get primaryLight;

  Color get secondary;

  Color get secondaryDark;

  Color get secondaryLight;

  Color get shadow;

  Color get textDark;

  Color get textLight;

  Color get textDisable;

  Color get textError;

  Color get textHint;

  Color get textColored;

  Color get textColoredDark;

  // Text Style
  TextStyle get title;

  TextStyle get subTitle;

  TextStyle get normal;

  TextStyle get small;

  TextStyle get large;

  TextStyle get button;

  TextStyle get hint;

  TextStyle get label;

  TextStyle get listTitle;

  TextStyle get listSubTitle;

  TextStyle get listBody;

  TextStyle get listSubBody;
}

class LightTheme extends BNTheme {
  @override
  Color get base => const Color(0xFFFFFFFF);

  @override
  Color get baseDark => const Color(0xFFF1F4F8);

  @override
  Color get error => const Color(0xFFE21F1F);

  @override
  Color get errorDisabled => const Color(0xFFD43D3D);

  @override
  Color get nonoBlue => const Color(0xFF1F6DE2);

  @override
  Color get nonoOrange => const Color(0xFFF96D39);

  @override
  Color get nonoYellow => const Color(0xFFFFA800);

  @override
  Color get primary => const Color(0xFF1F6DE2);

  @override
  Color get primaryDark => const Color(0xFF0043AF);

  @override
  Color get primaryDisabled => const Color(0xFF1F6DE2);

  @override
  Color get primaryLight => const Color(0xFF6A9BFF);

  @override
  Color get secondary => const Color(0xFFE2F1FF);

  @override
  Color get secondaryDark => const Color(0xFFB0BECC);

  @override
  Color get secondaryLight => const Color(0xFFF2F9FF);

  @override
  Color get shadow => const Color(0xFF000000);

  @override
  Color get textColored => const Color(0xFF1F6DE2);

  @override
  Color get textColoredDark => const Color(0xFF0B005C);

  @override
  Color get textDark => const Color(0xFF2E2E2E);

  @override
  Color get textDisable => const Color(0xFFE9ECEF);

  @override
  Color get textError => const Color(0xFFE21F1F);

  @override
  Color get textHint => const Color(0xFF7A7A7D);

  @override
  get textLight => const Color(0xFFFFFFFF);

  @override
  TextStyle get title => TextStyle(
        fontFamily: FontFamily.notoSansKR,
        fontWeight: FontWeight.w700,
        color: textDark,
        fontSize: 32,
      );

  @override
  TextStyle get subTitle => TextStyle(
        fontFamily: FontFamily.notoSansKR,
        fontWeight: FontWeight.normal,
        color: textHint,
        fontSize: 14,
      );

  @override
  TextStyle get normal => TextStyle(
        fontFamily: FontFamily.notoSansKR,
        fontWeight: FontWeight.normal,
        color: textDark,
        fontSize: 14,
      );

  @override
  TextStyle get small => TextStyle(
        fontFamily: FontFamily.notoSansKR,
        fontWeight: FontWeight.normal,
        color: textDark,
        fontSize: 14,
      );

  @override
  TextStyle get large => TextStyle(
        fontFamily: FontFamily.notoSansKR,
        fontWeight: FontWeight.normal,
        color: textDark,
        fontSize: 14,
      );

  @override
  TextStyle get button => TextStyle(
        fontFamily: FontFamily.notoSansKR,
        fontWeight: FontWeight.normal,
        color: textHint,
        fontSize: 14,
      );

  @override
  TextStyle get hint => TextStyle(
        fontFamily: FontFamily.notoSansKR,
        fontWeight: FontWeight.normal,
        color: textHint,
        fontSize: 14,
      );

  @override
  TextStyle get label => TextStyle(
        fontFamily: FontFamily.notoSansKR,
        fontWeight: FontWeight.normal,
        color: textDark,
        fontSize: 14,
      );

  @override
  TextStyle get listTitle => TextStyle(
        fontFamily: FontFamily.notoSansKR,
        fontWeight: FontWeight.normal,
        color: textDark,
        fontSize: 14,
      );

  @override
  TextStyle get listSubTitle => TextStyle(
        fontFamily: FontFamily.notoSansKR,
        fontWeight: FontWeight.normal,
        color: textDark,
        fontSize: 14,
      );

  @override
  TextStyle get listBody => TextStyle(
        fontFamily: FontFamily.notoSansKR,
        fontWeight: FontWeight.normal,
        color: textDark,
        fontSize: 14,
      );

  @override
  TextStyle get listSubBody => TextStyle(
        fontFamily: FontFamily.notoSansKR,
        fontWeight: FontWeight.normal,
        color: textDark,
        fontSize: 14,
      );
}

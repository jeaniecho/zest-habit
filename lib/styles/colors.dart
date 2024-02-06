import 'package:flutter/material.dart';

class HTColors {
  HTColors._();

  static final lightColorScheme = ColorScheme.fromSeed(
      seedColor: white,
      brightness: Brightness.light,
      primary: white,
      onPrimary: black,
      secondary: grey010,
      onSecondary: grey080,
      tertiary: HTColors.grey020,
      onTertiary: HTColors.grey070,
      error: error,
      onError: white,
      background: white,
      onBackground: black,
      surface: white,
      onSurface: black);

  static final darkColorScheme = ColorScheme.fromSeed(
      seedColor: black,
      brightness: Brightness.dark,
      primary: black,
      onPrimary: white,
      secondary: grey080,
      onSecondary: grey010,
      tertiary: HTColors.grey070,
      onTertiary: HTColors.grey020,
      error: error,
      onError: black,
      background: black,
      onBackground: white,
      surface: black,
      onSurface: white);

  static const _secondaryValue = 0xFF39D9C6;

  // secondary value
  static const _secondaryVatiantValue = 0xFF24BBA9;

  int get secondaryValue => _secondaryValue;
  int get secondaryVatiantValue => _secondaryVatiantValue;

  // yellow value
  static const _yellowValue = 0xFFFCCB6B;

  // red value
  static const _redValue = 0xFFFC5454;

  // red value
  static const _blueValue = 0xFF29A5FF;

  static const error = Color(0xFFFC5454);

  // Background
  static const background = Colors.white;

  // Surface
  static const surface = Colors.white;

  //skeleton
  static const shimmerBackgorund = grey020;
  static const shimmerHighlight = grey010;

  // Grey
  static const grey010 = Color(0xFFF4F5F7);
  static const grey020 = Color(0xFFE5E7EB);
  static const grey030 = Color(0xFFD3D6DB);
  static const grey040 = Color(0xFFA0A6B1);
  static const grey050 = Color(0xFF6C727F);
  static const grey060 = Color(0xFF4D5562);
  static const grey070 = Color(0xFF394150);
  static const grey080 = Color(0xFF272F3E);
  static const grey090 = Color(0xFF151515);
  static bool isAppGrey(c) => [
        grey010,
        grey020,
        grey030,
        grey040,
        grey050,
        grey060,
        grey070,
        grey080,
        grey090,
      ].contains(c);

  // Clear
  static const clear = Color(0x00FFFFFF);

  // White
  static const white = Colors.white;
  static const white30 = Color(0x4CFFFFFF);
  static const white50 = Color(0x7FFFFFFF);
  static const white80 = Color(0xCCFFFFFF);

  // Black
  static const materialBlack = Colors.black;
  static const black = Color(0xFF181E2D);
  static const black30 = Color(0x4C181E2D);
  static const black50 = Color(0x7F181E2D);
  static const black80 = Color(0xCC181E2D);

  // Secondary
  static const MaterialColor secondary =
      MaterialColor(_secondaryValue, <int, Color>{
    100: Color(0xFFFAFEFD),
    200: Color(0xFFB9F2EB),
    300: Color(0xFF39D9C6),
    400: Color(_secondaryValue),
    500: Color(_secondaryVatiantValue),
    600: Color(0xFF1C9082),
    700: Color(0xFF13655C),
  });

  // Yellow
  static const materialYellow = Colors.yellow;
  static const yellow = MaterialColor(_yellowValue, <int, Color>{
    100: Color(0xFFFFF7E8),
    200: Color(0xFFFFF7E8),
    300: Color(0xFFFDDD9D),
    400: Color(_yellowValue),
    500: Color(0xFFFAB120),
    600: Color(0xFFE39805),
    700: Color(0xFFB17604),
  });

  // Red
  static const red = MaterialColor(_redValue, <int, Color>{
    100: Color(0xFFFFEAEA),
    200: Color(0xFFFED1D1),
    300: Color(0xFFFD9F9F),
    400: Color(_redValue),
    500: Color(0xFFE60404),
    600: Color(0xFF9B0303),
    700: Color(0xFF500101),
  });

  // Blue
  static const blue = MaterialColor(_blueValue, <int, Color>{
    100: Color(0xFFF5FBFF),
    200: Color(0xFFC2E5FF),
    300: Color(0xFF75C5FF),
    400: Color(_blueValue),
    500: Color(0xFF007FDB),
    600: Color(0xFF00538F),
    700: Color(0xFF002742),
  });

  static const skyBlue = Color(0xFFE4F4FF);

  static const orange = Color(0xFFEC920B);
}

import 'package:flutter/material.dart';

HTGreys htGreys(context) => Theme.of(context).extension<HTGreys>()!;

List<int> taskColors = [
  0xFF000000,
  0xFF435EEB,
  0XFF40A2E3,
  0XFF50CD73,
  0XFFC854F1,
  0XFFE74646,
  0XFFFF8080,
  0XFFFFD93D,
];

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

  // grey
  static const grey010 = Color(0xFFF4F5F7);
  static const grey020 = Color(0xFFE5E7EB);
  static const grey030 = Color(0xFFD3D6DB);
  static const grey040 = Color(0xFFA0A6B1);
  static const grey050 = Color(0xFF6C727F);
  static const grey060 = Color(0xFF4D5562);
  static const grey070 = Color(0xFF394150);
  static const grey080 = Color(0xFF272F3E);
  static const grey090 = Color(0xFF151515);

  // Clear
  static const clear = Color(0x00FFFFFF);

  // White
  static const white = Colors.white;
  static const white30 = Color(0x4CFFFFFF);
  static const white50 = Color(0x7FFFFFFF);
  static const white80 = Color(0xCCFFFFFF);

  // Black
  static const materialBlack = Colors.black;
  // static const black = Color(0xFF181E2D);
  static const black = Colors.black;
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

class HTGreys extends ThemeExtension<HTGreys> {
  final Color white;
  final Color black;
  final Color grey010;
  final Color grey020;
  final Color grey030;
  final Color grey040;
  final Color grey050;
  final Color grey060;
  final Color grey070;
  final Color grey080;
  final Color grey090;

  HTGreys({
    this.white = const Color(0xFFFFFFFF),
    this.black = const Color(0xFF000000),
    this.grey010 = const Color(0xFFF4F5F7),
    this.grey020 = const Color(0xFFE5E7EB),
    this.grey030 = const Color(0xFFD3D6DB),
    this.grey040 = const Color(0xFFA0A6B1),
    this.grey050 = const Color(0xFF6C727F),
    this.grey060 = const Color(0xFF4D5562),
    this.grey070 = const Color(0xFF394150),
    this.grey080 = const Color(0xFF272F3E),
    this.grey090 = const Color(0xFF151515),
  });

  @override
  HTGreys copyWith({
    Color? white,
    Color? black,
    Color? grey010,
    Color? grey020,
    Color? grey030,
    Color? grey040,
    Color? grey050,
    Color? grey060,
    Color? grey070,
    Color? grey080,
    Color? grey090,
  }) {
    return HTGreys(
      white: white ?? this.white,
      black: black ?? this.black,
      grey010: grey010 ?? this.grey010,
      grey020: grey020 ?? this.grey020,
      grey030: grey030 ?? this.grey030,
      grey040: grey040 ?? this.grey040,
      grey050: grey050 ?? this.grey050,
      grey060: grey060 ?? this.grey060,
      grey070: grey070 ?? this.grey070,
      grey080: grey080 ?? this.grey080,
      grey090: grey090 ?? this.grey090,
    );
  }

  @override
  HTGreys lerp(ThemeExtension<HTGreys>? other, double t) {
    if (other is HTGreys) {
      return HTGreys(
        white: Color.lerp(white, other.white, t)!,
        black: Color.lerp(black, other.black, t)!,
        grey010: Color.lerp(grey010, other.grey010, t)!,
        grey020: Color.lerp(grey020, other.grey020, t)!,
        grey030: Color.lerp(grey030, other.grey030, t)!,
        grey040: Color.lerp(grey040, other.grey040, t)!,
        grey050: Color.lerp(grey050, other.grey050, t)!,
        grey060: Color.lerp(grey060, other.grey060, t)!,
        grey070: Color.lerp(grey070, other.grey070, t)!,
        grey080: Color.lerp(grey080, other.grey080, t)!,
        grey090: Color.lerp(grey090, other.grey090, t)!,
      );
    } else {
      return this;
    }
  }
}

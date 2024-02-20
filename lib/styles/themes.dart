import 'package:flutter/material.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';

class HTThemes {
  HTThemes._();
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: HTColors.white,
    ),
    scaffoldBackgroundColor: HTColors.white,
    splashColor: HTColors.clear,
    primaryColor: HTColors.black,
    focusColor: HTColors.grey030,
    highlightColor: HTColors.clear,
    cardColor: HTColors.white,
    disabledColor: HTColors.grey020,
    colorScheme: HTColors.lightColorScheme,
    textSelectionTheme:
        const TextSelectionThemeData(cursorColor: HTColors.grey060),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        splashFactory: InkRipple.splashFactory,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        backgroundColor: HTColors.black,
        shape: RoundedRectangleBorder(borderRadius: HTBorderRadius.circular8),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: HTColors.black,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: HTColors.grey010,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: HTColors.grey010, width: 1),
        borderRadius: HTBorderRadius.circular10,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: HTColors.grey030, width: 1),
        borderRadius: HTBorderRadius.circular10,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: HTColors.red, width: 1),
        borderRadius: HTBorderRadius.circular10,
      ),
    ),
    radioTheme: RadioThemeData(
      visualDensity: const VisualDensity(
        horizontal: VisualDensity.minimumDensity,
        vertical: VisualDensity.minimumDensity,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fillColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        return (states.contains(MaterialState.selected))
            ? HTColors.black
            : HTColors.grey040;
      }),
    ),
    useMaterial3: true,
    fontFamily: 'Pretendard',
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor: HTColors.black,
    ),
    scaffoldBackgroundColor: HTColors.black,
    splashColor: HTColors.clear,
    primaryColor: HTColors.white,
    focusColor: HTColors.grey080,
    highlightColor: HTColors.clear,
    cardColor: HTColors.black,
    disabledColor: HTColors.grey070,
    colorScheme: HTColors.darkColorScheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        splashFactory: InkRipple.splashFactory,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        backgroundColor: HTColors.white,
        shape: RoundedRectangleBorder(borderRadius: HTBorderRadius.circular8),
      ),
    ),
    useMaterial3: true,
    fontFamily: 'Pretendard',
  );
}

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
    shadowColor: HTColors.black,
    primaryColor: HTColors.black,
    focusColor: HTColors.grey030,
    highlightColor: HTColors.grey040,
    cardColor: HTColors.white,
    disabledColor: HTColors.grey020,
    colorScheme: HTColors.lightColorScheme,
    textSelectionTheme: const TextSelectionThemeData(
        cursorColor: HTColors.grey060,
        selectionColor: HTColors.grey030,
        selectionHandleColor: HTColors.grey040),
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
    buttonTheme: const ButtonThemeData(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      buttonColor: HTColors.black,
      disabledColor: HTColors.grey030,
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
    extensions: [HTGreys()],
  );

  static final darkTheme = ThemeData(
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(
        backgroundColor: HTColors.black,
      ),
      scaffoldBackgroundColor: HTColors.black,
      shadowColor: HTColors.white,
      splashColor: HTColors.clear,
      primaryColor: HTColors.white,
      focusColor: HTColors.grey070,
      highlightColor: HTColors.grey060,
      cardColor: HTColors.black,
      disabledColor: HTColors.grey080,
      colorScheme: HTColors.darkColorScheme,
      textSelectionTheme: const TextSelectionThemeData(
          cursorColor: HTColors.grey040,
          selectionColor: HTColors.grey070,
          selectionHandleColor: HTColors.grey060),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          splashFactory: InkRipple.splashFactory,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          backgroundColor: HTColors.white,
          shape: RoundedRectangleBorder(borderRadius: HTBorderRadius.circular8),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: HTColors.white,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: HTColors.grey090,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: HTColors.grey090, width: 1),
          borderRadius: HTBorderRadius.circular10,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: HTColors.grey070, width: 1),
          borderRadius: HTBorderRadius.circular10,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: HTColors.red, width: 1),
          borderRadius: HTBorderRadius.circular10,
        ),
      ),
      buttonTheme: const ButtonThemeData(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        buttonColor: HTColors.white,
        disabledColor: HTColors.grey070,
      ),
      radioTheme: RadioThemeData(
        visualDensity: const VisualDensity(
          horizontal: VisualDensity.minimumDensity,
          vertical: VisualDensity.minimumDensity,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        fillColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          return (states.contains(MaterialState.selected))
              ? HTColors.white
              : HTColors.grey060;
        }),
      ),
      useMaterial3: true,
      fontFamily: 'Pretendard',
      extensions: [
        HTGreys().copyWith(
          white: const Color(0xFF000000),
          black: const Color(0xFFFFFFFF),
          grey010: const Color(0xFF151515),
          grey020: const Color(0xFF272F3E),
          grey030: const Color(0xFF394150),
          grey040: const Color(0xFF4D5562),
          grey050: const Color(0xFF6C727F),
          grey060: const Color(0xFFA0A6B1),
          grey070: const Color(0xFFD3D6DB),
          grey080: const Color(0xFFE5E7EB),
          grey090: const Color(0xFFF4F5F7),
        )
      ]);
}

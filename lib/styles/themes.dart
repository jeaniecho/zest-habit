import 'package:flutter/material.dart';
import 'package:habit_app/styles/colors.dart';

class HTThemes {
  HTThemes._();
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xffFCFDFF),
    ),
    scaffoldBackgroundColor: const Color(0xffFCFDFF),
    splashColor: Colors.transparent,
    primaryColor: const Color(0xff39A0FF),
    focusColor: const Color(0xff39A0FF),
    highlightColor: Colors.transparent,
    cardColor: Colors.white,
    disabledColor: const Color(0xFFCDCDCD),
    colorScheme: HTColors.lightColorScheme,
    textSelectionTheme:
        const TextSelectionThemeData(cursorColor: Color(0xff39A0FF)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        splashFactory: InkRipple.splashFactory,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        backgroundColor: const Color(0xffD8ECFF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xff39A0FF), width: 2)),
    ),
    useMaterial3: true,
    fontFamily: 'NotoSansKR',
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff2D2D2D),
    ),
    scaffoldBackgroundColor: const Color(0xff2D2D2D),
    splashColor: Colors.transparent,
    primaryColor: const Color(0xff39A0FF),
    focusColor: const Color(0xff39A0FF),
    highlightColor: Colors.transparent,
    cardColor: const Color(0xff242424),
    disabledColor: const Color(0xFF757575),
    colorScheme: HTColors.darkColorScheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        splashFactory: InkRipple.splashFactory,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        backgroundColor: const Color.fromARGB(255, 40, 111, 178),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    useMaterial3: true,
    fontFamily: 'NotoSansKR',
  );
}

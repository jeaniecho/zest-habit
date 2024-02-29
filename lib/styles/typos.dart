import 'package:flutter/material.dart';

final material2021 = Typography.material2021();

enum HTTypoToken {
  headlineXXLarge(56, 1.4, 0, FontWeight.w700),

  headlineXLarge(48, 1.4, 0, FontWeight.w700),

  headlineLarge(36, 1.4, 0, FontWeight.w700),

  headlineML(32, 1.4, 0, FontWeight.w700),

  headlineMedium(28, 1.5, 0, FontWeight.w700),

  headlineSmall(24, 1.5, 0, FontWeight.w700),

  headlineXSmall(18, 1.5, 0, FontWeight.w700),

  headlineXXSmall(16, 1.5, 0, FontWeight.w700),

  subtitleXXLarge(24, 1.4, 0, FontWeight.w700),

  subtitleXLarge(20, 1.4, 0, FontWeight.w700),

  subtitleLarge(18, 1.4, 0, FontWeight.w700),

  subtitleMedium(16, 1.2, 0, FontWeight.w700),

  subtitleSmall(15, 1.4, 0, FontWeight.w700),

  subtitleXSmall(14, 1.4, 0, FontWeight.w700),

  subtitleXXSmall(12, 1.4, 0, FontWeight.w700),

  bodyHuge(48, 1.4, 0, FontWeight.w500),

  bodyXXXLarge(36, 1.4, 0, FontWeight.w500),

  bodyXXLarge(24, 1.5, 0, FontWeight.w500),

  bodyXLarge(20, 1.5, 0, FontWeight.w500),

  bodyLarge(18, 1.5, 0, FontWeight.w500),

  bodyMedium(16, 1.5, 0, FontWeight.w500),

  bodySmall(15, 1.6, 0, FontWeight.w500),

  bodyXSmall(14, 1.6, 0, FontWeight.w500),

  bodyXXSmall(12, 1.6, 0, FontWeight.w500),

  captionLarge(20, 1.1, 0, FontWeight.w500),

  captionMedium(16, 1.1, 0, FontWeight.w500),

  captionSmall(14, 1.15, 0, FontWeight.w500),

  captionXSmall(12, 1.2, 0, FontWeight.w500),

  captionXXSmall(10, 1.2, 0, FontWeight.w500),

  overlineLarge(12, 1.0, 0, FontWeight.w400),

  overlineMedium(10, 1.0, 0, FontWeight.w500),

  overlineSmall(9, 1.0, 0, FontWeight.w500),

  buttonTextXXLarge(24, 2.4, 0, FontWeight.w600),

  buttonTextXLarge(20, 2.0, 0, FontWeight.w600),

  buttonTextLarge(18, 1.8, 0, FontWeight.w600),

  buttonTextMedium(16, 1.6, 0, FontWeight.w600),

  buttonTextSmall(15, 1.5, 0, FontWeight.w600),

  buttonTextXSmall(14, 1.4, 0, FontWeight.w600),

  buttonTextXXSmall(12, 1.2, 0, FontWeight.w600),

  tagMobile(10, 1.0, 0, FontWeight.w500);

  final double size;
  final double height;
  final double letterSpacing;
  final FontWeight weight;
  // double get height => size * heightRaito;
  double get letter => size * letterSpacing;

  TextStyle get textStyle => TextStyle(
        fontFamily: 'Pretendard',
        fontSize: size,
        height: height,
        leadingDistribution: TextLeadingDistribution.even,
        letterSpacing: letterSpacing,
        fontWeight: weight,
      );

  const HTTypoToken(
    this.size,
    this.height,
    this.letterSpacing,
    this.weight,
  );
}

class MaterialTypoSizes {
  MaterialTypoSizes._();
  static const k57 = 57.0;
  static const k45 = 45.0;
  static const k36 = 36.0;
  static const k32 = 32.0;
  static const k28 = 28.0;
  static const k24 = 24.0;
  static const k22 = 22.0;
  static const k20 = 20.0;
  static const k18 = 18.0;
  static const k16 = 16.0;
  static const k14 = 14.0;
  static const k12 = 12.0;
  static const k11 = 11.0;
  static const displayLarge = k57;
  static const displayMedium = k45;
  static const displaySmall = k36;
  static const headlineLarge = k32;
  static const headlineMedium = k28;
  static const headlineSmall = k24;
  static const titleLarge = k22;
  static const titleMedium = k16;
  static const titleSmall = k14;
  static const labelLarge = k14;
  static const labelMedium = k12;
  static const labelSmall = k11;
  static const bodyLarge = k16;
  static const bodyMedium = k14;
  static const bodySmall = k12;
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:habit_app/styles/colors.dart';

class HTShadows {
  HTShadows._();

  static final dropDownPrimary40 = Shadow(
    color: HTColors.black.withOpacity(0.12),
    blurRadius: 8,
    offset: const Offset(0, 2),
  );

  static final dropDownPrimary60 = Shadow(
    color: HTColors.black.withOpacity(0.6),
    blurRadius: 20,
    offset: const Offset(0, 10),
  );
}

class HTBoxShadows {
  HTBoxShadows._();

  static final dropDownBlur8Spread2Opacity12 = BoxShadow(
    color: HTColors.black.withOpacity(0.12),
    blurRadius: 8,
    spreadRadius: 2,
    offset: const Offset(0, 2),
  );

  static final dropDownBlur12SpreadOpacity8 = BoxShadow(
    color: HTColors.black.withOpacity(0.08),
    blurRadius: 12,
    spreadRadius: 0,
    offset: const Offset(0, 2),
  );

  static final dropDownBlur24Spread4pacity8 = BoxShadow(
    color: HTColors.black.withOpacity(0.08),
    blurRadius: 24,
    spreadRadius: 4,
    offset: const Offset(0, 8),
  );
  static final dropDownBlur32Spread12Opacity8 = BoxShadow(
    color: HTColors.black.withOpacity(0.08),
    blurRadius: 32,
    spreadRadius: 12,
    offset: const Offset(0, 8),
  );

  static final dropDownBlur5Spread4Opacity8 = BoxShadow(
    color: HTColors.black.withOpacity(0.08),
    blurRadius: 5,
    spreadRadius: 4,
    offset: const Offset(0, 8),
  );

  static final dropDownBlur4Spread8Opacity4 = BoxShadow(
    color: HTColors.black.withOpacity(0.04),
    blurRadius: 4,
    spreadRadius: 8,
    offset: const Offset(0, 2),
  );

  static final shadows01 = [dropDownBlur8Spread2Opacity12];
  static final shadows02 = [
    dropDownBlur12SpreadOpacity8,
    dropDownBlur24Spread4pacity8
  ];
  static final shadows03 = [
    dropDownBlur32Spread12Opacity8,
    dropDownBlur5Spread4Opacity8,
    dropDownBlur4Spread8Opacity4
  ];
}

class HTFilters {
  HTFilters._();
  static final backdropBlur1 = ImageFilter.blur(sigmaX: 10, sigmaY: 10);
}

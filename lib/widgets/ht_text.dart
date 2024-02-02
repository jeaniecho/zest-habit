import 'package:flutter/material.dart';
import 'package:habit_app/styles/typos.dart';

class HTText extends StatelessWidget {
  final String text;
  final HTTypoToken typoToken;
  final TextAlign? textAlign;
  final Color color;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? height;
  final double? fontSize;
  final int? fontWeight;
  final bool? underline;

  const HTText(this.text,
      {required this.typoToken,
      required this.color,
      this.textAlign = TextAlign.start,
      this.overflow = TextOverflow.ellipsis,
      this.fontWeight,
      this.fontSize,
      this.maxLines,
      this.height,
      this.underline,
      super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = typoToken.textStyle;
    textStyle = textStyle.copyWith(
      color: color,
      overflow: overflow,
      fontFamily: 'Pretendard',
      height: height,
      fontSize: fontSize ?? textStyle.fontSize,
      fontWeight: textStyle.fontWeight,
      decoration: underline == true ? TextDecoration.underline : null,
    );

    StrutStyle strutStyle =
        StrutStyle.fromTextStyle(textStyle, forceStrutHeight: true);

    return Text(
      text.trimLeft(),
      softWrap: true,
      style: textStyle,
      strutStyle: strutStyle,
      textAlign: textAlign,
      maxLines: maxLines ?? 20,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/widgets/ht_text.dart';

class HTRadio<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String text;
  final Function() onTap;
  final Color? unselectedColor;
  final Color? unselectedTextColor;
  final Color? selectedColor;
  final Color? selectedTextColor;
  final EdgeInsets padding;
  const HTRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.text,
    this.unselectedColor,
    this.unselectedTextColor,
    this.selectedColor,
    this.selectedTextColor,
    required this.onTap,
    this.padding = HTEdgeInsets.vertical12,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = value == groupValue;

    Color color = isSelected
        ? (selectedColor ?? htGreys(context).black)
        : (unselectedColor ?? htGreys(context).grey040);
    Color textColor = isSelected
        ? (selectedTextColor ?? htGreys(context).black)
        : (unselectedTextColor ?? htGreys(context).grey060);
    HTTypoToken typo =
        isSelected ? HTTypoToken.subtitleMedium : HTTypoToken.bodyMedium;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            Radio(
                value: value,
                activeColor: color,
                groupValue: groupValue,
                onChanged: (value) {
                  onTap();
                }),
            HTSpacers.width8,
            HTText(
              text,
              typoToken: typo,
              color: textColor,
              height: 1,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/widgets/ht_text.dart';

class HTRadio extends StatelessWidget {
  final bool isSelected;
  final String text;
  final Function() onTap;
  final Color unselectedColor;
  final Color unselectedTextColor;
  final Color selectedColor;
  final Color selectedTextColor;
  const HTRadio({
    super.key,
    required this.isSelected,
    required this.text,
    this.unselectedColor = HTColors.grey040,
    this.unselectedTextColor = HTColors.grey060,
    this.selectedColor = HTColors.black,
    this.selectedTextColor = HTColors.black,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color color = isSelected ? selectedColor : unselectedColor;
    Color textColor = isSelected ? selectedTextColor : unselectedTextColor;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: HTEdgeInsets.vertical12,
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: color),
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                    ),
                  )
              ],
            ),
            HTSpacers.width8,
            HTText(
              text,
              typoToken: HTTypoToken.bodyMedium,
              color: textColor,
              height: 1,
            ),
          ],
        ),
      ),
    );
  }
}

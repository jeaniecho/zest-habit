import 'package:flutter/material.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/widgets/ht_text.dart';

class HTAnimatedToggle extends StatefulWidget {
  final List<String> values;
  final ValueChanged onToggleCallback;
  final Color backgroundColor;
  final Color buttonColor;
  final Color textColor;
  final double width;
  final double height;

  const HTAnimatedToggle({
    super.key,
    required this.values,
    required this.onToggleCallback,
    this.backgroundColor = HTColors.grey010,
    this.buttonColor = HTColors.white,
    this.textColor = HTColors.black,
    this.width = 320,
    this.height = 40,
  });
  @override
  State<HTAnimatedToggle> createState() => _HTAnimatedToggleState();
}

class _HTAnimatedToggleState extends State<HTAnimatedToggle> {
  bool initialPosition = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              initialPosition = !initialPosition;
              var index = 0;
              if (!initialPosition) {
                index = 1;
              }
              widget.onToggleCallback(index);
              setState(() {});
            },
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: ShapeDecoration(
                color: widget.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: HTBorderRadius.circular12,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  widget.values.length,
                  (index) => HTText(
                    widget.values[index],
                    typoToken: HTTypoToken.captionMedium,
                    color: HTColors.grey050,
                  ),
                ),
              ),
            ),
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            curve: Curves.decelerate,
            alignment:
                initialPosition ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: widget.width / 2,
              height: widget.height,
              margin: HTEdgeInsets.all2,
              decoration: ShapeDecoration(
                color: widget.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: HTBorderRadius.circular10,
                ),
              ),
              alignment: Alignment.center,
              child: HTText(
                initialPosition ? widget.values[0] : widget.values[1],
                typoToken: HTTypoToken.subtitleMedium,
                color: HTColors.grey080,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

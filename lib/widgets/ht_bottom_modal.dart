import 'package:flutter/material.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';

class HTBottomModal extends StatelessWidget {
  final Widget child;
  const HTBottomModal({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    double mainHeight = MediaQuery.sizeOf(context).height;

    return Container(
      height: mainHeight,
      decoration: BoxDecoration(
        color: htGreys(context).white,
        borderRadius: HTBorderRadius.top24,
      ),
      child: child,
    );
  }
}

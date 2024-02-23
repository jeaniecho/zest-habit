import 'package:flutter/material.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';

class HTBottomModal extends StatelessWidget {
  final Widget child;
  const HTBottomModal({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    double mainHeight = MediaQuery.sizeOf(context).height * 0.92;

    return SizedBox(
      height: mainHeight + 12,
      child: Column(
        children: [
          Container(
            height: 12,
            width: MediaQuery.sizeOf(context).width - 48,
            decoration: const BoxDecoration(
              color: HTColors.white50,
              borderRadius: HTBorderRadius.top40,
            ),
          ),
          Container(
            height: mainHeight,
            decoration: const BoxDecoration(
              color: HTColors.white,
              borderRadius: HTBorderRadius.top24,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

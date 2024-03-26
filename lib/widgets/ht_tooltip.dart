import 'package:flutter/material.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/utils/painters.dart';
import 'package:habit_app/widgets/ht_text.dart';

class HTTooltip extends StatelessWidget {
  final String text;
  final Alignment alignment;
  const HTTooltip(
    this.text, {
    this.alignment = Alignment.topLeft,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CrossAxisAlignment crossAxisAlignment = alignment == Alignment.center
        ? CrossAxisAlignment.center
        : (alignment == Alignment.bottomLeft || alignment == Alignment.topLeft)
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end;

    bool isBottom = alignment == Alignment.bottomCenter ||
        alignment == Alignment.bottomLeft ||
        alignment == Alignment.bottomRight;

    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: htGreys(context).black.withOpacity(0.08),
          blurRadius: 12,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
      ]),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          if (isBottom)
            alignment == Alignment.bottomCenter
                ? Center(
                    child: CustomPaint(
                      painter: TrianglePainter(),
                      size: const Size(20, 10),
                    ),
                  )
                : Align(
                    alignment: alignment,
                    child: Padding(
                      padding: HTEdgeInsets.horizontal20,
                      child: CustomPaint(
                        painter: TrianglePainter(),
                        size: const Size(20, 10),
                      ),
                    ),
                  ),
          IntrinsicWidth(
            child: Container(
              height: 40,
              padding: HTEdgeInsets.horizontal16,
              decoration: BoxDecoration(
                color: htGreys(context).white,
                borderRadius: HTBorderRadius.circular10,
              ),
              child: Center(
                child: HTText(
                  text,
                  typoToken: HTTypoToken.bodyMedium,
                  color: htGreys(context).black,
                  height: 1.25,
                ),
              ),
            ),
          ),
          if (!isBottom)
            alignment == Alignment.center
                ? Center(
                    child: CustomPaint(
                      painter: InvertedTrianglePainter(),
                      size: const Size(20, 10),
                    ),
                  )
                : Align(
                    alignment: alignment,
                    child: Padding(
                      padding: HTEdgeInsets.horizontal20,
                      child: CustomPaint(
                        painter: InvertedTrianglePainter(),
                        size: const Size(20, 10),
                      ),
                    ),
                  ),
        ],
      ),
    );
  }
}

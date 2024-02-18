import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/widgets/ht_text.dart';

class HTAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool? showBack;
  final bool? showClose;
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final bool? centerTitle;
  final double? titleSpacing;

  const HTAppbar(
      {this.title,
      this.showBack = true,
      this.showClose = false,
      this.leading,
      this.actions,
      this.bottom,
      this.elevation = 0,
      this.centerTitle = true,
      this.titleSpacing = 24,
      super.key});

  @override
  Widget build(BuildContext context) {
    double height = 56 + (bottom?.preferredSize.height ?? 0);

    return AppBar(
      toolbarHeight: height,
      elevation: elevation,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      leadingWidth:
          (showBack == true && showClose == false) || leading != null ? 50 : 0,
      leading: leading ??
          ((showBack == false || showClose == true)
              ? const SizedBox.shrink()
              : GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    }
                  },
                  child: Container(
                    margin: HTEdgeInsets.left4,
                    padding: HTEdgeInsets.all12,
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 24,
                      color: HTColors.grey080,
                    ),
                  ),
                )),
      title: title == null
          ? null
          : HTText(
              title!,
              typoToken: HTTypoToken.subtitleLarge,
              color: HTColors.grey070,
            ),
      actions: [
        if (showClose == true)
          GestureDetector(
            onTap: () {
              context.pop();
            },
            child: Container(
              margin: HTEdgeInsets.right4,
              padding: HTEdgeInsets.all12,
              child: const Icon(
                Icons.close_rounded,
                size: 24,
                color: HTColors.grey040,
              ),
            ),
          ),
        if (actions != null) ...actions!,
      ],
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(56 + (bottom?.preferredSize.height ?? 0));
}

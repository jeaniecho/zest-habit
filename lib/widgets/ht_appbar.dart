import 'package:flutter/material.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';

class HTAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool? showBack;
  final bool? showClose;
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final double? elevation;

  const HTAppbar(
      {this.title,
      this.showBack,
      this.showClose,
      this.leading,
      this.actions,
      this.bottom,
      this.elevation,
      super.key});

  @override
  Widget build(BuildContext context) {
    double height = 56 + (bottom?.preferredSize.height ?? 0);

    return AppBar(
      toolbarHeight: height,
      elevation: elevation ?? 0.1,
      automaticallyImplyLeading: false,
      centerTitle: true,
      leading: leading ??
          ((showBack == false || showClose == true)
              ? const SizedBox.shrink()
              : GestureDetector(
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    margin: HTEdgeInsets.left4,
                    padding: HTEdgeInsets.all12,
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 24,
                      color: HTColors.gray080,
                    ),
                  ),
                )),
      title: title == null ? null : Text(title!),
      actions: [
        if (showClose == true)
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: HTEdgeInsets.right4,
              padding: HTEdgeInsets.all12,
              child: const Icon(
                Icons.close_rounded,
                size: 24,
                color: HTColors.gray080,
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

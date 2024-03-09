import 'package:flutter/cupertino.dart';

class HTDialog {
  HTDialog._();

  static showConfirmDialog(
    BuildContext context, {
    required String title,
    required String content,
    required Function action,
    required String buttonText,
    bool isDestructive = true,
  }) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(content),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  textStyle: TextStyle(
                      color: !isDestructive
                          ? CupertinoColors.black
                          : CupertinoColors.activeBlue),
                  child: const Text('Cancel'),
                ),
                CupertinoDialogAction(
                    isDefaultAction: true,
                    isDestructiveAction: isDestructive,
                    onPressed: () {
                      Navigator.pop(context);
                      action();
                    },
                    textStyle: TextStyle(
                        color: !isDestructive
                            ? CupertinoColors.activeBlue
                            : CupertinoColors.destructiveRed),
                    child: Text(buttonText)),
              ],
            ));
  }
}

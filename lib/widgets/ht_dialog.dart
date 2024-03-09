import 'package:flutter/cupertino.dart';

class HTDialog {
  HTDialog._();

  static showConfirmDialog(
    BuildContext context, {
    required String title,
    required String content,
    required Function action,
    required String buttonText,
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
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: CupertinoColors.activeBlue),
                  ),
                ),
                CupertinoDialogAction(
                    isDefaultAction: true,
                    isDestructiveAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                      action();
                    },
                    child: Text(buttonText)),
              ],
            ));
  }
}

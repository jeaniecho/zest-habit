import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/utils/notifications.dart';
import 'package:habit_app/widgets/ht_appbar.dart';
import 'package:habit_app/widgets/ht_dialog.dart';
import 'package:habit_app/widgets/ht_text.dart';

class DevPage extends StatelessWidget {
  const DevPage({super.key});

  static const routeName = '/dev';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: htGreys(context).white,
      appBar: const HTAppbar(
        title: 'Dev Menu',
        showClose: true,
      ),
      body: SingleChildScrollView(
        padding: HTEdgeInsets.all24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () async {
                List<PendingNotificationRequest> pendingeNotifications =
                    await HTNotification.getPendingNotifications();

                // ignore: use_build_context_synchronously
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        surfaceTintColor: htGreys(context).white,
                        child: Container(
                          width: 300,
                          height: 300,
                          padding: HTEdgeInsets.horizontal32,
                          child: ListView.separated(
                            padding: HTEdgeInsets.vertical24,
                            itemBuilder: (context, index) {
                              PendingNotificationRequest item =
                                  pendingeNotifications[index];

                              return Row(
                                children: [
                                  Container(
                                    padding: HTEdgeInsets.all4,
                                    decoration: BoxDecoration(
                                      color: htGreys(context).black,
                                      borderRadius: HTBorderRadius.circular4,
                                    ),
                                    child: Center(
                                      child: HTText(
                                        item.id.toString(),
                                        typoToken: HTTypoToken.subtitleXXSmall,
                                        color: htGreys(context).white,
                                        height: 1,
                                      ),
                                    ),
                                  ),
                                  HTSpacers.width8,
                                  HTText(
                                    item.title ?? '?',
                                    typoToken: HTTypoToken.bodySmall,
                                    color: htGreys(context).black,
                                    height: 1,
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) {
                              return HTSpacers.height8;
                            },
                            itemCount: pendingeNotifications.length,
                          ),
                        ),
                      );
                    });
              },
              child: HTText(
                'View Notifications',
                typoToken: HTTypoToken.buttonTextMedium,
                color: htGreys(context).white,
                height: 1.25,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                HTDialog.showConfirmDialog(
                  context,
                  title: 'Delete All Notifications',
                  content: 'This will delete all scheduled notifications.',
                  action: () {
                    HTNotification.cancelAllNotifications();
                  },
                  buttonText: 'Delete',
                );
              },
              child: HTText(
                'Delete All Notifications',
                typoToken: HTTypoToken.buttonTextMedium,
                color: htGreys(context).white,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

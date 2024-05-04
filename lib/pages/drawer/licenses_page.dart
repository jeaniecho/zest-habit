import 'package:flutter/material.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/widgets/ht_appbar.dart';
import 'package:habit_app/widgets/ht_text.dart';

class LicensesPage extends StatelessWidget {
  const LicensesPage({super.key});

  static const routeName = '/license';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HTAppbar(showClose: true),
      body: SingleChildScrollView(
        padding: HTEdgeInsets.all24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HTText(
              'Licenses',
              typoToken: HTTypoToken.headlineMedium,
              color: htGreys(context).black,
            ),
            HTSpacers.height8,
            HTText(
              '''
Zest Habit utilizes the following third-party packages and resources:

Flutter Packages:
- rxdart
- provider
- isar
- isar_flutter_libs
- path_provider
- intl
- firebase_core
- quiver
- go_router
- package_info_plus
- flutter_email_sender
- flutter_ringtone_player
- flutter_animate
- table_calendar
- flutter_local_notifications
- flutter_timezone
- in_app_purchase
- in_app_purchase_storekit
- shared_preferences
- flutter_screenutil

Fonts:
- Pretendard

Please note that these packages and resources may be subject to their own respective licenses, and we encourage you to review their terms and conditions.

Zest Habit is developed using Flutter, an open-source mobile application development framework created by Google. For more information about Flutter and its licenses, please visit Flutter's GitHub repository.

Thank you for using Zest Habit!
''',
              typoToken: HTTypoToken.bodySmall,
              color: htGreys(context).grey080,
              maxLines: 1000,
            )
          ],
        ),
      ),
    );
  }
}

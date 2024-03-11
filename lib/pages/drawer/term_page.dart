import 'package:flutter/material.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/widgets/ht_appbar.dart';
import 'package:habit_app/widgets/ht_text.dart';

class TermPage extends StatelessWidget {
  const TermPage({super.key});

  static const routeName = '/terms';

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
              'Terms of Use',
              typoToken: HTTypoToken.headlineMedium,
              color: htGreys(context).black,
            ),
            HTSpacers.height8,
            HTText(
              '''
Welcome to Zest Habit! These Terms of Use ("Terms") govern your access to and use of the Zest Habit application ("App"). By accessing or using the App, you agree to be bound by these Terms.

1. Acceptance of Terms
By downloading, installing, accessing, or using the App, you agree to be bound by these Terms. If you do not agree to these Terms, you may not access or use the App.

2. Use of the App
2.1. Zest Habit is a habit tracking application designed to help users track their tasks and habits. Users can add tasks, check them off as completed, use timers while performing tasks, and set notifications.

2.2. The App stores task data locally on the user's device. Zest does not collect or store any personal information of users.

2.3. The free version of the App ("Free Version") includes limited functionality. Users of the Free Version are restricted to:
- Adding up to 3 tasks.
- Setting the timer time to a fixed duration of 25 minutes.
- Inability to set notifications for tasks.

2.4. Zest Pro is a premium version of the App ("Zest Pro") that offers additional features and functionalities. Zest Pro users have access to:
- Unlimited task additions.
- Customizable timer durations.
- Ability to schedule notifications for tasks.

3. Zest Pro Subscription
3.1. Users may opt to subscribe to Zest Pro by purchasing a subscription through the App.

3.2. Subscription fees may apply and are subject to change at Zest's discretion.

3.3. Payment for Zest Pro subscriptions will be charged to the user's iTunes or Google Play account at confirmation of purchase.

3.4. Subscriptions automatically renew unless auto-renew is turned off at least 24 hours before the end of the current subscription period.

3.5. Users can manage their subscriptions and turn off auto-renewal by going to their account settings after purchase.

4. Intellectual Property
4.1. The App, including all content, features, and functionality, is owned by Zest and is protected by copyright, trademark, and other intellectual property laws.

4.2. Users may not modify, reproduce, distribute, or create derivative works based on the App without Zest's prior written consent.

5. Limitation of Liability
5.1. Zest shall not be liable for any direct, indirect, incidental, special, consequential, or punitive damages arising out of or in connection with the use or inability to use the App.

5.2. Zest does not warrant that the App will be error-free or uninterrupted.

6. Modification of Terms
Zest reserves the right to modify or amend these Terms at any time. Users will be notified of any changes to these Terms within the App. Continued use of the App after such modifications constitutes acceptance of the revised Terms.

7. Contact Us
If you have any questions or concerns about these Terms, please contact us at yeajeanie@gmail.com.

By accessing or using the App, you acknowledge that you have read, understood, and agree to be bound by these Terms of Use.
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

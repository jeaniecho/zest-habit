import 'package:flutter/material.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/widgets/ht_appbar.dart';
import 'package:habit_app/widgets/ht_text.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  static const routeName = '/terms';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HTAppbar(title: 'Terms of Service'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: HTEdgeInsets.all24,
                child: HTText(
                  _termsContent,
                  typoToken: HTTypoToken.bodySmall,
                  color: HTColors.black,
                  maxLines: 100,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const String _termsContent = '''
Welcome to Zest Habit! These Terms of Service ("Terms") govern your access to and use of the Zest Habit application ("App").
By accessing or using the App, you agree to be bound by these Terms.

1. Acceptance of Terms
By downloading, installing, accessing, or using the App, you agree to be bound by these Terms. If you do not agree to these Terms, you may not access or use the App.

2. Use of the App

2.1. Zest Habit is a habit tracking application designed to help users track their tasks and habits. Users can add tasks, check them off as completed, use timers while performing tasks, and set notifications.

2.2. The App stores task data locally on the user's device. Zest does not collect or store any personal information of users.

2.3. All features and functionalities of the App, including those previously designated as part of the Zest Pro subscription, are now available to all users for free.


3. Intellectual Property

3.1. The App, including all content, features, and functionality, is owned by Zest and is protected by copyright, trademark, and other intellectual property laws.

3.2. Users may not modify, reproduce, distribute, or create derivative works based on the App without Zest's prior written consent.


4. Limitation of Liability

4.1. Zest shall not be liable for any direct, indirect, incidental, special, consequential, or punitive damages arising out of or in connection with the use or inability to use the App.

4.2. Zest does not warrant that the App will be error-free or uninterrupted.


5. Modification of Terms
Zest reserves the right to modify or amend these Terms at any time. Users will be notified of any changes to these Terms within the App. Continued use of the App after such modifications constitutes acceptance of the revised Terms.

By accessing or using the App, you acknowledge that you have read, understood, and agree to be bound by these Terms of Use.
''';

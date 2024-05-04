import 'package:flutter/material.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/widgets/ht_appbar.dart';
import 'package:habit_app/widgets/ht_text.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  static const routeName = '/privacy-policy';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HTAppbar(title: 'Privacy Policy'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: HTEdgeInsets.all24,
                child: HTText(
                  _privacyContent,
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

const String _privacyContent = '''
This Privacy Policy governs the manner in which Zest ("Zest," "we," "us," or "our") collects, uses, maintains, and discloses information collected from users ("User" or "you") of the Zest Habit application ("App"). This Privacy Policy applies to the App and all products and services offered by Zest.

1. Information Collection and Use

1.1. Personal Information: Zest does not collect or store any personal information from users of the App. The App only stores task data locally on the user's device.

1.2. Non-Personal Information: The App may collect non-personal information such as device information, usage patterns, and technical data for the purpose of improving the App's performance and user experience.

2. Information Sharing

2.1. Third-Party Services: The App may utilize third-party services, such as analytics tools, to collect non-personal information for the purposes stated above. These third-party services may have their own privacy policies governing the collection and use of information.

2.2. Legal Compliance: Zest may disclose user information if required to do so by law or in response to valid legal requests, such as court orders or subpoenas.

3. Data Security

3.1. Zest takes reasonable measures to protect user data stored within the App. However, no method of transmission over the internet or electronic storage is 100% secure, and therefore, we cannot guarantee absolute security of user data.

4. Changes to this Privacy Policy

4.1. Zest reserves the right to update or revise this Privacy Policy at any time. Any changes to this Privacy Policy will be communicated within the App. Your continued use of the App after such changes constitutes acceptance of the revised Privacy Policy.

By using the Zest Habit App, you acknowledge that you have read, understood, and agree to be bound by this Privacy Policy.
''';

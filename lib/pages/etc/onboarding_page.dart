import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/widgets/ht_text.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  static const routeName = '/onboarding';

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        color: HTColors.black,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: HTColors.black,
            body: Column(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 428.h,
                    child: PageView.builder(
                      itemBuilder: (context, index) {
                        return Container(
                          color: HTColors.black,
                          child: Center(
                            child: Text(
                              'Page $index',
                              style: const TextStyle(color: HTColors.white),
                            ),
                          ),
                        );
                      },
                      itemCount: 3,
                    ),
                  ),
                ),
                HTSpacers.height24,
                Container(
                  height: 64,
                  width: double.infinity,
                  padding: HTEdgeInsets.horizontal24,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HTColors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.h)),
                    ),
                    onPressed: () {},
                    child: const HTText(
                      'Get Started',
                      typoToken: HTTypoToken.subtitleXLarge,
                      color: HTColors.black,
                      height: 1.25,
                    ),
                  ),
                ),
                HTSpacers.height24,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

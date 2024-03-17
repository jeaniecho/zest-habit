import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_app/blocs/etc/onboarding/onboarding_bloc.dart';
import 'package:habit_app/pages/etc/onboarding/onboarding_task_page.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/widgets/ht_text.dart';
import 'package:provider/provider.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  static const routeName = '/onboarding';

  @override
  Widget build(BuildContext context) {
    OnboardingBloc bloc = context.read<OnboardingBloc>();

    int imageCount = 4;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: HTColors.black,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SizedBox(
                  height: 428.h,
                  child: PageView.builder(
                    onPageChanged: (index) => bloc.setImageIndex(index),
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
                    itemCount: imageCount,
                  ),
                ),
              ),
              HTSpacers.height48,
              SizedBox(
                height: 6,
                child: StreamBuilder<int>(
                    stream: bloc.imageIndex,
                    builder: (context, snapshot) {
                      int imageIndex = snapshot.data ?? 0;

                      return ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: imageIndex == index
                                  ? HTColors.white
                                  : HTColors.white30,
                              shape: BoxShape.circle,
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return HTSpacers.width8;
                        },
                        itemCount: imageCount,
                      );
                    }),
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
                  onPressed: () {
                    context.go(OnboardingTaskPage.routeName);
                  },
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
    );
  }
}

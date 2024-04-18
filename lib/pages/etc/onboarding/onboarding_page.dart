import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_app/blocs/app_service.dart';
import 'package:habit_app/blocs/etc/onboarding/onboarding_bloc.dart';
import 'package:habit_app/pages/base/task_page.dart';
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
    AppService appService = context.read<AppService>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: HTColors.black,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 400.h,
                child: PageView.builder(
                  controller: bloc.imageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return bloc.images[index].image();
                  },
                  itemCount: bloc.images.length,
                ),
              ),
              Container(
                height: 6,
                margin: HTEdgeInsets.vertical24,
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
                        itemCount: bloc.images.length,
                      );
                    }),
              ),
              HTSpacers.height24,
              SizedBox(
                height: 72.h,
                child: PageView.builder(
                  controller: bloc.textController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return HTText(
                      bloc.texts[index],
                      typoToken: HTTypoToken.headlineSmall,
                      color: HTColors.white,
                      textAlign: TextAlign.center,
                      fontSize: 24.h,
                    );
                  },
                  itemCount: bloc.texts.length,
                ),
              ),
              HTSpacers.height48,
              StreamBuilder<int>(
                  stream: bloc.imageIndex,
                  builder: (context, snapshot) {
                    int imageIndex = snapshot.data ?? 0;

                    bool inLastPage = imageIndex >= bloc.images.length - 1;

                    return Container(
                      height: 64.h,
                      width: double.infinity,
                      padding: HTEdgeInsets.horizontal24,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: HTColors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.h)),
                        ),
                        onPressed: () {
                          if (!inLastPage) {
                            bloc.setImageIndex(imageIndex + 1);
                            bloc.movePage(imageIndex + 1);
                          } else {
                            appService.downloadFromICloud().then((value) {
                              if (value.isEmpty) {
                                context.pushReplacement(
                                    OnboardingTaskPage.routeName);
                              } else {
                                appService.updateOnboardingStatus(true);
                                context.pushReplacement(TaskPage.routeName,
                                    extra: true);
                              }
                            });
                          }
                        },
                        child: HTText(
                          inLastPage ? 'Get Started' : 'Go Ahead',
                          typoToken: HTTypoToken.subtitleXLarge,
                          color: HTColors.black,
                          height: 1.25,
                        ),
                      ),
                    );
                  }),
              HTSpacers.height24,
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_app/blocs/etc/signin_bloc.dart';
import 'package:habit_app/gen/assets.gen.dart';
import 'package:habit_app/pages/base/task_page.dart';
import 'package:habit_app/pages/etc/webview_page.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/utils/enums.dart';
import 'package:habit_app/widgets/ht_text.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class SigninPage extends StatelessWidget {
  const SigninPage({super.key});

  static const routeName = '/signin';

  @override
  Widget build(BuildContext context) {
    SigninBloc bloc = context.read<SigninBloc>();

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
                  onPageChanged: (index) => bloc.movePage(index),
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
              HTSpacers.height24,
              const SigninButton(snsType: SNSType.apple),
              HTSpacers.height16,
              const SigninButton(snsType: SNSType.google),
              HTSpacers.height24,
              const SigninMenu(),
            ],
          ),
        ),
      ),
    );
  }
}

class SigninButton extends StatelessWidget {
  final SNSType snsType;
  const SigninButton({super.key, required this.snsType});

  @override
  Widget build(BuildContext context) {
    SigninBloc bloc = context.read<SigninBloc>();

    return Container(
      height: 56.h,
      width: double.infinity,
      padding: HTEdgeInsets.horizontal24,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: HTColors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.h)),
        ),
        onPressed: () async {
          if (snsType == SNSType.apple) {
            bloc.signInWithApple().then((value) {
              if (value != null) {
                context.pushReplacement(TaskPage.routeName);
              }
            });
          } else if (snsType == SNSType.google) {
            bloc.signInWithGoogle().then((value) {
              if (value != null) {
                context.pushReplacement(TaskPage.routeName);
              }
            });
          }

          // context.pushReplacement(TaskPage.routeName);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            snsType == SNSType.apple
                ? const Icon(
                    Icons.apple,
                    size: 32,
                    color: HTColors.black,
                  )
                : Assets.icons.googleIcon.image(width: 24),
            HTSpacers.width8,
            HTText(
              'Sign in with ${snsType.value}',
              typoToken: HTTypoToken.subtitleLarge,
              color: HTColors.black,
              height: 1.25,
            ),
          ],
        ),
      ),
    );
  }
}

class SigninMenu extends StatelessWidget {
  const SigninMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const WebviewPage(
                        title: 'Terms of Service',
                        url:
                            'https://dour-rhodium-0f4.notion.site/Zest-Terms-of-Use-3d0f81cfe4d94feaae19ccd6dcbe1d66?pvs=4')));
          },
          child: const HTText(
            'Terms of Service',
            typoToken: HTTypoToken.bodyXXSmall,
            color: HTColors.grey050,
          ),
        ),
        const Padding(
          padding: HTEdgeInsets.horizontal8,
          child: HTText(
            '|',
            typoToken: HTTypoToken.bodyXXSmall,
            color: HTColors.grey050,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const WebviewPage(
                        title: 'Privacy Policy',
                        url:
                            'https://dour-rhodium-0f4.notion.site/Zest-Privacy-Policy-bb8879af28fa4d83862300eb6c1f99ea?pvs=4')));
          },
          child: const HTText(
            'Privacy Policy',
            typoToken: HTTypoToken.bodyXXSmall,
            color: HTColors.grey050,
          ),
        ),
        const Padding(
          padding: HTEdgeInsets.horizontal8,
          child: HTText(
            '|',
            typoToken: HTTypoToken.bodyXXSmall,
            color: HTColors.grey050,
          ),
        ),
        FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }

              PackageInfo packageInfo = snapshot.data!;

              return HTText(
                'App Version ${packageInfo.version}',
                typoToken: HTTypoToken.bodyXXSmall,
                color: HTColors.grey050,
              );
            }),
      ],
    );
  }
}

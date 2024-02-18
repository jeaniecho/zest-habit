import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_app/blocs/app_bloc.dart';
import 'package:habit_app/pages/base/daily_page.dart';
import 'package:habit_app/pages/base/timer_page.dart';
import 'package:habit_app/pages/task/task_add_page.dart';
import 'package:habit_app/router.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/widgets/ht_text.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class BasePage extends StatelessWidget {
  final Widget child;
  const BasePage({required this.child, super.key});

  static const routeName = '/base';

  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = context.read<AppBloc>();

    return StreamBuilder<int>(
        stream: appBloc.bottomIndex,
        builder: (context, snapshot) {
          int bottomIndex = snapshot.data ?? 0;

          return Scaffold(
            key: rootScaffoldKey,
            body: SafeArea(
              child: child,
            ),
            bottomNavigationBar: SafeArea(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: HTColors.grey010,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        context.replace(DailyPage.routeName);
                        appBloc.setBottomIndex(0);
                      },
                      child: SizedBox(
                        width: 88,
                        child: Icon(
                          Icons.calendar_today_rounded,
                          size: 22,
                          color: bottomIndex == 0
                              ? HTColors.black
                              : HTColors.grey040,
                        ),
                      ),
                    ),
                    GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          context.push(TaskAddPage.routeName);
                        },
                        child: SizedBox(
                          width: 88,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: HTColors.black,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add_rounded,
                                size: 24,
                                color: HTColors.white,
                              ),
                            ),
                          ),
                        )),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        context.replace(TimerPage.routeName);
                        appBloc.setBottomIndex(1);
                      },
                      child: SizedBox(
                        width: 88,
                        child: Icon(
                          Icons.timer_outlined,
                          size: 24,
                          color: bottomIndex == 1
                              ? HTColors.black
                              : HTColors.grey040,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            endDrawer: const BaseEndDrawer(),
          );
        });
  }
}

class BaseEndDrawer extends StatelessWidget {
  const BaseEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: HTColors.white,
      surfaceTintColor: HTColors.white,
      shape: RoundedRectangleBorder(borderRadius: HTBorderRadius.circularZero),
      width: 320,
      child: SafeArea(
        child: Padding(
          padding: HTEdgeInsets.all16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  rootScaffoldKey.currentState!.closeEndDrawer();
                },
                child: const Padding(
                  padding: HTEdgeInsets.all12,
                  child: Icon(
                    Icons.close_rounded,
                    color: HTColors.grey040,
                    size: 24,
                  ),
                ),
              ),
              HTSpacers.height20,
              BaseEndDrawerItem(
                  onTap: () async {
                    PackageInfo packageInfo = await PackageInfo.fromPlatform();

                    String body =
                        "\n\n\n\n\nApp Version: ${packageInfo.version} (${packageInfo.buildNumber})";

                    Email email = Email(
                      subject: '[${packageInfo.appName}] Feedback',
                      body: body,
                      recipients: ['yeajeanie@gmail.com'],
                    );

                    await FlutterEmailSender.send(email);
                  },
                  text: 'Support'),
              HTSpacers.height8,
              BaseEndDrawerItem(onTap: () {}, text: 'Terms of Use'),
              HTSpacers.height8,
              BaseEndDrawerItem(onTap: () {}, text: 'Privacy Policy'),
              HTSpacers.height8,
              BaseEndDrawerItem(onTap: () {}, text: 'Licenses'),
              HTSpacers.height8,
              BaseEndDrawerItem(onTap: () {}, text: 'Mode'),
              const Spacer(),
              FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox.shrink();
                    }

                    PackageInfo packageInfo = snapshot.data!;

                    return HTText(
                      'App Version ${packageInfo.version} (${packageInfo.buildNumber})',
                      typoToken: HTTypoToken.bodyMedium,
                      color: HTColors.grey040,
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class BaseEndDrawerItem extends StatelessWidget {
  final Function onTap;
  final String text;
  const BaseEndDrawerItem({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        rootScaffoldKey.currentState!.closeEndDrawer();
        onTap();
      },
      child: Padding(
        padding: HTEdgeInsets.all12,
        child: HTText(
          text,
          typoToken: HTTypoToken.bodyLarge,
          color: HTColors.black,
        ),
      ),
    );
  }
}

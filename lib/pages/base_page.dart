import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_app/iap/iap_service.dart';
import 'package:habit_app/blocs/app_service.dart';
import 'package:habit_app/blocs/task/task_add_bloc.dart';
import 'package:habit_app/models/settings_model.dart';
import 'package:habit_app/pages/base/task_page.dart';
import 'package:habit_app/pages/base/timer_page.dart';
import 'package:habit_app/pages/drawer/licenses_page.dart';
import 'package:habit_app/pages/drawer/mode_page.dart';
import 'package:habit_app/pages/drawer/privacy_page.dart';
import 'package:habit_app/pages/drawer/term_page.dart';
import 'package:habit_app/pages/etc/dev_page.dart';
import 'package:habit_app/pages/task/task_add_page.dart';
import 'package:habit_app/router.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:habit_app/widgets/ht_dialog.dart';
import 'package:habit_app/widgets/ht_text.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class BasePage extends StatefulWidget {
  final Widget child;
  const BasePage({required this.child, super.key});

  static const routeName = '/base';

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!context.read<IAPService>().isPro() &&
          context.read<AppService>().settingsValue.createdTaskCount >= 3) {
        pushSubscriptionPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppService appService = context.read<AppService>();

    return StreamBuilder<List>(
        stream: Rx.combineLatestList(
            [appService.bottomIndex, appService.settings, appService.isPro]),
        builder: (context, snapshot) {
          int bottomIndex = snapshot.data?[0] ?? 0;
          Settings settings = snapshot.data?[1] ?? Settings();
          bool isPro = snapshot.data?[2] ?? false;

          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: settings.isDarkMode
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
            child: Scaffold(
              key: rootScaffoldKey,
              body: SafeArea(
                child: widget.child,
              ),
              bottomNavigationBar: SafeArea(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: htGreys(context).grey010,
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
                          while (context.canPop()) {
                            context.pop();
                          }

                          if (appService.bottomIndexValue != 0) {
                            context.replace(TaskPage.routeName);
                            appService.setBottomIndex(0);
                          }
                        },
                        child: SizedBox(
                          width: 88,
                          height: 52,
                          child: Icon(
                            Icons.calendar_today_rounded,
                            size: 22,
                            color: bottomIndex == 0
                                ? htGreys(context).black
                                : htGreys(context).grey040,
                          ),
                        ),
                      ),
                      GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (appService.activeTaskCount() < taskLimit ||
                                isPro) {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: HTColors.clear,
                                  barrierColor:
                                      htGreys(context).black.withOpacity(0.3),
                                  useSafeArea: true,
                                  builder: (context) {
                                    return Provider(
                                        create: (context) => TaskAddBloc(
                                            appService:
                                                context.read<AppService>()),
                                        dispose: (context, value) =>
                                            value.dispose(),
                                        child: const TaskAddWidget());
                                  });
                            } else {
                              HTDialog.showConfirmDialog(
                                context,
                                title: 'Unlimited Task with PRO',
                                content:
                                    'To add more task, you need PRO plan.\nStart with free trial plan!',
                                action: () {
                                  pushSubscriptionPage();
                                },
                                buttonText: 'Try PRO',
                                isDestructive: false,
                              );
                            }
                          },
                          child: SizedBox(
                            width: 88,
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: htGreys(context).black,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.add_rounded,
                                  size: 24,
                                  color: htGreys(context).white,
                                ),
                              ),
                            ),
                          )),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          while (context.canPop()) {
                            context.pop();
                          }

                          if (appService.bottomIndexValue != 1) {
                            context.replace(TimerPage.routeName);
                            appService.setBottomIndex(1);
                          }
                        },
                        child: SizedBox(
                          width: 88,
                          height: 52,
                          child: Icon(
                            Icons.timer_outlined,
                            size: 24,
                            color: bottomIndex == 1
                                ? htGreys(context).black
                                : htGreys(context).grey040,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              endDrawer: const BaseEndDrawer(),
            ),
          );
        });
  }
}

class BaseEndDrawer extends StatelessWidget {
  const BaseEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: htGreys(context).white,
      surfaceTintColor: htGreys(context).white,
      shape: RoundedRectangleBorder(borderRadius: HTBorderRadius.circularZero),
      width: 300,
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
                child: Padding(
                  padding: HTEdgeInsets.all12,
                  child: Icon(
                    Icons.close_rounded,
                    color: htGreys(context).grey040,
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
              BaseEndDrawerItem(
                  onTap: () {
                    context.push(TermPage.routeName);
                  },
                  text: 'Terms of Use'),
              HTSpacers.height8,
              BaseEndDrawerItem(
                  onTap: () {
                    context.push(PrivacyPage.routeName);
                  },
                  text: 'Privacy Policy'),
              HTSpacers.height8,
              BaseEndDrawerItem(
                  onTap: () {
                    context.push(LicensesPage.routeName);
                  },
                  text: 'Licenses'),
              HTSpacers.height8,
              BaseEndDrawerItem(
                  onTap: () {
                    context.push(ModePage.routeName);
                  },
                  text: 'Mode'),
              const Spacer(),
              const DevMenu(),
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
                      color: htGreys(context).grey040,
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
          color: htGreys(context).black,
        ),
      ),
    );
  }
}

class DevMenu extends StatelessWidget {
  const DevMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: HTEdgeInsets.bottom4,
      child: ElevatedButton(
        onPressed: () {
          rootScaffoldKey.currentState!.closeEndDrawer();
          context.push(DevPage.routeName);
        },
        child: HTText(
          'Dev Menu',
          typoToken: HTTypoToken.buttonTextMedium,
          color: htGreys(context).white,
          height: 1.25,
        ),
      ),
    );
  }
}

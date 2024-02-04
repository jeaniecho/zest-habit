import 'package:flutter/material.dart';
import 'package:habit_app/blocs/app_bloc.dart';
import 'package:habit_app/blocs/base/daily_bloc.dart';
import 'package:habit_app/blocs/base/timer_bloc.dart';
import 'package:habit_app/pages/base/daily_page.dart';
import 'package:habit_app/pages/base/timer_page.dart';
import 'package:habit_app/pages/task/task_add_page.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:provider/provider.dart';

class BasePage extends StatelessWidget {
  const BasePage({super.key});

  static const routeName = '/base';

  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = context.read<AppBloc>();
    DailyBloc dailyBloc = DailyBloc(
        appBloc: appBloc, deviceWidth: MediaQuery.sizeOf(context).width);
    TimerBloc timerBloc = TimerBloc();

    return StreamBuilder<int>(
        stream: appBloc.bottomIndex,
        builder: (context, snapshot) {
          int bottomIndex = snapshot.data ?? 0;

          return Scaffold(
            body: SafeArea(
              child: IndexedStack(
                index: bottomIndex,
                children: [
                  MultiProvider(
                    providers: [
                      Provider(create: (context) => appBloc),
                      Provider(create: (context) => dailyBloc),
                    ],
                    child: const DailyPage(),
                  ),
                  MultiProvider(
                    providers: [
                      Provider(create: (context) => appBloc),
                      Provider(create: (context) => timerBloc),
                    ],
                    child: const TimerPage(),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Container(
                padding: HTEdgeInsets.h24v16,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: HTColors.gray010,
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
                        appBloc.setBottomIndex(0);
                      },
                      child: SizedBox(
                        width: 88,
                        child: Icon(
                          Icons.calendar_today_rounded,
                          size: 22,
                          color: bottomIndex == 0
                              ? HTColors.black
                              : HTColors.gray040,
                        ),
                      ),
                    ),
                    GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.pushNamed(context, TaskAddPage.routeName);
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
                        appBloc.setBottomIndex(1);
                      },
                      child: SizedBox(
                        width: 88,
                        child: Icon(
                          Icons.timer_outlined,
                          size: 24,
                          color: bottomIndex == 1
                              ? HTColors.black
                              : HTColors.gray040,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

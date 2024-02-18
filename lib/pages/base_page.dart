import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_app/blocs/app_bloc.dart';
import 'package:habit_app/pages/base/daily_page.dart';
import 'package:habit_app/pages/base/timer_page.dart';
import 'package:habit_app/pages/task/task_add_page.dart';
import 'package:habit_app/styles/colors.dart';
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
          );
        });
  }
}

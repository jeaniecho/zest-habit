import 'package:flutter/material.dart';
import 'package:habit_app/blocs/app_bloc.dart';
import 'package:habit_app/blocs/base/daily_bloc.dart';
import 'package:habit_app/blocs/base/timer_bloc.dart';
import 'package:habit_app/pages/base/daily_page.dart';
import 'package:habit_app/pages/base/timer_page.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:provider/provider.dart';

class BasePage extends StatelessWidget {
  const BasePage({super.key});

  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = context.read<AppBloc>();
    DailyBloc dailyBloc =
        DailyBloc(deviceWidth: MediaQuery.sizeOf(context).width);
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
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: bottomIndex,
              onTap: (int index) {
                appBloc.setBottomIndex(index);
              },
              selectedItemColor: HTColors.black,
              unselectedItemColor: HTColors.gray040,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.timer_outlined), label: 'Timer'),
              ],
            ),
          );
        });
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_app/blocs/app_bloc.dart';
import 'package:habit_app/blocs/task/task_add_bloc.dart';
import 'package:habit_app/blocs/task/task_detail_bloc.dart';
import 'package:habit_app/blocs/task/task_edit_bloc.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/pages/base/daily_page.dart';
import 'package:habit_app/pages/base/timer_page.dart';
import 'package:habit_app/pages/base_page.dart';
import 'package:habit_app/pages/task/task_add_page.dart';
import 'package:habit_app/pages/task/task_detail_page.dart';
import 'package:habit_app/pages/task/task_edit_page.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> rootNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavKey = GlobalKey<NavigatorState>();

final GlobalKey<ScaffoldState> rootScaffoldKey = GlobalKey<ScaffoldState>();

final router =
    GoRouter(navigatorKey: rootNavKey, initialLocation: '/daily', routes: [
  ShellRoute(
      navigatorKey: shellNavKey,
      builder: (context, state, child) {
        return BasePage(child: child);
      },
      routes: [
        GoRoute(
            path: DailyPage.routeName,
            builder: (context, state) {
              return const DailyPage();
            }),
        GoRoute(
            path: TimerPage.routeName,
            builder: (context, state) {
              return const TimerPage();
            }),
        GoRoute(
            path: TaskDetailPage.routeName,
            builder: (context, state) {
              final Task task = state.extra as Task;

              return Provider<TaskDetailBloc>(
                create: (context) => TaskDetailBloc(task: task),
                dispose: (context, value) => value.dispose(),
                child: const TaskDetailPage(),
              );
            }),
        GoRoute(
          path: TaskAddPage.routeName,
          builder: (context, state) => Provider<TaskAddBloc>(
            create: (context) => TaskAddBloc(appBloc: context.read<AppBloc>()),
            dispose: (context, value) => value.dispose(),
            child: const TaskAddPage(),
          ),
        ),
        GoRoute(
          path: TaskEditPage.routeName,
          builder: (context, state) {
            final Task task = state.extra as Task;

            return Provider<TaskEditBloc>(
              create: (context) => TaskEditBloc(
                appBloc: context.read<AppBloc>(),
                task: task,
              ),
              dispose: (context, value) => value.dispose(),
              child: const TaskEditPage(),
            );
          },
        ),
      ]),
]);

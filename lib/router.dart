import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_app/blocs/etc/subscription_bloc.dart';
import 'package:habit_app/blocs/task/task_detail_bloc.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/pages/base/task_page.dart';
import 'package:habit_app/pages/base/timer_page.dart';
import 'package:habit_app/pages/base_page.dart';
import 'package:habit_app/pages/drawer/licenses_page.dart';
import 'package:habit_app/pages/drawer/mode_page.dart';
import 'package:habit_app/pages/drawer/privacy_page.dart';
import 'package:habit_app/pages/drawer/term_page.dart';
import 'package:habit_app/pages/etc/dev_page.dart';
import 'package:habit_app/pages/etc/onboarding_page.dart';
import 'package:habit_app/pages/etc/subscription_page.dart';
import 'package:habit_app/pages/task/task_detail_page.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> rootNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldState> rootScaffoldKey = GlobalKey<ScaffoldState>();
final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

List<RouteBase> routes = [
  ShellRoute(
    navigatorKey: shellNavKey,
    builder: (context, state, child) {
      return BasePage(child: child);
    },
    routes: [
      GoRoute(
          path: TaskPage.routeName,
          builder: (context, state) {
            return const TaskPage();
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
    ],
  ),
  GoRoute(
    path: TermPage.routeName,
    builder: (context, state) {
      return const TermPage();
    },
  ),
  GoRoute(
    path: PrivacyPage.routeName,
    builder: (context, state) {
      return const PrivacyPage();
    },
  ),
  GoRoute(
    path: LicensesPage.routeName,
    builder: (context, state) {
      return const LicensesPage();
    },
  ),
  GoRoute(
    path: ModePage.routeName,
    builder: (context, state) {
      return const ModePage();
    },
  ),
  GoRoute(
    path: DevPage.routeName,
    builder: (context, state) {
      return const DevPage();
    },
  ),
  GoRoute(
    path: SubscriptionPage.routeName,
    builder: (context, state) {
      return Provider(
        create: (context) => SubscriptionBloc(),
        dispose: (context, value) => value.dispose(),
        child: const SubscriptionPage(),
      );
    },
  ),
  GoRoute(
    path: OnboardingPage.routeName,
    builder: (context, state) {
      return const OnboardingPage();
    },
  ),
];

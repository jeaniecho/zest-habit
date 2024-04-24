import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_app/services/app_service.dart';
import 'package:habit_app/blocs/etc/onboarding/onboarding_bloc.dart';
import 'package:habit_app/blocs/etc/onboarding/onboarding_task_bloc.dart';
import 'package:habit_app/blocs/etc/signin_bloc.dart';
import 'package:habit_app/blocs/etc/subscription_bloc.dart';
import 'package:habit_app/blocs/task/task_detail_bloc.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/pages/base/task_page.dart';
import 'package:habit_app/pages/base/timer_page.dart';
import 'package:habit_app/pages/base/base_page.dart';
import 'package:habit_app/pages/drawer/licenses_page.dart';
import 'package:habit_app/pages/drawer/mode_page.dart';
import 'package:habit_app/pages/etc/dev_page.dart';
import 'package:habit_app/pages/etc/onboarding/onboarding_page.dart';
import 'package:habit_app/pages/etc/onboarding/onboarding_task_page.dart';
import 'package:habit_app/pages/etc/signin_page.dart';
import 'package:habit_app/pages/etc/splash_page.dart';
import 'package:habit_app/pages/etc/subscription_page.dart';
import 'package:habit_app/pages/task/task_detail_page.dart';
import 'package:habit_app/utils/enums.dart';
import 'package:habit_app/utils/page_routes.dart';
import 'package:provider/provider.dart';

GlobalKey<NavigatorState> rootNavKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> shellNavKey = GlobalKey<NavigatorState>();
GlobalKey<ScaffoldState> rootScaffoldKey = GlobalKey<ScaffoldState>();
GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

final router = GoRouter(
    navigatorKey: rootNavKey,
    initialLocation: SplashPage.routeName,
    routes: routes,
    observers: [
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
    ]);

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
            final bool showTutorial = (state.extra ?? false) as bool;

            return TaskPage(showTutorial: showTutorial);
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
              create: (context) => TaskDetailBloc(
                  task: task, appService: context.read<AppService>()),
              dispose: (context, value) => value.dispose(),
              child: const TaskDetailPage(),
            );
          }),
    ],
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
    path: OnboardingPage.routeName,
    builder: (context, state) {
      return Provider(
        create: (context) => OnboardingBloc(),
        dispose: (context, value) => value.dispose(),
        child: const OnboardingPage(),
      );
    },
  ),
  GoRoute(
    path: OnboardingTaskPage.routeName,
    builder: (context, state) {
      return Provider(
        create: (context) =>
            OnboardingTaskBloc(appService: context.read<AppService>()),
        dispose: (context, value) => value.dispose(),
        child: const OnboardingTaskPage(),
      );
    },
  ),
  GoRoute(
    path: SplashPage.routeName,
    builder: (context, state) {
      return const SplashPage();
    },
  ),
  GoRoute(
    path: SigninPage.routeName,
    builder: (context, state) {
      return Provider(
        create: (context) => SigninBloc(context.read<AppService>()),
        dispose: (context, value) => value.dispose(),
        child: const SigninPage(),
      );
    },
  ),
];

pushSubscriptionPage(SubscriptionLocation location) {
  if (rootNavKey.currentContext != null) {
    Navigator.push(
        rootNavKey.currentContext!,
        HTPageRoutes.slideUp(Provider(
          create: (context) => SubscriptionBloc(location),
          dispose: (context, value) => value.dispose(),
          child: const SubscriptionPage(),
        )));
  }
}

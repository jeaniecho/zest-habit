import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_app/services/app_service.dart';
import 'package:habit_app/pages/base/task_page.dart';
import 'package:habit_app/pages/etc/signin_page.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const routeName = '/splash';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (context.read<AppService>().authValue != null) {
        context.pushReplacement(TaskPage.routeName);
      } else {
        context.pushReplacement(SigninPage.routeName);
      }

      // if (context.read<AppService>().settingsValue.completedOnboarding) {
      //   context.pushReplacement(TaskPage.routeName);
      // } else {
      //   context.pushReplacement(OnboardingPage.routeName);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.read<AppService>().settingsValue.isDarkMode
          ? HTColors.grey080
          : HTColors.white,
      body: Center(
        child: Lottie.asset('assets/lotties/splash_icon.json',
            width: 200, repeat: true),
      ),
    );
  }
}

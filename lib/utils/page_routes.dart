import 'package:flutter/widgets.dart';
import 'package:habit_app/blocs/etc/subscription_bloc.dart';
import 'package:habit_app/pages/etc/subscription_page.dart';
import 'package:habit_app/router.dart';
import 'package:provider/provider.dart';

class HTPageRoutes {
  HTPageRoutes._();

  static Route noTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: ((context, animation, secondaryAnimation) => page),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }

  static Route slideUp(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

slideUpSubscriptionPage() {
  if (rootNavKey.currentContext != null) {
    Navigator.push(
        rootNavKey.currentContext!,
        HTPageRoutes.slideUp(Provider(
          create: (context) => SubscriptionBloc(),
          dispose: (context, value) => value.dispose(),
          child: const SubscriptionPage(),
        )));
  }
}

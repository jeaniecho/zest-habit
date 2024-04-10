import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_app/iap/iap_service.dart';
import 'package:habit_app/blocs/app_service.dart';
import 'package:habit_app/blocs/base/task_bloc.dart';
import 'package:habit_app/blocs/base/timer_bloc.dart';
import 'package:habit_app/models/settings_model.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/router.dart';
import 'package:habit_app/styles/themes.dart';
import 'package:habit_app/utils/notifications.dart';
import 'package:isar/isar.dart';

import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Isar
  final dir = await getApplicationDocumentsDirectory();
  Isar isar = await Isar.open(
    [
      TaskSchema,
      SettingsSchema,
    ],
    directory: dir.path,
  );

  // Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

  // Local Notification
  HTNotification.init();

  runApp(MyApp(isar: isar));
}

class MyApp extends StatelessWidget {
  final Isar isar;
  const MyApp({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    IAPService iapService = IAPService();

    AppService appService = AppService(isar: isar, iapService: iapService);
    TaskBloc taskBloc = TaskBloc(
        appService: appService, deviceWidth: MediaQuery.sizeOf(context).width);
    TimerBloc timerBloc = TimerBloc(
        appService: appService,
        deviceHeight: MediaQuery.sizeOf(context).height);

    return MultiProvider(
      providers: [
        Provider(create: (context) => appService),
        Provider(create: (context) => iapService),
        Provider(create: (context) => taskBloc),
        Provider(create: (context) => timerBloc),
      ],
      child: StreamBuilder<Settings>(
          stream: appService.settings,
          builder: (context, snapshot) {
            Settings settings = snapshot.data ?? Settings();
            bool isDarkMode = settings.isDarkMode;

            return ScreenUtilInit(
              designSize: const Size(428, 926),
              minTextAdapt: true,
              child: MaterialApp.router(
                routerConfig: router,
                debugShowCheckedModeBanner: false,
                theme: HTThemes.lightTheme,
                darkTheme: HTThemes.darkTheme,
                themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
                scaffoldMessengerKey: snackbarKey,
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(textScaler: const TextScaler.linear(1.0)),
                    child: child!,
                  );
                },
              ),
            );
          }),
    );
  }
}

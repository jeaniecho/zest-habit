import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:habit_app/blocs/app_bloc.dart';
import 'package:habit_app/blocs/base/calendar_bloc.dart';
import 'package:habit_app/blocs/base/timer_bloc.dart';
import 'package:habit_app/models/settings_model.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/router.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/themes.dart';
import 'package:habit_app/utils/notifications.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Isar isar = await Isar.open(
    [
      TaskSchema,
      SettingsSchema,
    ],
    directory: dir.path,
  );

  HTNotification.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp(isar: isar));
}

class MyApp extends StatelessWidget {
  final Isar isar;
  const MyApp({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = AppBloc(isar: isar);

    double deviceWidth = MediaQuery.sizeOf(context).width;
    double deviceHeight = MediaQuery.sizeOf(context).height;

    return MultiProvider(
      providers: [
        Provider(create: (context) => appBloc),
        Provider(
          create: (context) =>
              CalendarBloc(appBloc: appBloc, deviceWidth: deviceWidth),
        ),
        Provider(
            create: (context) => TimerBloc(
                  appBloc: appBloc,
                  deviceHeight: deviceHeight,
                )),
      ],
      child: StreamBuilder<Settings>(
          stream: appBloc.settings,
          builder: (context, snapshot) {
            Settings settings = snapshot.data ?? Settings();
            bool isDarkMode = settings.isDarkMode;

            return MaterialApp.router(
              routerConfig: router,
              debugShowCheckedModeBanner: false,
              theme: HTThemes.lightTheme.copyWith(extensions: [HTGreys()]),
              darkTheme: HTThemes.darkTheme.copyWith(extensions: [
                HTGreys().copyWith(
                  white: const Color(0xFF000000),
                  black: const Color(0xFFFFFFFF),
                  grey010: const Color(0xFF151515),
                  grey020: const Color(0xFF272F3E),
                  grey030: const Color(0xFF394150),
                  grey040: const Color(0xFF4D5562),
                  grey050: const Color(0xFF6C727F),
                  grey060: const Color(0xFFA0A6B1),
                  grey070: const Color(0xFFD3D6DB),
                  grey080: const Color(0xFFE5E7EB),
                  grey090: const Color(0xFFF4F5F7),
                )
              ]),
              themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
              scaffoldMessengerKey: snackbarKey,
            );
          }),
    );
  }
}

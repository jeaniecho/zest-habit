import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:habit_app/blocs/app_bloc.dart';
import 'package:habit_app/blocs/base/daily_bloc.dart';
import 'package:habit_app/blocs/base/timer_bloc.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/router.dart';
import 'package:habit_app/styles/themes.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Isar isar = await Isar.open(
    [TaskSchema],
    directory: dir.path,
  );

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

    return MultiProvider(
      providers: [
        Provider(create: (context) => appBloc),
        Provider(
          create: (context) =>
              DailyBloc(appBloc: appBloc, deviceWidth: deviceWidth),
        ),
        Provider(create: (context) => TimerBloc()),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        theme: HTThemes.lightTheme,
        darkTheme: HTThemes.darkTheme,
        themeMode: ThemeMode.light,
      ),
    );
  }
}

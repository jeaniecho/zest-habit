import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:habit_app/blocs/app_bloc.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/pages/base_page.dart';
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
  AppBloc appBloc = AppBloc(isar: isar);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp(appBloc: appBloc));
}

class MyApp extends StatelessWidget {
  final AppBloc appBloc;
  const MyApp({super.key, required this.appBloc});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: HTThemes.lightTheme,
      darkTheme: HTThemes.darkTheme,
      themeMode: ThemeMode.system,
      home: Provider(
        create: (context) => appBloc,
        child: const BasePage(),
      ),
    );
  }
}

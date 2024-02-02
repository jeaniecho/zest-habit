import 'package:flutter/material.dart';
import 'package:habit_app/blocs/app_bloc.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/pages/base_page.dart';
import 'package:habit_app/styles/themes.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  getApplicationDocumentsDirectory().then((dir) {
    Isar.open(
      [TaskSchema],
      directory: dir.path,
    ).then((isar) {
      AppBloc appBloc = AppBloc(isar: isar);

      runApp(MyApp(appBloc: appBloc));
    });
  });
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

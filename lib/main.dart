import 'package:flutter/material.dart';
import 'package:habit_app/blocs/app_bloc.dart';
import 'package:habit_app/pages/base_page.dart';
import 'package:habit_app/styles/themes.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = AppBloc();

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

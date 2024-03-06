import 'package:flutter/material.dart';
import 'package:habit_app/blocs/app_bloc.dart';
import 'package:habit_app/models/settings_model.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/widgets/ht_appbar.dart';
import 'package:habit_app/widgets/ht_radio.dart';
import 'package:provider/provider.dart';

class ModePage extends StatelessWidget {
  const ModePage({super.key});

  static const routeName = '/mode';

  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = context.read<AppBloc>();

    return Scaffold(
      backgroundColor: htGreys(context).grey010,
      appBar: const HTAppbar(
        title: 'Mode',
        showClose: true,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<Settings>(
            stream: appBloc.settings,
            builder: (context, snapshot) {
              Settings settings = snapshot.data ?? Settings();
              bool isDarkMode = settings.isDarkMode;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: HTEdgeInsets.all24,
                    color: htGreys(context).white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HTRadio(
                          value: isDarkMode,
                          groupValue: false,
                          text: 'Light',
                          onTap: () {
                            appBloc.setDarkMode(false, context);
                          },
                        ),
                        HTSpacers.height8,
                        HTRadio(
                          value: isDarkMode,
                          groupValue: true,
                          text: 'Dark',
                          onTap: () {
                            appBloc.setDarkMode(true, context);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}

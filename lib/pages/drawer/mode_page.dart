import 'package:flutter/material.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/widgets/ht_appbar.dart';
import 'package:habit_app/widgets/ht_radio.dart';

class ModePage extends StatelessWidget {
  const ModePage({super.key});

  static const routeName = '/mode';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HTColors.grey010,
      appBar: const HTAppbar(
        title: 'Mode',
        showClose: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: HTEdgeInsets.all24,
              color: HTColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HTRadio(
                    isSelected: true,
                    text: 'Light (Default)',
                    onTap: () {},
                  ),
                  HTSpacers.height8,
                  HTRadio(
                    isSelected: false,
                    text: 'Dark',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/widgets/ht_text.dart';

class DailyPage extends StatelessWidget {
  const DailyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        DailyAppbar(),
        DailyTaskList(),
      ],
    );
  }
}

class DailyAppbar extends StatelessWidget {
  const DailyAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        HTText(
          'Task',
          typoToken: HTTypoToken.headlineLarge,
          color: HTColors.gray080,
        )
      ],
    );
  }
}

class DailyTaskList extends StatelessWidget {
  const DailyTaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: SingleChildScrollView(),
    );
  }
}

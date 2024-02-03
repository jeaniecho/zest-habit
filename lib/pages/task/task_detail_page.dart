import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:habit_app/blocs/task/task_detail_bloc.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/pages/task/task_edit_page.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:habit_app/widgets/ht_appbar.dart';
import 'package:habit_app/widgets/ht_text.dart';
import 'package:habit_app/widgets/ht_toggle.dart';
import 'package:provider/provider.dart';
import 'package:quiver/time.dart';

class TaskDetailPage extends StatelessWidget {
  const TaskDetailPage({super.key});

  static const routeName = '/task-detail';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TaskDetailAppbar(),
      body: TaskDetailBody(),
    );
  }
}

class TaskDetailAppbar extends HTAppbar {
  const TaskDetailAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    TaskDetailBloc taskDetailBloc = context.read<TaskDetailBloc>();

    return HTAppbar(
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, TaskEditPage.routeName,
                arguments: [taskDetailBloc.task]);
          },
          child: Container(
            margin: HTEdgeInsets.right16,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: HTColors.gray010,
              borderRadius: HTBorderRadius.circular24,
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.edit_rounded,
                  size: 14,
                  color: HTColors.black,
                ),
                HTSpacers.width4,
                HTText(
                  'Edit',
                  typoToken: HTTypoToken.subtitleMedium,
                  color: HTColors.black,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class TaskDetailBody extends StatelessWidget {
  const TaskDetailBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: HTEdgeInsets.vertical24,
      child: Column(
        children: [
          TaskDesc(),
          Divider(color: HTColors.gray010, thickness: 12, height: 12),
          TaskCalendar(),
          Divider(color: HTColors.gray010, thickness: 12, height: 12),
          TaskDetailInfo(),
          HTSpacers.height48,
        ],
      ),
    );
  }
}

class TaskDesc extends StatelessWidget {
  const TaskDesc({super.key});

  @override
  Widget build(BuildContext context) {
    TaskDetailBloc taskDetailBloc = context.read<TaskDetailBloc>();
    Task task = taskDetailBloc.task;

    return Padding(
      padding: HTEdgeInsets.horizontal24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (task.emoji != null)
            HTText(
              task.emoji!,
              typoToken: HTTypoToken.headlineLarge,
              color: HTColors.black,
            ),
          HTText(
            task.title,
            typoToken: HTTypoToken.headlineMedium,
            color: HTColors.black,
          ),
          if (task.goal != null)
            Padding(
              padding: HTEdgeInsets.top8,
              child: Row(
                children: [
                  HTText(
                    task.goal!,
                    typoToken: HTTypoToken.captionMedium,
                    color: HTColors.gray040,
                  ),
                ],
              ),
            ),
          if (task.desc != null)
            Container(
              margin: HTEdgeInsets.top12,
              padding: HTEdgeInsets.all16,
              decoration: BoxDecoration(
                color: HTColors.gray010,
                borderRadius: HTBorderRadius.circular10,
              ),
              child: HTText(
                task.desc!,
                typoToken: HTTypoToken.captionMedium,
                color: HTColors.gray070,
              ),
            ),
          HTSpacers.height16,
        ],
      ),
    );
  }
}

class TaskCalendar extends StatelessWidget {
  const TaskCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HTSpacers.height32,
        const TaskMonthly(),
        HTSpacers.height32,
        HTAnimatedToggle(
          values: const ['Weekly', 'Monthly'],
          onToggleCallback: (value) {},
        ),
        HTSpacers.height32,
      ],
    );
  }
}

class TaskMonthly extends StatelessWidget {
  const TaskMonthly({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        TaskMonthlyTitle(),
        HTSpacers.height24,
        TaskMonthlyCalendar(),
      ],
    );
  }
}

class TaskMonthlyTitle extends StatelessWidget {
  const TaskMonthlyTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              child: const Padding(
                padding: HTEdgeInsets.all4,
                child: Icon(
                  Icons.chevron_left_rounded,
                  size: 24,
                  color: HTColors.gray070,
                ),
              ),
            ),
            const HTText(
              '2024 January',
              typoToken: HTTypoToken.headlineMedium,
              color: HTColors.black,
              height: 1,
              underline: true,
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              child: const Padding(
                padding: HTEdgeInsets.all4,
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 24,
                  color: HTColors.gray070,
                ),
              ),
            ),
          ],
        ),
        HTSpacers.height16,
        const HTText(
          'You are about 42% closer to our goal.',
          typoToken: HTTypoToken.captionMedium,
          color: HTColors.gray040,
        )
      ],
    );
  }
}

class TaskMonthlyCalendar extends StatelessWidget {
  const TaskMonthlyCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    int daysCount = daysInMonth(today.year, today.month);

    return Container(
      width: (28 * 7) +
          (8 * 6) +
          16, // (boxWidth * 7days) + (boxPadding * (7-1)days) + containerPadding
      padding: HTEdgeInsets.all8,
      decoration: BoxDecoration(
        color: HTColors.gray010,
        borderRadius: HTBorderRadius.circular8,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        padding: HTEdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          return Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: HTColors.black,
              borderRadius: HTBorderRadius.circular8,
            ),
          );
        },
        itemCount: daysCount,
      ),
    );
  }
}

class TaskDetailInfo extends StatelessWidget {
  const TaskDetailInfo({super.key});

  @override
  Widget build(BuildContext context) {
    TaskDetailBloc taskDetailBloc = context.read<TaskDetailBloc>();

    return Padding(
      padding: HTEdgeInsets.horizontal24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HTSpacers.height24,
          const HTText(
            'Repeat',
            typoToken: HTTypoToken.captionMedium,
            color: HTColors.gray050,
          ),
          HTSpacers.height12,
          Container(
            padding: HTEdgeInsets.h16v12,
            decoration: BoxDecoration(
              border: Border.all(color: HTColors.gray010, width: 1),
              borderRadius: HTBorderRadius.circular10,
            ),
            child: HTText(
              '\u2022  ${repeatAtToText(taskDetailBloc.task.repeatAt)}',
              typoToken: HTTypoToken.captionMedium,
              color: HTColors.black,
            ),
          ),
          HTSpacers.height12,
          Container(
            padding: HTEdgeInsets.h16v12,
            decoration: BoxDecoration(
              border: Border.all(color: HTColors.gray010, width: 1),
              borderRadius: HTBorderRadius.circular10,
            ),
            child: HTText(
              '\u2022  ${untilToText(taskDetailBloc.task.until)}',
              typoToken: HTTypoToken.captionMedium,
              color: HTColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

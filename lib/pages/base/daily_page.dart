import 'package:flutter/material.dart';
import 'package:habit_app/blocs/app_bloc.dart';
import 'package:habit_app/blocs/base/daily_bloc.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/pages/task/task_detail_page.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:habit_app/widgets/ht_text.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class DailyPage extends StatelessWidget {
  const DailyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        DailyAppbar(),
        DailyDates(),
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Row(
            children: [
              HTText(
                'Task',
                typoToken: HTTypoToken.headlineLarge,
                color: HTColors.black,
              ),
              Spacer(),
              InkWell(
                child: Icon(
                  Icons.menu_rounded,
                  size: 24,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class DailyDates extends StatelessWidget {
  const DailyDates({super.key});

  @override
  Widget build(BuildContext context) {
    DailyBloc dailyBloc = context.read<DailyBloc>();

    return StreamBuilder<int>(
        stream: dailyBloc.dateIndex,
        builder: (context, snapshot) {
          int dateIndex = snapshot.data ?? 0;

          return Container(
            height: 52 + 16,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: HTColors.grey010,
                  width: 1,
                ),
              ),
            ),
            child: ListView.separated(
                controller: dailyBloc.dateScrollController,
                scrollDirection: Axis.horizontal,
                padding: HTEdgeInsets.horizontal16,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DateTime date = dailyBloc.dates[index];
                  bool isSelected = index == dateIndex;

                  return Row(
                    children: [
                      if (date.day == 1)
                        Container(
                          width: 52,
                          height: 52,
                          margin: HTEdgeInsets.right12,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: HTColors.grey010,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              HTText(
                                date.year.toString(),
                                typoToken: HTTypoToken.captionXSmall,
                                color: HTColors.grey040,
                              ),
                              HTText(
                                DateFormat.MMM().format(date),
                                typoToken: HTTypoToken.captionSmall,
                                color: HTColors.grey060,
                              ),
                            ],
                          ),
                        ),
                      GestureDetector(
                        onTap: () {
                          dailyBloc.setDateIndex(index);
                        },
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: isSameDay(DateTime.now().getDate(), date)
                                ? Border.all(
                                    color: isSelected
                                        ? HTColors.black
                                        : HTColors.grey020)
                                : null,
                            color: isSelected ? HTColors.black : HTColors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              HTText(
                                weekdayToText(date.weekday),
                                typoToken: HTTypoToken.captionXSmall,
                                color: HTColors.grey030,
                              ),
                              HTSpacers.height1,
                              HTText(
                                date.day.toString(),
                                typoToken: HTTypoToken.subtitleLarge,
                                color: isSelected
                                    ? HTColors.white
                                    : HTColors.black,
                                height: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return HTSpacers.width12;
                },
                itemCount: dailyBloc.dates.length),
          );
        });
  }
}

class DailyTaskList extends StatelessWidget {
  const DailyTaskList({super.key});

  @override
  Widget build(BuildContext context) {
    DailyBloc dailyBloc = context.read<DailyBloc>();

    return Expanded(
      child: Container(
          color: HTColors.grey010,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: StreamBuilder<List>(
                stream: Rx.combineLatestList(
                    [dailyBloc.currTasks, dailyBloc.dateIndex]),
                builder: (context, snapshot) {
                  List<Task> currTasks = snapshot.data?[0] ?? [];
                  int dateIndex = snapshot.data?[1] ?? 0;
                  List<Task> doneTasks = currTasks
                      .where((element) =>
                          isDone(dailyBloc.dates[dateIndex], element.doneAt))
                      .toList();

                  return Column(
                    children: [
                      Padding(
                        padding: HTEdgeInsets.horizontal8,
                        child: Row(
                          children: [
                            HTText(
                              '${currTasks.length} Task${currTasks.length > 1 ? 's' : ''}',
                              typoToken: HTTypoToken.captionMedium,
                              color: HTColors.grey040,
                            ),
                            const Spacer(),
                            HTText(
                              '${doneTasks.length} Done',
                              typoToken: HTTypoToken.captionMedium,
                              color: HTColors.grey040,
                            ),
                          ],
                        ),
                      ),
                      HTSpacers.height8,
                      ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            Task task = currTasks[index];
                            return TaskBox(task: task);
                          },
                          separatorBuilder: (context, index) {
                            return HTSpacers.height8;
                          },
                          itemCount: currTasks.length)
                    ],
                  );
                }),
          )),
    );
  }
}

class TaskBox extends StatelessWidget {
  final Task task;
  const TaskBox({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = context.read<AppBloc>();
    DailyBloc dailyBloc = context.read<DailyBloc>();

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, TaskDetailPage.routeName, arguments: task);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
            color: HTColors.white, borderRadius: HTBorderRadius.circular12),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (task.emoji != null)
                  HTText(
                    task.emoji!,
                    typoToken: HTTypoToken.headlineSmall,
                    color: HTColors.black,
                    height: 1.25,
                  ),
                HTText(
                  task.title,
                  typoToken: HTTypoToken.headlineSmall,
                  color: HTColors.black,
                ),
                Padding(
                  padding: HTEdgeInsets.top4,
                  child: Row(
                    children: [
                      if (task.until != null)
                        HTText(
                          '${untilToText(task.until)} ㆍ ',
                          typoToken: HTTypoToken.captionSmall,
                          color: HTColors.grey040,
                        ),
                      HTText(
                        repeatAtToText(task.repeatAt),
                        typoToken: HTTypoToken.captionSmall,
                        color: HTColors.grey040,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            StreamBuilder<int>(
                stream: dailyBloc.dateIndex,
                builder: (context, snapshot) {
                  int dateIndex = snapshot.data ?? 0;
                  DateTime date = dailyBloc.dates[dateIndex];
                  bool isDone = appBloc.isDone(task, date);

                  return GestureDetector(
                    onTap: () {
                      appBloc.toggleTask(task, date);
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: isDone ? HTColors.black : HTColors.grey030,
                        ),
                        HTText(
                          'Done',
                          typoToken: HTTypoToken.headlineXXSmall,
                          color: isDone ? HTColors.black : HTColors.grey030,
                        )
                      ],
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_app/blocs/app_bloc.dart';
import 'package:habit_app/blocs/base/daily_bloc.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/pages/task/task_detail_page.dart';
import 'package:habit_app/router.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:habit_app/widgets/ht_scale.dart';
import 'package:habit_app/widgets/ht_text.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class DailyPage extends StatelessWidget {
  const DailyPage({super.key});

  static const routeName = '/daily';

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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Row(
            children: [
              HTText(
                'Task',
                typoToken: HTTypoToken.headlineML,
                color: htGreys(context).black,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  rootScaffoldKey.currentState!.openEndDrawer();
                },
                child: const Icon(
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

          double dateSize = 52;
          double totalHeight = dateSize + 16;

          return Container(
            height: totalHeight,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: htGreys(context).grey010,
                  width: 1,
                ),
              ),
            ),
            child: Stack(
              children: [
                ListView.separated(
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
                              width: dateSize,
                              height: dateSize,
                              margin: HTEdgeInsets.right12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: htGreys(context).grey010,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  HTText(
                                    date.year.toString(),
                                    typoToken: HTTypoToken.captionXXSmall,
                                    color: htGreys(context).grey040,
                                  ),
                                  HTText(
                                    DateFormat.MMM().format(date),
                                    typoToken: HTTypoToken.captionSmall,
                                    color: htGreys(context).grey050,
                                  ),
                                ],
                              ),
                            ),
                          GestureDetector(
                            onTap: () {
                              dailyBloc.setDateIndex(index);
                            },
                            child: Container(
                              width: dateSize,
                              height: dateSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    htIsSameDay(DateTime.now().getDate(), date)
                                        ? Border.all(
                                            color: isSelected
                                                ? htGreys(context).black
                                                : htGreys(context).grey020)
                                        : null,
                                color: isSelected
                                    ? htGreys(context).black
                                    : htGreys(context).white,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  HTText(
                                    htWeekdayToText(date.weekday),
                                    typoToken: HTTypoToken.captionXXSmall,
                                    color: htGreys(context).grey030,
                                  ),
                                  HTSpacers.height1,
                                  HTText(
                                    date.day.toString(),
                                    typoToken: HTTypoToken.subtitleMedium,
                                    color: isSelected
                                        ? htGreys(context).white
                                        : htGreys(context).black,
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
                StreamBuilder<int>(
                    stream: dailyBloc.notToday,
                    builder: (context, snapshot) {
                      int notToday = snapshot.data ?? 0;

                      if (notToday >= 0) {
                        return const SizedBox.shrink();
                      }

                      return Positioned(
                        left: 0,
                        child: Container(
                          height: totalHeight,
                          color: htGreys(context).white,
                          child: GestureDetector(
                            onTap: () {
                              dailyBloc.scrollToToday();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: HTEdgeInsets.horizontal12,
                                  child: Icon(
                                    Icons.keyboard_double_arrow_left_rounded,
                                    size: 24,
                                    color: htGreys(context).grey040,
                                  ),
                                ),
                                Padding(
                                  padding: HTEdgeInsets.vertical8,
                                  child: VerticalDivider(
                                    width: 1,
                                    thickness: 1,
                                    color: htGreys(context).grey020,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                StreamBuilder<int>(
                    stream: dailyBloc.notToday,
                    builder: (context, snapshot) {
                      int notToday = snapshot.data ?? 0;

                      if (notToday <= 0) {
                        return const SizedBox.shrink();
                      }

                      return Positioned(
                        right: 0,
                        child: Container(
                          height: totalHeight,
                          color: htGreys(context).white,
                          child: GestureDetector(
                            onTap: () {
                              dailyBloc.scrollToToday();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: HTEdgeInsets.vertical8,
                                  child: VerticalDivider(
                                    width: 1,
                                    thickness: 1,
                                    color: htGreys(context).grey020,
                                  ),
                                ),
                                Padding(
                                  padding: HTEdgeInsets.horizontal12,
                                  child: Icon(
                                    Icons.keyboard_double_arrow_right_rounded,
                                    size: 24,
                                    color: htGreys(context).grey040,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            ),
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
        color: htGreys(context).grey010,
        child: StreamBuilder<List>(
            stream: Rx.combineLatestList(
                [dailyBloc.currTasks, dailyBloc.dateIndex]),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              List<Task> currTasks = snapshot.data?[0] ?? [];
              int dateIndex = snapshot.data?[1] ?? 0;
              List<Task> doneTasks = currTasks
                  .where((element) =>
                      htIsDone(dailyBloc.dates[dateIndex], element.doneAt))
                  .toList();

              if (currTasks.isEmpty) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: HTEdgeInsets.horizontal8,
                        child: Row(
                          children: [
                            HTText(
                              '${currTasks.length} Task${currTasks.length > 1 ? 's' : ''}',
                              typoToken: HTTypoToken.captionSmall,
                              color: htGreys(context).grey040,
                            ),
                            const Spacer(),
                            HTText(
                              '${doneTasks.length} Done',
                              typoToken: HTTypoToken.captionSmall,
                              color: htGreys(context).grey040,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: htGreys(context).grey020,
                                borderRadius: HTBorderRadius.circular12,
                              ),
                            ),
                            HTSpacers.height24,
                            HTText(
                              'Let\'s kickstart with a new task!',
                              typoToken: HTTypoToken.subtitleLarge,
                              color: htGreys(context).black,
                            ),
                            HTSpacers.height8,
                            HTText(
                              'Start your habit journey now! Add a task to get going.',
                              typoToken: HTTypoToken.bodyXSmall,
                              color: htGreys(context).grey050,
                            ),
                            HTSpacers.height40,
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: HTEdgeInsets.horizontal8,
                      child: Row(
                        children: [
                          HTText(
                            '${currTasks.length} Task${currTasks.length > 1 ? 's' : ''}',
                            typoToken: HTTypoToken.captionSmall,
                            color: htGreys(context).grey040,
                          ),
                          const Spacer(),
                          HTText(
                            '${doneTasks.length} Done',
                            typoToken: HTTypoToken.captionSmall,
                            color: htGreys(context).grey040,
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
                ),
              );
            }),
      ),
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

    return HTScale(
      onTap: () {
        context.push(TaskDetailPage.routeName, extra: task);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
            color: htGreys(context).white,
            borderRadius: HTBorderRadius.circular12),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                task.emoji != null && task.emoji!.isNotEmpty
                    ? HTText(
                        task.emoji!,
                        typoToken: HTTypoToken.subtitleXLarge,
                        color: htGreys(context).black,
                        height: 1.25,
                      )
                    : Icon(
                        Icons.emoji_emotions_rounded,
                        color: htGreys(context).grey030,
                        size: 20,
                      ),
                HTText(
                  task.title,
                  typoToken: HTTypoToken.headlineXSmall,
                  color: htGreys(context).black,
                ),
                Padding(
                  padding: HTEdgeInsets.top2,
                  child: Row(
                    children: [
                      if (task.until != null)
                        HTText(
                          '${htUntilToText(task.until)} ㆍ ',
                          typoToken: HTTypoToken.captionXSmall,
                          color: htGreys(context).grey040,
                        ),
                      HTText(
                        htRepeatAtToText(task.repeatAt),
                        typoToken: HTTypoToken.captionXSmall,
                        color: htGreys(context).grey040,
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
                      HapticFeedback.lightImpact();
                      appBloc.toggleTask(task, date);
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: isDone
                              ? htGreys(context).black
                              : htGreys(context).grey030,
                          size: 24,
                        ),
                        HTText(
                          'Done',
                          typoToken: HTTypoToken.subtitleXSmall,
                          color: isDone
                              ? htGreys(context).black
                              : htGreys(context).grey050,
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

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_app/blocs/app_bloc.dart';
import 'package:habit_app/blocs/task/task_detail_bloc.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/effects.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:habit_app/widgets/ht_appbar.dart';
import 'package:habit_app/widgets/ht_text.dart';
import 'package:habit_app/widgets/ht_toggle.dart';
import 'package:intl/intl.dart';
import 'package:kr_pull_down_button/pull_down_button.dart';
import 'package:provider/provider.dart';
import 'package:quiver/time.dart';
import 'package:rxdart/rxdart.dart';

class TaskDetailPage extends StatelessWidget {
  const TaskDetailPage({super.key});

  static const routeName = '/task-detail';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HTAppbar(
        actions: [
          TaskDetailAction(),
          HTSpacers.width16,
        ],
      ),
      body: TaskDetailBody(),
    );
  }
}

class TaskDetailAction extends StatelessWidget {
  const TaskDetailAction({super.key});

  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = context.read<AppBloc>();
    TaskDetailBloc taskDetailBloc = context.read<TaskDetailBloc>();

    showDeleteDialog() {
      showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoAlertDialog(
                title: const Text('Delete your task?'),
                content: const Text(
                    'Removing this task clears all habit tracking data.'),
                actions: <CupertinoDialogAction>[
                  CupertinoDialogAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: CupertinoColors.activeBlue),
                    ),
                  ),
                  CupertinoDialogAction(
                      isDefaultAction: true,
                      isDestructiveAction: true,
                      onPressed: () {
                        Navigator.pop(context);

                        appBloc
                            .deleteTask(taskDetailBloc.taskObjValue)
                            .then((value) {
                          context.pop();
                        });
                      },
                      child: const Text('Delete')),
                ],
              ));
    }

    return PullDownButton(
        offset: const Offset(4, 4),
        routeTheme: const PullDownMenuRouteTheme().copyWith(
            backgroundColor: HTColors.white,
            beginShadow: HTBoxShadows.dropDownBlur12SpreadOpacity8,
            endShadow: HTBoxShadows.dropDownBlur24Spread4pacity8),
        itemBuilder: (context) => [
              PullDownMenuItem(
                title: 'Edit',
                icon: CupertinoIcons.pen,
                onTap: () {
                  taskDetailBloc.showEditModal(context);
                },
              ),
              const PullDownMenuDivider(),
              PullDownMenuItem(
                title: 'Delete',
                icon: CupertinoIcons.trash,
                isDestructive: true,
                onTap: () {
                  showDeleteDialog();
                },
              ),
            ],
        buttonBuilder: (context, showMenu) => GestureDetector(
              onTap: showMenu,
              child: const Icon(
                Icons.more_horiz,
                color: HTColors.black,
                size: 24,
              ),
            ));
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
          Divider(color: HTColors.grey010, thickness: 12, height: 12),
          Column(
            children: [
              TaskCalendar(),
              Divider(color: HTColors.grey010, thickness: 12, height: 12),
            ],
          ),
          TaskDetailInfo(),
          HTSpacers.height48,
        ],
      ),
    );
  }
}

class TaskEditButton extends StatelessWidget {
  const TaskEditButton({super.key});

  @override
  Widget build(BuildContext context) {
    TaskDetailBloc taskDetailBloc = context.read<TaskDetailBloc>();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        taskDetailBloc.showEditModal(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: HTColors.grey010,
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
    );
  }
}

class TaskDesc extends StatelessWidget {
  const TaskDesc({super.key});

  @override
  Widget build(BuildContext context) {
    TaskDetailBloc taskDetailBloc = context.read<TaskDetailBloc>();

    return StreamBuilder<Task>(
        stream: taskDetailBloc.taskObj,
        builder: (context, snapshot) {
          Task task = snapshot.data ?? taskDetailBloc.task;

          return Padding(
            padding: HTEdgeInsets.horizontal24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    task.emoji != null && task.emoji!.isNotEmpty
                        ? HTText(
                            task.emoji!,
                            typoToken: HTTypoToken.headlineLarge,
                            color: HTColors.black,
                          )
                        : const Icon(
                            Icons.emoji_emotions_rounded,
                            color: HTColors.grey030,
                            size: 36,
                          ),
                    const Spacer(),
                    const TaskEditButton(),
                  ],
                ),
                HTText(
                  task.title,
                  typoToken: HTTypoToken.headlineMedium,
                  color: HTColors.black,
                ),
                if (task.goal != null && task.goal!.isNotEmpty)
                  Padding(
                    padding: HTEdgeInsets.top8,
                    child: HTText(
                      task.goal!,
                      typoToken: HTTypoToken.captionMedium,
                      color: HTColors.grey040,
                    ),
                  ),
                // if (task.desc != null)
                //   Container(
                //     margin: HTEdgeInsets.top12,
                //     padding: HTEdgeInsets.h16v12,
                //     decoration: BoxDecoration(
                //       color: HTColors.grey010,
                //       borderRadius: HTBorderRadius.circular10,
                //     ),
                //     child: HTText(
                //       task.desc!,
                //       typoToken: HTTypoToken.captionMedium,
                //       color: HTColors.grey070,
                //     ),
                //   ),
                HTSpacers.height16,
              ],
            ),
          );
        });
  }
}

class TaskCalendar extends StatelessWidget {
  const TaskCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    TaskDetailBloc taskDetailBloc = context.read<TaskDetailBloc>();

    return Column(
      children: [
        HTSpacers.height32,
        StreamBuilder<bool>(
            stream: taskDetailBloc.isMonthly,
            builder: (context, snapshot) {
              bool isMonthly = snapshot.data ?? true;

              return isMonthly ? const TaskMonthly() : const TaskWeekly();
            }),
        HTSpacers.height24,
        HTAnimatedToggle(
          values: const ['Weekly', 'Monthly'],
          onToggleCallback: (value) {
            taskDetailBloc.toggleCalendarType();
          },
        ),
        HTSpacers.height32,
      ],
    );
  }
}

class TaskWeekly extends StatelessWidget {
  const TaskWeekly({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        TaskWeeklyTitle(),
        HTSpacers.height24,
        TaskWeeklyCalendar(),
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

class TaskWeeklyTitle extends StatelessWidget {
  const TaskWeeklyTitle({super.key});

  @override
  Widget build(BuildContext context) {
    TaskDetailBloc taskDetailBloc = context.read<TaskDetailBloc>();

    return StreamBuilder<Task>(
        stream: taskDetailBloc.taskObj,
        builder: (context, snapshot) {
          Task task = snapshot.data ?? taskDetailBloc.task;

          return Column(
            children: [
              StreamBuilder<DateTime>(
                  stream: taskDetailBloc.currDate,
                  builder: (context, snapshot) {
                    DateTime today = DateTime.now().getDate();
                    DateTime currDate = snapshot.data ?? today;
                    int weekNum = htWeekOfMonth(currDate);

                    bool isBefore = !currDate.isAfter(task.from);
                    bool isLater = !htMostRecentWeekday(currDate)
                        .isBefore(htMostRecentWeekday(today));

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (!isBefore) {
                              taskDetailBloc.changeWeek(-1);
                            }
                          },
                          child: Padding(
                            padding: HTEdgeInsets.all4,
                            child: Icon(
                              Icons.chevron_left_rounded,
                              size: 24,
                              color: isBefore
                                  ? HTColors.grey030
                                  : HTColors.grey060,
                            ),
                          ),
                        ),
                        HTText(
                          '${DateFormat.MMMM().format(currDate)} $weekNum${stndrd(weekNum)} week',
                          typoToken: HTTypoToken.headlineSmall,
                          color: HTColors.black,
                          height: 1,
                          underline: true,
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (!isLater) {
                              taskDetailBloc.changeWeek(1);
                            }
                          },
                          child: Padding(
                            padding: HTEdgeInsets.all4,
                            child: Icon(
                              Icons.chevron_right_rounded,
                              size: 24,
                              color:
                                  isLater ? HTColors.grey030 : HTColors.grey060,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
              HTSpacers.height16,
              if (task.until != null)
                HTText(
                  'You are about ${progressPercentage(task.from, task.until!, task.doneAt)}% closer to our goal.',
                  typoToken: HTTypoToken.captionMedium,
                  color: HTColors.grey040,
                )
            ],
          );
        });
  }
}

class TaskMonthlyTitle extends StatelessWidget {
  const TaskMonthlyTitle({super.key});

  @override
  Widget build(BuildContext context) {
    TaskDetailBloc taskDetailBloc = context.read<TaskDetailBloc>();

    return StreamBuilder<Task>(
        stream: taskDetailBloc.taskObj,
        builder: (context, snapshot) {
          Task task = snapshot.data ?? taskDetailBloc.task;

          return Column(
            children: [
              StreamBuilder<DateTime>(
                  stream: taskDetailBloc.currDate,
                  builder: (context, snapshot) {
                    DateTime today = DateTime.now().getDate();
                    DateTime currMonth = snapshot.data ?? today;

                    bool isBefore = htIsSameMonth(task.from, currMonth);
                    bool isAfter = htIsSameMonth(today, currMonth);

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (!isBefore) {
                              taskDetailBloc.changeMonth(-1);
                            }
                          },
                          child: Padding(
                            padding: HTEdgeInsets.all4,
                            child: Icon(
                              Icons.chevron_left_rounded,
                              size: 24,
                              color: isBefore
                                  ? HTColors.grey030
                                  : HTColors.grey060,
                            ),
                          ),
                        ),
                        HTText(
                          '${currMonth.year} ${DateFormat.MMMM().format(currMonth)}',
                          typoToken: HTTypoToken.headlineSmall,
                          color: HTColors.black,
                          height: 1,
                          underline: true,
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (!isAfter) {
                              taskDetailBloc.changeMonth(1);
                            }
                          },
                          child: Padding(
                            padding: HTEdgeInsets.all4,
                            child: Icon(
                              Icons.chevron_right_rounded,
                              size: 24,
                              color:
                                  isAfter ? HTColors.grey030 : HTColors.grey060,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
              if (task.until != null)
                Padding(
                  padding: HTEdgeInsets.top16,
                  child: HTText(
                    'You are about ${progressPercentage(task.from, task.until!, task.doneAt)}% closer to our goal.',
                    typoToken: HTTypoToken.captionMedium,
                    color: HTColors.grey040,
                  ),
                )
            ],
          );
        });
  }
}

class TaskWeeklyCalendar extends StatelessWidget {
  const TaskWeeklyCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    TaskDetailBloc taskDetailBloc = context.read<TaskDetailBloc>();

    return SizedBox(
      height: 86,
      child: StreamBuilder<List>(
          stream: Rx.combineLatestList([
            taskDetailBloc.currDate,
            taskDetailBloc.doneDates,
            taskDetailBloc.taskObj
          ]),
          builder: (context, snapshot) {
            Task task = snapshot.data?[2] ?? taskDetailBloc.task;

            DateTime now = DateTime.now().getDate();
            DateTime currDate = htMostRecentWeekday(snapshot.data?[0] ?? now);
            DateTime firstDay = htMostRecentWeekday(currDate);
            int lastDate = getLastDateOfMonth(currDate);

            List<int> doneDates = snapshot.data?[1] ?? [];

            return LayoutBuilder(builder: (context, constraints) {
              List<int> repeatAt = task.repeatAt ?? [];
              repeatAt = htSortRepeatAt(repeatAt);

              double maxWidth = constraints.maxWidth;
              double itemWidth = 38;
              int itemCount = repeatAt.length;
              double spacing = min(
                  (maxWidth - (itemWidth * itemCount) - 48) / (itemCount - 1),
                  24);

              // One time
              if (repeatAt.isEmpty) {
                bool isDone = doneDates.contains(
                    firstDay.day + (dayNums.indexOf(task.from.weekday) % 7));
                bool isLater = task.from.difference(now).inDays >= 0;

                return Column(
                  children: [
                    HTText(
                      htWeekdayToText(task.from.weekday),
                      typoToken: HTTypoToken.captionXSmall,
                      color: HTColors.grey050,
                    ),
                    HTSpacers.height12,
                    Container(
                      width: itemWidth,
                      height: itemWidth,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: isDone ? HTColors.black : HTColors.grey010,
                            width: 1),
                        color: isDone
                            ? HTColors.black
                            : isLater
                                ? HTColors.white
                                : HTColors.grey010,
                      ),
                      child: Center(
                          child: isDone
                              ? const Icon(
                                  Icons.check_rounded,
                                  color: HTColors.white,
                                  size: 20,
                                )
                              : HTText(
                                  '${task.from.day}',
                                  typoToken: HTTypoToken.subtitleXSmall,
                                  color: HTColors.grey040,
                                  height: 1.25,
                                )),
                    ),
                    HTSpacers.height4,
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: htIsSameDay(task.from, now)
                            ? HTColors.red
                            : HTColors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                );
              }

              return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  padding: HTEdgeInsets.horizontal24,
                  itemBuilder: (context, index) {
                    int dayOfWeek = dayNums.indexOf(repeatAt[index]);

                    int day = firstDay.day + (dayOfWeek % 7);
                    if (day > lastDate) {
                      day -= lastDate;
                    }

                    bool isDone = doneDates.contains(day);
                    int diff = now.difference(firstDay).inDays;
                    bool inSameWeek = diff >= 0 && diff < 7;
                    bool isLater = (inSameWeek &&
                            dayNums.indexOf(now.weekday) <= dayOfWeek) ||
                        (!inSameWeek && diff < 0);
                    bool isToday = inSameWeek && now.day == day;

                    return Column(
                      children: [
                        HTText(
                          htWeekdayToText(repeatAt[index]),
                          typoToken: HTTypoToken.captionXSmall,
                          color: HTColors.grey050,
                        ),
                        HTSpacers.height12,
                        Container(
                          width: itemWidth,
                          height: itemWidth,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: isDone
                                    ? Color(task.color)
                                    : HTColors.grey010,
                                width: 1),
                            color: isDone
                                ? Color(task.color)
                                : isLater
                                    ? HTColors.white
                                    : HTColors.grey010,
                          ),
                          child: Center(
                              child: isDone
                                  ? const Icon(
                                      Icons.check_rounded,
                                      color: HTColors.white,
                                      size: 20,
                                    )
                                  : HTText(
                                      '$day',
                                      typoToken: HTTypoToken.subtitleXSmall,
                                      color: HTColors.grey040,
                                      height: 1.25,
                                    )),
                        ),
                        HTSpacers.height4,
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: isToday ? HTColors.red : HTColors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(width: spacing);
                  },
                  itemCount: repeatAt.length);
            });
          }),
    );
  }
}

class TaskMonthlyCalendar extends StatelessWidget {
  const TaskMonthlyCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    TaskDetailBloc taskDetailBloc = context.read<TaskDetailBloc>();

    return StreamBuilder<List>(
        stream: Rx.combineLatestList(
            [taskDetailBloc.currDate, taskDetailBloc.taskObj]),
        builder: (context, snapshot) {
          Task task = snapshot.data?[1] ?? taskDetailBloc.task;

          DateTime currDate = snapshot.data?[0] ?? DateTime.now().getDate();
          DateTime currMonth = DateTime(currDate.year, currDate.month, 1);
          int daysCount = daysInMonth(currMonth.year, currMonth.month);

          // fill first week
          int fillDays = 7 - ((7 + firstDayOfWeek) - currMonth.weekday);
          daysCount += fillDays;

          List<int> repeatAt = task.repeatAt ?? [];

          return Container(
            width: (28 * 7) +
                (8 * 6) +
                16, // (boxWidth * 7days) + (boxPadding * (7-1)days) + containerPadding
            padding: HTEdgeInsets.all8,
            decoration: BoxDecoration(
              color: HTColors.grey010,
              borderRadius: HTBorderRadius.circular8,
            ),
            child: StreamBuilder<List<int>>(
                stream: taskDetailBloc.doneDates,
                builder: (context, snapshot) {
                  List<int> doneDates = snapshot.data ?? [];

                  DateTime now = DateTime.now().getDate();
                  int todayDateInCal = now.day - 1 + fillDays;

                  return GridView.builder(
                    shrinkWrap: true,
                    padding: HTEdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      int currWeekday = index % 7;
                      if (currWeekday == 0 && firstDayOfWeek == 0) {
                        currWeekday = 7;
                      }
                      bool repeatToday =
                          repeatAt.contains(currWeekday + firstDayOfWeek);

                      bool inSameMonth = htIsSameMonth(currMonth, now);

                      bool isDone = doneDates.contains(index - fillDays + 1);

                      bool isLater = (inSameMonth && index > todayDateInCal) ||
                          (!inSameMonth &&
                              DateTime(currMonth.year, currMonth.month)
                                  .isAfter(DateTime(now.year, now.month)));

                      if (repeatAt.isEmpty &&
                          task.from.day - 1 + fillDays == index) {
                        return Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(task.color), width: 2),
                            color: isDone
                                ? Color(task.color)
                                : isLater
                                    ? HTColors.white
                                    : HTColors.grey030,
                            borderRadius: HTBorderRadius.circular8,
                          ),
                        );
                      }

                      // fill days
                      if (index < fillDays) {
                        return Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: HTColors.grey010,
                            borderRadius: HTBorderRadius.circular8,
                          ),
                        );
                      }

                      // no repeat || before
                      if (!repeatToday ||
                          DateTime(currMonth.year, currMonth.month,
                                  index - fillDays + firstDayOfWeek)
                              .isBefore(task.from)) {
                        return Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: HTColors.white50,
                            borderRadius: HTBorderRadius.circular8,
                          ),
                        );
                      }

                      return Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          border: inSameMonth && index == todayDateInCal
                              ? Border.all(color: Color(task.color), width: 2)
                              : null,
                          color: isDone
                              ? Color(task.color)
                              : isLater
                                  ? HTColors.white
                                  : Color(task.color).withOpacity(0.2),
                          borderRadius: HTBorderRadius.circular8,
                        ),
                      );
                    },
                    itemCount: daysCount,
                  );
                }),
          );
        });
  }
}

class TaskDetailInfo extends StatelessWidget {
  const TaskDetailInfo({super.key});

  @override
  Widget build(BuildContext context) {
    TaskDetailBloc taskDetailBloc = context.read<TaskDetailBloc>();

    return StreamBuilder<Task>(
        stream: taskDetailBloc.taskObj,
        builder: (context, snapshot) {
          Task task = snapshot.data ?? taskDetailBloc.task;

          return Padding(
            padding: HTEdgeInsets.horizontal24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HTSpacers.height24,
                const HTText(
                  'Repeat',
                  typoToken: HTTypoToken.captionMedium,
                  color: HTColors.grey050,
                ),
                HTSpacers.height12,
                Container(
                  padding: HTEdgeInsets.h16v12,
                  decoration: BoxDecoration(
                    border: Border.all(color: HTColors.grey010, width: 1),
                    borderRadius: HTBorderRadius.circular10,
                  ),
                  child: HTText(
                    '\u2022  ${htRepeatAtToText(task.repeatAt)}',
                    typoToken: HTTypoToken.captionMedium,
                    color: HTColors.black,
                  ),
                ),
                HTSpacers.height12,
                Container(
                  padding: HTEdgeInsets.h16v12,
                  decoration: BoxDecoration(
                    border: Border.all(color: HTColors.grey010, width: 1),
                    borderRadius: HTBorderRadius.circular10,
                  ),
                  child: HTText(
                    '\u2022  From ${DateFormat('yyyy.MM.dd').format(task.from)}',
                    typoToken: HTTypoToken.captionMedium,
                    color: HTColors.black,
                  ),
                ),
                HTSpacers.height12,
                Container(
                  padding: HTEdgeInsets.h16v12,
                  decoration: BoxDecoration(
                    border: Border.all(color: HTColors.grey010, width: 1),
                    borderRadius: HTBorderRadius.circular10,
                  ),
                  child: HTText(
                    '\u2022  ${htUntilToText(task.until, long: true)}',
                    typoToken: HTTypoToken.captionMedium,
                    color: HTColors.black,
                  ),
                ),
              ],
            ),
          );
        });
  }
}

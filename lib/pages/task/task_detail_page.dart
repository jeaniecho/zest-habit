import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_app/blocs/app_bloc.dart';
import 'package:habit_app/blocs/task/task_detail_bloc.dart';
import 'package:habit_app/models/settings_model.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:habit_app/widgets/ht_appbar.dart';
import 'package:habit_app/widgets/ht_dialog.dart';
import 'package:habit_app/widgets/ht_text.dart';
import 'package:habit_app/widgets/ht_toggle.dart';
import 'package:intl/intl.dart';
import 'package:kr_pull_down_button/pull_down_button.dart';
import 'package:provider/provider.dart';
import 'package:quiver/time.dart';
import 'package:rxdart/rxdart.dart';
import 'package:table_calendar/table_calendar.dart';

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

    bool isOld = taskDetailBloc.task.until != null &&
        taskDetailBloc.task.until!.isBefore(DateTime.now().getDate());

    return PullDownButton(
        offset: const Offset(4, 4),
        routeTheme: const PullDownMenuRouteTheme().copyWith(
            backgroundColor: htGreys(context).white,
            beginShadow: BoxShadow(
              color: htGreys(context).black.withOpacity(0.08),
              blurRadius: 12,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
            endShadow: BoxShadow(
              color: htGreys(context).black.withOpacity(0.08),
              blurRadius: 24,
              spreadRadius: 4,
              offset: const Offset(0, 8),
            )),
        itemBuilder: (context) => [
              if (!isOld)
                PullDownMenuItem(
                  title: 'Edit',
                  icon: CupertinoIcons.pen,
                  onTap: () {
                    taskDetailBloc.showEditModal(context);
                  },
                ),
              if (!isOld) const PullDownMenuDivider(),
              PullDownMenuItem(
                title: 'Delete',
                icon: CupertinoIcons.trash,
                isDestructive: true,
                onTap: () {
                  HTDialog.showConfirmDialog(
                    context,
                    title: 'Delete your task?',
                    content:
                        'Removing this task clears all habit tracking data.',
                    action: () {
                      appBloc
                          .deleteTask(taskDetailBloc.taskObjValue)
                          .then((value) {
                        context.pop();
                      });
                    },
                    buttonText: 'Delete',
                  );
                },
              ),
            ],
        buttonBuilder: (context, showMenu) => GestureDetector(
              onTap: showMenu,
              child: Icon(
                Icons.more_horiz,
                color: htGreys(context).black,
                size: 24,
              ),
            ));
  }
}

class TaskDetailBody extends StatelessWidget {
  const TaskDetailBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: HTEdgeInsets.vertical24,
      child: Column(
        children: [
          const TaskDesc(),
          Divider(color: htGreys(context).grey010, thickness: 12, height: 12),
          const TaskCalendar(),
          Divider(color: htGreys(context).grey010, thickness: 12, height: 12),
          const TaskDetailRepeat(),
          Divider(color: htGreys(context).grey010, thickness: 12, height: 12),
          const TaskDetailAlarm(),
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

    bool isOld = taskDetailBloc.task.until != null &&
        taskDetailBloc.task.until!.isBefore(DateTime.now().getDate());
    if (isOld) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        taskDetailBloc.showEditModal(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: htGreys(context).grey010,
          borderRadius: HTBorderRadius.circular24,
        ),
        child: Row(
          children: [
            Icon(
              Icons.edit_rounded,
              size: 14,
              color: htGreys(context).black,
            ),
            HTSpacers.width4,
            HTText(
              'Edit',
              typoToken: HTTypoToken.subtitleMedium,
              color: htGreys(context).black,
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
                            color: htGreys(context).black,
                          )
                        : Icon(
                            Icons.emoji_emotions_rounded,
                            color: htGreys(context).grey030,
                            size: 36,
                          ),
                    const Spacer(),
                    const TaskEditButton(),
                  ],
                ),
                HTText(
                  task.title,
                  typoToken: HTTypoToken.headlineMedium,
                  color: htGreys(context).black,
                ),
                if (task.goal != null && task.goal!.isNotEmpty)
                  Padding(
                    padding: HTEdgeInsets.top8,
                    child: HTText(
                      task.goal!,
                      typoToken: HTTypoToken.captionMedium,
                      color: htGreys(context).grey040,
                    ),
                  ),
                // if (task.desc != null)
                //   Container(
                //     margin: HTEdgeInsets.top12,
                //     padding: HTEdgeInsets.h16v12,
                //     decoration: BoxDecoration(
                //       color: grey010,
                //       borderRadius: HTBorderRadius.circular10,
                //     ),
                //     child: HTText(
                //       task.desc!,
                //       typoToken: HTTypoToken.captionMedium,
                //       color: grey070,
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

                    bool isOld = taskDetailBloc.task.until != null &&
                        taskDetailBloc.task.until!.isBefore(today);

                    bool isBefore = !currDate.isAfter(task.from);
                    bool isLater = !htMostRecentWeekday(currDate).isBefore(
                        htMostRecentWeekday(isOld ? task.until! : today));

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
                                  ? htGreys(context).grey030
                                  : htGreys(context).grey060,
                            ),
                          ),
                        ),
                        HTText(
                          '${DateFormat.MMMM().format(currDate)} $weekNum${stndrd(weekNum)} week',
                          typoToken: HTTypoToken.headlineSmall,
                          color: htGreys(context).black,
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
                              color: isLater
                                  ? htGreys(context).grey030
                                  : htGreys(context).grey060,
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
                  color: htGreys(context).grey040,
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

                    bool isOld = taskDetailBloc.task.until != null &&
                        taskDetailBloc.task.until!.isBefore(today);

                    bool isBefore = htIsSameMonth(task.from, currMonth);
                    bool isAfter =
                        htIsSameMonth(isOld ? task.until! : today, currMonth);

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
                                  ? htGreys(context).grey030
                                  : htGreys(context).grey060,
                            ),
                          ),
                        ),
                        HTText(
                          '${currMonth.year} ${DateFormat.MMMM().format(currMonth)}',
                          typoToken: HTTypoToken.headlineSmall,
                          color: htGreys(context).black,
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
                              color: isAfter
                                  ? htGreys(context).grey030
                                  : htGreys(context).grey060,
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
                    color: htGreys(context).grey040,
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
    AppBloc appBloc = context.read<AppBloc>();

    return SizedBox(
      height: 86,
      child: StreamBuilder<List>(
          stream: Rx.combineLatestList([
            taskDetailBloc.currDate,
            taskDetailBloc.doneDates,
            taskDetailBloc.taskObj,
            taskDetailBloc.timerDates,
            appBloc.settings,
          ]),
          builder: (context, snapshot) {
            Task task = snapshot.data?[2] ?? taskDetailBloc.task;

            Settings settings = snapshot.data?[4] ?? Settings();
            if (settings.isDarkMode && task.color == 0xFF000000) {
              task.color = 0xFFFFFFFF;
            }

            DateTime now = DateTime.now().getDate();
            DateTime currDate = htMostRecentWeekday(snapshot.data?[0] ?? now);
            DateTime firstDay = htMostRecentWeekday(currDate);
            int lastDate = getLastDateOfMonth(currDate);

            List<int> doneDates = snapshot.data?[1] ?? [];
            List<int> timerDates = snapshot.data?[3] ?? [];

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
                bool isDone = task.doneAt
                    .where((element) => isSameDay(element, task.from))
                    .isNotEmpty;
                bool isDoneWithTimer = task.doneWithTimer
                    .where((element) => isSameDay(element, task.from))
                    .isNotEmpty;

                bool isLater = task.from.difference(now).inDays >= 0;

                return Column(
                  children: [
                    HTText(
                      htWeekdayToText(task.from.weekday),
                      typoToken: HTTypoToken.captionXSmall,
                      color: htGreys(context).grey050,
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
                                : htGreys(context).grey010,
                            width: 1),
                        color: isDone
                            ? Color(task.color)
                            : isLater
                                ? htGreys(context).white
                                : htGreys(context).grey010,
                      ),
                      child: Center(
                          child: isDone
                              ? Icon(
                                  isDoneWithTimer
                                      ? Icons.timer_rounded
                                      : Icons.check_rounded,
                                  color: htGreys(context).white,
                                  size: 20,
                                )
                              : HTText(
                                  '${task.from.day}',
                                  typoToken: HTTypoToken.subtitleXSmall,
                                  color: htGreys(context).grey040,
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
                            : htGreys(context).white,
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
                    bool isDoneWithTimer = timerDates.contains(day);

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
                          color: htGreys(context).grey050,
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
                                    : htGreys(context).grey010,
                                width: 1),
                            color: isDone
                                ? Color(task.color)
                                : isLater
                                    ? htGreys(context).white
                                    : htGreys(context).grey010,
                          ),
                          child: Center(
                              child: isDone
                                  ? Icon(
                                      isDoneWithTimer
                                          ? Icons.timer_rounded
                                          : Icons.check_rounded,
                                      color: htGreys(context).white,
                                      size: 20,
                                    )
                                  : HTText(
                                      '$day',
                                      typoToken: HTTypoToken.subtitleXSmall,
                                      color: htGreys(context).grey040,
                                      height: 1.25,
                                    )),
                        ),
                        HTSpacers.height4,
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color:
                                isToday ? HTColors.red : htGreys(context).white,
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
    AppBloc appBloc = context.read<AppBloc>();

    return StreamBuilder<List>(
        stream: Rx.combineLatestList([
          taskDetailBloc.currDate,
          taskDetailBloc.taskObj,
          appBloc.settings
        ]),
        builder: (context, snapshot) {
          Task task = snapshot.data?[1] ?? taskDetailBloc.task;

          Settings settings = snapshot.data?[2] ?? Settings();
          if (settings.isDarkMode && task.color == 0xFF000000) {
            task.color = 0xFFFFFFFF;
          }

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
              color: htGreys(context).grey010,
              borderRadius: HTBorderRadius.circular8,
            ),
            child: StreamBuilder<List>(
                stream: Rx.combineLatestList(
                    [taskDetailBloc.doneDates, taskDetailBloc.timerDates]),
                builder: (context, snapshot) {
                  List<int> doneDates = snapshot.data?[0] ?? [];
                  List<int> timerDates = snapshot.data?[1] ?? [];

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

                      int dateInCalendar = index - fillDays + firstDayOfWeek;

                      bool inSameMonth = htIsSameMonth(currMonth, now);

                      bool isDone = doneDates.contains(index - fillDays + 1);
                      bool isDoneWithTimer =
                          timerDates.contains(index - fillDays + 1);

                      bool isOld = task.until != null &&
                          task.until!.isBefore(DateTime(
                              currMonth.year, currMonth.month, dateInCalendar));

                      bool isLater = (inSameMonth && index > todayDateInCal) ||
                          (!inSameMonth &&
                              DateTime(currMonth.year, currMonth.month)
                                  .isAfter(DateTime(now.year, now.month)));

                      bool notInRange = !repeatToday ||
                          DateTime(currMonth.year, currMonth.month,
                                  dateInCalendar)
                              .isBefore(task.from) ||
                          isOld;

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
                                    ? htGreys(context).white
                                    : Color(task.color).withOpacity(0.2),
                            borderRadius: HTBorderRadius.circular8,
                          ),
                          child: isDone && isDoneWithTimer
                              ? Center(
                                  child: Icon(
                                    Icons.timer_rounded,
                                    color: htGreys(context).white,
                                    size: 18,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        );
                      }

                      // fill days
                      if (index < fillDays) {
                        return Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: htGreys(context).grey010,
                            borderRadius: HTBorderRadius.circular8,
                          ),
                        );
                      }

                      if (notInRange) {
                        return Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: htGreys(context).white.withOpacity(0.5),
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
                                  ? htGreys(context).white
                                  : Color(task.color).withOpacity(0.2),
                          borderRadius: HTBorderRadius.circular8,
                        ),
                        child: isDone && isDoneWithTimer
                            ? Center(
                                child: Icon(
                                  Icons.timer_rounded,
                                  color: htGreys(context).white,
                                  size: 18,
                                ),
                              )
                            : const SizedBox.shrink(),
                      );
                    },
                    itemCount: daysCount,
                  );
                }),
          );
        });
  }
}

class TaskDetailRepeat extends StatelessWidget {
  const TaskDetailRepeat({super.key});

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
                HTText(
                  'Repeat',
                  typoToken: HTTypoToken.captionMedium,
                  color: htGreys(context).grey050,
                ),
                HTSpacers.height12,
                Container(
                  padding: HTEdgeInsets.h16v12,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: htGreys(context).grey010, width: 1),
                    borderRadius: HTBorderRadius.circular10,
                  ),
                  child: HTText(
                    '\u2022  ${htRepeatAtToText(task.repeatAt)}',
                    typoToken: HTTypoToken.captionMedium,
                    color: htGreys(context).black,
                  ),
                ),
                HTSpacers.height12,
                Container(
                  padding: HTEdgeInsets.h16v12,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: htGreys(context).grey010, width: 1),
                    borderRadius: HTBorderRadius.circular10,
                  ),
                  child: HTText(
                    '\u2022  From ${DateFormat('yyyy.MM.dd').format(task.from)}',
                    typoToken: HTTypoToken.captionMedium,
                    color: htGreys(context).black,
                  ),
                ),
                HTSpacers.height12,
                Container(
                  padding: HTEdgeInsets.h16v12,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: htGreys(context).grey010, width: 1),
                    borderRadius: HTBorderRadius.circular10,
                  ),
                  child: HTText(
                    '\u2022  ${htUntilToText(task.until, long: true)}',
                    typoToken: HTTypoToken.captionMedium,
                    color: htGreys(context).black,
                  ),
                ),
                HTSpacers.height24,
              ],
            ),
          );
        });
  }
}

class TaskDetailAlarm extends StatelessWidget {
  const TaskDetailAlarm({super.key});

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
                HTText(
                  'Alarm',
                  typoToken: HTTypoToken.captionMedium,
                  color: htGreys(context).grey050,
                ),
                HTSpacers.height12,
                Container(
                  padding: HTEdgeInsets.h16v12,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: htGreys(context).grey010, width: 1),
                    borderRadius: HTBorderRadius.circular10,
                  ),
                  child: HTText(
                    '\u2022  ${task.alarmTime == null ? 'Never' : (DateFormat.jm().format(task.alarmTime!))}',
                    typoToken: HTTypoToken.captionMedium,
                    color: htGreys(context).black,
                  ),
                ),
              ],
            ),
          );
        });
  }
}

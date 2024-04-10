import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_app/blocs/app_service.dart';
import 'package:habit_app/blocs/base/task_bloc.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/pages/task/task_detail_page.dart';
import 'package:habit_app/router.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:habit_app/utils/tutorial.dart';
import 'package:habit_app/widgets/ht_scale.dart';
import 'package:habit_app/widgets/ht_text.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:table_calendar/table_calendar.dart';

class TaskPage extends StatefulWidget {
  final bool showTutorial;
  const TaskPage({super.key, this.showTutorial = false});

  static const routeName = '/calendar';

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  void initState() {
    super.initState();

    if (widget.showTutorial) {
      AppService appService = context.read<AppService>();
      appService.setIsLoading(true);

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Future.delayed(const Duration(seconds: 1), () {
          showTutorial(
              appService: appService, firstTask: appService.tasksValue.first);
          appService.setIsLoading(false);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppService appService = context.read<AppService>();

    return StreamBuilder<bool>(
        stream: appService.isPro,
        builder: (context, snapshot) {
          bool isPro = snapshot.data ?? true;

          return Stack(
            children: [
              const Column(
                children: [
                  TaskAppbar(),
                  TaskBody(),
                ],
              ),
              if (!isPro) const SubscribePopup(),
            ],
          );
        });
  }
}

class TaskBody extends StatelessWidget {
  const TaskBody({super.key});

  @override
  Widget build(BuildContext context) {
    TaskBloc bloc = context.read<TaskBloc>();

    return StreamBuilder<List>(
      stream: Rx.combineLatestList([bloc.tabIndex]),
      builder: (context, snapshot) {
        int tabIndex = snapshot.data?[0] ?? 0;

        if (tabIndex == 0) {
          return const Expanded(
            child: Column(
              children: [
                DailyDates(),
                DailyTaskList(),
              ],
            ),
          );
        } else {
          return const AllTaskList();
        }
      },
    );
  }
}

class TaskAppbar extends StatelessWidget {
  const TaskAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    TaskBloc bloc = context.read<TaskBloc>();

    return StreamBuilder<int>(
        stream: bloc.tabIndex,
        builder: (context, snapshot) {
          int tabIndex = snapshot.data ?? 0;

          bool isCalView = tabIndex == 0;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
            child: Row(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            bloc.setTabIndex(0);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 4),
                            child: HTText(
                              'Calendar',
                              typoToken: isCalView
                                  ? HTTypoToken.headlineSmall
                                  : HTTypoToken.bodyXXLarge,
                              color: isCalView
                                  ? htGreys(context).black
                                  : htGreys(context).grey040,
                            ),
                          ),
                        ),
                        HTSpacers.width16,
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            bloc.setTabIndex(1);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 4),
                            child: HTText(
                              'All Task',
                              typoToken: isCalView
                                  ? HTTypoToken.bodyXXLarge
                                  : HTTypoToken.headlineSmall,
                              color: isCalView
                                  ? htGreys(context).grey040
                                  : htGreys(context).black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        const SizedBox(
                          height: 3,
                          width: 208,
                        ),
                        AnimatedPositioned(
                          left: isCalView ? 0 : 114,
                          duration: const Duration(milliseconds: 200),
                          child: Container(
                            height: 3,
                            width: isCalView ? 108 : 100,
                            color: htGreys(context).black,
                          ),
                        ),
                      ],
                    ),
                  ],
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
          );
        });
  }
}

class DailyDates extends StatelessWidget {
  const DailyDates({super.key});

  @override
  Widget build(BuildContext context) {
    TaskBloc bloc = context.read<TaskBloc>();

    return StreamBuilder<List>(
        stream: Rx.combineLatestList([bloc.dateIndex, bloc.dates]),
        builder: (context, snapshot) {
          int dateIndex = snapshot.data?[0] ?? 0;
          List<DateTime> dates = snapshot.data?[1] ?? bloc.getDates();

          DateTime today = DateTime.now().getDate();

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
                    controller: bloc.dateScrollController,
                    scrollDirection: Axis.horizontal,
                    padding: HTEdgeInsets.horizontal16,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      DateTime date = dates[index];
                      bool isSelected = index == dateIndex;

                      double donePercentage = 0;
                      if (isSameDay(today, date) || today.isAfter(date)) {
                        donePercentage = bloc.getDonePercentage(date);
                      }

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
                              bloc.setDateIndex(index);
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: dateSize,
                                  height: dateSize,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
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
                                SizedBox(
                                  width: dateSize,
                                  height: dateSize,
                                  child: CircularProgressIndicator(
                                    value: donePercentage,
                                    color: donePercentage == 1
                                        ? htGreys(context).grey050
                                        : htGreys(context).grey030,
                                    strokeWidth: 1,
                                  ),
                                ),
                                if (isSameDay(today, date))
                                  Positioned.fill(
                                    bottom: 5,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        width: 4,
                                        height: 4,
                                        decoration: const BoxDecoration(
                                          color: HTColors.red,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return HTSpacers.width12;
                    },
                    itemCount: dates.length),
                StreamBuilder<int>(
                    stream: bloc.notToday,
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
                              bloc.scrollToToday();
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
                    stream: bloc.notToday,
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
                              bloc.scrollToToday();
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

class EmptyTaskList extends StatelessWidget {
  const EmptyTaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/lotties/calendar.json', width: 120),
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
}

class AllTaskList extends StatelessWidget {
  const AllTaskList({super.key});

  @override
  Widget build(BuildContext context) {
    AppService appService = context.read<AppService>();

    return Expanded(
      child: Container(
        color: htGreys(context).grey010,
        child: StreamBuilder<List>(
            stream: Rx.combineLatestList([appService.tasks, appService.isPro]),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              List<Task> tasks = snapshot.data?[0] ?? [];
              bool isPro = snapshot.data?[1] ?? true;

              if (tasks.isEmpty) {
                return const EmptyTaskList();
              }

              List<Task> activeTasks = tasks.toList();

              activeTasks.sort((a, b) => -a.from.compareTo(b.from));
              List<Task> oldTasks = activeTasks
                  .where((element) =>
                      element.until != null &&
                      element.until!.isBefore(DateTime.now().getDate()))
                  .toList();
              for (Task task in oldTasks) {
                activeTasks.remove(task);
              }
              tasks = activeTasks + oldTasks;

              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20)
                        .copyWith(bottom: isPro ? 20 : 142),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: HTEdgeInsets.horizontal8,
                      child: HTText(
                        '${tasks.length} Task${tasks.length > 1 ? 's' : ''}',
                        typoToken: HTTypoToken.captionSmall,
                        color: htGreys(context).grey040,
                      ),
                    ),
                    HTSpacers.height8,
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          Task task = tasks[index];

                          return TaskBox(
                            task: task,
                            disabled: true,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return HTSpacers.height8;
                        },
                        itemCount: tasks.length)
                  ],
                ),
              );
            }),
      ),
    );
  }
}

class DailyTaskList extends StatelessWidget {
  const DailyTaskList({super.key});

  @override
  Widget build(BuildContext context) {
    TaskBloc bloc = context.read<TaskBloc>();
    AppService appService = context.read<AppService>();

    return Expanded(
      child: Container(
        color: htGreys(context).grey010,
        child: StreamBuilder<List>(
            stream: Rx.combineLatestList(
                [bloc.currTasks, bloc.dateIndex, bloc.dates, appService.isPro]),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              List<Task> currTasks = snapshot.data?[0] ?? [];
              int dateIndex = snapshot.data?[1] ?? 0;
              List<DateTime> dates = snapshot.data?[2] ?? bloc.getDates();
              bool isPro = snapshot.data?[3] ?? true;

              DateTime currDate = dates[dateIndex];
              List<Task> doneTasks = currTasks
                  .where((element) => htIsDone(currDate, element.doneAt))
                  .toList();

              if (currTasks.isEmpty) {
                return const EmptyTaskList();
              }

              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20)
                        .copyWith(bottom: isPro ? 20 : 142),
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

                        DateTime today = DateTime.now().getDate();

                        return TaskBox(
                          key: index == 0 ? firstTaskKey : null,
                          task: task,
                          disabled: !isSameDay(today, currDate) &&
                              today.isBefore(currDate.getDate()),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return HTSpacers.height8;
                      },
                      itemCount: currTasks.length,
                    )
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
  final bool disabled;
  const TaskBox({
    super.key,
    required this.task,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    AppService appService = context.read<AppService>();
    TaskBloc bloc = context.read<TaskBloc>();

    DateTime today = DateTime.now().getDate();

    bool isOld = disabled && task.until != null && task.until!.isBefore(today);

    return HTScale(
      onTap: () {
        context.push(TaskDetailPage.routeName, extra: task);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
            color: isOld ? htGreys(context).grey020 : htGreys(context).white,
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
                  color:
                      isOld ? htGreys(context).grey050 : htGreys(context).black,
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
            if (!disabled)
              StreamBuilder<List>(
                  stream: Rx.combineLatestList([bloc.dateIndex, bloc.dates]),
                  builder: (context, snapshot) {
                    int dateIndex = snapshot.data?[0] ?? 0;
                    List<DateTime> dates = snapshot.data?[1] ?? bloc.getDates();

                    DateTime date = dates[dateIndex];
                    bool isDone = appService.isDone(task, date);

                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        appService.toggleTask(task, date);
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

class SubscribePopup extends StatelessWidget {
  const SubscribePopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      bottom: 24,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: () {
            pushSubscriptionPage();
          },
          child: Container(
            height: 96,
            margin: HTEdgeInsets.horizontal24,
            decoration: BoxDecoration(
              color: htGreys(context).black,
              borderRadius: HTBorderRadius.circular10,
              boxShadow: [
                BoxShadow(
                  color: htGreys(context).black.withOpacity(0.2),
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Row(
              children: [
                HTSpacers.width20,
                Padding(
                  padding: const EdgeInsets.only(bottom: 22),
                  child: HTText(
                    '🤩',
                    typoToken: HTTypoToken.subtitleLarge,
                    color: htGreys(context).black,
                  ),
                ),
                HTSpacers.width6,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HTText(
                      'Need additional task?',
                      typoToken: HTTypoToken.subtitleLarge,
                      color: htGreys(context).white,
                    ),
                    HTSpacers.height4,
                    HTText(
                      'Try Pro and get unlimited tasks!',
                      typoToken: HTTypoToken.bodyXXSmall,
                      color: htGreys(context).grey050,
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_forward,
                      color: htGreys(context).white,
                      size: 20,
                    ),
                    HTSpacers.height4,
                    HTText(
                      'Let\'s\nGo',
                      typoToken: HTTypoToken.subtitleXSmall,
                      color: htGreys(context).white,
                      textAlign: TextAlign.center,
                      height: 1.25,
                    ),
                  ],
                ),
                HTSpacers.width16,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

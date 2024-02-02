import 'package:flutter/material.dart';
import 'package:habit_app/blocs/app_bloc.dart';
import 'package:habit_app/blocs/base/daily_bloc.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:habit_app/widgets/ht_text.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
          padding: HTEdgeInsets.h24v16,
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

          return SizedBox(
            height: 52 + 16,
            child: ListView.separated(
                controller: dailyBloc.dateScrollController,
                scrollDirection: Axis.horizontal,
                padding: HTEdgeInsets.horizontal16,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DateTime date = dailyBloc.dates[index];
                  bool isSelected = index == dateIndex;

                  return GestureDetector(
                    onTap: () {
                      dailyBloc.setDateIndex(index);
                    },
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? HTColors.black : HTColors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          HTText(
                            weekdayToText(date.weekday),
                            typoToken: HTTypoToken.captionXSmall,
                            color: HTColors.gray030,
                          ),
                          HTSpacers.height1,
                          HTText(
                            date.day.toString(),
                            typoToken: HTTypoToken.subtitleLarge,
                            color: isSelected ? HTColors.white : HTColors.black,
                            height: 1,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return HTSpacers.width8;
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
    AppBloc appBloc = context.read<AppBloc>();

    return Expanded(
      child: Container(
          color: HTColors.gray010,
          child: SingleChildScrollView(
            padding: HTEdgeInsets.all24,
            child: StreamBuilder<List<Task>>(
                stream: dailyBloc.currTasks,
                builder: (context, snapshot) {
                  List<Task> currTasks = snapshot.data ?? [];

                  return Column(
                    children: [
                      Padding(
                        padding: HTEdgeInsets.horizontal12,
                        child: Row(
                          children: [
                            HTText(
                              '${currTasks.length} Tasks',
                              typoToken: HTTypoToken.captionMedium,
                              color: HTColors.gray040,
                            ),
                            const Spacer(),
                            HTText(
                              '${currTasks.length} Done',
                              typoToken: HTTypoToken.captionMedium,
                              color: HTColors.gray040,
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

                            return Container(
                              width: double.infinity,
                              padding: HTEdgeInsets.h24v16,
                              decoration: BoxDecoration(
                                  color: HTColors.white,
                                  borderRadius: HTBorderRadius.circular12),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (task.emoji != null)
                                        HTText(
                                          task.emoji!,
                                          typoToken: HTTypoToken.captionLarge,
                                          color: HTColors.black,
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
                                                'until ${DateFormat.yMd().format(task.until!)} ㆍ ',
                                                typoToken:
                                                    HTTypoToken.captionSmall,
                                                color: HTColors.gray040,
                                              ),
                                            HTText(
                                              repeatAtToText(task.repeatAt),
                                              typoToken:
                                                  HTTypoToken.captionSmall,
                                              color: HTColors.gray040,
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
                                        DateTime date =
                                            dailyBloc.dates[dateIndex];
                                        bool isDone =
                                            appBloc.isDone(task, date);

                                        return GestureDetector(
                                          onTap: () {
                                            appBloc.toggleTask(task, date);
                                          },
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.check_circle_rounded,
                                                color: isDone
                                                    ? HTColors.black
                                                    : HTColors.gray030,
                                              ),
                                              HTText(
                                                'Done',
                                                typoToken:
                                                    HTTypoToken.headlineXXSmall,
                                                color: isDone
                                                    ? HTColors.black
                                                    : HTColors.gray030,
                                              )
                                            ],
                                          ),
                                        );
                                      })
                                ],
                              ),
                            );
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

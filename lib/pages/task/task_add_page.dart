import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_app/blocs/task/task_add_bloc.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:habit_app/widgets/ht_text.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class TaskAddWidget extends StatelessWidget {
  const TaskAddWidget({super.key});

  @override
  Widget build(BuildContext context) {
    TaskAddBloc taskAddBloc = context.read<TaskAddBloc>();

    double mainHeight = MediaQuery.sizeOf(context).height * 0.92;

    return SizedBox(
      height: mainHeight + 12,
      child: Column(
        children: [
          Container(
            height: 12,
            width: MediaQuery.sizeOf(context).width * 0.9,
            decoration: const BoxDecoration(
              color: HTColors.white50,
              borderRadius: HTBorderRadius.top40,
            ),
          ),
          Container(
            height: mainHeight,
            decoration: const BoxDecoration(
              color: HTColors.white,
              borderRadius: HTBorderRadius.top24,
            ),
            child: const TaskAddBody(),
          ),
        ],
      ),
    );
  }
}

class TaskAddBody extends StatelessWidget {
  const TaskAddBody({super.key});

  @override
  Widget build(BuildContext context) {
    TaskAddBloc taskAddBloc = context.read<TaskAddBloc>();

    return Column(
      children: [
        HTSpacers.height8,
        const TaskAddClose(),
        Expanded(
          child: SingleChildScrollView(
            padding: HTEdgeInsets.h24v16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: HTEdgeInsets.all8,
                    decoration: BoxDecoration(
                      color: HTColors.grey010,
                      borderRadius: HTBorderRadius.circular10,
                    ),
                    child: const Icon(
                      Icons.emoji_emotions_rounded,
                      color: HTColors.grey030,
                      size: 32,
                    ),
                  ),
                ),
                HTSpacers.height8,
                Stack(
                  children: [
                    TextField(
                      controller: taskAddBloc.titleController,
                      onChanged: (value) => taskAddBloc.setTitle(value),
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      style: HTTypoToken.headlineSmall.textStyle,
                      maxLength: 30,
                      decoration: const InputDecoration(counterText: ''),
                    ),
                    Positioned.fill(
                      right: 16,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: StreamBuilder<String>(
                            stream: taskAddBloc.title,
                            builder: (context, snapshot) {
                              String title = snapshot.data ?? '';

                              return HTText(
                                '${title.length}/30',
                                typoToken: HTTypoToken.captionMedium,
                                color: HTColors.grey040,
                              );
                            }),
                      ),
                    ),
                  ],
                ),
                HTSpacers.height10,
                TextField(
                  controller: taskAddBloc.goalController,
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  style:
                      HTTypoToken.subtitleSmall.textStyle.copyWith(height: 1),
                  decoration: const InputDecoration(
                      labelText: 'Goal',
                      hintText: 'Goal',
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
                HTSpacers.height24,
                const TaskAddRepeatAt(),
                HTSpacers.height24,
                const TaskAddFrom(),
                HTSpacers.height24,
                const TaskAddUntil(),
                HTSpacers.height48,
                ElevatedButton(
                    onPressed: () {
                      taskAddBloc.addTask();
                      context.pop();
                    },
                    child: const Text('Add Task')),
                HTSpacers.width48,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TaskAddClose extends StatelessWidget {
  const TaskAddClose({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        height: 56,
        child: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Container(
            width: 28,
            height: 28,
            margin: HTEdgeInsets.horizontal16,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: HTColors.grey040,
            ),
            child: const Icon(
              Icons.close_rounded,
              color: HTColors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class TaskAddRepeatAt extends StatelessWidget {
  const TaskAddRepeatAt({super.key});

  @override
  Widget build(BuildContext context) {
    TaskAddBloc taskAddBloc = context.read<TaskAddBloc>();

    double size = (MediaQuery.sizeOf(context).width - 48 - 48) / 7;

    return StreamBuilder<List<int>>(
        stream: taskAddBloc.repeatAt,
        builder: (context, snapshot) {
          List<int> repeatAt = snapshot.data ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const HTText(
                'Repeat At',
                typoToken: HTTypoToken.subtitleMedium,
                color: HTColors.black,
              ),
              HTSpacers.height8,
              SizedBox(
                height: size,
                child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    padding: HTEdgeInsets.zero,
                    itemBuilder: (context, index) {
                      bool isSelected = repeatAt.contains(dayNums[index]);

                      return GestureDetector(
                        onTap: () {
                          taskAddBloc.toggleRepeatAt(dayNums[index]);
                        },
                        child: Container(
                          width: size,
                          height: size,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: isSelected
                                    ? HTColors.black
                                    : HTColors.grey020,
                                width: 1),
                            color: isSelected ? HTColors.black : HTColors.white,
                          ),
                          child: Center(
                              child: HTText(
                            days[index],
                            typoToken: HTTypoToken.subtitleXSmall,
                            color:
                                isSelected ? HTColors.white : HTColors.grey040,
                            height: 1.25,
                          )),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return HTSpacers.width8;
                    },
                    itemCount: 7),
              ),
              HTSpacers.height12,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      taskAddBloc.setRepeatAt([1, 2, 3, 4, 5, 6, 7]);
                    },
                    child: Container(
                      padding: HTEdgeInsets.h16v12,
                      decoration: BoxDecoration(
                        color: repeatAt.length == 7
                            ? HTColors.black
                            : HTColors.white,
                        border: Border.all(color: HTColors.grey020),
                        borderRadius: HTBorderRadius.circularMax,
                      ),
                      child: HTText(
                        'Everyday',
                        typoToken: HTTypoToken.subtitleXSmall,
                        color: repeatAt.length == 7
                            ? HTColors.white
                            : HTColors.grey060,
                        height: 1,
                      ),
                    ),
                  ),
                  HTSpacers.width8,
                  GestureDetector(
                    onTap: () {
                      taskAddBloc.setRepeatAt([1, 2, 3, 4, 5]);
                    },
                    child: Container(
                      padding: HTEdgeInsets.h16v12,
                      decoration: BoxDecoration(
                        color: repeatAtToText(repeatAt) == 'Weekday'
                            ? HTColors.black
                            : HTColors.white,
                        border: Border.all(color: HTColors.grey020),
                        borderRadius: HTBorderRadius.circularMax,
                      ),
                      child: HTText(
                        'Weekday',
                        typoToken: HTTypoToken.subtitleXSmall,
                        color: repeatAtToText(repeatAt) == 'Weekday'
                            ? HTColors.white
                            : HTColors.grey060,
                        height: 1,
                      ),
                    ),
                  ),
                  HTSpacers.width8,
                  GestureDetector(
                    onTap: () {
                      taskAddBloc.setRepeatAt([6, 7]);
                    },
                    child: Container(
                      padding: HTEdgeInsets.h16v12,
                      decoration: BoxDecoration(
                        color: repeatAtToText(repeatAt) == 'Weekend'
                            ? HTColors.black
                            : HTColors.white,
                        border: Border.all(color: HTColors.grey020),
                        borderRadius: HTBorderRadius.circularMax,
                      ),
                      child: HTText(
                        'Weekend',
                        typoToken: HTTypoToken.subtitleXSmall,
                        color: repeatAtToText(repeatAt) == 'Weekend'
                            ? HTColors.white
                            : HTColors.grey060,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }
}

class TaskAddFrom extends StatelessWidget {
  const TaskAddFrom({super.key});

  @override
  Widget build(BuildContext context) {
    TaskAddBloc taskAddBloc = context.read<TaskAddBloc>();

    return StreamBuilder<DateTime>(
        stream: taskAddBloc.from,
        builder: (context, snapshot) {
          DateTime from = snapshot.data ?? DateTime.now().getDate();

          return Row(
            children: [
              const SizedBox(
                width: 40,
                child: HTText(
                  'From',
                  typoToken: HTTypoToken.subtitleMedium,
                  color: HTColors.black,
                ),
              ),
              HTSpacers.width12,
              GestureDetector(
                onTap: () {
                  showDatePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2101))
                      .then((value) {
                    if (value != null) {
                      taskAddBloc.setFrom(value);
                    }
                  });
                },
                child: HTText(
                  DateFormat('yyyy.MM.dd (E)').format(from),
                  typoToken: HTTypoToken.subtitleMedium,
                  color: HTColors.grey040,
                ),
              )
            ],
          );
        });
  }
}

class TaskAddUntil extends StatelessWidget {
  const TaskAddUntil({super.key});

  @override
  Widget build(BuildContext context) {
    TaskAddBloc taskAddBloc = context.read<TaskAddBloc>();

    DateTime today = DateTime.now().getDate();

    return StreamBuilder<List>(
        stream: Rx.combineLatestList([taskAddBloc.until, taskAddBloc.from]),
        builder: (context, snapshot) {
          DateTime? until = snapshot.data?[0];
          DateTime from = snapshot.data?[1] ?? today;

          if (until != null && until.isBefore(from)) {
            taskAddBloc.setUntil(null);
          }

          return Row(
            children: [
              const SizedBox(
                width: 40,
                child: HTText(
                  'Until',
                  typoToken: HTTypoToken.subtitleMedium,
                  color: HTColors.black,
                ),
              ),
              HTSpacers.width12,
              GestureDetector(
                onTap: () {
                  showDatePicker(
                          context: context,
                          firstDate: from,
                          lastDate: DateTime(2101))
                      .then((value) => taskAddBloc.setUntil(value));
                },
                child: HTText(
                  until != null
                      ? DateFormat('yyyy.MM.dd (E)').format(until)
                      : 'Forever',
                  typoToken: HTTypoToken.subtitleMedium,
                  color: HTColors.grey040,
                ),
              )
            ],
          );
        });
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_app/blocs/task/task_add_bloc.dart';
import 'package:habit_app/pages/task/task_detail_page.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/effects.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/utils/emojis.dart';
import 'package:habit_app/utils/enums.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:habit_app/widgets/ht_bottom_modal.dart';
import 'package:habit_app/widgets/ht_radio.dart';
import 'package:habit_app/widgets/ht_text.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class TaskAddWidget extends StatelessWidget {
  const TaskAddWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const HTBottomModal(child: TaskAddBody());
  }
}

class TaskAddBody extends StatelessWidget {
  const TaskAddBody({super.key});

  @override
  Widget build(BuildContext context) {
    TaskAddBloc taskAddBloc = context.read<TaskAddBloc>();

    return Stack(
      children: [
        Column(
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
                      onTap: () {
                        taskAddBloc.toggleOpenEmoji();
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: HTColors.grey010,
                          borderRadius: HTBorderRadius.circular10,
                        ),
                        child: StreamBuilder<String>(
                            stream: taskAddBloc.emoji,
                            builder: (context, snapshot) {
                              String emoji = snapshot.data ?? '';

                              if (emoji.isEmpty) {
                                return const Icon(
                                  Icons.emoji_emotions_rounded,
                                  color: HTColors.grey030,
                                  size: 32,
                                );
                              } else {
                                return Center(
                                    child: Text(
                                  emoji,
                                  style: const TextStyle(fontSize: 28),
                                ));
                              }
                            }),
                      ),
                    ),
                    HTSpacers.height8,
                    const TaskAddTitle(),
                    HTSpacers.height10,
                    const TaskAddGoal(),
                    HTSpacers.height24,
                    const TaskAddRepeatAt(),
                    const TaskAddFrom(),
                    const TaskAddUntil(),
                    HTSpacers.height48,
                    const TaskAddSubmit(),
                    HTSpacers.height48,
                  ],
                ),
              ),
            ),
          ],
        ),
        StreamBuilder<bool>(
            stream: taskAddBloc.openEmoji,
            builder: (context, snapshot) {
              bool openEmoji = snapshot.data ?? false;

              if (openEmoji) {
                return const TaskAddEmojiPicker();
              } else {
                return const SizedBox.shrink();
              }
            }),
      ],
    );
  }
}

class TaskAddEmojiPicker extends StatelessWidget {
  const TaskAddEmojiPicker({super.key});

  @override
  Widget build(BuildContext context) {
    TaskAddBloc taskAddBloc = context.read<TaskAddBloc>();

    return Positioned(
      top: 128,
      left: 24,
      child: Container(
        decoration: BoxDecoration(
          color: HTColors.white,
          borderRadius: HTBorderRadius.circular10,
          boxShadow: HTBoxShadows.shadows01,
        ),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width - 48,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.7,
                child: LayoutBuilder(builder: (context, constraints) {
                  int crossAxisCount = 7;
                  double spacing = 12;
                  double emojiSize = (constraints.maxWidth -
                          (spacing * (crossAxisCount - 1))) /
                      crossAxisCount;

                  ScrollController emojiScrollController = ScrollController();

                  return RawScrollbar(
                    thickness: 6,
                    minThumbLength: 80,
                    thumbColor: HTColors.grey020,
                    radius: const Radius.circular(10),
                    controller: emojiScrollController,
                    child: GridView.builder(
                      controller: emojiScrollController,
                      padding: HTEdgeInsets.all16,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: spacing,
                          crossAxisSpacing: spacing,
                          childAspectRatio: 1),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            taskAddBloc.setEmoji(allEmojis[index]);
                            taskAddBloc.setOpenEmoji(false);
                          },
                          child: SizedBox(
                            width: emojiSize,
                            height: emojiSize,
                            child: Center(
                              child: Text(
                                allEmojis[index],
                                style: TextStyle(
                                    fontSize: emojiSize * 0.8, height: 1),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: allEmojis.length,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
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
            Navigator.pop(context);
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

class TaskAddTitle extends StatefulWidget {
  const TaskAddTitle({super.key});

  @override
  State<TaskAddTitle> createState() => _TaskAddTitleState();
}

class _TaskAddTitleState extends State<TaskAddTitle> {
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    TaskAddBloc taskAddBloc = context.read<TaskAddBloc>();

    return Focus(
      child: Stack(
        children: [
          TextField(
            onChanged: (value) => taskAddBloc.setTitle(value),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            style: HTTypoToken.subtitleXLarge.textStyle,
            maxLength: 30,
            decoration: const InputDecoration(
              counterText: '',
              suffix: SizedBox(
                width: 48,
              ),
            ),
          ),
          if (_hasFocus)
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
      onFocusChange: (value) {
        setState(() {
          _hasFocus = value;
        });
      },
    );
  }
}

class TaskAddGoal extends StatefulWidget {
  const TaskAddGoal({super.key});

  @override
  State<TaskAddGoal> createState() => _TaskAddGoalState();
}

class _TaskAddGoalState extends State<TaskAddGoal> {
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    TaskAddBloc taskAddBloc = context.read<TaskAddBloc>();

    return Focus(
      child: Stack(
        children: [
          TextField(
            onChanged: (value) => taskAddBloc.setGoal(value),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            style: HTTypoToken.bodyMedium.textStyle
                .copyWith(color: HTColors.black),
            maxLength: 100,
            maxLines: 7,
            minLines: 7,
            decoration: const InputDecoration(counterText: ''),
          ),
          if (_hasFocus)
            Positioned(
              bottom: 12,
              right: 12,
              child: StreamBuilder<String>(
                  stream: taskAddBloc.goal,
                  builder: (context, snapshot) {
                    String goal = snapshot.data ?? '';

                    return HTText(
                      '${goal.length}/100',
                      typoToken: HTTypoToken.captionMedium,
                      color: HTColors.grey040,
                    );
                  }),
            )
        ],
      ),
      onFocusChange: (value) {
        setState(() {
          _hasFocus = value;
        });
      },
    );
  }
}

class TaskAddRepeatAt extends StatelessWidget {
  const TaskAddRepeatAt({super.key});

  @override
  Widget build(BuildContext context) {
    TaskAddBloc taskAddBloc = context.read<TaskAddBloc>();

    return StreamBuilder<bool>(
        stream: taskAddBloc.isRepeat,
        builder: (context, snapshot) {
          bool isRepeat = snapshot.data ?? false;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 56,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const HTText(
                      'Repeat',
                      typoToken: HTTypoToken.subtitleXLarge,
                      color: HTColors.black,
                      height: 1,
                    ),
                    CupertinoSwitch(
                        value: isRepeat,
                        activeColor: HTColors.black,
                        onChanged: (value) => taskAddBloc.setIsRepeat(value)),
                  ],
                ),
              ),
              if (isRepeat)
                StreamBuilder<List>(
                    stream: Rx.combineLatestList(
                        [taskAddBloc.repeatAt, taskAddBloc.repeatType]),
                    builder: (context, snapshot) {
                      List<int> repeatAt = snapshot.data?[0] ?? [];
                      RepeatType repeatType =
                          snapshot.data?[1] ?? RepeatType.everyday;

                      return Container(
                        margin: HTEdgeInsets.bottom16,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: HTColors.grey010,
                          borderRadius: HTBorderRadius.circular10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HTRadio(
                                value: RepeatType.everyday,
                                groupValue: repeatType,
                                text: 'Everyday',
                                padding: HTEdgeInsets.vertical8,
                                onTap: () {
                                  taskAddBloc
                                      .setRepeatType(RepeatType.everyday);
                                  taskAddBloc
                                      .setRepeatAt([1, 2, 3, 4, 5, 6, 7]);
                                }),
                            HTRadio(
                                value: RepeatType.weekday,
                                groupValue: repeatType,
                                text: 'Weekday',
                                padding: HTEdgeInsets.vertical8,
                                onTap: () {
                                  taskAddBloc.setRepeatType(RepeatType.weekday);
                                  taskAddBloc.setRepeatAt([1, 2, 3, 4, 5]);
                                }),
                            HTRadio(
                                value: RepeatType.weekend,
                                groupValue: repeatType,
                                text: 'Weekend',
                                padding: HTEdgeInsets.vertical8,
                                onTap: () {
                                  taskAddBloc.setRepeatType(RepeatType.weekend);
                                  taskAddBloc.setRepeatAt([6, 7]);
                                }),
                            HTRadio(
                                value: RepeatType.custom,
                                groupValue: repeatType,
                                text: 'Custom',
                                padding: HTEdgeInsets.vertical8,
                                onTap: () {
                                  taskAddBloc.setRepeatType(RepeatType.custom);
                                  taskAddBloc.setRepeatAt([1, 3, 5]);
                                }),
                            if (repeatType == RepeatType.custom)
                              LayoutBuilder(builder: (context, constraints) {
                                double size =
                                    (constraints.maxWidth - (8 * 6)) / 7;

                                return Container(
                                  height: size,
                                  margin: HTEdgeInsets.vertical8,
                                  child: ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      padding: HTEdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        bool isSelected =
                                            repeatAt.contains(dayNums[index]);

                                        return GestureDetector(
                                          onTap: () {
                                            taskAddBloc
                                                .toggleRepeatAt(dayNums[index]);
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
                                              color: isSelected
                                                  ? HTColors.black
                                                  : HTColors.clear,
                                            ),
                                            child: Center(
                                                child: HTText(
                                              days[index],
                                              typoToken: isSelected
                                                  ? HTTypoToken.subtitleXSmall
                                                  : HTTypoToken.bodyXSmall,
                                              color: isSelected
                                                  ? HTColors.white
                                                  : HTColors.grey060,
                                              height: 1.25,
                                            )),
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return HTSpacers.width8;
                                      },
                                      itemCount: 7),
                                );
                              }),
                          ],
                        ),
                      );
                    }),
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

    return SizedBox(
      height: 56,
      child: StreamBuilder<DateTime>(
          stream: taskAddBloc.from,
          builder: (context, snapshot) {
            DateTime from = snapshot.data ?? DateTime.now().getDate();

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const HTText(
                  'Start Date',
                  typoToken: HTTypoToken.subtitleXLarge,
                  color: HTColors.black,
                  height: 1,
                ),
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
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: HTColors.grey010,
                      borderRadius: HTBorderRadius.circular10,
                    ),
                    child: HTText(
                      DateFormat('yyyy.MM.dd').format(from) +
                          (isSameDay(from, DateTime.now())
                              ? ' (Today)'
                              : DateFormat(' (E)').format(from)),
                      typoToken: HTTypoToken.bodyMedium,
                      color: HTColors.black,
                      height: 1.2,
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }
}

class TaskAddUntil extends StatelessWidget {
  const TaskAddUntil({super.key});

  @override
  Widget build(BuildContext context) {
    TaskAddBloc taskAddBloc = context.read<TaskAddBloc>();

    DateTime today = DateTime.now().getDate();

    return SizedBox(
      height: 56,
      child: StreamBuilder<List>(
          stream: Rx.combineLatestList([taskAddBloc.until, taskAddBloc.from]),
          builder: (context, snapshot) {
            DateTime? until = snapshot.data?[0];
            DateTime from = snapshot.data?[1] ?? today;

            if (until != null && until.isBefore(from)) {
              taskAddBloc.setUntil(null);
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const HTText(
                  'End Date',
                  typoToken: HTTypoToken.subtitleXLarge,
                  color: HTColors.black,
                  height: 1,
                ),
                CupertinoSwitch(
                    value: until != null,
                    activeColor: HTColors.black,
                    onChanged: (value) {
                      if (value) {
                        taskAddBloc.setUntil(
                            today.getDate().add(const Duration(days: 7)));
                      } else {
                        taskAddBloc.setUntil(null);
                      }
                    }),
                // GestureDetector(
                //   onTap: () {
                //     showDatePicker(
                //             context: context,
                //             firstDate: from,
                //             lastDate: DateTime(2101))
                //         .then((value) => taskAddBloc.setUntil(value));
                //   },
                //   child: HTText(
                //     until != null
                //         ? DateFormat('yyyy.MM.dd (E)').format(until)
                //         : 'Forever',
                //     typoToken: HTTypoToken.subtitleMedium,
                //     color: HTColors.grey040,
                //   ),
                // )
              ],
            );
          }),
    );
  }
}

class TaskAddSubmit extends StatelessWidget {
  const TaskAddSubmit({super.key});

  @override
  Widget build(BuildContext context) {
    TaskAddBloc taskAddBloc = context.read<TaskAddBloc>();

    return StreamBuilder<List>(
        stream: Rx.combineLatestList(
            [taskAddBloc.emoji, taskAddBloc.title, taskAddBloc.goal]),
        builder: (context, snapshot) {
          String emoji = snapshot.data?[0] ?? '';
          String title = snapshot.data?[1] ?? '';
          String goal = snapshot.data?[2] ?? '';

          bool canSubmit =
              emoji.isNotEmpty && title.isNotEmpty && goal.isNotEmpty;

          return SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: HTEdgeInsets.vertical16,
                    shape: RoundedRectangleBorder(
                        borderRadius: HTBorderRadius.circular10)),
                onPressed: canSubmit
                    ? () {
                        taskAddBloc.addTask();

                        context.push(TaskDetailPage.routeName,
                            extra: taskAddBloc.getNewTask());
                        Navigator.pop(context);
                      }
                    : null,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_rounded,
                      color: HTColors.white,
                      size: 24,
                    ),
                    HTSpacers.width4,
                    HTText(
                      'Done',
                      typoToken: HTTypoToken.subtitleXLarge,
                      color: HTColors.white,
                      height: 1.25,
                    ),
                  ],
                )),
          );
        });
  }
}

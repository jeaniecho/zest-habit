import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_app/blocs/task/task_edit_bloc.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/effects.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/utils/emojis.dart';
import 'package:habit_app/utils/enums.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:habit_app/widgets/ht_bottom_modal.dart';
import 'package:habit_app/widgets/ht_calendar.dart';
import 'package:habit_app/widgets/ht_radio.dart';
import 'package:habit_app/widgets/ht_text.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class TaskEditWidget extends StatelessWidget {
  const TaskEditWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const HTBottomModal(child: TaskEditBody());
  }
}

class TaskEditBody extends StatelessWidget {
  const TaskEditBody({super.key});

  @override
  Widget build(BuildContext context) {
    TaskEditBloc taskEditBloc = context.read<TaskEditBloc>();

    return Stack(
      children: [
        const Column(
          children: [
            HTSpacers.height8,
            TaskEditClose(),
            Expanded(
              child: SingleChildScrollView(
                padding: HTEdgeInsets.h24v16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TaskEditEmoji(),
                    HTSpacers.height8,
                    TaskEditTitle(),
                    HTSpacers.height10,
                    TaskEditGoal(),
                    HTSpacers.height24,
                    TaskEditRepeatAt(),
                    TaskEditFrom(),
                    TaskEditUntil(),
                    HTSpacers.height120,
                  ],
                ),
              ),
            ),
            TaskEditSubmit(),
          ],
        ),
        StreamBuilder<bool>(
            stream: taskEditBloc.openEmoji,
            builder: (context, snapshot) {
              bool openEmoji = snapshot.data ?? false;

              if (openEmoji) {
                return const TaskEditEmojiPicker();
              } else {
                return const SizedBox.shrink();
              }
            }),
      ],
    );
  }
}

class TaskEditEmoji extends StatelessWidget {
  const TaskEditEmoji({super.key});

  @override
  Widget build(BuildContext context) {
    TaskEditBloc taskEditBloc = context.read<TaskEditBloc>();

    return InkWell(
      onTap: () {
        taskEditBloc.toggleOpenEmoji();
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: HTColors.grey010,
          borderRadius: HTBorderRadius.circular10,
        ),
        child: StreamBuilder<String>(
            stream: taskEditBloc.emoji,
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
    );
  }
}

class TaskEditEmojiPicker extends StatelessWidget {
  const TaskEditEmojiPicker({super.key});

  @override
  Widget build(BuildContext context) {
    TaskEditBloc taskEditBloc = context.read<TaskEditBloc>();

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
                height: MediaQuery.sizeOf(context).height * 0.6,
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
                            taskEditBloc.setEmoji(allEmojis[index]);
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
              Padding(
                padding: HTEdgeInsets.all16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        taskEditBloc.setOpenEmoji(false);
                      },
                      child: const HTText(
                        'Close',
                        typoToken: HTTypoToken.subtitleLarge,
                        color: HTColors.grey040,
                      ),
                    ),
                    StreamBuilder<String>(
                        stream: taskEditBloc.emoji,
                        builder: (context, snapshot) {
                          String emoji = snapshot.data ?? '';

                          return ElevatedButton(
                            onPressed: emoji.isEmpty
                                ? null
                                : () {
                                    taskEditBloc.setOpenEmoji(false);
                                  },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: HTBorderRadius.circularMax)),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.check_rounded,
                                  color: HTColors.white,
                                  size: 22,
                                ),
                                HTSpacers.width4,
                                HTText(
                                  'Done',
                                  typoToken: HTTypoToken.subtitleXLarge,
                                  color: HTColors.white,
                                  height: 1.1,
                                ),
                              ],
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskEditClose extends StatelessWidget {
  const TaskEditClose({super.key});

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

class TaskEditTitle extends StatefulWidget {
  const TaskEditTitle({super.key});

  @override
  State<TaskEditTitle> createState() => _TaskEditTitleState();
}

class _TaskEditTitleState extends State<TaskEditTitle> {
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    TaskEditBloc taskEditBloc = context.read<TaskEditBloc>();

    return Focus(
      child: Stack(
        children: [
          TextField(
            controller: taskEditBloc.titleController,
            onChanged: (value) => taskEditBloc.setTitle(value),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            style: HTTypoToken.headlineSmall.textStyle,
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
                    stream: taskEditBloc.title,
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

class TaskEditGoal extends StatefulWidget {
  const TaskEditGoal({super.key});

  @override
  State<TaskEditGoal> createState() => _TaskEditGoalState();
}

class _TaskEditGoalState extends State<TaskEditGoal> {
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    TaskEditBloc taskEditBloc = context.read<TaskEditBloc>();

    return Focus(
      child: Stack(
        children: [
          TextField(
            controller: taskEditBloc.goalController,
            onChanged: (value) => taskEditBloc.setGoal(value),
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
                  stream: taskEditBloc.goal,
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

class TaskEditRepeatAt extends StatelessWidget {
  const TaskEditRepeatAt({super.key});

  @override
  Widget build(BuildContext context) {
    TaskEditBloc taskEditBloc = context.read<TaskEditBloc>();

    return StreamBuilder<bool>(
        stream: taskEditBloc.isRepeat,
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
                      typoToken: HTTypoToken.headlineSmall,
                      color: HTColors.black,
                      height: 1,
                    ),
                    CupertinoSwitch(
                        value: isRepeat,
                        activeColor: HTColors.black,
                        onChanged: (value) => taskEditBloc.setIsRepeat(value)),
                  ],
                ),
              ),
              if (isRepeat)
                StreamBuilder<List>(
                    stream: Rx.combineLatestList(
                        [taskEditBloc.repeatAt, taskEditBloc.repeatType]),
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
                                  taskEditBloc
                                      .setRepeatType(RepeatType.everyday);
                                  taskEditBloc
                                      .setRepeatAt([1, 2, 3, 4, 5, 6, 7]);
                                }),
                            HTRadio(
                                value: RepeatType.weekday,
                                groupValue: repeatType,
                                text: 'Weekday',
                                padding: HTEdgeInsets.vertical8,
                                onTap: () {
                                  taskEditBloc
                                      .setRepeatType(RepeatType.weekday);
                                  taskEditBloc.setRepeatAt([1, 2, 3, 4, 5]);
                                }),
                            HTRadio(
                                value: RepeatType.weekend,
                                groupValue: repeatType,
                                text: 'Weekend',
                                padding: HTEdgeInsets.vertical8,
                                onTap: () {
                                  taskEditBloc
                                      .setRepeatType(RepeatType.weekend);
                                  taskEditBloc.setRepeatAt([6, 7]);
                                }),
                            HTRadio(
                                value: RepeatType.custom,
                                groupValue: repeatType,
                                text: 'Custom',
                                padding: HTEdgeInsets.vertical8,
                                onTap: () {
                                  taskEditBloc.setRepeatType(RepeatType.custom);
                                  taskEditBloc.setRepeatAt([1, 3, 5]);
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
                                            taskEditBloc
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

class TaskEditFrom extends StatefulWidget {
  const TaskEditFrom({super.key});

  @override
  State<TaskEditFrom> createState() => _TaskEditFromState();
}

class _TaskEditFromState extends State<TaskEditFrom> {
  bool _showCalendar = false;

  @override
  Widget build(BuildContext context) {
    TaskEditBloc taskEditBloc = context.read<TaskEditBloc>();

    return StreamBuilder<List>(
        stream: Rx.combineLatestList([taskEditBloc.from, taskEditBloc.until]),
        builder: (context, snapshot) {
          DateTime from = snapshot.data?[0] ?? DateTime.now().getDate();
          DateTime? until = snapshot.data?[1];

          return Column(
            children: [
              SizedBox(
                height: 56,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const HTText(
                      'Start Date',
                      typoToken: HTTypoToken.headlineSmall,
                      color: HTColors.black,
                      height: 1,
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _showCalendar = !_showCalendar;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: HTColors.grey010,
                          borderRadius: HTBorderRadius.circular10,
                        ),
                        child: HTText(
                          DateFormat('yyyy.MM.dd').format(from) +
                              (htIsSameDay(from, DateTime.now())
                                  ? ' (Today)'
                                  : DateFormat(' (E)').format(from)),
                          typoToken: HTTypoToken.bodyMedium,
                          color: HTColors.black,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_showCalendar)
                HTCalendar(
                    selectedDate: from,
                    lastDay: until,
                    onSelected: (selectedDay) {
                      taskEditBloc.setFrom(selectedDay.getDate());
                    }),
            ],
          );
        });
  }
}

class TaskEditUntil extends StatefulWidget {
  const TaskEditUntil({super.key});

  @override
  State<TaskEditUntil> createState() => _TaskEditUntilState();
}

class _TaskEditUntilState extends State<TaskEditUntil> {
  bool _showCalendar = true;

  @override
  Widget build(BuildContext context) {
    TaskEditBloc taskEditBloc = context.read<TaskEditBloc>();

    DateTime today = DateTime.now().getDate();

    return StreamBuilder<List>(
        stream: Rx.combineLatestList([taskEditBloc.until, taskEditBloc.from]),
        builder: (context, snapshot) {
          DateTime? until = snapshot.data?[0];
          DateTime from = snapshot.data?[1] ?? today;

          if (until != null && until.isBefore(from)) {
            taskEditBloc.setUntil(null);
          }

          return Column(
            children: [
              SizedBox(
                height: 56,
                child: Row(
                  children: [
                    const HTText(
                      'End Date',
                      typoToken: HTTypoToken.headlineSmall,
                      color: HTColors.black,
                      height: 1,
                    ),
                    const Spacer(),
                    if (until != null)
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            _showCalendar = !_showCalendar;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: HTColors.grey010,
                            borderRadius: HTBorderRadius.circular10,
                          ),
                          child: HTText(
                            DateFormat('yyyy.MM.dd').format(until),
                            typoToken: HTTypoToken.bodyMedium,
                            color: HTColors.black,
                            height: 1.2,
                          ),
                        ),
                      ),
                    HTSpacers.width8,
                    CupertinoSwitch(
                        value: until != null,
                        activeColor: HTColors.black,
                        onChanged: (value) {
                          if (value) {
                            taskEditBloc.setUntil(
                                today.getDate().add(const Duration(days: 7)));

                            if (!taskEditBloc.isRepeatValue) {
                              taskEditBloc.setIsRepeat(true);
                            }
                          } else {
                            taskEditBloc.setUntil(null);
                          }
                        }),
                  ],
                ),
              ),
              if (_showCalendar && until != null)
                HTCalendar(
                    selectedDate: until,
                    firstDay: from,
                    onSelected: (selectedDay) {
                      taskEditBloc.setUntil(selectedDay.getDate());
                    }),
            ],
          );
        });
  }
}

class TaskEditSubmit extends StatelessWidget {
  const TaskEditSubmit({super.key});

  @override
  Widget build(BuildContext context) {
    TaskEditBloc taskEditBloc = context.read<TaskEditBloc>();

    return StreamBuilder<List>(
        stream: Rx.combineLatestList(
            [taskEditBloc.emoji, taskEditBloc.title, taskEditBloc.goal]),
        builder: (context, snapshot) {
          String emoji = snapshot.data?[0] ?? '';
          String title = snapshot.data?[1] ?? '';
          String goal = snapshot.data?[2] ?? '';

          bool canSubmit =
              emoji.isNotEmpty && title.isNotEmpty && goal.isNotEmpty;

          return SafeArea(
            child: Container(
              width: double.infinity,
              padding: HTEdgeInsets.h24v16,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: HTEdgeInsets.vertical16,
                      shape: RoundedRectangleBorder(
                          borderRadius: HTBorderRadius.circular10)),
                  onPressed: canSubmit
                      ? () {
                          taskEditBloc.updateTask();

                          Navigator.pop(context, taskEditBloc.getUpdatedTask());
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
            ),
          );
        });
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_app/blocs/app_bloc.dart';
import 'package:habit_app/blocs/task/task_add_bloc.dart';
import 'package:habit_app/models/settings_model.dart';
import 'package:habit_app/pages/task/task_detail_page.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/utils/emojis.dart';
import 'package:habit_app/utils/enums.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:habit_app/utils/notifications.dart';
import 'package:habit_app/widgets/ht_bottom_modal.dart';
import 'package:habit_app/widgets/ht_calendar.dart';
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
        const Column(
          children: [
            HTSpacers.height8,
            TaskAddClose(),
            Expanded(
              child: SingleChildScrollView(
                padding: HTEdgeInsets.vertical16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: HTEdgeInsets.horizontal24,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TaskAddEmoji(),
                          TaskAddAlarm(),
                        ],
                      ),
                    ),
                    HTSpacers.height8,
                    TaskAddTitle(),
                    HTSpacers.height10,
                    TaskAddGoal(),
                    HTSpacers.height24,
                    TaskAddColor(),
                    HTSpacers.height12,
                    TaskAddRepeatAt(),
                    TaskAddFrom(),
                    TaskAddUntil(),
                    HTSpacers.height120,
                  ],
                ),
              ),
            ),
            TaskAddSubmit(),
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

class TaskAddAlarm extends StatelessWidget {
  const TaskAddAlarm({super.key});

  @override
  Widget build(BuildContext context) {
    TaskAddBloc taskAddBloc = context.read<TaskAddBloc>();

    return StreamBuilder<DateTime?>(
        stream: taskAddBloc.alarmTime,
        builder: (context, snapshot) {
          DateTime? alarmTime = snapshot.data;

          return GestureDetector(
            onTap: () {
              HTNotification.requestNotificationPermission();
              // HTNotification.showNotification();

              DateTime initialDateTime =
                  alarmTime ?? DateTime.now().copyWith(minute: 0);

              taskAddBloc.setAlarmTime(initialDateTime);

              showCupertinoModalPopup(
                  context: context,
                  builder: (context) => Container(
                        padding: HTEdgeInsets.top16,
                        margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        color: htGreys(context).white,
                        child: SafeArea(
                          top: false,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: HTEdgeInsets.horizontal16,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          taskAddBloc.setAlarmTime(null);
                                          Navigator.pop(context);
                                        },
                                        child: HTText(
                                          'Turn Off',
                                          typoToken:
                                              HTTypoToken.buttonTextMedium,
                                          color: htGreys(context).grey060,
                                          height: 1.25,
                                        )),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: HTText(
                                          'Done',
                                          typoToken:
                                              HTTypoToken.buttonTextMedium,
                                          color: htGreys(context).white,
                                          height: 1.25,
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 200,
                                child: CupertinoDatePicker(
                                  initialDateTime: initialDateTime,
                                  mode: CupertinoDatePickerMode.time,
                                  use24hFormat: false,
                                  onDateTimeChanged: (dateTime) {
                                    taskAddBloc.setAlarmTime(dateTime);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ));
            },
            child: Container(
              height: 48,
              padding: HTEdgeInsets.horizontal16,
              decoration: BoxDecoration(
                color: htGreys(context).grey010,
                borderRadius: HTBorderRadius.circular10,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.notifications_rounded,
                    size: 20,
                    color: alarmTime == null
                        ? htGreys(context).grey050
                        : htGreys(context).black,
                  ),
                  HTSpacers.width4,
                  alarmTime == null
                      ? HTText(
                          'Alarm Off',
                          typoToken: HTTypoToken.bodyMedium,
                          color: htGreys(context).grey050,
                          height: 1.25,
                        )
                      : HTText(
                          DateFormat.jm().format(alarmTime),
                          typoToken: HTTypoToken.bodyMedium,
                          color: htGreys(context).black,
                          height: 1.25,
                        ),
                ],
              ),
            ),
          );
        });
  }
}

class TaskAddEmoji extends StatelessWidget {
  const TaskAddEmoji({super.key});

  @override
  Widget build(BuildContext context) {
    TaskAddBloc taskAddBloc = context.read<TaskAddBloc>();

    return GestureDetector(
      onTap: () {
        taskAddBloc.toggleOpenEmoji();
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: htGreys(context).grey010,
          borderRadius: HTBorderRadius.circular10,
        ),
        child: StreamBuilder<String>(
            stream: taskAddBloc.emoji,
            builder: (context, snapshot) {
              String emoji = snapshot.data ?? '';

              if (emoji.isEmpty) {
                return Icon(
                  Icons.emoji_emotions_rounded,
                  color: htGreys(context).grey030,
                  size: 28,
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
          color: htGreys(context).white,
          borderRadius: HTBorderRadius.circular10,
          boxShadow: [
            BoxShadow(
              color: htGreys(context).black.withOpacity(0.12),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            )
          ],
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
                  double spacing = 6;
                  double emojiSize = (constraints.maxWidth -
                          (spacing * (crossAxisCount - 1))) /
                      crossAxisCount;

                  ScrollController emojiScrollController = ScrollController();

                  return RawScrollbar(
                    thickness: 6,
                    minThumbLength: 80,
                    thumbColor: htGreys(context).grey020,
                    radius: const Radius.circular(10),
                    controller: emojiScrollController,
                    child: GridView.builder(
                      controller: emojiScrollController,
                      padding: HTEdgeInsets.all16,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: spacing,
                        crossAxisSpacing: spacing,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return GestureDetector(
                            onTap: () {
                              taskAddBloc.setEmoji('');
                              taskAddBloc.setOpenEmoji(false);
                            },
                            child: SizedBox(
                              width: emojiSize,
                              height: emojiSize,
                              child: Center(
                                  child: Icon(
                                Icons.emoji_emotions_rounded,
                                color: htGreys(context).grey030,
                                size: emojiSize * 0.75,
                              )),
                            ),
                          );
                        } else if (index >= 1 && index <= crossAxisCount - 1) {
                          return const SizedBox();
                        }

                        int newIndex = index - crossAxisCount;

                        return GestureDetector(
                          onTap: () {
                            taskAddBloc.setEmoji(allEmojis[newIndex]);
                            taskAddBloc.setOpenEmoji(false);
                          },
                          child: SizedBox(
                            width: emojiSize,
                            height: emojiSize,
                            child: Center(
                              child: Text(
                                allEmojis[newIndex],
                                style: TextStyle(
                                    fontSize: emojiSize * 0.8, height: 1),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: allEmojis.length + crossAxisCount,
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
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: htGreys(context).grey040,
            ),
            child: Icon(
              Icons.close_rounded,
              color: htGreys(context).white,
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

    return Padding(
      padding: HTEdgeInsets.horizontal24,
      child: Focus(
        child: Stack(
          children: [
            TextField(
              controller: taskAddBloc.titleController,
              onChanged: (value) => taskAddBloc.setTitle(value),
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              style: HTTypoToken.subtitleXLarge.textStyle,
              maxLength: 30,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                counterText: '',
                suffix: const SizedBox(width: 48),
                hintText: 'Add your task here...',
                hintStyle: HTTypoToken.bodyXLarge.textStyle.copyWith(
                  color: htGreys(context).grey030,
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
                          color: htGreys(context).grey040,
                          height: 1.25,
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
      ),
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

    return Padding(
      padding: HTEdgeInsets.horizontal24,
      child: Focus(
        child: Stack(
          children: [
            TextField(
              controller: taskAddBloc.goalController,
              onChanged: (value) => taskAddBloc.setGoal(value),
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              style: HTTypoToken.bodyMedium.textStyle
                  .copyWith(color: htGreys(context).black),
              maxLength: 100,
              maxLines: 7,
              minLines: 7,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                  counterText: '',
                  hintText:
                      '(Optional) Describe the habit you want to build and set your goals here.',
                  hintStyle: HTTypoToken.bodyMedium.textStyle.copyWith(
                    color: htGreys(context).grey030,
                  )),
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
                        color: htGreys(context).grey040,
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
      ),
    );
  }
}

class TaskAddColor extends StatelessWidget {
  const TaskAddColor({super.key});

  @override
  Widget build(BuildContext context) {
    TaskAddBloc taskAddBloc = context.read<TaskAddBloc>();
    AppBloc appBloc = context.read<AppBloc>();

    return StreamBuilder<List>(
        stream:
            Rx.combineLatestList([taskAddBloc.selectedColor, appBloc.settings]),
        builder: (context, snapshot) {
          int selectedColor = snapshot.data?[0] ?? 0xFF000000;
          Settings settings = snapshot.data?[1] ?? Settings();

          return SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: HTEdgeInsets.horizontal24,
              itemBuilder: (context, index) {
                int currColor = taskColors[index];

                int displayColor = currColor;
                if (settings.isDarkMode && displayColor == 0xFF000000) {
                  displayColor = 0xFFFFFFFF;
                }

                return GestureDetector(
                  onTap: () {
                    taskAddBloc.setSelectedColor(currColor);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currColor == selectedColor
                          ? htGreys(context).black
                          : htGreys(context).white,
                    ),
                    child: Center(
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: htGreys(context).white,
                              width: 4,
                              strokeAlign: BorderSide.strokeAlignOutside),
                          shape: BoxShape.circle,
                          color: Color(displayColor),
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (cotext, index) {
                return HTSpacers.width8;
              },
              itemCount: taskColors.length,
            ),
          );
        });
  }
}

class TaskAddRepeatAt extends StatelessWidget {
  const TaskAddRepeatAt({super.key});

  @override
  Widget build(BuildContext context) {
    TaskAddBloc taskAddBloc = context.read<TaskAddBloc>();

    return Padding(
      padding: HTEdgeInsets.horizontal24,
      child: StreamBuilder<bool>(
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
                      HTText(
                        'Repeat',
                        typoToken: HTTypoToken.subtitleXLarge,
                        color: htGreys(context).black,
                        height: 1,
                      ),
                      CupertinoSwitch(
                          value: isRepeat,
                          activeColor: htGreys(context).black,
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
                            color: htGreys(context).grey010,
                            borderRadius: HTBorderRadius.circular10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...RepeatType.values.map((e) =>
                                  TaskAddRepeatRadio(
                                      groupValue: repeatType, repeatType: e)),
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
                                              taskAddBloc.toggleRepeatAt(
                                                  dayNums[index]);
                                            },
                                            child: Container(
                                              width: size,
                                              height: size,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: isSelected
                                                        ? htGreys(context).black
                                                        : htGreys(context)
                                                            .grey020,
                                                    width: 1),
                                                color: isSelected
                                                    ? htGreys(context).black
                                                    : HTColors.clear,
                                              ),
                                              child: Center(
                                                  child: HTText(
                                                days[index],
                                                typoToken: isSelected
                                                    ? HTTypoToken.subtitleXSmall
                                                    : HTTypoToken.bodyXSmall,
                                                color: isSelected
                                                    ? htGreys(context).white
                                                    : htGreys(context).grey060,
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
          }),
    );
  }
}

class TaskAddRepeatRadio extends StatelessWidget {
  final RepeatType groupValue;
  final RepeatType repeatType;
  const TaskAddRepeatRadio(
      {super.key, required this.groupValue, required this.repeatType});

  @override
  Widget build(BuildContext context) {
    TaskAddBloc taskAddBloc = context.read<TaskAddBloc>();

    return HTRadio(
        value: repeatType,
        groupValue: groupValue,
        text: repeatType.text,
        padding: HTEdgeInsets.vertical8,
        onTap: () {
          taskAddBloc.setRepeatType(repeatType);
          taskAddBloc.setRepeatAt(repeatType.days);
        });
  }
}

class TaskAddFrom extends StatefulWidget {
  const TaskAddFrom({super.key});

  @override
  State<TaskAddFrom> createState() => _TaskAddFromState();
}

class _TaskAddFromState extends State<TaskAddFrom> {
  bool _showCalendar = false;

  @override
  Widget build(BuildContext context) {
    TaskAddBloc taskAddBloc = context.read<TaskAddBloc>();

    return Padding(
      padding: HTEdgeInsets.horizontal24,
      child: StreamBuilder<List>(
          stream: Rx.combineLatestList([taskAddBloc.from, taskAddBloc.until]),
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
                      HTText(
                        'Start Date',
                        typoToken: HTTypoToken.subtitleXLarge,
                        color: htGreys(context).black,
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
                            color: htGreys(context).grey010,
                            borderRadius: HTBorderRadius.circular10,
                          ),
                          child: HTText(
                            DateFormat('yyyy.MM.dd').format(from) +
                                (htIsSameDay(from, DateTime.now())
                                    ? ' (Today)'
                                    : DateFormat(' (E)').format(from)),
                            typoToken: HTTypoToken.bodyMedium,
                            color: htGreys(context).black,
                            height: 1.2,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                if (_showCalendar)
                  HTCalendar(
                      selectedDate: from,
                      lastDay: until?.subtract(const Duration(days: 1)),
                      onSelected: (selectedDay) {
                        taskAddBloc.setFrom(selectedDay.getDate());
                      }),
              ],
            );
          }),
    );
  }
}

class TaskAddUntil extends StatefulWidget {
  const TaskAddUntil({super.key});

  @override
  State<TaskAddUntil> createState() => _TaskAddUntilState();
}

class _TaskAddUntilState extends State<TaskAddUntil> {
  bool _showCalendar = true;

  @override
  Widget build(BuildContext context) {
    TaskAddBloc taskAddBloc = context.read<TaskAddBloc>();

    DateTime today = DateTime.now().getDate();

    return Padding(
      padding: HTEdgeInsets.horizontal24,
      child: StreamBuilder<List>(
          stream: Rx.combineLatestList(
              [taskAddBloc.until, taskAddBloc.from, taskAddBloc.isRepeat]),
          builder: (context, snapshot) {
            DateTime? until = snapshot.data?[0];
            DateTime from = snapshot.data?[1] ?? today;
            bool isRepeat = snapshot.data?[2] ?? true;

            DateTime firstDate = from.add(const Duration(days: 1));

            if (!isRepeat) {
              return const SizedBox.shrink();
            }

            if (until != null && until.isBefore(from)) {
              taskAddBloc.setUntil(null);
            }

            return Column(
              children: [
                SizedBox(
                  height: 56,
                  child: Row(
                    children: [
                      HTText(
                        'End Date',
                        typoToken: HTTypoToken.subtitleXLarge,
                        color: htGreys(context).black,
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
                              color: htGreys(context).grey010,
                              borderRadius: HTBorderRadius.circular10,
                            ),
                            child: HTText(
                              DateFormat('yyyy.MM.dd').format(until),
                              typoToken: HTTypoToken.bodyMedium,
                              color: htGreys(context).black,
                              height: 1.2,
                            ),
                          ),
                        ),
                      HTSpacers.width8,
                      CupertinoSwitch(
                          value: until != null,
                          activeColor: htGreys(context).black,
                          onChanged: (value) {
                            if (value) {
                              taskAddBloc.setUntil(
                                  firstDate.add(const Duration(days: 7)));

                              if (!taskAddBloc.isRepeatValue) {
                                taskAddBloc.setIsRepeat(true);
                              }
                            } else {
                              taskAddBloc.setUntil(null);
                            }
                          }),
                    ],
                  ),
                ),
                if (_showCalendar && until != null)
                  HTCalendar(
                      selectedDate:
                          until.isAfter(firstDate) ? until : firstDate,
                      firstDay: firstDate,
                      onSelected: (selectedDay) {
                        taskAddBloc.setUntil(selectedDay.getDate());
                      }),
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
        stream: Rx.combineLatestList([
          taskAddBloc.title,
        ]),
        builder: (context, snapshot) {
          String title = snapshot.data?[0] ?? '';

          bool canSubmit = title.isNotEmpty;

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
                          if (taskAddBloc.task != null) {
                            taskAddBloc.updateTask().then((value) {
                              if (value != null) {
                                Navigator.pop(
                                    context, taskAddBloc.getUpdatedTask(value));
                              }
                            });
                          } else {
                            taskAddBloc.addTask().then((value) {
                              context.push(TaskDetailPage.routeName,
                                  extra: value);
                              Navigator.pop(context);
                            });
                          }
                        }
                      : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_rounded,
                        color: htGreys(context).white,
                        size: 24,
                      ),
                      HTSpacers.width4,
                      HTText(
                        'Done',
                        typoToken: HTTypoToken.subtitleXLarge,
                        color: htGreys(context).white,
                        height: 1.25,
                      ),
                    ],
                  )),
            ),
          );
        });
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_app/blocs/app_service.dart';
import 'package:habit_app/blocs/task/task_add_bloc.dart';
import 'package:habit_app/models/settings_model.dart';
import 'package:habit_app/pages/task/task_detail_page.dart';
import 'package:habit_app/router.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/utils/emojis.dart';
import 'package:habit_app/utils/enums.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:habit_app/utils/notifications.dart';
import 'package:habit_app/utils/tutorial.dart';
import 'package:habit_app/widgets/ht_bottom_modal.dart';
import 'package:habit_app/widgets/ht_calendar.dart';
import 'package:habit_app/widgets/ht_dialog.dart';
import 'package:habit_app/widgets/ht_radio.dart';
import 'package:habit_app/widgets/ht_text.dart';
import 'package:habit_app/widgets/ht_tooltip.dart';
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
    TaskAddBloc bloc = context.read<TaskAddBloc>();

    ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (bloc.openEmojiValue) {
        bloc.setOpenEmoji(false);
      }
    });

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (bloc.openEmojiValue) {
              bloc.setOpenEmoji(false);
            }
          },
          child: Column(
            children: [
              HTSpacers.height8,
              const TaskAddClose(),
              Expanded(
                child: SingleChildScrollView(
                  controller: bloc.scrollController,
                  padding: HTEdgeInsets.vertical16,
                  child: const Column(
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
              const TaskAddSubmit(),
            ],
          ),
        ),
        StreamBuilder<bool>(
            stream: bloc.openEmoji,
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
    TaskAddBloc bloc = context.read<TaskAddBloc>();
    AppService appService = context.read<AppService>();

    return StreamBuilder<List>(
        stream: Rx.combineLatestList([bloc.alarmTime, appService.isPro]),
        builder: (context, snapshot) {
          DateTime? alarmTime = snapshot.data?[0];
          bool isPro = snapshot.data?[1] ?? false;

          return GestureDetector(
            onTap: () {
              if (isPro) {
                HTNotification.requestNotificationPermission(context);
                // HTNotification.showNotification();

                DateTime initialDateTime =
                    alarmTime ?? DateTime.now().copyWith(minute: 0);

                bloc.setAlarmTime(initialDateTime);

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
                                            bloc.setAlarmTime(null);
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
                                      bloc.setAlarmTime(dateTime);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
              } else {
                HTDialog.showConfirmDialog(
                  context,
                  title: 'Set Alarm with PRO',
                  content:
                      'To set alarm, you need PRO plan.\nStart with free trial plan!',
                  action: () {
                    pushSubscriptionPage();
                  },
                  buttonText: 'Try PRO',
                  isDestructive: false,
                );
              }
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
    TaskAddBloc bloc = context.read<TaskAddBloc>();

    return GestureDetector(
      key: emojiButtonKey,
      onTap: () {
        bloc.toggleOpenEmoji();
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: htGreys(context).grey010,
          borderRadius: HTBorderRadius.circular10,
        ),
        child: StreamBuilder<String>(
            stream: bloc.emoji,
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
    TaskAddBloc bloc = context.read<TaskAddBloc>();

    return Positioned(
      key: emojiPickerKey,
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
                              bloc.setEmoji('');
                              bloc.setOpenEmoji(false);
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
                            bloc.setEmoji(allEmojis[newIndex]);
                            bloc.setOpenEmoji(false);
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
    TaskAddBloc bloc = context.read<TaskAddBloc>();

    return Padding(
      padding: HTEdgeInsets.horizontal24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Focus(
            child: Stack(
              children: [
                TextField(
                  controller: bloc.titleController,
                  onChanged: (value) {
                    bloc.setTitle(value);
                    if (value.trim().isNotEmpty) {
                      bloc.setTitleError(false);
                    }
                  },
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
                          stream: bloc.title,
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
          StreamBuilder<bool>(
              stream: bloc.titleError,
              builder: (context, snapshot) {
                bool titleError = snapshot.data ?? false;

                if (titleError) {
                  return const HTText(
                    'Please fill title.',
                    typoToken: HTTypoToken.bodyMedium,
                    color: HTColors.red,
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
        ],
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
    TaskAddBloc bloc = context.read<TaskAddBloc>();

    return Padding(
      padding: HTEdgeInsets.horizontal24,
      child: Focus(
        child: Stack(
          children: [
            TextField(
              controller: bloc.goalController,
              onChanged: (value) => bloc.setGoal(value),
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
                    stream: bloc.goal,
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

          if (value && bloc.showColorTooltipValue) {
            bloc.setShowColorTooltip(false);
          }
        },
      ),
    );
  }
}

class TaskAddColor extends StatelessWidget {
  const TaskAddColor({super.key});

  @override
  Widget build(BuildContext context) {
    TaskAddBloc bloc = context.read<TaskAddBloc>();
    AppService appService = context.read<AppService>();

    ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (bloc.showColorTooltipValue) {
        bloc.setShowColorTooltip(false);
      }
    });

    return StreamBuilder<List>(
        stream: Rx.combineLatestList(
            [bloc.selectedColor, appService.settings, bloc.showColorTooltip]),
        builder: (context, snapshot) {
          int selectedColor = snapshot.data?[0] ?? 0xFF000000;
          Settings settings = snapshot.data?[1] ?? Settings();
          bool showColorTooltip = snapshot.data?[2] ?? false;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                height: 44,
                child: ListView.separated(
                  controller: scrollController,
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
                        bloc.setSelectedColor(currColor);

                        if (bloc.showColorTooltipValue) {
                          bloc.setShowColorTooltip(false);
                        }
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
              ),
              if (showColorTooltip)
                const Positioned(
                  top: -58,
                  left: 16,
                  child: HTTooltip('🎨 Change color of your task'),
                ),
            ],
          );
        });
  }
}

class TaskAddRepeatAt extends StatelessWidget {
  const TaskAddRepeatAt({super.key});

  @override
  Widget build(BuildContext context) {
    TaskAddBloc bloc = context.read<TaskAddBloc>();

    return Padding(
      padding: HTEdgeInsets.horizontal24,
      child: StreamBuilder<bool>(
          stream: bloc.isRepeat,
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
                          onChanged: (value) => bloc.setIsRepeat(value)),
                    ],
                  ),
                ),
                if (isRepeat)
                  StreamBuilder<List>(
                      stream: Rx.combineLatestList(
                          [bloc.repeatAt, bloc.repeatType]),
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
                                              bloc.toggleRepeatAt(
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
    TaskAddBloc bloc = context.read<TaskAddBloc>();

    return HTRadio(
        value: repeatType,
        groupValue: groupValue,
        text: repeatType.text,
        padding: HTEdgeInsets.vertical8,
        onTap: () {
          bloc.setRepeatType(repeatType);
          bloc.setRepeatAt(repeatType.days);
        });
  }
}

class TaskAddFrom extends StatelessWidget {
  const TaskAddFrom({super.key});

  @override
  Widget build(BuildContext context) {
    TaskAddBloc bloc = context.read<TaskAddBloc>();

    return Padding(
      padding: HTEdgeInsets.horizontal24,
      child: StreamBuilder<List>(
          stream: Rx.combineLatestList([
            bloc.from,
            bloc.until,
            bloc.showStartCalendar,
          ]),
          builder: (context, snapshot) {
            DateTime from = snapshot.data?[0] ?? DateTime.now().getDate();
            DateTime? until = snapshot.data?[1];
            bool showStartCalendar = snapshot.data?[2] ?? false;

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
                          bloc.toggleStartCalendar();
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
                if (showStartCalendar)
                  HTCalendar(
                      selectedDate: from,
                      lastDay: until?.subtract(const Duration(days: 1)),
                      onSelected: (selectedDay) {
                        bloc.setFrom(selectedDay.getDate());
                      }),
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
    TaskAddBloc bloc = context.read<TaskAddBloc>();

    DateTime today = DateTime.now().getDate();

    return Padding(
      padding: HTEdgeInsets.horizontal24,
      child: StreamBuilder<List>(
          stream: Rx.combineLatestList(
              [bloc.until, bloc.from, bloc.isRepeat, bloc.showEndCalendar]),
          builder: (context, snapshot) {
            DateTime? until = snapshot.data?[0];
            DateTime from = snapshot.data?[1] ?? today;
            bool isRepeat = snapshot.data?[2] ?? true;
            bool showEndCalendar = snapshot.data?[3] ?? false;

            DateTime firstDate = from.add(const Duration(days: 1));

            if (!isRepeat) {
              return const SizedBox.shrink();
            }

            if (until != null && until.isBefore(from)) {
              bloc.setUntil(null);
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
                            bloc.toggleEndCalendar();
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
                              bloc.setShowEndCalendar(true);
                              bloc.scrollToEndCalendar();

                              bloc.setUntil(
                                  firstDate.add(const Duration(days: 7)));

                              if (!bloc.isRepeatValue) {
                                bloc.setIsRepeat(true);
                              }
                            } else {
                              bloc.setUntil(null);
                            }
                          }),
                    ],
                  ),
                ),
                if (showEndCalendar && until != null)
                  HTCalendar(
                      selectedDate:
                          until.isAfter(firstDate) ? until : firstDate,
                      firstDay: firstDate,
                      onSelected: (selectedDay) {
                        bloc.setUntil(selectedDay.getDate());
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
    TaskAddBloc bloc = context.read<TaskAddBloc>();

    return StreamBuilder<List>(
        stream: Rx.combineLatestList([
          bloc.title,
        ]),
        builder: (context, snapshot) {
          String title = snapshot.data?[0] ?? '';
          title = title.trim();

          bool canSubmit = title.isNotEmpty;

          return SafeArea(
            child: Container(
              width: double.infinity,
              padding: HTEdgeInsets.h24v16,
              child: ElevatedButton(
                  key: doneButtonKey,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: canSubmit
                          ? htGreys(context).black
                          : htGreys(context).grey030,
                      padding: HTEdgeInsets.vertical16,
                      shape: RoundedRectangleBorder(
                          borderRadius: HTBorderRadius.circular10)),
                  onPressed: () {
                    if (canSubmit) {
                      if (bloc.task != null) {
                        bloc.updateTask().then((value) {
                          if (value != null) {
                            Navigator.pop(context, bloc.getUpdatedTask(value));
                          }
                        });
                      } else {
                        bloc.addTask().then((value) {
                          context.push(TaskDetailPage.routeName, extra: value);
                          Navigator.pop(context);
                        });
                      }
                    } else {
                      if (title.isEmpty) {
                        bloc.setTitleError(true);
                      }
                    }
                  },
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

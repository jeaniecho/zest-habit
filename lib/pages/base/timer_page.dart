import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_app/blocs/base/timer_bloc.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/router.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/utils/enums.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:habit_app/widgets/ht_bottom_modal.dart';
import 'package:habit_app/widgets/ht_scale.dart';
import 'package:habit_app/widgets/ht_snackbar.dart';
import 'package:habit_app/widgets/ht_text.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

double timeStringWidth = 64;
double timerStringHeight = 72;

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  static const routeName = '/timer';

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        TimerAppbar(),
        Expanded(child: TimerWidget()),
      ],
    );
  }
}

class TimerAppbar extends StatelessWidget {
  const TimerAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Row(
            children: [
              HTText(
                'Timer',
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

class TimerTask extends StatelessWidget {
  const TimerTask({super.key});

  @override
  Widget build(BuildContext context) {
    TimerBloc timerBloc = context.read<TimerBloc>();

    return StreamBuilder<List>(
        stream: Rx.combineLatestList([timerBloc.start, timerBloc.curr]),
        builder: (context, snapshot) {
          Duration? start = snapshot.data?[0];
          Duration? curr = snapshot.data?[1];

          bool isTimerOn = curr != null && !curr.isNegative && start != curr;

          return GestureDetector(
            onTap: isTimerOn
                ? null
                : () {
                    showModalBottomSheet(
                        context: context,
                        useRootNavigator: true,
                        isScrollControlled: true,
                        backgroundColor: HTColors.clear,
                        barrierColor: htGreys(context).black.withOpacity(0.3),
                        useSafeArea: true,
                        builder: (context) {
                          return const TimerTaskPicker();
                        });
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: htGreys(context).grey010,
                borderRadius: HTBorderRadius.circular10,
              ),
              child: StreamBuilder<Task?>(
                  stream: timerBloc.selectedTask,
                  builder: (context, snapshot) {
                    Task? selectedTask = snapshot.data;

                    bool hasEmoji = selectedTask?.emoji != null &&
                        selectedTask!.emoji!.isNotEmpty;

                    if (selectedTask == null) {
                      return HTText(
                        'Select Task...',
                        typoToken: HTTypoToken.bodyMedium,
                        color: htGreys(context).grey040,
                        height: 1.2,
                      );
                    } else {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!hasEmoji)
                            Padding(
                              padding: HTEdgeInsets.right4,
                              child: Icon(
                                Icons.emoji_emotions_rounded,
                                color: htGreys(context).grey030,
                                size: 18,
                              ),
                            ),
                          HTText(
                            '${hasEmoji ? '${selectedTask.emoji} ' : ''}${selectedTask.title}',
                            typoToken: HTTypoToken.subtitleMedium,
                            color: htGreys(context).black,
                          ),
                          if (!isTimerOn)
                            Padding(
                              padding: HTEdgeInsets.left8,
                              child: GestureDetector(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  timerBloc.setSelectedTask(null);
                                },
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: htGreys(context).grey040,
                                  ),
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: htGreys(context).grey010,
                                    size: 14,
                                  ),
                                ),
                              ),
                            )
                        ],
                      );
                    }
                  }),
            ),
          );
        });
  }
}

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    TimerBloc timerBloc = context.read<TimerBloc>();

    double timerSize = 320;
    // double timerSize = MediaQuery.sizeOf(context).width * 0.75;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: HTEdgeInsets.horizontal24,
          child: StreamBuilder<List>(
              stream: Rx.combineLatestList([timerBloc.start, timerBloc.curr]),
              builder: (context, snapshot) {
                Duration? start = snapshot.data?[0];
                Duration? curr = snapshot.data?[1];

                bool isTimerOn =
                    curr != null && !curr.isNegative && start != curr;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TimerTask(),
                    HTSpacers.height32,
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: timerSize,
                            height: timerSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: htGreys(context).grey020,
                                width: 1,
                                strokeAlign: BorderSide.strokeAlignOutside,
                              ),
                            ),
                          ),
                          if (start != null && curr != null)
                            Positioned.fill(
                              child: Center(
                                child: SizedBox(
                                  width: timerSize - 5,
                                  height: timerSize - 5,
                                  child: CircularProgressIndicator(
                                    value: 1 -
                                        curr.inMilliseconds /
                                            start.inMilliseconds,
                                    strokeWidth: 5,
                                    backgroundColor: htGreys(context).white,
                                    color: curr.isNegative
                                        ? htGreys(context).white
                                        : htGreys(context).black,
                                  ),
                                ),
                              ),
                            ),
                          Positioned.fill(
                            child: Center(
                              child: Container(
                                width: timerSize - 6.5,
                                height: timerSize - 6.5,
                                decoration: BoxDecoration(
                                  color: htGreys(context).white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            width: timerSize,
                            height: timerSize,
                            child: Center(
                              child: isTimerOn
                                  ? const FixedTimerText()
                                  : EditableTimerText(timerSize: timerSize),
                            ),
                          )
                        ],
                      ),
                    ),
                    HTSpacers.height48,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isTimerOn
                                ? htGreys(context).white
                                : htGreys(context).black,
                            border: isTimerOn
                                ? Border.all(
                                    color: htGreys(context).grey020, width: 1)
                                : null,
                          ),
                          child: IconButton(
                            onPressed: () {
                              if (isTimerOn) {
                                timerBloc.stopTimer();
                              } else {
                                timerBloc.startTimer();
                              }
                            },
                            icon: Icon(
                              isTimerOn
                                  ? Icons.stop_rounded
                                  : Icons.play_arrow_rounded,
                              size: isTimerOn ? 40 : 48,
                              color: isTimerOn
                                  ? htGreys(context).black
                                  : htGreys(context).white,
                            ),
                          ),
                        ),
                        if (isTimerOn)
                          StreamBuilder<bool>(
                              stream: timerBloc.isTimerPaused,
                              builder: (context, snapshot) {
                                bool isTimerPaused = snapshot.data ?? false;

                                return Container(
                                  width: 80,
                                  height: 80,
                                  margin: HTEdgeInsets.left32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: htGreys(context).white,
                                    border: Border.all(
                                        color: htGreys(context).grey020,
                                        width: 1),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      if (isTimerPaused) {
                                        timerBloc.resumeTimer();
                                      } else {
                                        timerBloc.pauseTimer();
                                      }
                                    },
                                    icon: Icon(
                                        isTimerPaused
                                            ? Icons.play_arrow_rounded
                                            : Icons.pause_rounded,
                                        size: isTimerPaused ? 48 : 40,
                                        color: htGreys(context).black),
                                  ),
                                );
                              }),
                      ],
                    ),
                    HTSpacers.height40,
                  ],
                );
              }),
        ),
      ),
    );
  }
}

class FixedTimerText extends StatelessWidget {
  const FixedTimerText({super.key});

  @override
  Widget build(BuildContext context) {
    TimerBloc timerBloc = context.read<TimerBloc>();

    return StreamBuilder<List>(
        stream: Rx.combineLatestList([
          timerBloc.curr,
          timerBloc.pausedTime,
          timerBloc.isTimerPaused,
        ]),
        builder: (context, snapshot) {
          Duration curr =
              snapshot.data?[0] ?? const Duration(minutes: defaultMin);
          Duration? pausedTime = snapshot.data?[1];
          bool isTimerPaused = snapshot.data?[2] ?? false;

          if (isTimerPaused && pausedTime != null) {
            curr = pausedTime;
          }

          String timeString = curr.toShortString();
          List<String> timeList = timeString.split(':');

          return GestureDetector(
            onTap: () {
              timerBloc.showAdjustLater();
            },
            child: SizedBox(
              height: timerStringHeight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                      width: timeStringWidth,
                      child: HTText(
                        timeList[0],
                        typoToken: HTTypoToken.bodyHuge,
                        color: htGreys(context).black,
                        height: 1.25,
                        textAlign: TextAlign.center,
                      )),
                  HTText(
                    ':',
                    typoToken: HTTypoToken.bodyHuge,
                    color: htGreys(context).black,
                    height: 1,
                  ),
                  SizedBox(
                      width: timeStringWidth,
                      child: HTText(
                        timeList[1],
                        typoToken: HTTypoToken.bodyHuge,
                        color: htGreys(context).black,
                        height: 1.25,
                        textAlign: TextAlign.center,
                      )),
                  HTText(
                    ':',
                    typoToken: HTTypoToken.bodyHuge,
                    color: htGreys(context).black,
                    height: 1,
                  ),
                  SizedBox(
                      width: timeStringWidth,
                      child: HTText(
                        timeList[2],
                        typoToken: HTTypoToken.bodyHuge,
                        color: htGreys(context).black,
                        height: 1.25,
                        textAlign: TextAlign.center,
                      )),
                ],
              ),
            ),
          );
        });
  }
}

class EditableTimerText extends StatelessWidget {
  final double timerSize;
  const EditableTimerText({super.key, required this.timerSize});

  @override
  Widget build(BuildContext context) {
    TimerBloc timerBloc = context.read<TimerBloc>();

    TextStyle timerStyle =
        HTTypoToken.bodyHuge.textStyle.copyWith(height: 1.25);
    InputDecoration timerDecoration = const InputDecoration(
      contentPadding: HTEdgeInsets.zero,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      fillColor: HTColors.clear,
      counterText: '',
    );

    TextEditingController hourController =
        TextEditingController(text: timerBloc.hourValue);
    hourController.selection = TextSelection.fromPosition(
        TextPosition(offset: hourController.text.length));

    TextEditingController minuteController =
        TextEditingController(text: timerBloc.minuteValue);
    minuteController.selection = TextSelection.fromPosition(
        TextPosition(offset: minuteController.text.length));

    TextEditingController secondController =
        TextEditingController(text: timerBloc.secondValue);
    secondController.selection = TextSelection.fromPosition(
        TextPosition(offset: secondController.text.length));

    return Focus(
      onFocusChange: (value) {
        timerBloc.setIsFocused(value);
      },
      child: StreamBuilder<List>(
          stream: Rx.combineLatestList(
              [timerBloc.isFocused, timerBloc.hasStringError]),
          builder: (context, snapshot) {
            bool isFocused = snapshot.data?[0] ?? false;
            bool hasStringError = snapshot.data?[1] ?? false;

            return Container(
              padding: HTEdgeInsets.horizontal16,
              decoration: BoxDecoration(
                color: isFocused
                    ? hasStringError
                        ? HTColors.red[100]
                        : htGreys(context).grey010
                    : htGreys(context).white,
                borderRadius: HTBorderRadius.circular10,
              ),
              child: SizedBox(
                height: timerStringHeight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        width: timeStringWidth,
                        child: TextField(
                          controller: hourController,
                          onTap: () {
                            hourController.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: hourController.text.length);
                          },
                          onTapOutside: (event) {
                            hourController.text = timerBloc.hourValue;
                            timerBloc.setHasStringError(false);
                            FocusScope.of(context).unfocus();
                          },
                          onChanged: (value) {
                            String hourString = value;

                            if (value.length > 2) {
                              timerBloc.showTimerExceed();
                              timerBloc.setHasStringError(true);

                              hourString = value.substring(0, 2);
                              hourController.text = hourString;
                            } else {
                              timerBloc.setHasStringError(false);
                            }

                            String checked = timerBloc.timeStringCheck(
                                hourString, TimeType.hour);
                            timerBloc.setHour(checked);
                          },
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          style: timerStyle,
                          textAlign: TextAlign.center,
                          decoration: timerDecoration,
                          cursorHeight: 40,
                        )),
                    HTText(
                      ':',
                      typoToken: HTTypoToken.bodyHuge,
                      color: htGreys(context).black,
                      height: 1,
                    ),
                    SizedBox(
                        width: timeStringWidth,
                        child: TextField(
                          controller: minuteController,
                          onTap: () {
                            minuteController.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: minuteController.text.length);
                          },
                          onTapOutside: (event) {
                            minuteController.text = timerBloc.minuteValue;
                            timerBloc.setHasStringError(false);
                            FocusScope.of(context).unfocus();
                          },
                          onChanged: (value) {
                            String minuteString = value;

                            if (value.length > 2) {
                              timerBloc.showTimerExceed();
                              timerBloc.setHasStringError(true);

                              minuteString = value.substring(0, 2);
                              minuteController.text = minuteString;
                            } else {
                              timerBloc.setHasStringError(false);
                            }

                            String checked = timerBloc.timeStringCheck(
                                minuteString, TimeType.minute);
                            timerBloc.setMinute(checked);
                          },
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          textAlign: TextAlign.center,
                          style: timerStyle,
                          decoration: timerDecoration,
                          cursorHeight: 40,
                        )),
                    HTText(
                      ':',
                      typoToken: HTTypoToken.bodyHuge,
                      color: htGreys(context).black,
                      height: 1,
                    ),
                    SizedBox(
                        width: timeStringWidth,
                        child: TextField(
                          controller: secondController,
                          onTap: () {
                            secondController.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: secondController.text.length);
                          },
                          onTapOutside: (event) {
                            secondController.text = timerBloc.secondValue;
                            timerBloc.setHasStringError(false);
                            FocusScope.of(context).unfocus();
                          },
                          onChanged: (value) {
                            String secondString = value;

                            if (value.length > 2) {
                              timerBloc.showTimerExceed();
                              timerBloc.setHasStringError(true);

                              secondString = value.substring(0, 2);
                              secondController.text = secondString;
                            } else {
                              timerBloc.setHasStringError(false);
                            }

                            String checked = timerBloc.timeStringCheck(
                                secondString, TimeType.second);
                            timerBloc.setSecond(checked);
                          },
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          style: timerStyle,
                          textAlign: TextAlign.center,
                          decoration: timerDecoration,
                          cursorHeight: 40,
                        )),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class TimerTaskPicker extends StatelessWidget {
  const TimerTaskPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return HTBottomModal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HTSpacers.height8,
          const TimeTaskPickerClose(),
          HTSpacers.height16,
          Padding(
            padding: HTEdgeInsets.horizontal20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HTText(
                  'Select Task',
                  typoToken: HTTypoToken.headlineMedium,
                  color: htGreys(context).black,
                ),
                HTSpacers.height8,
                HTText(
                  'Only today\'s tasks are displayed',
                  typoToken: HTTypoToken.bodySmall,
                  color: htGreys(context).grey050,
                ),
                HTSpacers.height8,
              ],
            ),
          ),
          const TimerTaskList(),
        ],
      ),
    );
  }
}

class TimerTaskList extends StatelessWidget {
  const TimerTaskList({super.key});

  @override
  Widget build(BuildContext context) {
    TimerBloc timerBloc = context.read<TimerBloc>();

    List<Task> tasks = timerBloc.getTodayTasks();

    if (tasks.isEmpty) {
      return Expanded(
        child: Center(
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
                'There is no task',
                typoToken: HTTypoToken.subtitleLarge,
                color: htGreys(context).black,
              ),
              HTSpacers.height8,
              HTText(
                'Start your habit journey now! Add a task to get going.',
                typoToken: HTTypoToken.bodyXSmall,
                color: htGreys(context).grey050,
              ),
              HTSpacers.height160,
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.separated(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 56),
          itemBuilder: (context, index) {
            Task task = tasks[index];

            return TimerTaskItem(task: task);
          },
          separatorBuilder: (context, index) {
            return HTSpacers.height8;
          },
          itemCount: tasks.length),
    );
  }
}

class TimerTaskItem extends StatelessWidget {
  final Task task;
  const TimerTaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    TimerBloc timerBloc = context.read<TimerBloc>();

    return HTScale(
      onTap: () {
        timerBloc.setSelectedTask(task);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: htGreys(context).white,
          border: Border.all(color: htGreys(context).grey010, width: 1),
          borderRadius: HTBorderRadius.circular10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            task.emoji == null || task.emoji!.isEmpty
                ? Padding(
                    padding: HTEdgeInsets.right4,
                    child: Icon(
                      Icons.emoji_emotions_rounded,
                      color: htGreys(context).grey030,
                      size: 24,
                    ),
                  )
                : HTText(
                    task.emoji!,
                    typoToken: HTTypoToken.headlineSmall,
                    color: htGreys(context).black,
                    height: 1.25,
                  ),
            HTText(
              task.title,
              typoToken: HTTypoToken.headlineSmall,
              color: htGreys(context).black,
            ),
            Padding(
              padding: HTEdgeInsets.top4,
              child: Row(
                children: [
                  if (task.until != null)
                    HTText(
                      '${htUntilToText(task.until)} ㆍ ',
                      typoToken: HTTypoToken.captionSmall,
                      color: htGreys(context).grey040,
                    ),
                  HTText(
                    htRepeatAtToText(task.repeatAt),
                    typoToken: HTTypoToken.captionSmall,
                    color: htGreys(context).grey040,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeTaskPickerClose extends StatelessWidget {
  const TimeTaskPickerClose({super.key});

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

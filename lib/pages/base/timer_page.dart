import 'package:flutter/material.dart';
import 'package:habit_app/blocs/app_bloc.dart';
import 'package:habit_app/blocs/base/timer_bloc.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/router.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/utils/enums.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:habit_app/widgets/ht_bottom_modal.dart';
import 'package:habit_app/widgets/ht_text.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

double timeStringWidth = 60;
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
              const HTText(
                'Timer',
                typoToken: HTTypoToken.headlineLarge,
                color: HTColors.black,
              ),
              const Spacer(),
              InkWell(
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

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            useRootNavigator: true,
            isScrollControlled: true,
            backgroundColor: HTColors.clear,
            useSafeArea: true,
            builder: (context) {
              return const TimerTaskPicker();
            });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: HTColors.grey010,
          borderRadius: HTBorderRadius.circular10,
        ),
        child: StreamBuilder<Task?>(
            stream: timerBloc.selectedTask,
            builder: (context, snapshot) {
              Task? selectedTask = snapshot.data;

              if (selectedTask == null) {
                return const HTText(
                  'Select Task...',
                  typoToken: HTTypoToken.bodyMedium,
                  color: HTColors.grey040,
                  height: 1.2,
                );
              } else {
                return Container();
              }
            }),
      ),
    );
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
                    (curr != null && !curr.isNegative) && start != curr;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TimerTask(),
                    HTSpacers.height32,
                    if (start != null && curr != null)
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: timerSize,
                              height: timerSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: HTColors.grey020,
                                  width: 1,
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Center(
                                child: SizedBox(
                                  width: timerSize - 5,
                                  height: timerSize - 5,
                                  child: CircularProgressIndicator(
                                    value: curr.inMilliseconds /
                                        start.inMilliseconds,
                                    strokeWidth: 5,
                                    backgroundColor: curr.isNegative
                                        ? HTColors.white
                                        : HTColors.black,
                                    color: HTColors.white,
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Center(
                                child: Container(
                                  width: timerSize - 6.5,
                                  height: timerSize - 6.5,
                                  decoration: const BoxDecoration(
                                    color: HTColors.white,
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
                            color: isTimerOn ? HTColors.white : HTColors.black,
                            border: isTimerOn
                                ? Border.all(color: HTColors.grey020, width: 1)
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
                              color:
                                  isTimerOn ? HTColors.black : HTColors.white,
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
                                    color: HTColors.white,
                                    border: Border.all(
                                        color: HTColors.grey020, width: 1),
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
                                        color: HTColors.black),
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

          return SizedBox(
            height: timerStringHeight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                    width: timeStringWidth,
                    child: HTText(
                      timeList[0],
                      typoToken: HTTypoToken.bodyHuge,
                      color: HTColors.black,
                      height: 1.25,
                      textAlign: TextAlign.center,
                    )),
                const HTText(
                  ':',
                  typoToken: HTTypoToken.bodyHuge,
                  color: HTColors.black,
                  height: 1,
                ),
                SizedBox(
                    width: timeStringWidth,
                    child: HTText(
                      timeList[1],
                      typoToken: HTTypoToken.bodyHuge,
                      color: HTColors.black,
                      height: 1.25,
                      textAlign: TextAlign.center,
                    )),
                const HTText(
                  ':',
                  typoToken: HTTypoToken.bodyHuge,
                  color: HTColors.black,
                  height: 1,
                ),
                SizedBox(
                    width: timeStringWidth,
                    child: HTText(
                      timeList[2],
                      typoToken: HTTypoToken.bodyHuge,
                      color: HTColors.black,
                      height: 1.25,
                      textAlign: TextAlign.center,
                    )),
              ],
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
      child: StreamBuilder<bool>(
          stream: timerBloc.isFocused,
          builder: (context, snapshot) {
            bool isFocused = snapshot.data ?? false;

            return Container(
              padding: HTEdgeInsets.horizontal16,
              decoration: BoxDecoration(
                color: isFocused ? HTColors.grey010 : HTColors.white,
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
                            FocusScope.of(context).unfocus();
                          },
                          onChanged: (value) {
                            String checked =
                                timerBloc.timeStringCheck(value, TimeType.hour);
                            timerBloc.setHour(checked);
                          },
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          style: timerStyle,
                          textAlign: TextAlign.center,
                          decoration: timerDecoration,
                          cursorHeight: 40,
                        )),
                    const HTText(
                      ':',
                      typoToken: HTTypoToken.bodyHuge,
                      color: HTColors.black,
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
                            FocusScope.of(context).unfocus();
                          },
                          onChanged: (value) {
                            String checked = timerBloc.timeStringCheck(
                                value, TimeType.minute);
                            timerBloc.setMinute(checked);
                          },
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          textAlign: TextAlign.center,
                          style: timerStyle,
                          decoration: timerDecoration,
                          cursorHeight: 40,
                        )),
                    const HTText(
                      ':',
                      typoToken: HTTypoToken.bodyHuge,
                      color: HTColors.black,
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
                            FocusScope.of(context).unfocus();
                          },
                          onChanged: (value) {
                            String checked = timerBloc.timeStringCheck(
                                value, TimeType.second);
                            timerBloc.setSecond(checked);
                          },
                          keyboardType: TextInputType.number,
                          maxLength: 2,
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
    AppBloc appBloc = context.read<AppBloc>();

    return const HTBottomModal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HTSpacers.height8,
          TimeTaskPickerClose(),
          HTSpacers.height16,
          Padding(
            padding: HTEdgeInsets.horizontal20,
            child: HTText(
              'Select Task',
              typoToken: HTTypoToken.headlineMedium,
              color: HTColors.black,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: HTEdgeInsets.h24v16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HTSpacers.height8,
                ],
              ),
            ),
          ),
        ],
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

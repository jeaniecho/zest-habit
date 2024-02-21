import 'package:flutter/material.dart';
import 'package:habit_app/blocs/base/timer_bloc.dart';
import 'package:habit_app/router.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:habit_app/widgets/ht_text.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  static const routeName = '/timer';

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        TimerAppbar(),
        TimerWidget(),
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
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: HTColors.grey010,
          borderRadius: HTBorderRadius.circular10,
        ),
        child: const HTText(
          'Select Task...',
          typoToken: HTTypoToken.bodyMedium,
          color: HTColors.grey040,
          height: 1.2,
        ),
      ),
    );
  }
}

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    TimerBloc timerBloc = context.read<TimerBloc>();

    double timerSize = MediaQuery.sizeOf(context).width * 0.75;

    return Expanded(
      child: Padding(
        padding: HTEdgeInsets.horizontal24,
        child: StreamBuilder<List>(
            stream: Rx.combineLatestList([timerBloc.start, timerBloc.curr]),
            builder: (context, snapshot) {
              Duration? start = snapshot.data?[0];
              Duration? curr = snapshot.data?[1];

              return Column(
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
                                  value: curr.inSeconds / start.inSeconds,
                                  strokeWidth: 5,
                                  backgroundColor: HTColors.black,
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
                              child: StreamBuilder<bool>(
                                  stream: timerBloc.isTimerOn,
                                  builder: (context, snapshot) {
                                    bool isTimerOn = snapshot.data ?? false;

                                    return HTText(
                                      (isTimerOn ? curr : start)
                                          .toShortString(),
                                      typoToken: HTTypoToken.bodyHuge,
                                      color: HTColors.black,
                                      height: 1,
                                    );
                                  }),
                            ),
                          )
                        ],
                      ),
                    ),
                  HTSpacers.height48,
                  StreamBuilder<bool>(
                      stream: timerBloc.isTimerOn,
                      builder: (context, snapshot) {
                        bool isTimerOn = snapshot.data ?? false;

                        return ElevatedButton(
                            onPressed: () {
                              if (isTimerOn) {
                                timerBloc.stopTimer();
                              } else {
                                timerBloc.startTimer();
                              }
                            },
                            child: HTText(
                              isTimerOn ? 'Stop' : 'Start',
                              typoToken: HTTypoToken.buttonTextMedium,
                              color: HTColors.white,
                              height: 1.25,
                            ));
                      }),
                  HTSpacers.height40,
                ],
              );
            }),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:habit_app/blocs/base/timer_bloc.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:habit_app/widgets/ht_text.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    TimerBloc timerBloc = context.read<TimerBloc>();

    double timerSize = 280;

    return Padding(
      padding: HTEdgeInsets.horizontal24,
      child: StreamBuilder<List>(
          stream: Rx.combineLatestList([timerBloc.start, timerBloc.curr]),
          builder: (context, snapshot) {
            Duration? start = snapshot.data?[0];
            Duration? curr = snapshot.data?[1];

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (start != null && curr != null)
                  Center(
                    child: Stack(
                      children: [
                        SizedBox(
                          width: timerSize,
                          height: timerSize,
                          child: CircularProgressIndicator(
                            value: curr.inSeconds / start.inSeconds,
                            strokeWidth: 20,
                            backgroundColor: HTColors.black,
                            color: HTColors.grey010,
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
                                    (isTimerOn ? curr : start).toShortString(),
                                    typoToken: HTTypoToken.headlineXXLarge,
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
                    })
              ],
            );
          }),
    );
  }
}

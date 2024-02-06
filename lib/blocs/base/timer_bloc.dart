import 'dart:async';

import 'package:habit_app/utils/disposable.dart';
import 'package:quiver/async.dart';
import 'package:rxdart/rxdart.dart';

class TimerBloc extends Disposable {
  final BehaviorSubject<Duration> _start =
      BehaviorSubject.seeded(const Duration(minutes: 1));
  Stream<Duration> get start => _start.stream;
  Function(Duration) get setStart => _start.add;

  final BehaviorSubject<Duration> _curr =
      BehaviorSubject.seeded(const Duration(minutes: 0));
  Stream<Duration> get curr => _curr.stream;

  final BehaviorSubject<bool> _isTimerOn = BehaviorSubject.seeded(false);
  Stream<bool> get isTimerOn => _isTimerOn.stream;

  late CountdownTimer timer;

  TimerBloc();

  @override
  void dispose() {
    _start.close();
    _curr.close();
  }

  startTimer() {
    timer = CountdownTimer(_start.value, const Duration(seconds: 1));

    _curr.add(_start.value);
    _isTimerOn.add(true);

    var sub = timer.listen(null);
    sub.onData((data) {
      _curr.add(_start.value - data.elapsed + const Duration(seconds: 1));
    });
    sub.onDone(() {
      sub.cancel();
      _isTimerOn.add(false);
    });
  }

  stopTimer() {
    _curr.add(_start.value);
    _isTimerOn.add(false);

    if (timer.isRunning) {
      timer.listen(null).cancel();
      timer.cancel();
    }
  }
}

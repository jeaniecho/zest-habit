import 'dart:async';

import 'package:habit_app/utils/disposable.dart';
import 'package:quiver/async.dart';
import 'package:rxdart/rxdart.dart';

const int defaultMin = 25;

class TimerBloc extends Disposable {
  final BehaviorSubject<Duration> _start =
      BehaviorSubject.seeded(const Duration(minutes: defaultMin));
  Stream<Duration> get start => _start.stream;
  Function(Duration) get setStart => _start.add;

  final BehaviorSubject<Duration> _curr =
      BehaviorSubject.seeded(const Duration(minutes: 25));
  Stream<Duration> get curr => _curr.stream;

  final BehaviorSubject<bool> _isTimerOn = BehaviorSubject.seeded(false);
  Stream<bool> get isTimerOn => _isTimerOn.stream;

  final BehaviorSubject<bool> _isFocused = BehaviorSubject.seeded(false);
  Stream<bool> get isFocused => _isFocused.stream;
  Function(bool) get setIsFocused => _isFocused.add;

  final BehaviorSubject<String> _hour = BehaviorSubject.seeded('00');
  Stream<String> get hour => _hour.stream;
  Function(String) get setHour => _hour.add;
  String get hourValue => _hour.value;

  final BehaviorSubject<String> _minute = BehaviorSubject.seeded('$defaultMin');
  Stream<String> get minute => _minute.stream;
  Function(String) get setMinute => _minute.add;
  String get minuteValue => _minute.value;

  final BehaviorSubject<String> _second = BehaviorSubject.seeded('00');
  Stream<String> get second => _second.stream;
  Function(String) get setSecond => _second.add;
  String get secondValue => _second.value;

  late CountdownTimer timer;

  TimerBloc();

  @override
  void dispose() {
    _start.close();
    _curr.close();
    _isTimerOn.close();
    _isFocused.close();
    _hour.close();
    _minute.close();
    _second.close();
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

  String timeStringCheck(String string) {
    if (string.isEmpty) {
      return '00';
    } else if (string.length == 1) {
      return '0$string';
    } else if (string.length > 2) {
      return string.substring(0, 2);
    } else {
      return string;
    }
  }
}

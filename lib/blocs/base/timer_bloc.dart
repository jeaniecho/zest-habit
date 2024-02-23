import 'dart:async';

import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/utils/disposable.dart';
import 'package:habit_app/utils/enums.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:quiver/async.dart';
import 'package:rxdart/rxdart.dart';

const int defaultMin = 25;

class TimerBloc extends Disposable {
  final BehaviorSubject<Duration> _start =
      BehaviorSubject.seeded(const Duration(minutes: defaultMin));
  Stream<Duration> get start => _start.stream;
  Function(Duration) get setStart => _start.add;

  final BehaviorSubject<Duration> _curr =
      BehaviorSubject.seeded(const Duration(seconds: -1));
  Stream<Duration> get curr => _curr.stream;

  final BehaviorSubject<bool> _isTimerPaused = BehaviorSubject.seeded(false);
  Stream<bool> get isTimerPaused => _isTimerPaused.stream;
  Function(bool) get setIsTimerPaused => _isTimerPaused.add;

  final BehaviorSubject<Duration?> _pausedTime = BehaviorSubject.seeded(null);
  Stream<Duration?> get pausedTime => _pausedTime.stream;
  Function(Duration?) get setPausedTime => _pausedTime.add;

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

  final BehaviorSubject<Task?> _selectedTask = BehaviorSubject.seeded(null);
  Stream<Task?> get selectedTask => _selectedTask.stream;
  Function(Task?) get setSelectedTask => _selectedTask.add;

  late CountdownTimer timer;

  TimerBloc();

  @override
  void dispose() {
    _start.close();
    _curr.close();
    _isTimerPaused.close();
    _pausedTime.close();
    _isFocused.close();
    _hour.close();
    _minute.close();
    _second.close();
    _selectedTask.close();
    timer.cancel();
  }

  startTimer() {
    _start.add(Duration(
      hours: int.tryParse(hourValue) ?? 0,
      minutes: int.tryParse(minuteValue) ?? 0,
      seconds: int.tryParse(secondValue) ?? 0,
    ));

    timer = CountdownTimer(_start.value, const Duration(seconds: 0));

    _curr.add(_start.value);

    var sub = timer.listen(null);

    sub.onData((data) {
      _curr.add(_start.value - data.elapsed);
    });
    sub.onDone(() {
      sub.cancel();
      timer.cancel();
    });
  }

  stopTimer() {
    _curr.add(const Duration(seconds: -1));
    _isTimerPaused.add(false);
    _pausedTime.add(null);

    if (timer.isRunning) {
      timer.listen(null).cancel();
      timer.cancel();
    }
  }

  pauseTimer() {
    _pausedTime.add(_curr.value);
    _isTimerPaused.add(true);

    timer.listen(null).cancel;
    timer.cancel();
  }

  resumeTimer() {
    timer = CountdownTimer(_start.value, const Duration(seconds: 0));

    _isTimerPaused.add(false);

    var sub = timer.listen(null);
    sub.onData((data) {
      _curr.add((_pausedTime.value ?? _start.value) - data.elapsed);
    });
    sub.onDone(() {
      sub.cancel();
      timer.cancel();
    });
  }

  String timeStringCheck(String string, TimeType timeType) {
    if (timeType != TimeType.hour) {
      int parsed = int.tryParse(string) ?? 0;

      if (parsed >= 60) {
        string = '59';
      }
    }

    if (string.isEmpty) {
      return '00';
    } else if (string.length == 1) {
      return '0$string';
    } else if (string.length > 2) {
      return '99';
    } else {
      return string;
    }
  }
}

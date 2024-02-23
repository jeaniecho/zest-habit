import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:habit_app/blocs/app_bloc.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/router.dart';
import 'package:habit_app/styles/tokens.dart';
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

  final AppBloc appBloc;
  final double deviceHeight;

  bool timerEnded = false;

  TimerBloc({
    required this.appBloc,
    required this.deviceHeight,
  });

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

    timer = CountdownTimer(
        _start.value + const Duration(seconds: 1), const Duration(seconds: 0));

    _curr.add(_start.value);

    var sub = timer.listen(null);

    sub.onData((data) {
      Duration remainder = _start.value - data.elapsed;

      _curr.add(remainder);

      if (remainder.inMilliseconds == -200) {
        onTimerDone();
      }
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
      Duration remainder = (_pausedTime.value ?? _start.value) - data.elapsed;
      _curr.add(remainder);

      if (remainder.inMilliseconds == -200) {
        onTimerDone();
      }
    });
    sub.onDone(() {
      sub.cancel();
      timer.cancel();
    });
  }

  onTimerDone() {
    if (!timerEnded) {
      timerEnded = true;

      FlutterRingtonePlayer().playAlarm(looping: false);

      SnackBar snackBar = SnackBar(
        content: const Text("⏰ Timer Ended!"),
        dismissDirection: DismissDirection.horizontal,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: HTEdgeInsets.horizontal20,
        shape: RoundedRectangleBorder(
          borderRadius: HTBorderRadius.circular12,
        ),
      );
      snackbarKey.currentState?.showSnackBar(snackBar);

      if (_selectedTask.value != null) {
        appBloc.setTaskDone(_selectedTask.value!, DateTime.now().getDate());
      }

      Future.delayed(const Duration(seconds: 1), () {
        timerEnded = false;
      });
    }
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

  List<Task> getTodayTasks() {
    List<Task> tasks = appBloc.tasksValue;

    DateTime date = DateTime.now().getDate();
    List<Task> todayTasks = tasks.where((element) {
      return (!element.from.getDate().isAfter(date)) &&
          (element.until == null ||
              (!element.until!.getDate().isBefore(date))) &&
          (((element.repeatAt == null || element.repeatAt!.isEmpty) &&
                  isSameDay(element.from, date)) ||
              element.repeatAt!.contains(date.weekday));
    }).toList();

    return todayTasks;
  }
}

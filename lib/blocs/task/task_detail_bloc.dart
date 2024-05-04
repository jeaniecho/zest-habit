import 'package:flutter/material.dart';
import 'package:habit_app/services/app_service.dart';
import 'package:habit_app/services/event_service.dart';
import 'package:habit_app/blocs/task/task_add_bloc.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/pages/task/task_add_page.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/utils/disposable.dart';
import 'package:habit_app/utils/enums.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class TaskDetailBloc extends Disposable {
  final AppService appService;
  final Task task;

  late final BehaviorSubject<Task> _taskObj;
  Stream<Task> get taskObj => _taskObj.stream;
  Function(Task) get setTaskObj => _taskObj.add;
  Task get taskObjValue => _taskObj.value;

  final BehaviorSubject<bool> _isMonthly = BehaviorSubject<bool>.seeded(true);
  Stream<bool> get isMonthly => _isMonthly.stream;

  late final BehaviorSubject<DateTime> _currDate;
  Stream<DateTime> get currDate => _currDate.stream;

  final BehaviorSubject<List<int>> _doneDates = BehaviorSubject.seeded([]);
  Stream<List<int>> get doneDates => _doneDates.stream;

  final BehaviorSubject<List<int>> _timerDates = BehaviorSubject.seeded([]);
  Stream<List<int>> get timerDates => _timerDates.stream;

  TaskDetailBloc({required this.task, required this.appService}) {
    _taskObj = BehaviorSubject.seeded(task);

    DateTime today = DateTime.now().getDate();

    bool isOld = task.until != null && task.until!.isBefore(today);
    _currDate = BehaviorSubject.seeded(isOld ? task.until! : today);

    getDoneDatesForMonth(_currDate.value);
  }

  @override
  void dispose() {
    _taskObj.close();
    _isMonthly.close();
    _currDate.close();
    _doneDates.close();
    _timerDates.close();
  }

  toggleCalendarType() {
    DateTime dateTime = DateTime.now().getDate();
    if (task.until != null && task.until!.isBefore(dateTime)) {
      dateTime = task.until!;
    }

    if (_isMonthly.value) {
      getDoneDatesForWeek(dateTime);
    } else {
      getDoneDatesForMonth(dateTime);
    }

    _currDate.add(dateTime);
    _isMonthly.add(!_isMonthly.value);
  }

  changeMonth(int move) {
    DateTime newDate =
        DateTime(_currDate.value.year, _currDate.value.month + move);
    _currDate.add(newDate);

    getDoneDatesForMonth(newDate);
  }

  changeWeek(int move) {
    DateTime newWeek = DateTime(_currDate.value.year, _currDate.value.month,
        _currDate.value.day + move * 7);
    _currDate.add(newWeek);

    getDoneDatesForWeek(newWeek);
  }

  getDoneDatesForMonth(DateTime date) {
    List<int> dates = task.doneAt
        .where((element) => htIsSameMonth(element, date))
        .map((e) => e.day)
        .toList();
    _doneDates.add(dates);

    dates = task.doneWithTimer
        .where((element) => htIsSameMonth(element, date))
        .map((e) => e.day)
        .toList();
    _timerDates.add(dates);
  }

  getDoneDatesForWeek(DateTime date) {
    DateTime fd = htMostRecentWeekday(date);

    List<int> dates = task.doneAt
        .where((element) =>
            element.isAfter(date.subtract(const Duration(days: 7))) &&
            element.isBefore(date.add(const Duration(days: 7))))
        .where((element) => htIsSameDay(fd, htMostRecentWeekday(element)))
        .map((e) => e.day)
        .toList();
    _doneDates.add(dates);

    dates = task.doneWithTimer
        .where((element) =>
            element.isAfter(date.subtract(const Duration(days: 7))) &&
            element.isBefore(date.add(const Duration(days: 7))))
        .where((element) => htIsSameDay(fd, htMostRecentWeekday(element)))
        .map((e) => e.day)
        .toList();
    _timerDates.add(dates);
  }

  showEditModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        backgroundColor: HTColors.clear,
        barrierColor: htGreys(context).black.withOpacity(0.3),
        useSafeArea: true,
        builder: (context) {
          return Provider(
              create: (context) => TaskAddBloc(
                  appService: context.read<AppService>(), task: taskObjValue),
              dispose: (context, value) => value.dispose(),
              child: const TaskAddWidget());
        }).then((task) {
      if (task != null && task.runtimeType == Task) {
        setTaskObj(task as Task);
      }
    });

    editTaskEvent();
  }

  showTutorialEditModal(BuildContext context, TaskAddBloc taskAddBloc) {
    showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        backgroundColor: HTColors.clear,
        barrierColor: htGreys(context).black.withOpacity(0.3),
        useSafeArea: true,
        builder: (context) {
          return Provider(
              create: (context) => taskAddBloc,
              dispose: (context, value) => value.dispose(),
              child: const TaskAddWidget());
        }).then((task) {
      if (task != null && task.runtimeType == Task) {
        setTaskObj(task as Task);
      }
    });
  }

  editTaskEvent() {
    EventService.editTask(
      taskTitle: task.title,
      taskStartDate: task.from,
      taskEndDate: task.until,
      taskRepeatType:
          task.repeatAt == null ? null : htGetRepeatType(task.repeatAt!),
      taskEmoji: task.emoji,
      taskCreateDate: task.from,
      taskAlarm: task.alarmTime != null,
      // subscribeStatus:
      //     getSubscriptionType(appService.iapService.purchasesValue),
      subscribeStatus: SubscriptionType.free,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:habit_app/blocs/app_service.dart';
import 'package:habit_app/blocs/event_service.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/utils/disposable.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:rxdart/rxdart.dart';

const int prevDates = 15;
const double dateWidth = 52 + 12;

class TaskBloc extends Disposable {
  final AppService appService;
  final double deviceWidth;

  final BehaviorSubject<List<DateTime>> _dates = BehaviorSubject.seeded([]);
  Stream<List<DateTime>> get dates => _dates.stream;

  final BehaviorSubject<int> _tabIndex = BehaviorSubject.seeded(0);
  Stream<int> get tabIndex => _tabIndex.stream;

  final BehaviorSubject<int> _dateIndex = BehaviorSubject.seeded(prevDates);
  Stream<int> get dateIndex => _dateIndex.stream;

  final BehaviorSubject<List<Task>> _currTasks = BehaviorSubject.seeded([]);
  Stream<List<Task>> get currTasks => _currTasks.stream;

  final BehaviorSubject<int> _notToday = BehaviorSubject.seeded(0);
  Stream<int> get notToday => _notToday.stream;
  Function(int) get setNotToday => _notToday.add;

  late final ScrollController dateScrollController;
  late final double dateScrollOffset;

  TaskBloc({required this.appService, required this.deviceWidth}) {
    getDates();
    dateScrollOffset =
        (dateWidth * (prevDates + 2) - ((deviceWidth - 84) / 2)).toDouble();

    dateScrollController =
        ScrollController(initialScrollOffset: dateScrollOffset);

    appService.tasks.listen((tasks) {
      getCurrTasks(tasks, _dates.value[_dateIndex.value]);
    });

    dateScrollController.addListener(() {
      if (dateScrollController.offset <
          dateScrollOffset - ((deviceWidth - 84) / 2)) {
        _notToday.add(1);
      } else if (dateScrollController.offset >
          dateScrollOffset + ((deviceWidth - 84) / 2)) {
        _notToday.add(-1);
      } else {
        _notToday.add(0);
      }
    });

    viewCalendarTaskEvent();
  }

  @override
  void dispose() {
    _dateIndex.close();
    _currTasks.close();
    _notToday.close();
    _tabIndex.close();
    dateScrollController.dispose();
  }

  List<DateTime> getDates() {
    DateTime today = DateTime.now().getDate();
    DateTime lastMonth = today.subtract(const Duration(days: prevDates));

    List<DateTime> items = List<DateTime>.generate(
        prevDates * 2,
        (i) => DateTime.utc(
              lastMonth.year,
              lastMonth.month,
              lastMonth.day,
            ).add(Duration(days: i)));

    _dates.add(items);
    return items;
  }

  setTabIndex(int index) {
    _tabIndex.add(index);

    if (index == 0) {
      EventService.tapTabCalendar();
      viewCalendarTaskEvent();
    } else if (index == 1) {
      int totalNumTask = appService.tasksValue.length;
      int totalNumTaskActive = appService.activeTaskCount();
      EventService.tapTabAllTask(
        totalNumTask: totalNumTask,
        totalNumTaskActive: totalNumTaskActive,
        totalNumTaskInactive: totalNumTask - totalNumTaskActive,
        totalNumTaskRepeat: appService.repeatingTaskCount(),
      );
    }
  }

  viewCalendarTaskEvent() {
    EventService.viewCalendarTask(
      todayNumTask: _currTasks.value.length,
      todayNumTaskRepeat: _currTasks.value
          .where((element) =>
              element.repeatAt != null && element.repeatAt!.isNotEmpty)
          .length,
      date: _dates.value[_dateIndex.value],
      viewDate: DateTime.now(),
    );
  }

  setDateIndex(int index) {
    _dateIndex.add(index);

    DateTime currDate = _dates.value[index];
    getCurrTasks(appService.tasksValue, currDate);

    EventService.tapCalendarDate(
      calendarDate: currDate,
      tapDate: DateTime.now(),
    );
  }

  List<Task> getCurrTasks(List<Task> tasks, DateTime currDate) {
    DateTime date = currDate.getDate();
    List<Task> currTasks = tasks.where((element) {
      return (!element.from.getDate().isAfter(date)) &&
          (element.until == null ||
              (!element.until!.getDate().isBefore(date))) &&
          (((element.repeatAt == null || element.repeatAt!.isEmpty) &&
                  htIsSameDay(element.from, date)) ||
              element.repeatAt!.contains(date.weekday));
    }).toList();

    _currTasks.add(currTasks);
    return currTasks;
  }

  scrollToToday() {
    getDates();
    DateTime now = DateTime.now().getDate();

    dateScrollController.animateTo(
        dateScrollOffset + (now.day == 1 ? dateWidth : 0),
        duration: const Duration(milliseconds: 350),
        curve: Curves.ease);
    setDateIndex(prevDates);
  }

  double getDonePercentage(DateTime date) {
    List<Task> tasks = appService.tasksValue;

    List<Task> currTasks = tasks.where((element) {
      return (!element.from.getDate().isAfter(date)) &&
          (element.until == null ||
              (!element.until!.getDate().isBefore(date))) &&
          (((element.repeatAt == null || element.repeatAt!.isEmpty) &&
                  htIsSameDay(element.from, date)) ||
              element.repeatAt!.contains(date.weekday));
    }).toList();

    if (currTasks.isEmpty) {
      return 0;
    }

    int done =
        currTasks.where((element) => htIsDone(date, element.doneAt)).length;

    return done / currTasks.length;
  }
}

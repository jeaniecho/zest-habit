import 'package:flutter/material.dart';
import 'package:habit_app/blocs/app_bloc.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/utils/disposable.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:rxdart/rxdart.dart';

const int prevDates = 30;
const double dateWidth = 52 + 12;

class DailyBloc extends Disposable {
  final AppBloc appBloc;
  final double deviceWidth;

  late final List<DateTime> dates;

  final BehaviorSubject<int> _dateIndex = BehaviorSubject.seeded(prevDates);
  Stream<int> get dateIndex => _dateIndex.stream;

  final BehaviorSubject<List<Task>> _currTasks = BehaviorSubject.seeded([]);
  Stream<List<Task>> get currTasks => _currTasks.stream;

  final BehaviorSubject<int> _notToday = BehaviorSubject.seeded(0);
  Stream<int> get notToday => _notToday.stream;
  Function(int) get setNotToday => _notToday.add;

  late final ScrollController dateScrollController;
  late final double dateScrollOffset;

  DailyBloc({required this.appBloc, required this.deviceWidth}) {
    dates = getDates();
    dateScrollOffset =
        (dateWidth * (prevDates + 1) - ((deviceWidth - 84) / 2)).toDouble();

    dateScrollController =
        ScrollController(initialScrollOffset: dateScrollOffset);

    appBloc.tasks.listen((tasks) {
      getCurrTasks(tasks, dates[_dateIndex.value]);
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
  }

  @override
  void dispose() {
    _dateIndex.close();
    _currTasks.close();
    _notToday.close();
    dateScrollController.dispose();
  }

  List<DateTime> getDates() {
    DateTime today = DateTime.now().getDate();
    DateTime lastMonth = today.subtract(const Duration(days: prevDates));

    List<DateTime> items = List<DateTime>.generate(
        60,
        (i) => DateTime.utc(
              lastMonth.year,
              lastMonth.month,
              lastMonth.day,
            ).add(Duration(days: i)));

    return items;
  }

  setDateIndex(int index) {
    _dateIndex.add(index);

    DateTime currDate = dates[index];
    getCurrTasks(appBloc.tasksValue, currDate);
  }

  List<Task> getCurrTasks(List<Task> tasks, DateTime currDate) {
    DateTime date = currDate.getDate();
    List<Task> currTasks = tasks.where((element) {
      return (!element.from.getDate().isAfter(date)) &&
          (element.until == null ||
              (!element.until!.getDate().isBefore(date))) &&
          (((element.repeatAt == null || element.repeatAt!.isEmpty) &&
                  isSameDay(element.from, date)) ||
              element.repeatAt!.contains(date.weekday));
    }).toList();

    _currTasks.add(currTasks);
    return currTasks;
  }

  scrollToToday() {
    dateScrollController.animateTo(dateScrollOffset,
        duration: const Duration(milliseconds: 350), curve: Curves.ease);
    setDateIndex(prevDates);
  }
}

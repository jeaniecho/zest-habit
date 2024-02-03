import 'package:flutter/material.dart';
import 'package:habit_app/blocs/app_bloc.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/utils/disposable.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:rxdart/rxdart.dart';

const int prevDates = 30;

class DailyBloc extends Disposable {
  final AppBloc appBloc;
  final double deviceWidth;

  late final List<DateTime> dates;

  final BehaviorSubject<int> _dateIndex = BehaviorSubject.seeded(prevDates);
  Stream<int> get dateIndex => _dateIndex.stream;

  final BehaviorSubject<List<Task>> _currTasks = BehaviorSubject.seeded([]);
  Stream<List<Task>> get currTasks => _currTasks.stream;

  late final ScrollController dateScrollController;

  DailyBloc({required this.appBloc, required this.deviceWidth}) {
    dates = getDates();
    dateScrollController = ScrollController(
        initialScrollOffset:
            ((52 + 8) * prevDates - ((deviceWidth - 86) / 2)).toDouble());

    appBloc.tasks.listen((tasks) {
      getCurrTasks(tasks, dates[_dateIndex.value]);
    });
  }

  @override
  void dispose() {
    _dateIndex.close();
    _currTasks.close();
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

  Future<List<Task>> getCurrTasks(List<Task> tasks, DateTime currDate) async {
    List<Task> currTasks = tasks.where((element) {
      return element.from.difference(currDate).inDays <= 0 &&
          (element.until == null ||
              (element.until!.difference(currDate).inDays >= 0)) &&
          (element.repeatAt == null ||
              element.repeatAt!.contains(currDate.weekday));
    }).toList();

    _currTasks.add(currTasks);
    return currTasks;
  }
}

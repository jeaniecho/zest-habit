import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/utils/disposable.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:rxdart/rxdart.dart';

class TaskDetailBloc extends Disposable {
  final Task task;

  late final BehaviorSubject<Task> _taskObj;
  Stream<Task> get taskObj => _taskObj.stream;
  Function(Task) get setTaskObj => _taskObj.add;
  Task get taskObjValue => _taskObj.value;

  final BehaviorSubject<bool> _isMonthly = BehaviorSubject<bool>.seeded(true);
  Stream<bool> get isWeekly => _isMonthly.stream;

  final BehaviorSubject<DateTime> _currDate =
      BehaviorSubject.seeded(DateTime.now().getDate());
  Stream<DateTime> get currDate => _currDate.stream;

  final BehaviorSubject<List<int>> _doneDates = BehaviorSubject.seeded([]);
  Stream<List<int>> get doneDates => _doneDates.stream;

  TaskDetailBloc({required this.task}) {
    _taskObj = BehaviorSubject.seeded(task);

    getDoneDatesForWeek(DateTime.now().getDate());
  }

  @override
  void dispose() {
    _taskObj.close();
    _isMonthly.close();
    _currDate.close();
    _doneDates.close();
  }

  toggleCalendarType() {
    DateTime now = DateTime.now().getDate();

    if (_isMonthly.value) {
      getDoneDatesForMonth(now);
    } else {
      getDoneDatesForWeek(now);
    }

    _currDate.add(now);
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
        .where((element) => isSameMonth(element, date))
        .map((e) => e.day)
        .toList();
    _doneDates.add(dates);
  }

  getDoneDatesForWeek(DateTime date) {
    DateTime sunday = mostRecentWeekday(date);

    List<int> dates = task.doneAt
        .where((element) =>
            element.isAfter(date.subtract(const Duration(days: 7))) &&
            element.isBefore(date.add(const Duration(days: 7))))
        .where((element) => isSameDay(sunday, mostRecentWeekday(element)))
        .map((e) => e.day)
        .toList();
    _doneDates.add(dates);
  }
}

import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/utils/disposable.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:rxdart/rxdart.dart';

class TaskDetailBloc extends Disposable {
  final Task task;

  final BehaviorSubject<bool> _isMonthly = BehaviorSubject<bool>.seeded(true);
  Stream<bool> get isWeekly => _isMonthly.stream;

  final BehaviorSubject<DateTime> _currDate =
      BehaviorSubject.seeded(DateTime.now().getDate());
  Stream<DateTime> get currDate => _currDate.stream;

  final BehaviorSubject<List<int>> _doneDates = BehaviorSubject.seeded([]);
  Stream<List<int>> get doneDates => _doneDates.stream;

  TaskDetailBloc({required this.task}) {
    getDoneDates(DateTime.now().getDate());
  }

  @override
  void dispose() {
    _isMonthly.close();
    _currDate.close();
    _doneDates.close();
  }

  toggleCalendarType() {
    _currDate.add(DateTime.now().getDate());
    _isMonthly.add(!_isMonthly.value);
  }

  changeMonth(int move) {
    DateTime newDate =
        DateTime(_currDate.value.year, _currDate.value.month + move);
    _currDate.add(newDate);

    getDoneDates(newDate);
  }

  changeWeek(int move) {
    DateTime newWeek = DateTime(_currDate.value.year, _currDate.value.month,
        _currDate.value.day + move * 7);
    _currDate.add(newWeek);

    getDoneDates(newWeek);
  }

  getDoneDates(DateTime date) {
    List<int> dates = task.doneAt
        .where((element) => isSameMonth(element, date))
        .map((e) => e.day)
        .toList();
    _doneDates.add(dates);
  }
}

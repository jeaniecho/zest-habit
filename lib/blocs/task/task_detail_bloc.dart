import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/utils/disposable.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:rxdart/rxdart.dart';

class TaskDetailBloc extends Disposable {
  final Task task;

  final BehaviorSubject<bool> _isMonthly = BehaviorSubject<bool>.seeded(true);
  Stream<bool> get isMonthly => _isMonthly.stream;

  final BehaviorSubject<DateTime> _currMonth = BehaviorSubject.seeded(
      DateTime(DateTime.now().year, DateTime.now().month));
  Stream<DateTime> get currMonth => _currMonth.stream;

  final BehaviorSubject<List<int>> _doneDates = BehaviorSubject.seeded([]);
  Stream<List<int>> get doneDates => _doneDates.stream;

  TaskDetailBloc({required this.task}) {
    getDoneDates(DateTime(DateTime.now().year, DateTime.now().month));
  }

  @override
  void dispose() {
    _isMonthly.close();
    _currMonth.close();
    _doneDates.close();
  }

  toggleCalendarType() {
    _currMonth.add(DateTime(DateTime.now().year, DateTime.now().month));
    _isMonthly.add(!_isMonthly.value);
  }

  changeMonth(int move) {
    DateTime newMonth =
        DateTime(_currMonth.value.year, _currMonth.value.month + move);
    _currMonth.add(newMonth);

    getDoneDates(newMonth);
  }

  getDoneDates(DateTime month) {
    List<int> dates = task.doneAt
        .where((element) => isSameMonth(element, month))
        .map((e) => e.day)
        .toList();
    _doneDates.add(dates);
  }
}

import 'package:habit_app/utils/disposable.dart';
import 'package:rxdart/rxdart.dart';

const int prevDates = 30;

class DailyBloc extends Disposable {
  late final List<DateTime> dates;

  final BehaviorSubject<int> _dateIndex = BehaviorSubject.seeded(prevDates);
  Stream<int> get dateIndex => _dateIndex.stream;
  Function get setDateIndex => _dateIndex.add;

  DailyBloc() {
    dates = getDates();
  }

  @override
  void dispose() {
    _dateIndex.close();
  }

  List<DateTime> getDates() {
    DateTime today = DateTime.now();
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
}

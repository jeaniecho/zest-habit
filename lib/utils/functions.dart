import 'package:intl/intl.dart';

const int firstDayOfWeek = 0; // 0: Sunday, 1: Monday

const List daysList = [
  ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
  ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
];

const List dayNumsList = [
  [7, 1, 2, 3, 4, 5, 6],
  [1, 2, 3, 4, 5, 6, 7]
];

List<String> days = daysList[firstDayOfWeek];
List<int> dayNums = dayNumsList[firstDayOfWeek];

String weekdayToText(int weekday) {
  return days[dayNums.indexOf(weekday)];
}

String repeatAtToText(List<int>? repeatAt) {
  if (repeatAt == null || repeatAt.isEmpty) {
    return 'One time';
  } else if (repeatAt.length == 7) {
    return 'Everyday';
  } else if (repeatAt.length == 5 &&
      !(repeatAt.contains(6) || repeatAt.contains(7))) {
    return 'Weekday';
  } else if (repeatAt.length == 2 &&
      repeatAt.contains(6) &&
      repeatAt.contains(7)) {
    return 'Weekend';
  }

  return repeatAt.map((e) => days[dayNums.indexOf(e)]).join(', ');
}

String untilToText(DateTime? until, {bool long = false}) {
  if (until == null) {
    return 'Forever';
  } else {
    return 'until ${DateFormat('${long ? 'yy' : ''}yy.MM.dd').format(until)}';
  }
}

bool isSameDay(DateTime one, DateTime two) {
  return one.day == two.day && one.month == two.month && one.year == two.year;
}

bool isSameWeek(DateTime one, DateTime two) {
  return one.month == two.month &&
      one.year == two.year &&
      weekOfMonth(one) == weekOfMonth(two);
}

bool isSameMonth(DateTime one, DateTime two) {
  return one.month == two.month && one.year == two.year;
}

bool isDone(DateTime currDate, List<DateTime> doneAt) {
  try {
    doneAt.firstWhere((element) => isSameDay(element, currDate));
    return true;
  } catch (e) {
    return false;
  }
}

/// The [weekday] may be 0 for Sunday, 1 for Monday, etc. up to 7 for Sunday.
DateTime mostRecentWeekday(DateTime date, {int weekday = firstDayOfWeek}) =>
    DateTime(date.year, date.month, date.day - ((date.weekday - weekday) % 7));

int weekOfMonth(DateTime date) {
  DateTime firstDayOfTheMonth = DateTime(date.year, date.month, 1);
  int sum = date.day + firstDayOfTheMonth.weekday - firstDayOfWeek;
  if (sum % 7 == 0) {
    return sum ~/ 7;
  } else {
    return sum ~/ 7 + 1;
  }
}

List<int> sortRepeatAt(List<int> repeatAt) {
  List<int> copy = repeatAt.toList();
  copy.sort();

  if (firstDayOfWeek == 0 && copy.contains(7)) {
    copy.remove(7);
    copy.insert(0, 7);
  }

  return copy;
}

String stndrd(int num) {
  if (num % 10 == 1) {
    return 'st';
  } else if (num % 10 == 2) {
    return 'nd';
  } else if (num % 10 == 3) {
    return 'rd';
  } else {
    return 'th';
  }
}

int progressPercentage(DateTime from, DateTime until, List<DateTime> doneAt) {
  int difference = until.difference(from).inDays;

  if (difference == 0) {
    return 0;
  }

  return ((doneAt.length / difference) * 100).round();
}

extension DateTimeExtension on DateTime {
  DateTime getDate() {
    return DateTime(year, month, day);
  }
}

extension DurationExtension on Duration {
  String toShortString() {
    String negativeSign = isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitsHours = twoDigits(inHours);
    String twoDigitMinutes = twoDigits(inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(inSeconds.remainder(60).abs());

    return "$negativeSign${twoDigitsHours == '00' ? '' : '$twoDigitsHours:'}$twoDigitMinutes:$twoDigitSeconds";
  }
}

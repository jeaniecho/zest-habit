import 'package:intl/intl.dart';

String weekdayToText(int weekday) {
  List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return days[weekday - 1];
}

String repeatAtToText(List<int>? repeatAt) {
  if (repeatAt == null) {
    return 'One time';
  } else if (repeatAt.length == 7) {
    return 'Everyday';
  } else if (repeatAt == [1, 2, 3, 4, 5]) {
    return 'Weekday';
  } else if (repeatAt == [6, 7]) {
    return 'Weekend';
  }

  return '';
}

String untilToText(DateTime? until) {
  if (until == null) {
    return 'Forever';
  } else {
    return 'until ${DateFormat.yMd(until)}';
  }
}

bool isSameDay(DateTime one, DateTime two) {
  return one.day == two.day && one.month == two.month && one.year == two.year;
}

bool isSameWeek(DateTime one, DateTime two) {
  return one.month == two.month &&
      one.year == two.year &&
      weekOfMonth(one, 0) == weekOfMonth(two, 0);
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
DateTime mostRecentWeekday(DateTime date, int weekday) =>
    DateTime(date.year, date.month, date.day - (date.weekday - weekday) % 7);

int weekOfMonth(DateTime date, int weekday) {
  DateTime firstDayOfTheMonth = DateTime(date.year, date.month, 1);
  int sum =
      firstDayOfTheMonth.weekday - ((date.weekday - weekday) % 7) + date.day;
  if (sum % 7 == 0) {
    return sum ~/ 7;
  } else {
    return sum ~/ 7 + 1;
  }
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

extension DateTimeExtension on DateTime {
  DateTime getDate() {
    return DateTime(year, month, day);
  }
}

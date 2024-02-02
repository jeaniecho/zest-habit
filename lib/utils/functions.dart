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

bool isSameDay(DateTime one, DateTime two) {
  return one.day == two.day && one.month == two.month && one.year == two.year;
}

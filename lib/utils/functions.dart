String weekdayToText(int weekday) {
  List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return days[weekday - 1];
}

enum RepeatType {
  everyday('Everyday'),
  weekday('Weekday'),
  weekend('Weekend'),
  custom('Custom');

  final String text;
  const RepeatType(this.text);
}

enum TimeType {
  hour,
  minute,
  second,
}

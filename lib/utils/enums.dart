enum RepeatType {
  everyday('Everyday', [1, 2, 3, 4, 5, 6, 7]),
  weekday('Weekday', [1, 2, 3, 4, 5]),
  weekend('Weekend', [6, 7]),
  custom('Custom', [1, 3, 5]);

  final String text;
  final List<int> days;
  const RepeatType(this.text, this.days);
}

enum TimeType {
  hour,
  minute,
  second,
}

enum SubscriptionType {
  monthly,
  yearly,
  free,
}

enum SubscriptionLocation {
  onboarding,
  secondSession,
  bottomBanner,
  alarmDialog,
  timerDialog,
  addDialog,
  duplicateDialog,
}

enum ModeType {
  light,
  dark,
}

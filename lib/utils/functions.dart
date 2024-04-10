import 'package:habit_app/utils/enums.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';

const int firstDayOfWeek = 0; // 0: Sunday, 1: Monday
const int taskLimit = 3;

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

String htWeekdayToText(int weekday) {
  return days[dayNums.indexOf(weekday)];
}

String htRepeatAtToText(List<int>? repeatAt) {
  if (repeatAt == null || repeatAt.isEmpty) {
    return 'One time';
  }

  repeatAt = htSortRepeatAt(repeatAt);
  if (repeatAt.length == 7) {
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

String htUntilToText(DateTime? until, {bool long = false}) {
  if (until == null) {
    return 'Forever';
  } else {
    return 'Until ${DateFormat('${long ? 'yy' : ''}yy.MM.dd').format(until)}';
  }
}

bool htIsSameDay(DateTime one, DateTime two) {
  return one.day == two.day && one.month == two.month && one.year == two.year;
}

bool htIsSameWeek(DateTime one, DateTime two) {
  return one.month == two.month &&
      one.year == two.year &&
      htWeekOfMonth(one) == htWeekOfMonth(two);
}

bool htIsSameMonth(DateTime one, DateTime two) {
  return one.month == two.month && one.year == two.year;
}

bool htIsDone(DateTime currDate, List<DateTime> doneAt) {
  try {
    doneAt.firstWhere((element) => htIsSameDay(element, currDate));
    return true;
  } catch (e) {
    return false;
  }
}

/// The [weekday] may be 0 for Sunday, 1 for Monday, etc. up to 7 for Sunday.
DateTime htMostRecentWeekday(DateTime date, {int weekday = firstDayOfWeek}) =>
    DateTime(date.year, date.month, date.day - ((date.weekday - weekday) % 7));

int htWeekOfMonth(DateTime date) {
  DateTime firstDayOfTheMonth = DateTime(date.year, date.month, 1);
  int sum = date.day + firstDayOfTheMonth.weekday - firstDayOfWeek;
  if (sum % 7 == 0) {
    return sum ~/ 7;
  } else {
    return sum ~/ 7 + 1;
  }
}

List<int> htSortRepeatAt(List<int> repeatAt) {
  List<int> copy = repeatAt.toList();
  copy.sort();

  if (firstDayOfWeek == 0 && copy.contains(7)) {
    copy.remove(7);
    copy.insert(0, 7);
  }

  return copy;
}

RepeatType htGetRepeatType(List<int> repeatAt) {
  if (repeatAt.length == 7) {
    return RepeatType.everyday;
  } else if (repeatAt.length == 5 &&
      !(repeatAt.contains(6) || repeatAt.contains(7))) {
    return RepeatType.weekday;
  } else if (repeatAt.length == 2 &&
      repeatAt.contains(6) &&
      repeatAt.contains(7)) {
    return RepeatType.weekend;
  } else {
    return RepeatType.custom;
  }
}

int getLastDateOfMonth(DateTime dateTime) {
  return (dateTime.month < 12
          ? DateTime(dateTime.year, dateTime.month + 1, 0)
          : DateTime(dateTime.year + 1, 1, 0))
      .day;
}

SubscriptionType getSubscriptionType(List<PurchaseDetails> purchases) {
  if (purchases
      .where((element) => element.productID.contains('monthly'))
      .isNotEmpty) {
    return SubscriptionType.monthly;
  } else if (purchases
      .where((element) => element.productID.contains('yearly'))
      .isNotEmpty) {
    return SubscriptionType.yearly;
  } else {
    return SubscriptionType.free;
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

int progressPercentage(DateTime from, DateTime until, List<DateTime> doneAt) {
  int difference = until.difference(from).inDays;

  if (difference == 0) {
    return 0;
  }

  return ((doneAt.length / difference) * 100).round();
}

String subscriptionPriceFormat(double price, String currencySymbol) {
  NumberFormat formatter = NumberFormat.decimalPatternDigits(
      decimalDigits: price.toString().contains('.') ? 2 : 0);

  return currencySymbol + formatter.format(price);
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

    return "$negativeSign$twoDigitsHours:$twoDigitMinutes:$twoDigitSeconds";
  }
}

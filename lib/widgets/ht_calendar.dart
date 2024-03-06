import 'package:flutter/material.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class HTCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onSelected;
  final DateTime? firstDay;
  final DateTime? lastDay;
  const HTCalendar({
    super.key,
    required this.selectedDate,
    required this.onSelected,
    this.firstDay,
    this.lastDay,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: HTEdgeInsets.bottom16,
      child: Container(
        padding: HTEdgeInsets.all16,
        decoration: BoxDecoration(
          color: htGreys(context).grey010,
          borderRadius: HTBorderRadius.circular10,
        ),
        child: TableCalendar(
          focusedDay: selectedDate,
          firstDay: firstDay ?? DateTime(2000),
          lastDay: lastDay ?? DateTime(2101),
          currentDay: DateTime.now().getDate(),
          selectedDayPredicate: (day) {
            return isSameDay(selectedDate, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            onSelected(selectedDay);
          },
          daysOfWeekHeight: 18,
          daysOfWeekStyle: DaysOfWeekStyle(
            dowTextFormatter: (date, locale) {
              return DateFormat('EEE').format(date).toUpperCase();
            },
            weekdayStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: htGreys(context).grey040,
            ),
            weekendStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: htGreys(context).grey040,
            ),
          ),
          availableGestures: AvailableGestures.horizontalSwipe,
          headerStyle: HeaderStyle(
            titleTextStyle: HTTypoToken.subtitleLarge.textStyle
                .copyWith(color: htGreys(context).grey080, height: 1),
            formatButtonVisible: false,
            headerMargin: HTEdgeInsets.vertical10,
            headerPadding: HTEdgeInsets.zero,
            leftChevronIcon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: htGreys(context).black,
              size: 22,
            ),
            rightChevronIcon: Icon(
              Icons.arrow_forward_ios_rounded,
              color: htGreys(context).black,
              size: 22,
            ),
            titleCentered: true,
          ),
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            cellMargin: HTEdgeInsets.all2,
            defaultTextStyle: HTTypoToken.bodyXLarge.textStyle
                .copyWith(color: htGreys(context).grey080),
            weekendTextStyle: HTTypoToken.bodyXLarge.textStyle
                .copyWith(color: htGreys(context).grey080),
            todayTextStyle: HTTypoToken.subtitleXLarge.textStyle,
            selectedTextStyle: HTTypoToken.headlineSmall.textStyle.copyWith(
              color: htGreys(context).white,
              fontWeight: FontWeight.w500,
            ),
            disabledTextStyle: HTTypoToken.bodyLarge.textStyle.copyWith(
              color: htGreys(context).grey030,
              fontWeight: FontWeight.w500,
            ),
            todayDecoration: const BoxDecoration(shape: BoxShape.circle),
            selectedDecoration: BoxDecoration(
              color: htGreys(context).black,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

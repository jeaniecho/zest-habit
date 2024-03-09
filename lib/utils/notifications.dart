// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class HTNotification {
  HTNotification._();

  static FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static init() async {
    DarwinInitializationSettings iosInitSettings =
        const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    InitializationSettings initSettings = InitializationSettings(
      iOS: iosInitSettings,
    );

    await plugin.initialize(initSettings);
  }

  static requestNotificationPermission() {
    plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static Future<void> showNotification() async {
    const NotificationDetails notificationDetails = NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        presentBanner: true,
      ),
    );

    await plugin.show(
      0,
      'Zest',
      'Zest Notification Test',
      notificationDetails,
    );
  }

  static Future<void> scheduleNotification(Task task) async {
    tz.initializeTimeZones();
    tz.setLocalLocation(
        tz.getLocation(await FlutterTimezone.getLocalTimezone()));
    final tz.TZDateTime scheduledDate = toTZDateTime(task.alarmTime!);

    const NotificationDetails notificationDetails = NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        presentBanner: true,
      ),
    );

    List<int> repeatDays = task.repeatAt ?? [];

    if (repeatDays.length == 7) {
      // everyday
      await plugin.zonedSchedule(
        task.id * 10,
        (task.emoji == null ? '' : '${task.emoji!} ') + task.title,
        'Reminding you to complete this task!',
        scheduledDate,
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } else if (repeatDays.isEmpty) {
      // one time
      await plugin.zonedSchedule(
        task.id * 10,
        (task.emoji == null ? '' : '${task.emoji!} ') + task.title,
        'Reminding you to complete this task!',
        scheduledDate,
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } else {
      // multiple weekly
      List<tz.TZDateTime> dates =
          getCorrespondingDates(scheduledDate, repeatDays);

      for (tz.TZDateTime date in dates) {
        await plugin.zonedSchedule(
          task.id * 10 + date.weekday,
          (task.emoji == null ? '' : '${task.emoji!} ') + task.title,
          'Reminding you to complete this task!',
          date,
          notificationDetails,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
      }
    }
  }

  static Future<void> cancelNotification(int id, List<int> repeatAt) async {
    if (repeatAt.isNotEmpty) {
      for (int i in repeatAt) {
        await plugin.cancel(id * 10 + i);
      }
    } else {
      await plugin.cancel(id * 10);
    }
  }

  static Future<void> cancelAllNotifications() async {
    await plugin.cancelAll();
  }

  static Future<List<ActiveNotification>> getActiveNotifications() async {
    return await plugin.getActiveNotifications();
  }

  static Future<List<PendingNotificationRequest>>
      getPendingNotifications() async {
    return await plugin.pendingNotificationRequests();
  }
}

List<tz.TZDateTime> getCorrespondingDates(
    DateTime startDate, List<int> repeatDays) {
  List<tz.TZDateTime> dates = [];

  for (int i = 0; i < 7; i++) {
    DateTime date = startDate.add(Duration(days: i));

    if (repeatDays.contains(date.weekday)) {
      dates.add(toTZDateTime(date));
    }
  }

  return dates;
}

tz.TZDateTime toTZDateTime(DateTime dateTime) {
  return tz.TZDateTime.local(
    dateTime.year,
    dateTime.month,
    dateTime.day,
    dateTime.hour,
    dateTime.minute,
  );
}

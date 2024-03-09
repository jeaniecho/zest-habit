// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
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

  static Future<void> scheduleNotification({
    required List<int> repeatDays,
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    tz.initializeTimeZones();
    tz.setLocalLocation(
        tz.getLocation(await FlutterTimezone.getLocalTimezone()));
    final tz.TZDateTime scheduledDate = toTZDateTime(dateTime);

    const NotificationDetails notificationDetails = NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        presentBanner: true,
      ),
    );

    if (repeatDays.length == 7) {
      // everyday
      await plugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } else if (repeatDays.isEmpty) {
      // one time
      await plugin.zonedSchedule(
        id,
        title,
        body,
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
          id * 10 + date.weekday,
          title,
          body,
          date,
          notificationDetails,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
      }
    }
  }

  static Future<void> cancelNotification(int id, List<int>? repeatAt) async {
    if (repeatAt != null && repeatAt.isNotEmpty) {
      for (int i in repeatAt) {
        await plugin.cancel(id * 10 + i);
      }
    } else {
      await plugin.cancel(id);
    }
  }

  static Future<void> cancelAllNotifications() async {
    await plugin.cancelAll();
  }

  static viewNotifiations() async {
    if (kDebugMode) {
      print(await plugin.getActiveNotifications());
      print((await plugin.pendingNotificationRequests()).map((e) => e.title));
    }
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

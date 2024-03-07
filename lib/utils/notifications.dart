import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:habit_app/utils/enums.dart';
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
    final tz.TZDateTime scheduledDate = tz.TZDateTime.local(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
    );

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
    }
  }

  static Future<void> cancelNotification(int id) async {
    await plugin.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await plugin.cancelAll();
  }
}

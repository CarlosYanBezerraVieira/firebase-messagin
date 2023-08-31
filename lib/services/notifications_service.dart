import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';
import 'package:notifications/models/custom_notificaion.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

import '../util/routes.dart';

class NotificationsService {
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  late AndroidNotificationDetails androidDetails;

  NotificationsService() {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _setuoNotifications();
  }

  void _setuoNotifications() async {
    await _setupTimezone();
    await _initializeNotifications();
  }

  _setupTimezone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  _initializeNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await localNotificationsPlugin.initialize(
      const InitializationSettings(
        android: android,
      ),
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
  }

  _onDidReceiveNotificationResponse(NotificationResponse? details) {
    if (details?.payload != null && details!.payload!.isNotEmpty) {
      Navigator.of(Routes.navigatorKey!.currentContext!)
          .pushReplacementNamed(details.payload!);
    }
  }

  // showNotification(CustomNotificaion notification) {
  //   androidDetails = const AndroidNotificationDetails(
  //     'lembretes_notifications',
  //     'Lembretes',
  //     channelDescription: 'Este canal é para lembretes',
  //     importance: Importance.max,
  //     priority: Priority.max,
  //     enableVibration: true,
  //   );

  //   localNotificationsPlugin.show(
  //     notification.id,
  //     notification.title,
  //     notification.body,
  //     NotificationDetails(
  //       android: androidDetails,
  //     ),
  //     payload: notification.payload,
  //   );
  // }

  showNotificationScheduling(CustomNotificaion notification) {
    final date = DateTime.now().add(const Duration(seconds: 5));
    androidDetails = const AndroidNotificationDetails(
      'lembretes_notifications',
      'Lembretes',
      channelDescription: 'Este canal é para lembretes',
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
    );

    localNotificationsPlugin.zonedSchedule(
      notification.id,
      notification.title,
      notification.body,
      tz.TZDateTime.from(date, tz.local),
      NotificationDetails(
        android: androidDetails,
      ),
      payload: notification.payload,
      androidScheduleMode: AndroidScheduleMode.exact,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  checkForNotification() async {
    final details =
        await localNotificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      _onDidReceiveNotificationResponse(details.notificationResponse);
    }
  }
}

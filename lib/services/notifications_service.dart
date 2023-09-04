import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';
import 'package:notifications/models/custom_notificaion.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

import '../util/routes.dart';

class NotificationsService {
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  late AndroidNotificationDetails androidDetails;
  late DarwinNotificationDetails iosDetails;

  NotificationsService() {
    requestPermission();
  }

  requestPermission() async {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
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
    final DarwinInitializationSettings ios = DarwinInitializationSettings(
        onDidReceiveLocalNotification: _onDidReceiveLocalNotification);
    await localNotificationsPlugin.initialize(
      InitializationSettings(
        android: android,
        iOS: ios,
      ),
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
  }

  void _onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    if (payload != null) {
      showDialog(
        context: Routes.navigatorKey!.currentContext!,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(title ?? ""),
          content: Text(body ?? ""),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.of(Routes.navigatorKey!.currentContext!)
                    .pushNamed(payload);
              },
            )
          ],
        ),
      );
    }
  }

  _onDidReceiveNotificationResponse(NotificationResponse? details) {
    if (details?.payload != null && details!.payload!.isNotEmpty) {
      Navigator.of(Routes.navigatorKey!.currentContext!)
          .pushNamed(details.payload!);
    }
  }

  showNotification(CustomNotificaion notification) {
    androidDetails = const AndroidNotificationDetails(
      'lembretes_notifications',
      'Lembretes',
      channelDescription: 'Este canal é para lembretes',
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
    );
    iosDetails = const DarwinNotificationDetails(
      threadIdentifier: 'Lembretes',
    );

    localNotificationsPlugin.show(
      notification.id,
      notification.title,
      notification.body,
      NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
      payload: notification.payload,
    );
  }

  // showNotificationScheduling(CustomNotificaion notification) {
  //   final date = DateTime.now().add(const Duration(seconds: 5));
  //   androidDetails = const AndroidNotificationDetails(
  //     'lembretes_notifications',
  //     'Lembretes',
  //     channelDescription: 'Este canal é para lembretes',
  //     importance: Importance.max,
  //     priority: Priority.max,
  //     enableVibration: true,
  //   );

  //   localNotificationsPlugin.zonedSchedule(
  //     notification.id,
  //     notification.title,
  //     notification.body,
  //     tz.TZDateTime.from(date, tz.local),
  //     NotificationDetails(
  //       android: androidDetails,
  //     ),
  //     payload: notification.payload,
  //     androidScheduleMode: AndroidScheduleMode.exact,
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //   );
  // }

  checkForNotification() async {
    final details =
        await localNotificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      _onDidReceiveNotificationResponse(details.notificationResponse);
    }
  }
}

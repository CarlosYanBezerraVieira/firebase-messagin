import 'package:flutter/widgets.dart';
import 'package:notifications/models/custom_notificaion.dart';
import 'package:notifications/services/notifications_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../util/routes.dart';

class FirebaseMessagingService {
  final NotificationsService _notificationsService;
  FirebaseMessagingService(this._notificationsService);

  Future<void> initialize() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    getDeviceFirebaseToken();
    _onMessage();
    _onMessageOpenedApp();
  }

  void getDeviceFirebaseToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    debugPrint("===============");
    debugPrint("Token $token");
    debugPrint("===============");
  }

  void _onMessage() {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      AppleNotification? ios = message.notification?.apple;

      if (android != null && notification != null) {
        _notificationsService.showNotification(
          CustomNotificaion(
            id: android.hashCode,
            title: notification.title,
            body: notification.body,
            payload: message.data['route'] ?? "",
          ),
        );
      }
      if (ios != null && notification != null) {
        _notificationsService.showNotification(
          CustomNotificaion(
            id: ios.hashCode,
            title: notification.title,
            body: notification.body,
            payload: message.data['route'] ?? "",
          ),
        );
      }
    });
  }

  _onMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen(_goToPageAfterMessage);
  }

  _goToPageAfterMessage(message) {
    final String route = message.data['route'] ?? '';
    if (route.isNotEmpty) {
      Routes.navigatorKey?.currentState?.pushNamed(route);
    }
  }
}

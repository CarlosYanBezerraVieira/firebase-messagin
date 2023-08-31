import 'package:flutter/material.dart';
import 'package:notifications/pages/home.dart';
import 'package:notifications/pages/notifications.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list =
      <String, WidgetBuilder>{
    '/home': (_) => const Home(),
    '/notifications': (_) => const Notifications(),
  };

  static String init = '/home';

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}

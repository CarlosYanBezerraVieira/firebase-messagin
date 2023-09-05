import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notifications/services/firebase_messaging_service.dart';
import 'package:notifications/services/notifications_service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'util/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    Provider<NotificationsService>(
      create: (context) => NotificationsService(),
    ),
    Provider<FirebaseMessagingService>(
        create: (context) =>
            FirebaseMessagingService(context.read<NotificationsService>()))
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initializeFirebaseMessaging();
    checkForNotification();
    super.initState();
  }

  initializeFirebaseMessaging() async {
    await Provider.of<FirebaseMessagingService>(context, listen: false)
        .initialize();
  }

  checkForNotification() async {
    await Provider.of<NotificationsService>(context, listen: false)
        .requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: Routes.list,
      initialRoute: Routes.init,
      navigatorKey: Routes.navigatorKey,
    );
  }
}

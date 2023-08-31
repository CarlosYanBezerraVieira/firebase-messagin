import 'package:flutter/material.dart';
import 'package:notifications/models/custom_notificaion.dart';
import 'package:notifications/services/notifications_service.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool value = false;

  showNotification() {
    setState(() {
      value = !value;
      if (value) {
        Provider.of<NotificationsService>(context, listen: false)
            .showNotificationScheduling(CustomNotificaion(
          id: 1,
          title: 'Teste',
          body: 'Acesse o app',
          payload: '/notifications',
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Lembrar mais tarde"),
              Checkbox(
                  value: value,
                  onChanged: (value) {
                    showNotification();
                  }),
            ],
          )
        ],
      ),
    );
  }
}

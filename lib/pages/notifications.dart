import 'package:flutter/material.dart';

import '../util/routes.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(Routes.navigatorKey!.currentContext!).pop();
            },
            icon: const Icon(Icons.chevron_left)),
        title: const Text('Notificações'),
      ),
      body: const Center(child: Text("Notificações")),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/notification/push_notification_service.dart';


class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<ChatPushNotificationService>(context);
    final items = service.items;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minhas Notificações"),
      ),
      body: ListView.builder(
        itemCount: service.itensCount, itemBuilder: (ctx, index) =>
          ListTile(
            title: Text(items[index].tittle),
            subtitle: Text(items[index].body),
            onTap: () => service.remove(index),
          ),
      )
      ,
    );
  }
}

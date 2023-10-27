import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

import '../../models/chat_notification.dart';

class ChatPushNotificationService with ChangeNotifier {
  List<ChatNotification> _Items = [];

  int get itensCount {
    return _Items.length;
  }

  List<ChatNotification> get items {
    return [..._Items];
  }

  void add(ChatNotification notification) {
    _Items.add(notification);
    notifyListeners();
  }

  void remove(int i) {
    _Items.removeAt(i);
    notifyListeners();
  }

  // push Notification

  Future<void> init() async {
    await _configureForeground();
  }

  Future<bool> get _isAuthorized async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<void> _configureForeground() async {
    if (await _isAuthorized) {
      FirebaseMessaging.onMessage.listen((event) {
        if (event.notification == null) return;
        add(ChatNotification(
          tittle: event.notification!.title ?? "Não informado!",
          body: event.notification!.body ?? "Não informado!",
        ));
      });
    }
  }
}

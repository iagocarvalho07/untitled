import 'package:flutter/cupertino.dart';

import '../../models/chat_notification.dart';

class ChatPushNotificationService with ChangeNotifier{
  List<ChatNotification> _Items =[];

  int get itensCount{
    return _Items.length;
  }

  List<ChatNotification> get items{
    return [..._Items];
  }
  void add(ChatNotification notification){
    _Items.add(notification);
    notifyListeners();
  }

  void remove(int i){
    _Items.removeAt(i);
    notifyListeners();
  }
}
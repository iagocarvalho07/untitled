import 'dart:async';
import 'dart:math';

import '../../models/chat_massage.dart';
import '../../models/chat_user.dart';
import 'chat_service.dart';



class ChatMockService implements ChatService {
  static final List<ChatMessage> _msg = [
    ChatMessage(
      id: "1",
      text: "bom dia",
      createdAt: DateTime.now(),
      userId: "123",
      userName: "iago",
      userImageUrl: "assets/imagens/avatar.png",
    ),
    ChatMessage(
      id: "2",
      text: "bom dia iago, teremos reunição hoje?",
      createdAt: DateTime.now(),
      userId: "1234",
      userName: "kesia",
      userImageUrl: "assets/imagens/avatar.png",
    ),
    ChatMessage(
      id: "1",
      text: "sim teremos",
      createdAt: DateTime.now(),
      userId: "1234",
      userName: "iago",
      userImageUrl: "assets/imagens/avatar.png",
    )
  ];
  static MultiStreamController<List<ChatMessage>>? _controller;
  static final _msgsStrem = Stream<List<ChatMessage>>.multi((controler) {
    _controller = controler;
    controler.add(_msg);
  });

  @override
  Stream<List<ChatMessage>> messagesStrem() {
    return _msgsStrem;
  }

  @override
  Future<ChatMessage> save(String text, ChatUser user) async {
    final newMsg = ChatMessage(
      id: Random().nextDouble().toString(),
      text: text,
      createdAt: DateTime.now(),
      userId: user.id,
      userName: user.name,
      userImageUrl: user.imageUrl,
    );
    _msg.add(newMsg);
    _controller?.add(_msg.reversed.toList());
    return newMsg;
  }
}

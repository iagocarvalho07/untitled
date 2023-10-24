
import '../../models/chat_massage.dart';
import '../../models/chat_user.dart';
import 'chat_mock_service.dart';

abstract class ChatService{
  Stream<List<ChatMessage>> messagesStrem();

  Future<ChatMessage> save(String text, ChatUser user, );

  factory ChatService(){
    return ChatMockService();
  }
}
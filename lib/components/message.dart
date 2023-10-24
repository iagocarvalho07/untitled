
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/chat_massage.dart';
import '../services/auth/auth_service.dart';
import '../services/chat/chat_service.dart';
import 'menssage_bable.dart';

class Messagens extends StatelessWidget {
  const Messagens({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService().currentUser;
    return StreamBuilder<List<ChatMessage>>(
      stream: ChatService().messagesStrem(),
      builder: (ctx, sbapshot) {
        if (sbapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!sbapshot.hasData || sbapshot.data!.isEmpty) {
          return const Center(
            child: Text("Sem Mensagens"),
          );
        } else {
          final msg = sbapshot.data!;
          return ListView.builder(
            reverse: true,
            itemCount: msg.length,
            itemBuilder: (ctx, index) => MenssageBable(
              key: ValueKey(msg[index].id),
              message: msg[index],
              belognsToCurrentUser: currentUser?.id == msg[index].userId,
            ),
          );
        }
      },
    );
  }
}


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/auth/auth_service.dart';
import '../services/chat/chat_service.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String _entreedMenssage = "";
  final _messageControler = TextEditingController();

  Future<void> _sendmessage() async {
    final user = AuthService().currentUser;
    if (user != null) {
      ChatService().save(_entreedMenssage, user);
      _messageControler.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageControler,
            onChanged: (msg) => setState(() => _entreedMenssage = msg),
            decoration: const InputDecoration(labelText: "Enviar Mensagem..."),
          ),
        ),
        IconButton(
            onPressed: _entreedMenssage.trim().isEmpty ? null : _sendmessage,
            icon: const Icon(Icons.send))
      ],
    );
  }
}

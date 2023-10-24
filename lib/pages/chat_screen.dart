
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../components/message.dart';
import '../components/new_message.dart';
import '../services/auth/auth_service.dart';
import '../services/notification/push_notification_service.dart';
import 'notification_screen.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .primary,
        title: Text("Chat App Iago"),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton(
              items: [
                DropdownMenuItem(
                    value: "logout",
                    child: Container(
                      child: Row(
                        children: [
                          Icon(Icons.exit_to_app),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Sair")
                        ],
                      ),
                    ))
              ],
              onChanged: (value) {
                if (value == "logout") {
                  AuthService().logout();
                }
              },
              icon: Icon(
                Icons.more_vert,
                color: Theme
                    .of(context)
                    .colorScheme
                    .onPrimary,
              ),
            ),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                    return NotificationScreen();
                  }));
                },
                icon: Icon(Icons.notifications),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: CircleAvatar(
                  maxRadius: 8,
                  backgroundColor: Colors.red.shade800,
                  child: Text(
                    "${Provider
                        .of<ChatPushNotificationService>(context)
                        .itensCount}",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              )
            ],
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Messagens(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}

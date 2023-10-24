import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../models/chat_user.dart';
import '../services/auth/auth_service.dart';
import 'auth_screen.dart';
import 'chat_screen.dart';
import 'loading_screen.dart';

class AuthOrAppScreen extends StatelessWidget {
  const AuthOrAppScreen({super.key});

  Future<void> init(BuildContext context) async {
    Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(context),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else {
          return StreamBuilder<ChatUser?>(
            stream: AuthService().userChanges,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingScreen();
              } else {
                return snapshot.hasData ? const ChatPage() : const AuthScreen();
              }
            },
          );
        }
      },
    );
  }
}

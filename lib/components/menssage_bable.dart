import 'dart:io';


import 'package:flutter/material.dart';

import '../models/chat_massage.dart';

class MenssageBable extends StatelessWidget {
  static const _defaultImage = "assets/imagens/avatar.png";
  final ChatMessage message;
  final bool belognsToCurrentUser;

  const MenssageBable(
      {super.key, required this.message, required this.belognsToCurrentUser});

  Widget _showUserImage(String ImageUrl) {
    ImageProvider? provider;
    final uir = Uri.parse(ImageUrl);
    if (uir.path.contains(_defaultImage)) {
      provider = AssetImage(_defaultImage);
    } else if (uir.scheme.contains('http')) {
      provider = NetworkImage(uir.toString());
    } else {
      provider = FileImage(File(uir.toString()));
    }
    return CircleAvatar(backgroundImage: provider);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: belognsToCurrentUser
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color:
                    belognsToCurrentUser ? Colors.grey.shade300 : Colors.cyan,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: belognsToCurrentUser
                      ? const Radius.circular(12)
                      : const Radius.circular(0),
                  bottomRight: belognsToCurrentUser
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                ),
              ),
              width: 180,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              child: Column(
                crossAxisAlignment: belognsToCurrentUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.userName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            belognsToCurrentUser ? Colors.black : Colors.white),
                  ),
                  Text(
                    message.text,
                    textAlign:
                        belognsToCurrentUser ? TextAlign.right : TextAlign.left,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          left: belognsToCurrentUser ? null : 165,
          right: belognsToCurrentUser ? 165 : null,
          child: _showUserImage(message.userImageUrl),
        ),
      ],
    );
  }
}

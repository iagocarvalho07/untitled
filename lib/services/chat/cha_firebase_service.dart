import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/chat_massage.dart';
import '../../models/chat_user.dart';
import 'chat_service.dart';

class ChatFireBaseService implements ChatService {
  @override
  Stream<List<ChatMessage>> messagesStrem() {
    final store = FirebaseFirestore.instance;
    final snapshot = store
        .collection('chat')
        .withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore)
        .orderBy('createdAt', descending: true)
        .snapshots();

    // segunda forma de recuperar dados do FibaseStore
    return snapshot.map((event) {
      return event.docs.map((e) {
        return e.data();
      }).toList();
    });

    // primeira forma de recuperar dados do FibaseStore

    // return Stream<List<ChatMessage>>.multi(
    //   (controler) {
    //     snapshot.listen((query) {
    //       List<ChatMessage> list = query.docs.map((e) {
    //         return e.data();
    //       }).toList();
    //       controler.add(list);
    //     });
    //   },
    // );
  }

  @override
  Future<ChatMessage?> save(String text, ChatUser user) async {
    final store = FirebaseFirestore.instance;

    // 1 implementação

    // // transformando um  chatmenssage => map<String, dynanmic>
    // final docRef = await store.collection("chat").add({
    //   'text': text,
    //   'createdAt': DateTime.now().toIso8601String(),
    //   'userId': user.id,
    //   'userName': user.name,
    //   'userImageUrl': user.imageUrl,
    // });
    // final doc = await docRef.get();
    // final data = doc.data()!;
    //
    // // transformando o contrario agora.  map<String, dynanmic> =>   chatmenssage
    // return ChatMessage(
    //   id: doc.id,
    //   text: data['text'],
    //   createdAt: DateTime.parse(data['createdAt']),
    //   userId: data['userId'],
    //   userName: data['userName'],
    //   userImageUrl: data['userImageUrl'],
    // );

    // 2 implementação apos refatoração

    final msg = ChatMessage(
      id: '',
      text: text,
      createdAt: DateTime.now(),
      userId: user.id,
      userName: user.name,
      userImageUrl: user.imageUrl,
    );

    final docRef = await store
        .collection('chat')
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .add(msg);

    final doc = await docRef.get();
    return doc.data()!;
  }

  // ChatMessage => Map<String, dynamic>
  Map<String, dynamic> _toFirestore(
    ChatMessage msg,
    SetOptions? options,
  ) {
    return {
      'text': msg.text,
      'createdAt': msg.createdAt.toIso8601String(),
      'userId': msg.userId,
      'userName': msg.userName,
      'userImageUrl': msg.userImageUrl,
    };
  }

  // Map<String, dynamic> => ChatMessage
  ChatMessage _fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    return ChatMessage(
      id: doc.id,
      text: doc['text'],
      createdAt: DateTime.parse(doc['createdAt']),
      userId: doc['userId'],
      userName: doc['userName'],
      userImageUrl: doc['userImageUrl'],
    );
  }
}

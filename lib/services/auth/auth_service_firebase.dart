import 'dart:io';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/chat_user.dart';
import 'auth_service.dart';

class AuthServiceFirebase implements AuthService {
  static ChatUser? _currentUser;
  static final _userStream = Stream<ChatUser?>.multi((controller) async {
    final authchange = FirebaseAuth.instance.authStateChanges();
    await for (final user in authchange) {
      _currentUser = user == null ? null : _toChatUser(user);
      controller.add(_currentUser);
    }
  });

  @override
  ChatUser? get currentUser {
    return _currentUser;
  }

  @override
  Stream<ChatUser?> get userChanges {
    return _userStream;
  }

  @override
  Future<void> signup(
    String name,
    String email,
    String password,
    File? image,
  ) async {
    final auth = FirebaseAuth.instance;
    try {
      UserCredential credecnial = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (credecnial.user == null) return;
      // 1 upload da foto do usuario
      final imageName = "${credecnial.user!.uid}.jpg";
      final imageUrl = await _uploadUserImage(image, imageName);

      // 2 atualizar os atributos do usuario
      await credecnial.user?.updateDisplayName(name);
      await credecnial.user?.updatePhotoURL(imageUrl);

      // 3 savar o usuario no banco de dados
      await _saveChatUser(_toChatUser(credecnial.user!, imageUrl));

    } on FirebaseAuthException catch (e) {
      print(" oque ta acontecendo nessa porra ${e}");
    }
  }

  @override
  Future<void> login(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print("oque aconteceu com o login ${e.message}");
    }
  }

  @override
  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
  }

  Future<String?> _uploadUserImage(File? image, String imageNmae) async {
    if (image == null) return null;
    final store = FirebaseStorage.instance;
    final imageRef = store.ref().child("user_image").child(imageNmae);
    await imageRef.putFile(image).whenComplete(() {});
    return await imageRef.getDownloadURL();
  }

  Future<void> _saveChatUser(ChatUser user) async {
    final soter = FirebaseFirestore.instance;
    final docRef = soter.collection('users').doc(user.id);
    return docRef.set(
        {'name': user.name, 'email': user.email, 'imageUrl': user.imageUrl});
  }

  static ChatUser _toChatUser(User user, [String? imageUrl]) {
    return ChatUser(
      id: user.uid,
      name: user.displayName ?? user.email!.split("@")[0],
      email: user.email!,
      imageUrl: imageUrl ?? user.photoURL ?? 'assets/imagens/avatar.png',
    );
  }
}

import 'dart:io';


import 'package:untitled/services/auth/auth_service_firebase.dart';

import '../../models/chat_user.dart';
import 'auth_service_mock.dart';

abstract class AuthService {
  ChatUser? get currentUser;

  Stream<ChatUser?> get userChanges;

  Future<void> signup(
      String name,
      String email,
      String password,
      File? image,
      );

  Future<void> login(
      String email,
      String password,
      );

  Future<void> logout();

  factory AuthService(){
    // return AuthServiceMock();
    return AuthServiceFirebase();
  }
}

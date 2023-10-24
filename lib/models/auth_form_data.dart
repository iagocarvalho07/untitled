import 'dart:io';

enum AuthMode { Singup, Login }

class AuthFormData {
  String name = '';
  String email = '';
  String password = '';
  File? Image;
  AuthMode _mode = AuthMode.Login;

  bool get islogin {
    return _mode == AuthMode.Login;
  }

  bool get isSingUp {
    return _mode == AuthMode.Singup;
  }

  void toogleAuthMode(){
    _mode = islogin ? AuthMode.Singup : AuthMode.Login;
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:untitled/components/user_image_picker.dart';

import '../models/auth_form_data.dart';

class AuthForm extends StatefulWidget {
  final void Function(AuthFormData) onSubmit;

  const AuthForm({super.key, required this.onSubmit});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formeKey = GlobalKey<FormState>();
  final _AuthFormData = AuthFormData();

  void _handleImagePick(File imagePick) {
    _AuthFormData.Image = imagePick;
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _submit() {
    final isvalid = _formeKey.currentState?.validate() ?? false;
    if (!isvalid) return;

    if (_AuthFormData.Image == null && _AuthFormData.isSingUp) {
      return _showError("Image não Selecionada!");
    }

    widget.onSubmit(_AuthFormData);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formeKey,
          child: Column(
            children: [
              if (_AuthFormData.isSingUp)
                UserImagePicker(
                  onImagePick: _handleImagePick,
                ),
              if (_AuthFormData.isSingUp)
                TextFormField(
                  key: const ValueKey("Name"),
                  initialValue: _AuthFormData.name,
                  onChanged: (name) => _AuthFormData.name = name,
                  decoration: InputDecoration(labelText: 'Nome'),
                  validator: (_name) {
                    final name = _name ?? '';
                    if (name.trim().length < 3) {
                      return 'O nome deve possuir 3 ou mais caracteres';
                    }
                    return null;
                  },
                ),
              TextFormField(
                key: const ValueKey("Email"),
                initialValue: _AuthFormData.email,
                onChanged: (email) => _AuthFormData.email = email,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (_email) {
                  final email = _email ?? '';
                  if (!email.contains("@")) {
                    return 'O email Informado não é valido';
                  }
                  return null;
                },
              ),
              TextFormField(
                obscureText: true,
                key: const ValueKey("Senha"),
                initialValue: _AuthFormData.password,
                onChanged: (password) => _AuthFormData.password = password,
                decoration: InputDecoration(labelText: 'Senha'),
                validator: (_password) {
                  final password = _password ?? '';
                  if (password.length < 6) {
                    return 'A senha deve Conter no minimo 6 Caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 12,
              ),
              ElevatedButton(
                onPressed: _submit,
                child: Text(
                  _AuthFormData.islogin ? "Entrar" : "Cadastrar",
                ),
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _AuthFormData.toogleAuthMode();
                    });
                  },
                  child: Text(_AuthFormData.islogin
                      ? "Criar uma Nova Conta"
                      : "Já possue conta?"))
            ],
          ),
        ),
      ),
    );
  }
}

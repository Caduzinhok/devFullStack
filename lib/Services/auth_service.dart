import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:managment/Screens/home.dart';

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

class AuthService extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  bool isLoading = true;

  AuthService() {
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      user = (user == null) ? null : user;
      isLoading = false;
      notifyListeners();
    });
  }

  _getUser() {
    user = _auth.currentUser;
    notifyListeners();
  }

  registrar(String email, String senha, String nome) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: senha);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException('A senha é muito fraca!');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('Este email já está cadastrado');
      }
      else
        throw AuthException('Erro ao criar conta');

    }
  }

  login(String email, String senha) async {
    if(email.isEmpty)
      throw AuthException('Email obrigatório');
    if(senha.isEmpty)
      throw AuthException('Senha obrigatória');
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      _getUser();
    }on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Email não encontrado. Cadastre-se.');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Senha incorreta. Tente novamente');
      }
      else
        throw AuthException('Erro ao tentar fazer login');
    }
  }

  logout() async {
    await _auth.signOut();
    _getUser();
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/custom_user.dart';

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

enum UserType {Solicitante, Recebedor, Administrador }

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CustomUser? usuario;
  bool isLoading = true;

  AuthService() {
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? user) async {
      if (user == null) {
        usuario = null;
      } else {
        var userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        usuario = CustomUser(
          uid: user.uid,
          email: user.email,
          displayName: user.displayName,
          tipoConta: userDoc.exists ? userDoc['tipoConta'] : '',
        );
      }
      isLoading = false;
      notifyListeners();
    });
  }




  registrar(String email, String senha, String nome, String tipoContaSelecionada) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: senha);
      await FirebaseFirestore.instance.collection('users').doc(usuario?.uid).set({
        'nome': nome,
        'email': email,
        'Username': nome,
        'tipoConta': tipoContaSelecionada,
      });
      _authCheck();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException('A senha é muito fraca!');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('Este email já está cadastrado');
      }
    }
  }

  login(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Email não encontrado. Cadastre-se.');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Senha incorreta. Tente novamente');
      }
    }
  }

  logout() async {
    await _auth.signOut();
  }
}


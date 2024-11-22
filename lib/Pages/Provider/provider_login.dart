import 'package:appidoso/comum/meuSnackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class IdosoProvider with ChangeNotifier {
  String _tipoUsuario = "user";
  String get tipoUsuario => _tipoUsuario;


  Future<void> login(BuildContext context, String email, String senha) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      String uid = userCredential.user!.uid;
     

      // Verifica o tipo de usuário
      DocumentSnapshot profissionalDoc = await FirebaseFirestore.instance
          .collection('profissional')
          .doc(uid)
          .get();

      _tipoUsuario = profissionalDoc.exists ? "profissional" : "user";

      
      mostrarSnackbar(
        context: context,
        texto: 'Login realizado com sucesso!',
        isErro: false,
      );

      notifyListeners();
    } catch (e) {
      mostrarSnackbar(
        context: context,
        texto: 'Erro ao fazer login. Tente novamente',
        isErro: true,
      );
      print("Erro no login: $e");  // Log do erro para ajudar na depuração
    }
  }

  
}
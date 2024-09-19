import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserIdoso extends StatefulWidget {
  final User? user;
  const UserIdoso({this.user, super.key});
 

 
  @override
  State<UserIdoso> createState() => _UserIdosoState();
}

class _UserIdosoState extends State<UserIdoso> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Carrega os dados do usuário a partir do Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('user').doc(widget.user!.uid).get();
      setState(() {
        userData = userDoc.data() as Map<String, dynamic>?;
           });
    } catch (e) {
      print("Erro ao carregar dados do usuário: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil do Usuário')),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nome: ${userData!['nome'] ?? 'Nome não informado'}'),
                  Text('Cpf: ${userData!['cpf'] ?? 'Cpf não informado'}'),
                  Text('Email: ${widget.user!.email}'),
                  Text('DatNasc:${userData!['dtNasc'] ?? 'Data de nascimento não informada'}'),
                ],
              ),
            ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AutenticacaoServico {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> cadastrarUsuario({
    required String nome, 
    required String cpf, // CPF como string
    required String email, 
    required String dtNas, 
    required String senha, 
    required String confSenha,
  }) async {
    try {
    

          // Criar usuário com email e senha
      UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );


           // Adicionar dados extras no Firestore
      await _firestore.collection('user').doc(userCredential.user!.uid).set({
        'nome': nome,
        'cpf': cpf,
        'dtNasc': dtNas,
        'email': email,
        'senha': senha,
        'confSenha': confSenha
      });


      print("Usuário cadastrado com sucesso");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print("O e-mail já está em uso por outra conta.");
      } else {
        print("Erro durante o cadastro: ${e.message}");
      }
    } catch (e) {
      print("Erro inesperado: $e");
    }
  }
}

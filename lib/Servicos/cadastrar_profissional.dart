import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AutenticacaoServicoProfissional {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> cadastrar_Profissional({
    required String nome, 
    required String email, // CPF como string
    required String profissao, 
    // required String concelho, 
    // required String especializacao, 
    required String senha,
    required String confirSenha
  }) async {
    try {
    

          // Criar usuário com email e senha
      UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );


           // Adicionar dados extras no Firestore
      await _firestore.collection('profissional').doc(userCredential.user!.uid).set({
        'nome': nome,
        'email': email,
        'profissao1': profissao,
        // 'cr1': concelho,
        // 'especializacao': especializacao,
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

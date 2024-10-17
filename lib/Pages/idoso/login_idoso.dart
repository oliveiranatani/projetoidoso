import 'package:appidoso/Pages/idoso/cadastro.dart';
import 'package:appidoso/Pages/profissional/catalogo_profissionais.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appidoso/comum/meuSnackbar.dart'; // Importando a função mostrarSnackbar
import 'package:appidoso/Servicos/shared_preferences_service.dart'; // Importando o SharedPreferencesService

class LoginIdoso extends StatefulWidget {
  const LoginIdoso({super.key});

  @override
  _LoginIdosoState createState() => _LoginIdosoState();
}

class _LoginIdosoState extends State<LoginIdoso> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      String uid = userCredential.user!.uid;

      // Salva o ID do idoso nos SharedPreferences
      await SharedPreferencesService.saveIdIdoso(uid);

      // Exibir mensagem de sucesso
      mostrarSnackbar(
        context: context,
        texto: 'Login realizado com sucesso!',
        isErro: false,
      );

      // Navegar para a tela CatalogoProfissionais após o login bem-sucedido
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const CatalogoProfissionais(),
        ),
      );
    } catch (e) {
      print("Erro no login: $e");

      // Exibir mensagem de erro
      mostrarSnackbar(
        context: context,
        texto: 'Erro ao fazer login. Tente novamente.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFBA68C8),
        title: const Text('Login Idoso'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                filled: true,
                fillColor: const Color(0xFFE1BEE7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Senha',
                filled: true,
                fillColor: const Color(0xFFE1BEE7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF892CDB),
              ),
              child: const Text(
                'Entrar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Não tem uma conta? '),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CadastroPage()),
                    );
                  },
                  child: const Text('Cadastre-se'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

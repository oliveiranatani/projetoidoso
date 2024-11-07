import 'package:appidoso/Pages/idoso/catalogo_idoso.dart';
import 'package:appidoso/Pages/profissional/cadastro_profissional.dart';
import 'package:appidoso/Servicos/shared_preferences_service.dart';
import 'package:appidoso/comum/meuSnackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginProfissional extends StatefulWidget {
  const LoginProfissional({super.key});

  @override
  _LoginProfissionalState createState() => _LoginProfissionalState();
}

class _LoginProfissionalState extends State<LoginProfissional> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  bool _obscureText = true; // Adicionando a variável para controlar a visibilidade da senha

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      String uid = userCredential.user!.uid;
      DocumentSnapshot teste = await FirebaseFirestore.instance.collection('user').doc(uid).get();

      if(!teste.exists){

      // Salva o ID do idoso nos SharedPreferences
      await SharedPreferencesService.saveIdProfissional(uid);

      // Exibir mensagem de sucesso
      mostrarSnackbar(
        context: context,
        texto: 'Login realizado com sucesso!',
        isErro: false,
      );

      // Navegar para a tela CatalogoIdosos após o login bem-sucedido
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const CatalogoIdosos(),
        ),
      );
      } else 
       {print("Erro no login: $teste");

      // Exibir mensagem de erro
      mostrarSnackbar(
        context: context,
        texto: 'Erro ao fazer login. Tente novamente. $teste',
      );}
    } catch (e) {
      print("Erro no login: $e");

      // Exibir mensagem de erro
      mostrarSnackbar(
        context: context,
        texto: 'Erro ao fazer login. Tente novamente 1.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFBA68C8),
        title: const Text('Login Profissional'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            // Campo de E-mail
            TextFormField(
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
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            // Campo de Senha
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Senha',
                filled: true,
                fillColor: const Color(0xFFE1BEE7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText; // Alterna o estado de visibilidade
                    });
                  },
                ),
              ),
              obscureText: _obscureText, // Utilizando a variável para controle de visibilidade
            ),
            const SizedBox(height: 20),
            // Botão de Entrar
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
            // Link para Cadastro
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Não tem uma conta? '),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CadastroProfissional()),
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

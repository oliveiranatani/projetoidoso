import 'package:appidoso/Pages/Provider/provider_login.dart';
import 'package:appidoso/Pages/idoso/cadastro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoginIdoso extends StatefulWidget {
  const LoginIdoso({super.key});

  @override
  _LoginIdosoState createState() => _LoginIdosoState();
}

class _LoginIdosoState extends State<LoginIdoso> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true; 

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFBA68C8),
        title: const Text('Login'),
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
              obscureText: _obscureText, // Definindo a visibilidade da senha
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
            ),
            const SizedBox(height: 20),

            Consumer<IdosoProvider>(builder: (context, provider, _) 
            {
                return  ElevatedButton(
              onPressed: () async {
                await provider.login(context, emailController.text, passwordController.text);
                if (provider.tipoUsuario == "user") {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamed('/dashboard');
                } else {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamed('/dashboardprofi');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF892CDB),
              ),
              child: const Text(
                'Entrar',
                style: TextStyle(color: Colors.white),
              ),
            );
            }
            ,),
           
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

import 'package:appidoso/Pages/idoso/login_idoso.dart';
import 'package:appidoso/Servicos/cadastrar_idoso.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:appidoso/comum/meuSnackbar.dart';
import 'package:flutter/services.dart'; // Importando a função

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  
  bool _obscureText = true; // Variável para controlar a visibilidade da senha

  void _register() async {
    final cadastrar = AutenticacaoServico();
    try {
      await cadastrar.cadastrarUsuario(
        nome: nameController.text, 
        email: emailController.text, 
        senha: passwordController.text, 
        confSenha: confirmPasswordController.text, 
        cpf: cpfController.text, 
        dtNas: birthdateController.text
      );

      // Exibir mensagem de sucesso
      mostrarSnackbar(
        context: context, 
        texto: 'Usuário cadastrado com sucesso!', 
        isErro: false
      );
    } catch (e) {
      // Exibir mensagem de erro
      mostrarSnackbar(
        context: context, 
        texto: 'Falha ao cadastrar usuário. Tente novamente.'
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFBA68C8),
        title: const Text('Cadastro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nome',
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
              controller: cpfController,
              decoration: InputDecoration(
                labelText: 'CPF',
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
              controller: birthdateController,
              inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            DataInputFormatter(),
                          ],
              decoration: InputDecoration(
                labelText: 'Data de Nascimento',
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
              obscureText: _obscureText, // Controla a visibilidade da senha
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirmar Senha',
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
              obscureText: _obscureText,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF892CDB),
              ),
              child: const Text('Cadastrar',
                style: TextStyle(color: Colors.white),),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Já é cadastrado? '),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginIdoso()),
                    );
                  },
                  child: const Text('Faça login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

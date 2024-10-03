import 'package:appidoso/Pages/profissional/loginprofissional.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appidoso/Servicos/cadastrar_profissional.dart';
import 'package:appidoso/comum/meuSnackbar.dart'; // Importando a função

class CadastroProfissional extends StatefulWidget {
  const CadastroProfissional({super.key});

  @override
  _CadastroProfissionalState createState() => _CadastroProfissionalState();
}

class _CadastroProfissionalState extends State<CadastroProfissional> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController profissaoController = TextEditingController();
  final TextEditingController conselhoRegionalController = TextEditingController();
  final TextEditingController especializacaoController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmaSenhaController = TextEditingController();

  void _cadastrar() async {
    final cadastro = AutenticacaoServicoProfissional();

    try {
      await cadastro.cadastrar_Profissional(
        nome: nomeController.text,
        email: emailController.text,
        profissao: profissaoController.text,
        concelho: conselhoRegionalController.text,
        especializacao: especializacaoController.text,
        senha: senhaController.text,
        confirSenha: confirmaSenhaController.text,
      );
      // Exibir mensagem de sucesso
      mostrarSnackbar(
        context: context,
        texto: 'Cadastro realizado com sucesso!',
        isErro: false,
      );
      // Navegar para a tela de login ou outra tela, se necessário
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginProfissional()),
      );
    } catch (e) {
      print("Erro ao cadastrar: $e");
      // Exibir mensagem de erro
      mostrarSnackbar(
        context: context,
        texto: 'Erro ao cadastrar. Tente novamente.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF892CDB),
        title: const Row(
          children: [
            Image(
              image: AssetImage('assets/img/logopreta.png'),
              height: 40, // Ajuste o tamanho conforme necessário
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo Nome
            TextField(
              controller: nomeController,
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

            // Campo Email
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
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

            // Campo Profissão
            TextField(
              controller: profissaoController,
              decoration: InputDecoration(
                labelText: 'Profissão',
                filled: true,
                fillColor: const Color(0xFFE1BEE7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Campo Conselho Regional
            TextField(
              controller: conselhoRegionalController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                labelText: 'Conselho Regional',
                filled: true,
                fillColor: const Color(0xFFE1BEE7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Campo Especialização
            TextField(
              controller: especializacaoController,
              decoration: InputDecoration(
                labelText: 'Especialização',
                filled: true,
                fillColor: const Color(0xFFE1BEE7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Campo Senha
            TextField(
              controller: senhaController,
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
            const SizedBox(height: 16),

            // Campo Confirmar Senha
            TextField(
              controller: confirmaSenhaController,
              decoration: InputDecoration(
                labelText: 'Confirmar Senha',
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

            // Botão Cadastrar
            ElevatedButton(
              onPressed: _cadastrar,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF892CDB),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text(
                'Cadastrar-se',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),

            const SizedBox(height: 20),

            // Link para Login
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Já é Profissional Cadastrado? '),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginProfissional()),
                    );
                  },
                  child: const Text('Logar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

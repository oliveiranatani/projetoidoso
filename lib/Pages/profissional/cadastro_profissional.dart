import 'package:appidoso/Servicos/cadastrar_profissional.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CadastroProfissional extends StatelessWidget {
   final _formKey = GlobalKey<FormState>();
  final TextEditingController profissionalnomeController = TextEditingController();
  final TextEditingController profissionalemailController = TextEditingController();
  final TextEditingController profissionalprofController = TextEditingController();
  final TextEditingController profissionalnumController = TextEditingController();
  final TextEditingController profissionalespecializacaoController = TextEditingController();
  final TextEditingController profissionalsenhaController = TextEditingController();
  final TextEditingController profissionalconfirmsenhaController = TextEditingController();

  final AutenticacaoServicoProfissional _autenticacaoServico = AutenticacaoServicoProfissional();

  Future<void> _cadastrar() async {
    if (_formKey.currentState!.validate()) {
      await _autenticacaoServico.cadastrar_profissional(
        nome:profissionalnomeController.text,
        email:profissionalemailController.text,
        profissao:profissionalprofController.text,
        concelho: profissionalnumController.text,
        especializacao:profissionalespecializacaoController.text,
        senha:profissionalsenhaController.text,
        confirSenha:profissionalconfirmsenhaController.text

     
      );
    }
  }

  
  CadastroProfissional({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF892CDB),
      ),
      body: SingleChildScrollView( // Adicionei este widget para permitir a rolagem
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: profissionalnomeController,
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
                controller: profissionalemailController,
                decoration: InputDecoration(
                  labelText: 'Email',
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
                controller: profissionalprofController,
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
              TextField(
                controller: profissionalnumController,
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
                 TextField(
                controller: profissionalsenhaController,
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
              TextField(
                controller: profissionalconfirmsenhaController,
                decoration: InputDecoration(
                  labelText: 'Confirmar Senha',
                  filled: true,
                  fillColor: const Color(0xFFE1BEE7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0), // Corrigido para manter a consistência do design
                    borderSide: BorderSide.none,
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: _cadastrar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF892CDB),
                  ),
                  child: const Text('Cadastrar'),
                ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Já é Profissional Cadastrado? '),
                  TextButton(
                    onPressed: () {
                      // Navegação para página de login de profissional
                    },
                    child: const Text('Logar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:appidoso/Pages/idoso/cadastro.dart';
import 'package:appidoso/Pages/idoso/loginidoso.dart';
import 'package:flutter/material.dart';

import 'profissional/cadastro_profissional.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CadastroProfissional()),
                );
              },
              child: const Text(
                'Sou Profissional',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          const Spacer(), // Adicionado para dar espaço entre o topo e os botões
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  const LoginPage()),
              );
            },
            child: const Text('Login'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CadastroPage()),
              );
            },
            child: const Text('Cadastre-se'),
          ),
          const Spacer(flex: 2), // Adicionado para criar espaço no final
        ],
      ),
    );
  }
}

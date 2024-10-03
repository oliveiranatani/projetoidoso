import 'package:appidoso/Pages/idoso/cadastro.dart';
import 'package:appidoso/Pages/idoso/login_idoso.dart';
import 'package:appidoso/Pages/profissional/cadastro_profissional.dart';
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE1BEE7),  // Tom de roxo mais claro
              Color(0xFF9C27B0), // Tom de roxo mais forte
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CadastroProfissional()),
                  );
                },
                child: const Text(
                  'Sou Profissional',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const Center(
              child: Image(
                image: AssetImage('assets/img/logohome.png'),
                height: 120,
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginIdoso()),
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
                const SizedBox(height: 100),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class DetalhesIdoso extends StatelessWidget {
  final Map<String, dynamic> idoso;

  const DetalhesIdoso({super.key, required this.idoso});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Idoso'),
        backgroundColor: const Color(0xFFBA68C8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              idoso['nome'] ?? 'Nome não disponível',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Idade: ${idoso['idade'] ?? 'Idade não disponível'}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: ${idoso['email'] ?? 'Email não disponível'}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Telefone: ${idoso['telefone'] ?? 'Telefone não disponível'}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            // Adicione mais informações aqui, se necessário
          ],
        ),
      ),
    );
  }
}

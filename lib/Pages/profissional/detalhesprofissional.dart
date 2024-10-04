import 'package:flutter/material.dart';

class DetalhesProfissional extends StatelessWidget {
  final Map<String, dynamic> profissional;

  const DetalhesProfissional({super.key, required this.profissional});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Profissional'),
        backgroundColor: const Color(0xFFBA68C8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profissional['nome'] ?? 'Nome não disponível',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Profissão: ${profissional['profissao1'] ?? 'Profissão não disponível'}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: ${profissional['email'] ?? 'Email não disponível'}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Telefone: ${profissional['telefone'] ?? 'Telefone não disponível'}',
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

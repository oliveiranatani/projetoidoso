import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MeuPerfilProfissional extends StatelessWidget {
  const MeuPerfilProfissional({super.key});

  Future<Map<String, dynamic>?> fetchProfissionalProfile(String uid) async {
    try {
      final DocumentSnapshot profissionalDoc = await FirebaseFirestore.instance.collection('profissional').doc(uid).get();
      if (profissionalDoc.exists) {
        return profissionalDoc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print('Erro ao buscar dados do profissional: $e');
    }
    return null;
  }

  Future<void> updateProfissionalProfile(BuildContext context, String uid, String nome, String profissao, String especializacao, String conselho) async {
    try {
      await FirebaseFirestore.instance.collection('profissional').doc(uid).update({
        'nome': nome,
        'profissao1': profissao,
        'especializacao': especializacao,
        'cr1': conselho,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar perfil: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? profissional = FirebaseAuth.instance.currentUser;
    final TextEditingController nomeController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController profissaoController = TextEditingController();
    final TextEditingController especializacaoController = TextEditingController();
    final TextEditingController concelhoController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil Profissional'),
        backgroundColor: const Color(0xFFBA68C8),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchProfissionalProfile(profissional?.uid ?? ''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Erro ao carregar perfil'));
          } else {
            final profissionalData = snapshot.data!;
            nomeController.text = profissionalData['nome'] ?? 'Nome não disponível';
            emailController.text = profissionalData['email'] ?? 'E-mail não disponível';
            profissaoController.text = profissionalData['profissao1'] ?? 'Não informado';
            especializacaoController.text = profissionalData['especializacao'] ?? 'Não informado';
            concelhoController.text = profissionalData['cr1'] ?? 'Não informado';

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true, // E-mail não pode ser editado
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: profissaoController,
                    decoration: const InputDecoration(
                      labelText: 'Profissão',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: especializacaoController,
                    decoration: const InputDecoration(
                      labelText: 'Especialização',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: concelhoController,
                    decoration: const InputDecoration(
                      labelText: 'Conselho Regional',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (profissional != null) {
                          updateProfissionalProfile(
                            context,
                            profissional.uid,
                            nomeController.text,
                            profissaoController.text,
                            especializacaoController.text,
                            concelhoController.text,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF892CDB),
                      ),
                      child: const Text(
                        'Salvar Alterações',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

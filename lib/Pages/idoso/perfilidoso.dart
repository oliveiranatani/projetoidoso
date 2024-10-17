import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MeuPerfil extends StatelessWidget {
  const MeuPerfil({super.key});

  Future<Map<String, dynamic>?> fetchUserProfile(String uid) async {
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('user').doc(uid).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print("Erro ao buscar perfil: $e");
    }
    return null;
  }

  Future<void> updateUserProfile(BuildContext context, String uid, String nome) async {
    try {
      await FirebaseFirestore.instance.collection('user').doc(uid).update({
        'nome': nome,
      });
      // Exibe uma mensagem de sucesso após salvar as alterações
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso!')),
      );
    } catch (e) {
      // Exibe uma mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar perfil: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final TextEditingController nomeController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController cpfController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: const Color(0xFFBA68C8),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchUserProfile(user?.uid ?? ''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar perfil'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Perfil não encontrado.'));
          } else {
            final userData = snapshot.data!;
            nomeController.text = userData['nome'] ?? 'Nome não disponível';
            emailController.text = userData['email'] ?? 'E-mail não disponível';
            cpfController.text = userData['cpf'] ?? 'CPF não disponível';

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
                    controller: cpfController,
                    decoration: const InputDecoration(
                      labelText: 'CPF',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true, // CPF não pode ser editado
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Salva as alterações no Firestore
                        if (user != null) {
                          updateUserProfile(context, user.uid, nomeController.text);
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

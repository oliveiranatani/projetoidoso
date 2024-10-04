import 'package:appidoso/Pages/idoso/login_idoso.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appidoso/Pages/idoso/editarperfilidoso.dart';
import 'detalhesprofissional.dart';

class CatalogoProfissionais extends StatelessWidget {
  const CatalogoProfissionais({super.key});

  Future<List<Map<String, dynamic>>> fetchProfissionais() async {
    try {
      final QuerySnapshot result =
          await FirebaseFirestore.instance.collection('profissional').get();
      print("Total de profissionais encontrados: ${result.docs.length}");

      return result.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Erro ao buscar profissionais: $e");
      return [];
    }
  }

  Future<String?> fetchNomeUsuario(String uid) async {
    try {
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('user').doc(uid).get();
      if (userDoc.exists) {
        return userDoc.get('nome');
      }
    } catch (e) {
      print("Erro ao buscar nome do usuário: $e");
    }
    return null; // Retorna null se não encontrar ou ocorrer erro
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser; // Pega o usuário logado
    final String? email = user?.email; // E-mail do usuário logado

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Profissionais'),
        backgroundColor: const Color(0xFFBA68C8),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const CircleAvatar(
                backgroundImage: AssetImage('assets/img/people.jpg'),
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Abre o Drawer
              },
            ),
          ),
        ],
      ),
      drawer: FutureBuilder<String?>(
        future: fetchNomeUsuario(user?.uid ?? ''), // Busca o nome do usuário
        builder: (context, snapshot) {
          String nomeUsuario = 'Nome não disponível';
          if (snapshot.connectionState == ConnectionState.waiting) {
            nomeUsuario = 'Carregando...'; // Exibe mensagem enquanto carrega
          } else if (snapshot.hasData) {
            nomeUsuario = snapshot.data ?? 'Nome não disponível'; // Nome obtido do Firestore
          }
          
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text(nomeUsuario), // Nome do usuário obtido do Firestore
                  accountEmail: Text(email ?? 'E-mail não disponível'), // Exibe o e-mail do usuário logado
                  currentAccountPicture: const CircleAvatar(
                    backgroundImage: AssetImage('assets/img/people.jpg'),
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFBA68C8),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Editar Perfil'),
                  onTap: () {
                    Navigator.pop(context); // Fecha o Drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditarPerfilIdoso(
                          idosoId: 'ID_DO_IDOSO_AQUI', // Substituir pelo ID do idoso
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text('Logoff'),
                  onTap: () {
                    _logout(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchProfissionais(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar profissionais'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum profissional cadastrado.'));
          } else {
            final profissionais = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      "Bem viver!",
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFBA68C8),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: profissionais.length,
                    itemBuilder: (context, index) {
                      final profissional = profissionais[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetalhesProfissional(
                                  profissional: profissional,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profissional['nome'] ?? 'Nome não disponível',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    profissional['profissao1'] ?? 'Profissão não disponível',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    profissional['email'] ?? 'Email não disponível',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navegar de volta para a tela de login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginIdoso()), // Substitua LoginIdoso pela sua tela de login
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você foi desconectado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao desconectar: $e')),
      );
    }
  }
}

import 'package:appidoso/Pages/idoso/login_idoso.dart';
import 'package:appidoso/Pages/idoso/perfilidoso.dart';
import 'package:appidoso/Pages/profissional/perfilprofissional.dart';
import 'package:appidoso/Servicos/dadosIdoso.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'detalhesprofissional.dart';

class CatalogoProfissionais extends StatelessWidget {
  const CatalogoProfissionais({super.key});

  Future<List<Map<String, dynamic>>> fetchProfissionais() async {
    try {
      final QuerySnapshot result =
          await FirebaseFirestore.instance.collection('profissional').get();
      return result.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser; 
    final String? email = user?.email; 
    final String? userid = user?.uid; 

    final usuario = DadosIdoso();

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
        future: usuario.fetchNomeUsuario(user?.uid ?? ''), // Busca o nome do usuário
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
                  accountName: Text(nomeUsuario),
                  accountEmail: Text(email ?? 'E-mail não disponível'),
                  currentAccountPicture: const CircleAvatar(
                    backgroundImage: AssetImage('assets/img/people.jpg'),
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFBA68C8),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Meu Perfil'),
                  onTap: () {
                    Navigator.pop(context); // Fecha o Drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MeuPerfil()), // Navega para a tela de Meu Perfil Profissional
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
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetalhesProfissional(
                                          profissional: profissional,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                const SizedBox(width: 20),
                                IconButton(
                                  onPressed: () async {
                                    await usuario.solicitarContato(profissional['email'], userid);
                                  },
                                  icon: const Icon(Icons.mail, size: 40),
                                ),
                                const SizedBox(width: 20),
                                IconButton(
                                  onPressed: () {}, // Adicionar funcionalidade para WhatsApp
                                  icon: const Icon(Icons.phone, size: 40),
                                ),
                              ],
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
        MaterialPageRoute(builder: (context) => const LoginIdoso()),
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

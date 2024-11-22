import 'package:appidoso/Pages/profissional/loginprofissional.dart';
import 'package:appidoso/Pages/profissional/perfilprofissional.dart';
import 'package:appidoso/Servicos/dadosProfissional.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CatalogoIdosos extends StatefulWidget {
  const CatalogoIdosos({super.key});


  @override
  _CatalogoIdososState createState() => _CatalogoIdososState();
}

class _CatalogoIdososState extends State<CatalogoIdosos> {

  @override
  void initState() {
    fetchNomeUsuario();
    super.initState();
    
  }

  String nomeUsuario = 'Carregando...';
  String? emailUsuario = 'Carregando...';
  String? fotoAvatar;

  // Função para carregar os dados do usuário sempre que o Drawer for aberto
  void fetchNomeUsuario() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('profissional').doc(user.uid).get();
        if (userDoc.exists) {
          setState(() {
            nomeUsuario = userDoc['nome'] ?? 'Nome não disponível';
            fotoAvatar = userDoc['imageUrl'];
            emailUsuario = user.email ?? 'E-mail não disponível';
          });
        }
      } catch (e) {
        print("usuário saiu!");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dadosprofissional = Dadosprofissional();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Idosos'),
        backgroundColor: const Color(0xFFBA68C8),
      ),
      drawer: Builder(
        builder: (context) {
          // Chama o método fetchNomeUsuario toda vez que o Drawer for aberto
          fetchNomeUsuario();

          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text(nomeUsuario),
                  accountEmail: Text(emailUsuario ?? ''),
                  currentAccountPicture: fotoAvatar != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(fotoAvatar!),
                          backgroundColor: Colors.transparent,
                        )
                      : const CircleAvatar(
                          child: Icon(Icons.person),
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
                      MaterialPageRoute(builder: (context) => const MeuPerfilProfissional()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text('Logoff'),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const LoginProfissional()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Você foi desconectado com sucesso!')),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dadosprofissional.fetchIdosos(emailUsuario as String),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erro ao carregar idosos: ${snapshot.error}')),
            );
            return const Center(child: Text('Erro ao carregar idosos'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum idoso cadastrado.'));
          } else {
            final idosos = snapshot.data!;
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
                    itemCount: idosos.length,
                    itemBuilder: (context, index) {
                      final idoso = idosos[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
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
                                  idoso['nome'] ?? 'Nome não disponível',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  idoso['data_servico'] ?? 'Data não disponível',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  idoso['email'] ?? 'E-mail não disponível',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  idoso['mensagem'] ?? 'Mensagem não disponível',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
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
}

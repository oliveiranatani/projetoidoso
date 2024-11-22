import 'package:appidoso/Pages/idoso/login_idoso.dart';
import 'package:appidoso/Pages/idoso/perfilidoso.dart';
import 'package:appidoso/Servicos/dadosIdoso.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'detalhesprofissional.dart';

class CatalogoProfissionais extends StatefulWidget {
  const CatalogoProfissionais({super.key});

  @override
  State<CatalogoProfissionais> createState() => _CatalogoProfissionaisState();
}

class _CatalogoProfissionaisState extends State<CatalogoProfissionais> {
  TextEditingController observacaoController = TextEditingController();
  Map<String, dynamic>? usuarioData;

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

  Future<void> fetchUsuarioData(String userId) async {
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .get();
      setState(() {
        usuarioData = userDoc.data() as Map<String, dynamic>?;
      });
    } catch (e) {
      setState(() {
        usuarioData = {};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? email = user?.email;
    final String? userId = user?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Profissionais'),
        backgroundColor: const Color(0xFFBA68C8),
      ),
      onDrawerChanged: (isOpened) {
        if (isOpened && userId != null) {
          fetchUsuarioData(userId);
        }
      },
      drawer: Drawer(
        child: usuarioData == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text(usuarioData?['nome'] ?? 'Nome não disponível'),
                    accountEmail: Text(email ?? 'E-mail não disponível'),
                    currentAccountPicture: usuarioData?['imageUrl'] != null
                        ? CircleAvatar(
                            backgroundImage:
                                NetworkImage(usuarioData!['imageUrl']),
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
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MeuPerfil(),
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
                                        profissional['nome'] ??
                                            'Nome não disponível',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        profissional['profissao1'] ??
                                            'Profissão não disponível',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        profissional['email'] ??
                                            'Email não disponível',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                       Text(
                                        profissional['telefone'] ??
                                            'Telefone não disponível',
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
                                    bool? confirmou =
                                        await _mostrarAlerta(context);

                                    if (confirmou == true) {
                                      await DadosIdoso().solicitarContato(
                                          profissional['email'],
                                          userId,
                                          observacaoController.text);
                                    }
                                  },
                                  icon: const Icon(Icons.comment, size: 40),
                                ),
                                const SizedBox(width: 20),
                                IconButton(
                                  onPressed: () async{

                                  final telefone = profissional['telefone'] ?? '';
                                    final url = Uri.parse(
                                        'https://wa.me/$telefone'); 

                                    
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(
                                          url); 
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Não foi possível abrir o WhatsApp')),
                                      );
                                    }

                                  },
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

  Future<bool?> _mostrarAlerta(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Insira sua mensagem ao profissional'),
          content: TextField(
            controller: observacaoController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Digite sua mensagem aqui',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
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

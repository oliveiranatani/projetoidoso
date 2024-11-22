import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class MeuPerfilProfissional extends StatefulWidget {
  const MeuPerfilProfissional({super.key});

  @override
  _MeuPerfilProfissionalState createState() => _MeuPerfilProfissionalState();
}

class _MeuPerfilProfissionalState extends State<MeuPerfilProfissional> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController profissaoController = TextEditingController();
  final TextEditingController especializacaoController = TextEditingController();
  final TextEditingController conselhoController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController(); 
  
  File? _imageFile;
  String? _imageUrl;

  Future<void> requestPermissions() async {
    await [
      Permission.camera,
      Permission.photos,
    ].request();
  }

  Future<XFile?> getImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(source: source);
  }

  Future<void> uploadImage(File file) async {
    try {
      String ref = 'images/profissional-${DateTime.now().toString()}.jpg';
      await storage.ref(ref).putFile(file);
      _imageUrl = await storage.ref(ref).getDownloadURL();
    } on FirebaseException catch (e) {
      throw Exception('Erro no upload: ${e.code}');
    }
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      await storage.refFromURL(imageUrl).delete();
    } on FirebaseException catch (e) {
      throw Exception('Erro ao excluir a imagem: ${e.code}');
    }
  }

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

  Future<void> updateProfissionalProfile(BuildContext context, String uid, String nome, String profissao, String especializacao, String conselho, String telefone) async {
    try {
      await FirebaseFirestore.instance.collection('profissional').doc(uid).update({
        'nome': nome,
        'profissao1': profissao,
        'especializacao': especializacao,
        'cr1': conselho,
        'telefone': telefone, // Atualizando o campo de telefone
        'imageUrl': _imageUrl,
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

  Future<void> pickAndUploadImage() async {
    await requestPermissions();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Escolha uma opção'),
          actions: <Widget>[
            TextButton(
              child: const Text('Tirar Foto'),
              onPressed: () async {
                Navigator.of(context).pop();
                XFile? file = await getImage(ImageSource.camera);
                if (file != null) {
                  setState(() {
                    _imageFile = File(file.path);
                  });
                  await uploadImage(_imageFile!);
                }
              },
            ),
            TextButton(
              child: const Text('Escolher da Galeria'),
              onPressed: () async {
                Navigator.of(context).pop();
                XFile? file = await getImage(ImageSource.gallery);
                if (file != null) {
                  setState(() {
                    _imageFile = File(file.path);
                  });
                  await uploadImage(_imageFile!);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> handleDeleteImage() async {
    if (_imageUrl != null) {
      await deleteImage(_imageUrl!);
      setState(() {
        _imageUrl = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto de perfil excluída com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? profissional = FirebaseAuth.instance.currentUser;

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
            conselhoController.text = profissionalData['cr1'] ?? 'Não informado';
            telefoneController.text = profissionalData['telefone'] ?? 'Não informado'; // Carregar telefone
            _imageUrl = profissionalData['imageUrl'];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: pickAndUploadImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : _imageUrl != null
                              ? NetworkImage(_imageUrl!) as ImageProvider
                              : null,
                      child: _imageUrl == null && _imageFile == null
                          ? const Text("Adicionar foto", style: TextStyle(color: Colors.white))
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: pickAndUploadImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF892CDB),
                        ),
                        child: const Text('Mudar Foto de Perfil', style: TextStyle(color: Colors.white),),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: telefoneController, // Novo campo de telefone
                    decoration: const InputDecoration(
                      labelText: 'Telefone',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: profissaoController,
                    decoration: const InputDecoration(
                      labelText: 'Profissão',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: especializacaoController,
                    decoration: const InputDecoration(
                      labelText: 'Especialização',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: conselhoController,
                    decoration: const InputDecoration(
                      labelText: 'Conselho Regional',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (profissional != null) {
                          await updateProfissionalProfile(
                            context,
                            profissional.uid,
                            nomeController.text,
                            profissaoController.text,
                            especializacaoController.text,
                            conselhoController.text,
                            telefoneController.text, 
                          );
                        }
                      },
                      child: const Text('Salvar Alterações'),
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

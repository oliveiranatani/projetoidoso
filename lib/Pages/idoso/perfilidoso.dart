import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class MeuPerfil extends StatefulWidget {
  const MeuPerfil({super.key});

  @override
  _MeuPerfilState createState() => _MeuPerfilState();
}

class _MeuPerfilState extends State<MeuPerfil> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController dtNascController = TextEditingController();
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
      String ref = 'images/img-${DateTime.now().toString()}.jpg';
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
    User? currentUser = FirebaseAuth.instance.currentUser;

      
      await FirebaseFirestore.instance.collection('user').doc(uid).update({
        'nome': nome,
        'imageUrl': _imageUrl,
      });
    
    //inserindo no authentication
    await currentUser?.updatePhotoURL(_imageUrl);
    await currentUser?.reload();

     
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
        _imageUrl = null; // Remove a URL da imagem após a exclusão
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto de perfil excluída com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

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
            dtNascController.text = userData['dtNasc'] ?? 'Data de nascimento não disponível';
            _imageUrl = userData['imageUrl'];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: pickAndUploadImage,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: _imageFile != null
                                ? FileImage(_imageFile!)
                                : _imageUrl != null
                                    ? NetworkImage(_imageUrl!) as ImageProvider
                                    : null,
                            child: _imageUrl == null && _imageFile == null
                                ? const Text(
                                    "Adicionar foto de perfil",
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  )
                                : null,
                          ),
                        ],
                      ),
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
                        child: const Text('Mudar Foto de Perfil', style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: handleDeleteImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade400,
                        ),
                        child: const Text('Excluir Foto de Perfil', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
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
                    controller: dtNascController,
                    decoration: const InputDecoration(
                      labelText: 'Data de Nascimento',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: cpfController,
                    decoration: const InputDecoration(
                      labelText: 'CPF',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
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
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

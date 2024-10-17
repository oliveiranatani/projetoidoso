// import 'dart:io'; // Importação necessária para manipular arquivos
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';

// class EditarPerfilProfissional extends StatefulWidget {
//   final String profissionalId;

//   const EditarPerfilProfissional({super.key, required this.profissionalId});

//   @override
//   _EditarPerfilProfissionalState createState() => _EditarPerfilProfissionalState();
// }

// class _EditarPerfilProfissionalState extends State<EditarPerfilProfissional> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nomeController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _telefoneController = TextEditingController();
//   final TextEditingController _especializacaoController = TextEditingController();
//   String? _imagemUrl; // Para armazenar a URL da imagem

//   final ImagePicker _picker = ImagePicker(); // Inicializa o ImagePicker
//   XFile? _imagemSelecionada; // Armazenar a imagem selecionada

//   @override
//   void initState() {
//     super.initState();
//     _carregarDadosProfissional();
//   }

//   void _carregarDadosProfissional() async {
//     DocumentSnapshot snapshot = await FirebaseFirestore.instance
//         .collection('profissionais')
//         .doc(widget.profissionalId)
//         .get();
    
//     if (snapshot.exists) {
//       setState(() {
//         _nomeController.text = snapshot['nome'];
//         _emailController.text = snapshot['email'];
//         _telefoneController.text = snapshot['telefone'];
//         _especializacaoController.text = snapshot['especializacao'];
//         _imagemUrl = snapshot['imagemUrl']; // Carrega a URL da imagem, se disponível
//       });
//     }
//   }

//   Future<void> _selecionarImagem() async {
//     // Primeiro, mostramos o diálogo para o usuário escolher a fonte da imagem
//     final ImageSource? source = await showDialog<ImageSource>(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         title: const Text('Escolha uma fonte de imagem'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, ImageSource.camera),
//             child: const Text('Câmera'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, ImageSource.gallery),
//             child: const Text('Galeria'),
//           ),
//         ],
//       ),
//     );

//     // Verificamos se o usuário realmente escolheu uma fonte
//     if (source != null) {
//       final XFile? imagem = await _picker.pickImage(source: source);
//       if (imagem != null) {
//         setState(() {
//           _imagemSelecionada = imagem;
//         });
//       }
//     }
//   }

//   void _atualizarPerfil() async {
//     if (_formKey.currentState!.validate()) {
//       // Atualizar os dados no Firestore
//       await FirebaseFirestore.instance
//           .collection('profissionais')
//           .doc(widget.profissionalId)
//           .update({
//         'nome': _nomeController.text,
//         'email': _emailController.text,
//         'telefone': _telefoneController.text,
//         'especializacao': _especializacaoController.text,
//         'imagemUrl': _imagemUrl, // Atualiza a URL da imagem, se necessário
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Perfil atualizado com sucesso!')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Editar Perfil Profissional'),
//         backgroundColor: Colors.purple[300],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               // Exibe a imagem selecionada ou um ícone padrão
//               GestureDetector(
//                 onTap: _selecionarImagem,
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundImage: _imagemSelecionada != null
//                       ? FileImage(File(_imagemSelecionada!.path)) // Exibe a imagem selecionada
//                       : _imagemUrl != null ? NetworkImage(_imagemUrl!) : const AssetImage('assets/img/default_avatar.png') as ImageProvider, // Exibe uma imagem padrão
//                   child: const Icon(Icons.camera_alt, size: 50, color: Colors.white),
//                 ),
//               ),
//               const SizedBox(height: 16.0),
//               TextFormField(
//                 controller: _nomeController,
//                 decoration: const InputDecoration(labelText: 'Nome'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Por favor, insira seu nome';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(labelText: 'E-mail'),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Por favor, insira seu e-mail';
//                   } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                     return 'Por favor, insira um e-mail válido';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               TextFormField(
//                 controller: _telefoneController,
//                 decoration: const InputDecoration(labelText: 'Telefone'),
//                 keyboardType: TextInputType.phone,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Por favor, insira seu telefone';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               TextFormField(
//                 controller: _especializacaoController,
//                 decoration: const InputDecoration(labelText: 'Especialização'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Por favor, insira sua especialização';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 32.0),
//               ElevatedButton(
//                 onPressed: _atualizarPerfil,
//                 child: const Text('Salvar Alterações'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

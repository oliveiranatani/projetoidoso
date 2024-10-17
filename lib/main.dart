import 'package:appidoso/Pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicializa o Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Idoso',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const Homepage(), // Wrapper para lidar com estado de autenticação
      debugShowCheckedModeBanner: false, // Remove o banner de depuração
    );
  }
}

// // Widget que decide para onde o usuário deve ser direcionado
// class AutenticacaoWrapper extends StatelessWidget {
//   const AutenticacaoWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         // Se o usuário já está autenticado, vai para a tela de perfil
//         if (snapshot.connectionState == ConnectionState.active) {
//           User? user = snapshot.data;
//           if (user == null) {
//             return const LoginPage(); // Usuário não logado
//           } else {
//             return UserProfileScreen(user); // Usuário logado
//           }
//         } else {
//           // Mostra um indicador de carregamento até o estado da autenticação ser resolvido
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
//       },
//     );
//   }
// }
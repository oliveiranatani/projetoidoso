import 'package:appidoso/Pages/Provider/provider_login.dart';
import 'package:appidoso/Pages/homePage.dart';
import 'package:appidoso/Pages/idoso/catalogo_idoso.dart';
import 'package:appidoso/Pages/idoso/perfilidoso.dart';
import 'package:appidoso/Pages/profissional/catalogo_profissionais.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
// Inicializa o ProviderInstaller
  await Firebase.initializeApp(); // Inicializa o Firebase
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => IdosoProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          "/": (context) => const Homepage(),
          "/dashboard": (context) => const CatalogoProfissionais(),
          "/dashboardprofi": (context) => const CatalogoIdosos(),
          "/meuperfil" : (context) => const MeuPerfil(),
        },
      ),
    );
  }
}
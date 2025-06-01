// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:app_condominio/modules/cadastros/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicialize o Firebase. Certifique-se de ter adicionado a dependencia firebase_core e configurado os arquivos de configuração.
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Defina a rota inicial como a tela de login
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Condomínio App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
      },
      home: const LoginScreen(),
    );
  }
}
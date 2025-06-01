// lib/main.dart
import 'package:app_condominio/modules/cadastros/screens/ocorrencia_list_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase
  await Firebase.initializeApp();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Ocorrencias',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Aqui você pode definir sua tela inicial (por exemplo, MoradorListScreen)
      home: OcorrenciaListScreen(), 
    );
  }
}

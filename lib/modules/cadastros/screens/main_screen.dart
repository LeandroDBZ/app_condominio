// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
// Importes aos demais módulos ou telas – por exemplo:
import 'morador_list_screen.dart';
// Caso já possua uma tela de cadastro/edição de morador:
//import 'morador_form_screen.dart';

class MainScreen extends StatelessWidget {
  final bool isSindico;
  const MainScreen({Key? key, required this.isSindico}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página Principal'),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                // Simula logout: retorna à tela de login.
                Navigator.pushReplacementNamed(context, '/login');
              })
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Início'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Lista de Moradores'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MoradorListScreen(),
                  ),
                );
              },
            ),
            if (isSindico)
              ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text('Cadastrar Morador'),
                onTap: () {
                  // Aqui você deve passar a instância do repositório responsável por Morador.
                  // Por exemplo:
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //      builder: (context) => MoradorFormScreen(repository: MoradorRepository()),
                  //   ),
                  // );
                  // Para fins de exemplo, apenas fechemos o drawer.
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ação de cadastro de morador')));
                },
              ),
            // Outras opções de menu podem ser adicionadas aqui.
          ],
        ),
      ),
      body: const Center(
        child: Text('Bem-vindo à página principal!'),
      ),
    );
  }
}
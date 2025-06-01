// lib/modules/cadastros/screens/funcionario_list_screen.dart

import 'package:flutter/material.dart';
import 'package:app_condominio/modules/cadastros/models/funcionario.dart';
import 'package:app_condominio/modules/cadastros/repositories/funcionario_repository.dart';
import 'funcionario_form_screen.dart';

class FuncionarioListScreen extends StatefulWidget {
  @override
  _FuncionarioListScreenState createState() => _FuncionarioListScreenState();
}

class _FuncionarioListScreenState extends State<FuncionarioListScreen> {
  late Future<List<Funcionario>> futureFuncionarios;
  final FuncionarioRepository repository = FuncionarioRepository();

  @override
  void initState() {
    super.initState();
    futureFuncionarios = repository.getFuncionarios();
  }

  void refreshFuncionarios() {
    setState(() {
      futureFuncionarios = repository.getFuncionarios();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Funcionários'),
      ),
      body: FutureBuilder<List<Funcionario>>(
        future: futureFuncionarios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final funcionarios = snapshot.data!;
          if (funcionarios.isEmpty) {
            return const Center(child: Text('Nenhum funcionário encontrado'));
          }
          return ListView.builder(
            itemCount: funcionarios.length,
            itemBuilder: (context, index) {
              final funcionario = funcionarios[index];
              return ListTile(
                title: Text(funcionario.nome),
                subtitle: Text('Função: ${funcionario.funcao}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                          builder: (_) => FuncionarioFormScreen(
                            repository: repository,
                            funcionario: funcionario,
                          ),
                        ))
                        .then((_) => refreshFuncionarios());
                  },
                ),
                onLongPress: () async {
                  bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Remover Funcionário'),
                      content: const Text('Deseja remover este funcionário?'),
                      actions: [
                        TextButton(
                          child: const Text('Cancelar'),
                          onPressed: () => Navigator.pop(context, false),
                        ),
                        TextButton(
                          child: const Text('Remover'),
                          onPressed: () => Navigator.pop(context, true),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await repository.deleteFuncionario(funcionario.id);
                    refreshFuncionarios();
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                builder: (_) => FuncionarioFormScreen(repository: repository),
              ))
              .then((_) => refreshFuncionarios());
        },
      ),
    );
  }
}
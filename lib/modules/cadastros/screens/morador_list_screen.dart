import 'package:flutter/material.dart';
import 'package:app_condominio/modules/cadastros/repositories/morador_repository.dart';
import 'package:app_condominio/modules/cadastros/models/morador.dart';
import 'morador_form_screen.dart';

class MoradorListScreen extends StatefulWidget {
  @override
  _MoradorListScreenState createState() => _MoradorListScreenState();
}

class _MoradorListScreenState extends State<MoradorListScreen> {
  late Future<List<Morador>> futureMoradores;
  final MoradorRepository repository = MoradorRepository();

  @override
  void initState() {
    super.initState();
    futureMoradores = repository.getMoradores();
  }

  void refreshMoradores() {
    setState(() {
      futureMoradores = repository.getMoradores();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moradores'),
      ),
      body: FutureBuilder<List<Morador>>(
        future: futureMoradores,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final moradores = snapshot.data!;
          if (moradores.isEmpty) {
            return const Center(child: Text('Nenhum morador encontrado'));
          }
          return ListView.builder(
            itemCount: moradores.length,
            itemBuilder: (context, index) {
              final morador = moradores[index];
              return ListTile(
                title: Text(morador.nome),
                subtitle: Text('Telefone: ${morador.telefone}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                          builder: (_) => MoradorFormScreen(
                            repository: repository,
                            morador: morador,
                          ),
                        ))
                        .then((_) => refreshMoradores());
                  },
                ),
                onLongPress: () async {
                  bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Remover Morador'),
                      content: const Text('Deseja remover este morador?'),
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
                    await repository.deleteMorador(morador.id);
                    refreshMoradores();
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
                builder: (_) => MoradorFormScreen(repository: repository),
              ))
              .then((_) => refreshMoradores());
        },
      ),
    );
  }
}
// lib/modules/cadastros/screens/encomenda_list_screen.dart

import 'package:flutter/material.dart';
import 'package:app_condominio/modules/cadastros/models/encomenda.dart';
import 'package:app_condominio/modules/cadastros/repositories/encomenda_repository.dart';
import 'encomenda_form_screen.dart';

class EncomendaListScreen extends StatefulWidget {
  @override
  _EncomendaListScreenState createState() => _EncomendaListScreenState();
}

class _EncomendaListScreenState extends State<EncomendaListScreen> {
  late Future<List<Encomenda>> futureEncomendas;
  final EncomendaRepository repository = EncomendaRepository();

  @override
  void initState() {
    super.initState();
    futureEncomendas = repository.getEncomendas();
  }

  void refreshEncomendas() {
    setState(() {
      futureEncomendas = repository.getEncomendas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encomendas'),
      ),
      body: FutureBuilder<List<Encomenda>>(
        future: futureEncomendas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final encomendas = snapshot.data!;
          if (encomendas.isEmpty) {
            return const Center(child: Text('Nenhuma encomenda encontrada'));
          }
          return ListView.builder(
            itemCount: encomendas.length,
            itemBuilder: (context, index) {
              final encomenda = encomendas[index];
              return ListTile(
                title: Text('Encomenda ${encomenda.id}'),
                subtitle: Text('Status: ${encomenda.status}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                          builder: (_) => EncomendaFormScreen(
                            repository: repository,
                            encomenda: encomenda,
                          ),
                        ))
                        .then((_) => refreshEncomendas());
                  },
                ),
                onLongPress: () async {
                  bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Remover Encomenda'),
                      content: const Text('Deseja remover esta encomenda?'),
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
                    await repository.deleteEncomenda(encomenda.id);
                    refreshEncomendas();
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
                builder: (_) =>
                    EncomendaFormScreen(repository: repository),
              ))
              .then((_) => refreshEncomendas());
        },
      ),
    );
  }
}
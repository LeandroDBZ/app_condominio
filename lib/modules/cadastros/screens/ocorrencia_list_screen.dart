// lib/modules/cadastros/screens/ocorrencia_list_screen.dart

import 'package:flutter/material.dart';
import 'package:app_condominio/modules/cadastros/models/ocorrencia.dart';
import 'package:app_condominio/modules/cadastros/repositories/ocorrencia_repository.dart';
import 'ocorrencia_form_screen.dart';

class OcorrenciaListScreen extends StatefulWidget {
  @override
  _OcorrenciaListScreenState createState() => _OcorrenciaListScreenState();
}

class _OcorrenciaListScreenState extends State<OcorrenciaListScreen> {
  late Future<List<Ocorrencia>> futureOcorrencias;
  final OcorrenciaRepository repository = OcorrenciaRepository();

  @override
  void initState() {
    super.initState();
    futureOcorrencias = repository.getOcorrencias();
  }

  void refreshOcorrencias() {
    setState(() {
      futureOcorrencias = repository.getOcorrencias();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ocorrências'),
      ),
      body: FutureBuilder<List<Ocorrencia>>(
        future: futureOcorrencias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final ocorrencias = snapshot.data!;
          if (ocorrencias.isEmpty) {
            return const Center(child: Text('Nenhuma ocorrência encontrada'));
          }
          return ListView.builder(
            itemCount: ocorrencias.length,
            itemBuilder: (context, index) {
              final ocorrencia = ocorrencias[index];
              return ListTile(
                title: Text(ocorrencia.titulo),
                subtitle: Text('Tipo: ${ocorrencia.tipo}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                          builder: (_) => OcorrenciaFormScreen(
                            repository: repository,
                            ocorrencia: ocorrencia,
                          ),
                        ))
                        .then((_) => refreshOcorrencias());
                  },
                ),
                onLongPress: () async {
                  bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Remover Ocorrência'),
                      content:
                          const Text('Deseja remover essa ocorrência?'),
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
                    await repository.deleteOcorrencia(ocorrencia.id);
                    refreshOcorrencias();
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
                    OcorrenciaFormScreen(repository: repository),
              ))
              .then((_) => refreshOcorrencias());
        },
      ),
    );
  }
}
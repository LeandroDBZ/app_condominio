// lib/modules/cadastros/screens/unidade_list_screen.dart
import 'package:app_condominio/modules/cadastros/models/unidade.dart';
import 'package:app_condominio/modules/cadastros/repositories/unidade_repository.dart';
import 'package:flutter/material.dart';
import 'unidade_form_screen.dart';

class UnidadeListScreen extends StatefulWidget {
  @override
  _UnidadeListScreenState createState() => _UnidadeListScreenState();
}

class _UnidadeListScreenState extends State<UnidadeListScreen> {
  late Future<List<Unidade>> futureUnidades;
  final UnidadeRepository repository = UnidadeRepository();

  @override
  void initState() {
    super.initState();
    futureUnidades = repository.getUnidades();
  }

  void refreshUnidades() {
    setState(() {
      futureUnidades = repository.getUnidades();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unidades'),
      ),
      body: FutureBuilder<List<Unidade>>(
        future: futureUnidades,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final unidades = snapshot.data!;
          if (unidades.isEmpty) {
            return Center(child: Text('Nenhuma unidade encontrada'));
          }
          return ListView.builder(
            itemCount: unidades.length,
            itemBuilder: (context, index) {
              final unidade = unidades[index];
              return ListTile(
                title: Text('Bloco: ${unidade.bloco} - Ap: ${unidade.apartamento}'),
                subtitle: Text('Moradores: ${unidade.moradores.length}'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Navega para a tela de formulário para edição da unidade
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (_) => UnidadeFormScreen(
                              repository: repository,
                              unidade: unidade,
                            ),
                          ),
                        )
                        .then((_) => refreshUnidades());
                  },
                ),
                onLongPress: () async {
                  // Confirmação para remoção
                  bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Remover Unidade'),
                      content: Text('Deseja remover esta unidade?'),
                      actions: [
                        TextButton(
                          child: Text('Cancelar'),
                          onPressed: () => Navigator.pop(context, false),
                        ),
                        TextButton(
                          child: Text('Remover'),
                          onPressed: () => Navigator.pop(context, true),
                        )
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await repository.deleteUnidade(unidade.id);
                    refreshUnidades();
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Navega para a tela de formulário para criar uma nova unidade
          Navigator.of(context)
              .push(MaterialPageRoute(
                builder: (_) => UnidadeFormScreen(repository: repository),
              ))
              .then((_) => refreshUnidades());
        },
      ),
    );
  }
}
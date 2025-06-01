import 'package:flutter/material.dart';
import 'package:app_condominio/modules/cadastros/models/visitante.dart';
import 'package:app_condominio/modules/cadastros/repositories/visitante_repository.dart';
import 'visitante_form_screen.dart';

class VisitanteListScreen extends StatefulWidget {
  @override
  _VisitanteListScreenState createState() => _VisitanteListScreenState();
}

class _VisitanteListScreenState extends State<VisitanteListScreen> {
  late Future<List<Visitante>> futureVisitantes;
  final VisitanteRepository repository = VisitanteRepository();

  @override
  void initState() {
    super.initState();
    futureVisitantes = repository.getVisitantes();
  }

  void refreshVisitantes() {
    setState(() {
      futureVisitantes = repository.getVisitantes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visitantes'),
      ),
      body: FutureBuilder<List<Visitante>>(
        future: futureVisitantes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final visitantes = snapshot.data!;
          if (visitantes.isEmpty) {
            return const Center(child: Text('Nenhum visitante encontrado'));
          }
          return ListView.builder(
            itemCount: visitantes.length,
            itemBuilder: (context, index) {
              final visitante = visitantes[index];
              return ListTile(
                title: Text(visitante.nome),
                subtitle: Text(
                    'Documento: ${visitante.documento}\nQR Code: ${visitante.qrCode}\nValidade: ${visitante.validade.toIso8601String()}'),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                          builder: (_) => VisitanteFormScreen(
                            repository: repository,
                            visitante: visitante,
                          ),
                        ))
                        .then((_) => refreshVisitantes());
                  },
                ),
                onLongPress: () async {
                  bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Remover Visitante'),
                      content:
                          const Text('Deseja remover este visitante?'),
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
                    await repository.deleteVisitante(visitante.id);
                    refreshVisitantes();
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
                    VisitanteFormScreen(repository: repository),
              ))
              .then((_) => refreshVisitantes());
        },
      ),
    );
  }
}
// lib/modules/cadastros/screens/reserva_list_screen.dart

import 'package:flutter/material.dart';
import 'package:app_condominio/modules/cadastros/models/reserva.dart';
import 'package:app_condominio/modules/cadastros/repositories/reserva_repository.dart';
import 'reserva_form_screen.dart';

class ReservaListScreen extends StatefulWidget {
  @override
  _ReservaListScreenState createState() => _ReservaListScreenState();
}

class _ReservaListScreenState extends State<ReservaListScreen> {
  late Future<List<Reserva>> futureReservas;
  final ReservaRepository repository = ReservaRepository();

  @override
  void initState() {
    super.initState();
    futureReservas = repository.getReservas();
  }

  void refreshReservas() {
    setState(() {
      futureReservas = repository.getReservas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservas'),
      ),
      body: FutureBuilder<List<Reserva>>(
        future: futureReservas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final reservas = snapshot.data!;
          if (reservas.isEmpty) {
            return const Center(child: Text('Nenhuma reserva encontrada'));
          }
          return ListView.builder(
            itemCount: reservas.length,
            itemBuilder: (context, index) {
              final reserva = reservas[index];
              return ListTile(
                title: Text('Reserva ${reserva.id}'),
                subtitle: Text('Status: ${reserva.status}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                          builder: (_) => ReservaFormScreen(
                            repository: repository,
                            reserva: reserva,
                          ),
                        ))
                        .then((_) => refreshReservas());
                  },
                ),
                onLongPress: () async {
                  bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Remover Reserva'),
                      content: const Text('Deseja remover esta reserva?'),
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
                    await repository.deleteReserva(reserva.id);
                    refreshReservas();
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
                builder: (_) => ReservaFormScreen(repository: repository),
              ))
              .then((_) => refreshReservas());
        },
      ),
    );
  }
}
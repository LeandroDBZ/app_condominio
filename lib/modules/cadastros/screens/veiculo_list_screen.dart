// lib/modules/cadastros/screens/veiculo_list_screen.dart

import 'package:flutter/material.dart';
import 'package:app_condominio/modules/cadastros/models/veiculo.dart';
import 'package:app_condominio/modules/cadastros/repositories/veiculo_repository.dart';
import 'veiculo_form_screen.dart';

class VeiculoListScreen extends StatefulWidget {
  @override
  _VeiculoListScreenState createState() => _VeiculoListScreenState();
}

class _VeiculoListScreenState extends State<VeiculoListScreen> {
  late Future<List<Veiculo>> futureVeiculos;
  final VeiculoRepository repository = VeiculoRepository();

  @override
  void initState() {
    super.initState();
    futureVeiculos = repository.getVeiculos();
  }

  void refreshVeiculos() {
    setState(() {
      futureVeiculos = repository.getVeiculos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Veículos'),
      ),
      body: FutureBuilder<List<Veiculo>>(
        future: futureVeiculos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final veiculos = snapshot.data!;
          if (veiculos.isEmpty) {
            return const Center(child: Text('Nenhum veículo encontrado'));
          }
          return ListView.builder(
            itemCount: veiculos.length,
            itemBuilder: (context, index) {
              final veiculo = veiculos[index];
              return ListTile(
                title: Text('Placa: ${veiculo.placa}'),
                subtitle: Text('Marca: ${veiculo.marca} - Cor: ${veiculo.cor}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                          builder: (_) => VeiculoFormScreen(
                            repository: repository,
                            veiculo: veiculo,
                          ),
                        ))
                        .then((_) => refreshVeiculos());
                  },
                ),
                onLongPress: () async {
                  bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Remover Veículo'),
                      content: const Text('Deseja remover este veículo?'),
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
                    await repository.deleteVeiculo(veiculo.id);
                    refreshVeiculos();
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
                builder: (_) => VeiculoFormScreen(repository: repository),
              ))
              .then((_) => refreshVeiculos());
        },
      ),
    );
  }
}
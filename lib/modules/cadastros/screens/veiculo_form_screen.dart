// lib/modules/cadastros/screens/veiculo_form_screen.dart

import 'package:flutter/material.dart';
import 'package:app_condominio/modules/cadastros/models/veiculo.dart';
import 'package:app_condominio/modules/cadastros/repositories/veiculo_repository.dart';

class VeiculoFormScreen extends StatefulWidget {
  final Veiculo? veiculo;
  final VeiculoRepository repository;

  const VeiculoFormScreen({Key? key, this.veiculo, required this.repository})
      : super(key: key);

  @override
  _VeiculoFormScreenState createState() => _VeiculoFormScreenState();
}

class _VeiculoFormScreenState extends State<VeiculoFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late String cor;
  late String placa;
  late String marca;
  late String foto;

  @override
  void initState() {
    super.initState();
    cor = widget.veiculo?.cor ?? '';
    placa = widget.veiculo?.placa ?? '';
    marca = widget.veiculo?.marca ?? '';
    foto = widget.veiculo?.foto ?? '';
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      // Gera um ID simples se for um novo registro
      final String id =
          widget.veiculo?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

      final newVeiculo = Veiculo(
        id: id,
        cor: cor,
        placa: placa,
        marca: marca,
        foto: foto,
      );

      try {
        if (widget.veiculo == null) {
          await widget.repository.createVeiculo(newVeiculo);
        } else {
          await widget.repository.updateVeiculo(newVeiculo);
        }
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.veiculo == null ? 'Novo Veículo' : 'Editar Veículo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo para Cor
              TextFormField(
                initialValue: cor,
                decoration: const InputDecoration(labelText: 'Cor'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a cor';
                  }
                  return null;
                },
                onSaved: (value) => cor = value!.trim(),
              ),
              const SizedBox(height: 16),
              // Campo para Placa
              TextFormField(
                initialValue: placa,
                decoration: const InputDecoration(labelText: 'Placa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a placa';
                  }
                  return null;
                },
                onSaved: (value) => placa = value!.trim(),
              ),
              const SizedBox(height: 16),
              // Campo para Marca
              TextFormField(
                initialValue: marca,
                decoration: const InputDecoration(labelText: 'Marca'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a marca';
                  }
                  return null;
                },
                onSaved: (value) => marca = value!.trim(),
              ),
              const SizedBox(height: 16),
              // Campo para Foto (URL)
              TextFormField(
                initialValue: foto,
                decoration: const InputDecoration(labelText: 'Foto (URL)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a URL da foto';
                  }
                  return null;
                },
                onSaved: (value) => foto = value!.trim(),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    child: const Text('Cancelar'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  ElevatedButton(
                    child: const Text('Salvar'),
                    onPressed: _submitForm,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
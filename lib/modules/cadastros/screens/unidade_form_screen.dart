// lib/modules/cadastros/screens/unidade_form_screen.dart
import 'package:flutter/material.dart';
import 'package:app_condominio/modules/cadastros/models/unidade.dart';
import 'package:app_condominio/modules/cadastros/repositories/unidade_repository.dart';

class UnidadeFormScreen extends StatefulWidget {
  final Unidade? unidade;
  final UnidadeRepository repository;

  UnidadeFormScreen({this.unidade, required this.repository});

  @override
  _UnidadeFormScreenState createState() => _UnidadeFormScreenState();
}

class _UnidadeFormScreenState extends State<UnidadeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String bloco;
  late String apartamento;

  @override
  void initState() {
    super.initState();
    bloco = widget.unidade?.bloco ?? '';
    apartamento = widget.unidade?.apartamento ?? '';
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Se for novo registro, gera um ID simples (pode ser substituído por um UUID, por exemplo)
      String id = widget.unidade?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
      Unidade unidade = Unidade(id: id, bloco: bloco, apartamento: apartamento);

      try {
        if (widget.unidade == null) {
          await widget.repository.createUnidade(unidade);
        } else {
          await widget.repository.updateUnidade(unidade);
        }
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erro ao salvar unidade: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.unidade == null ? 'Nova Unidade' : 'Editar Unidade'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: bloco,
                decoration: InputDecoration(labelText: 'Bloco'),
                validator: (value) => value == null || value.isEmpty ? 'Informe o bloco' : null,
                onSaved: (value) => bloco = value ?? '',
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: apartamento,
                decoration: InputDecoration(labelText: 'Apartamento'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o apartamento' : null,
                onSaved: (value) => apartamento = value ?? '',
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    child: Text('Cancelar'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  ElevatedButton(
                    child: Text('Salvar'),
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
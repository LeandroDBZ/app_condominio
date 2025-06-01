// lib/modules/cadastros/screens/funcionario_form_screen.dart

import 'package:flutter/material.dart';
import 'package:app_condominio/modules/cadastros/models/funcionario.dart';
import 'package:app_condominio/modules/cadastros/repositories/funcionario_repository.dart';

class FuncionarioFormScreen extends StatefulWidget {
  final Funcionario? funcionario;
  final FuncionarioRepository repository;

  const FuncionarioFormScreen({Key? key, this.funcionario, required this.repository})
      : super(key: key);

  @override
  _FuncionarioFormScreenState createState() => _FuncionarioFormScreenState();
}

class _FuncionarioFormScreenState extends State<FuncionarioFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late String nome;
  late String telefone;
  late String cpf;
  late String funcao;

  @override
  void initState() {
    super.initState();
    nome = widget.funcionario?.nome ?? '';
    telefone = widget.funcionario?.telefone ?? '';
    cpf = widget.funcionario?.cpf ?? '';
    funcao = widget.funcionario?.funcao ?? '';
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Para novo registro, gera um ID simples a partir do timestamp.
      final String id = widget.funcionario?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
      final funcionario = Funcionario(
        id: id,
        nome: nome,
        telefone: telefone,
        cpf: cpf,
        funcao: funcao,
      );

      try {
        if (widget.funcionario == null) {
          await widget.repository.createFuncionario(funcionario);
        } else {
          await widget.repository.updateFuncionario(funcionario);
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
        title: Text(widget.funcionario == null ? 'Novo Funcionário' : 'Editar Funcionário'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Campo para Nome
                TextFormField(
                  initialValue: nome,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o nome';
                    }
                    return null;
                  },
                  onSaved: (value) => nome = value!.trim(),
                ),
                const SizedBox(height: 16),
                // Campo para Telefone
                TextFormField(
                  initialValue: telefone,
                  decoration: const InputDecoration(labelText: 'Telefone'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o telefone';
                    }
                    return null;
                  },
                  onSaved: (value) => telefone = value!.trim(),
                ),
                const SizedBox(height: 16),
                // Campo para CPF
                TextFormField(
                  initialValue: cpf,
                  decoration: const InputDecoration(labelText: 'CPF'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o CPF';
                    }
                    return null;
                  },
                  onSaved: (value) => cpf = value!.trim(),
                ),
                const SizedBox(height: 16),
                // Campo para Função
                TextFormField(
                  initialValue: funcao,
                  decoration: const InputDecoration(labelText: 'Função'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a função';
                    }
                    return null;
                  },
                  onSaved: (value) => funcao = value!.trim(),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

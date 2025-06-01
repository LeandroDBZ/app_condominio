// lib/modules/cadastros/screens/ocorrencia_form_screen.dart

import 'package:flutter/material.dart';
import 'package:app_condominio/modules/cadastros/models/ocorrencia.dart';
import 'package:app_condominio/modules/cadastros/repositories/ocorrencia_repository.dart';

class OcorrenciaFormScreen extends StatefulWidget {
  final Ocorrencia? ocorrencia;
  final OcorrenciaRepository repository;

  const OcorrenciaFormScreen({Key? key, this.ocorrencia, required this.repository})
      : super(key: key);

  @override
  _OcorrenciaFormScreenState createState() => _OcorrenciaFormScreenState();
}

class _OcorrenciaFormScreenState extends State<OcorrenciaFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late String titulo;
  late String descricao;
  late String tipo;
  late String dataHoraRegistroText;

  @override
  void initState() {
    super.initState();
    titulo = widget.ocorrencia?.titulo ?? '';
    descricao = widget.ocorrencia?.descricao ?? '';
    tipo = widget.ocorrencia?.tipo ?? '';
    dataHoraRegistroText = widget.ocorrencia != null
        ? widget.ocorrencia!.dataHoraRegistro.toIso8601String()
        : DateTime.now().toIso8601String();
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      
      // Converte a string para DateTime
      DateTime dataHoraRegistro = DateTime.parse(dataHoraRegistroText);
      
      // Gera um ID simples se for novo registro.
      final String id = widget.ocorrencia?.id ??
          DateTime.now().millisecondsSinceEpoch.toString();
      
      final ocorrencia = Ocorrencia(
        id: id,
        titulo: titulo,
        descricao: descricao,
        tipo: tipo,
        dataHoraRegistro: dataHoraRegistro,
      );
      
      try {
        if (widget.ocorrencia == null) {
          await widget.repository.createOcorrencia(ocorrencia);
        } else {
          await widget.repository.updateOcorrencia(ocorrencia);
        }
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ocorrencia == null ? 'Nova Ocorrência' : 'Editar Ocorrência'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Campo para Título
                TextFormField(
                  initialValue: titulo,
                  decoration: const InputDecoration(labelText: 'Título'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe um título';
                    }
                    return null;
                  },
                  onSaved: (value) => titulo = value!.trim(),
                ),
                const SizedBox(height: 16),
                // Campo para Descrição
                TextFormField(
                  initialValue: descricao,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a descrição';
                    }
                    return null;
                  },
                  onSaved: (value) => descricao = value!.trim(),
                ),
                const SizedBox(height: 16),
                // Campo para Tipo
                TextFormField(
                  initialValue: tipo,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o tipo';
                    }
                    return null;
                  },
                  onSaved: (value) => tipo = value!.trim(),
                ),
                const SizedBox(height: 16),
                // Campo para Data/Hora de Registro em formato ISO8601
                TextFormField(
                  initialValue: dataHoraRegistroText,
                  decoration: const InputDecoration(
                    labelText: 'Data/Hora de Registro (ISO8601)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a data/hora de registro';
                    }
                    try {
                      DateTime.parse(value);
                    } catch (e) {
                      return 'Formato inválido';
                    }
                    return null;
                  },
                  onSaved: (value) => dataHoraRegistroText = value!.trim(),
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
                    ),
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
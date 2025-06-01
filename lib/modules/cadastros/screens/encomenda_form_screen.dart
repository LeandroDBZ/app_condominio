// lib/modules/cadastros/screens/encomenda_form_screen.dart

import 'package:flutter/material.dart';
import 'package:app_condominio/modules/cadastros/models/encomenda.dart';
import 'package:app_condominio/modules/cadastros/repositories/encomenda_repository.dart';

class EncomendaFormScreen extends StatefulWidget {
  final Encomenda? encomenda;
  final EncomendaRepository repository;

  const EncomendaFormScreen({Key? key, this.encomenda, required this.repository})
      : super(key: key);

  @override
  _EncomendaFormScreenState createState() => _EncomendaFormScreenState();
}

class _EncomendaFormScreenState extends State<EncomendaFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late String foto;
  late String qrCode;
  late String status;
  late String dataHoraRegistroText;
  late String dataHoraRetiradaText;

  @override
  void initState() {
    super.initState();
    // Caso seja edição, inicialize com os valores existentes; senão, valores padrão.
    foto = widget.encomenda?.foto ?? '';
    qrCode = widget.encomenda?.qrCode ?? '';
    status = widget.encomenda?.status ?? 'Pendente';
    // Formata as datas em String ISO, se já existirem.
    dataHoraRegistroText = widget.encomenda != null
        ? widget.encomenda!.dataHoraRegistro.toIso8601String()
        : DateTime.now().toIso8601String();
    dataHoraRetiradaText = widget.encomenda?.dataHoraRetirada != null
        ? widget.encomenda!.dataHoraRetirada!.toIso8601String()
        : '';
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Converte as strings para DateTime. Trata dataHoraRetirada como opcional.
      DateTime dataRegistro = DateTime.parse(dataHoraRegistroText);
      DateTime? dataRetirada = dataHoraRetiradaText.isNotEmpty
          ? DateTime.parse(dataHoraRetiradaText)
          : null;

      // Gera um ID simples se for novo registro.
      final String id = widget.encomenda?.id ??
          DateTime.now().millisecondsSinceEpoch.toString();

      final encomenda = Encomenda(
        id: id,
        foto: foto,
        qrCode: qrCode,
        status: status,
        dataHoraRegistro: dataRegistro,
        dataHoraRetirada: dataRetirada,
      );

      try {
        if (widget.encomenda == null) {
          await widget.repository.createEncomenda(encomenda);
        } else {
          await widget.repository.updateEncomenda(encomenda);
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
        title: Text(
            widget.encomenda == null ? 'Nova Encomenda' : 'Editar Encomenda'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Campo para Foto
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
                const SizedBox(height: 16),
                // Campo para QR Code
                TextFormField(
                  initialValue: qrCode,
                  decoration: const InputDecoration(labelText: 'QR Code'),
                  onSaved: (value) => qrCode = value!.trim(),
                ),
                const SizedBox(height: 16),
                // Campo para Status
                TextFormField(
                  initialValue: status,
                  decoration: const InputDecoration(labelText: 'Status'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o status';
                    }
                    return null;
                  },
                  onSaved: (value) => status = value!.trim(),
                ),
                const SizedBox(height: 16),
                // Campo para Data/Hora de Registro
                TextFormField(
                  initialValue: dataHoraRegistroText,
                  decoration: const InputDecoration(
                      labelText: 'Data/Hora de Registro (ISO8601)'),
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
                const SizedBox(height: 16),
                // Campo para Data/Hora de Retirada (opcional)
                TextFormField(
                  initialValue: dataHoraRetiradaText,
                  decoration: const InputDecoration(
                      labelText: 'Data/Hora de Retirada (opcional, ISO8601)'),
                  onSaved: (value) =>
                      dataHoraRetiradaText = value!.trim(),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
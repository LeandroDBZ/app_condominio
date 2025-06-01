import 'package:flutter/material.dart';
import 'package:app_condominio/modules/cadastros/models/visitante.dart';
import 'package:app_condominio/modules/cadastros/repositories/visitante_repository.dart';

class VisitanteFormScreen extends StatefulWidget {
  final Visitante? visitante;
  final VisitanteRepository repository;

  const VisitanteFormScreen({Key? key, this.visitante, required this.repository})
      : super(key: key);

  @override
  _VisitanteFormScreenState createState() => _VisitanteFormScreenState();
}

class _VisitanteFormScreenState extends State<VisitanteFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late String nome;
  late String documento;
  late String qrCode;
  late String validadeText;

  @override
  void initState() {
    super.initState();
    nome = widget.visitante?.nome ?? '';
    documento = widget.visitante?.documento ?? '';
    qrCode = widget.visitante?.qrCode ?? '';
    // Se for novo, pode definir a validade para 1 dia no futuro por padrão.
    validadeText = widget.visitante != null
        ? widget.visitante!.validade.toIso8601String()
        : DateTime.now().add(const Duration(days: 1)).toIso8601String();
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      DateTime validade;
      try {
        validade = DateTime.parse(validadeText);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Formato de data inválido. Use ISO8601.')),
        );
        return;
      }

      // Gera um ID simples caso seja novo
      final String id = widget.visitante?.id ??
          DateTime.now().millisecondsSinceEpoch.toString();

      final visitante = Visitante(
        id: id,
        nome: nome,
        documento: documento,
        qrCode: qrCode,
        validade: validade,
      );

      try {
        if (widget.visitante == null) {
          await widget.repository.createVisitante(visitante);
        } else {
          await widget.repository.updateVisitante(visitante);
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
        title: Text(widget.visitante == null ? 'Novo Visitante' : 'Editar Visitante'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo para Nome
              TextFormField(
                initialValue: nome,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Informe o nome' : null,
                onSaved: (value) => nome = value!.trim(),
              ),
              const SizedBox(height: 16),
              // Campo para Documento
              TextFormField(
                initialValue: documento,
                decoration: const InputDecoration(labelText: 'Documento'),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Informe o documento' : null,
                onSaved: (value) => documento = value!.trim(),
              ),
              const SizedBox(height: 16),
              // Campo para QR Code (opcional)
              TextFormField(
                initialValue: qrCode,
                decoration: const InputDecoration(labelText: 'QR Code'),
                onSaved: (value) => qrCode = value!.trim(),
              ),
              const SizedBox(height: 16),
              // Campo para Validade (ISO8601)
              TextFormField(
                initialValue: validadeText,
                decoration:
                    const InputDecoration(labelText: 'Validade (ISO8601)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a validade';
                  }
                  try {
                    DateTime.parse(value);
                  } catch (e) {
                    return 'Formato inválido';
                  }
                  return null;
                },
                onSaved: (value) => validadeText = value!.trim(),
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
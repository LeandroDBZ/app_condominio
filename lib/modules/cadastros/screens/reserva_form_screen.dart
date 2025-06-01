// lib/modules/cadastros/screens/reserva_form_screen.dart

import 'package:flutter/material.dart';
import 'package:app_condominio/modules/cadastros/models/reserva.dart';
import 'package:app_condominio/modules/cadastros/repositories/reserva_repository.dart';

class ReservaFormScreen extends StatefulWidget {
  final Reserva? reserva;
  final ReservaRepository repository;

  const ReservaFormScreen({Key? key, this.reserva, required this.repository})
      : super(key: key);

  @override
  _ReservaFormScreenState createState() => _ReservaFormScreenState();
}

class _ReservaFormScreenState extends State<ReservaFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late String dataText;
  late String horaInicioText;
  late String horaFimText;
  late String status;

  @override
  void initState() {
    super.initState();
    if (widget.reserva != null) {
      dataText = widget.reserva!.data.toIso8601String();
      horaInicioText = widget.reserva!.horaInicio.toIso8601String();
      horaFimText = widget.reserva!.horaFim.toIso8601String();
      status = widget.reserva!.status;
    } else {
      dataText = DateTime.now().toIso8601String();
      horaInicioText = DateTime.now().toIso8601String();
      horaFimText = DateTime.now().toIso8601String();
      status = 'Pendente';
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      try {
        DateTime data = DateTime.parse(dataText);
        DateTime horaInicio = DateTime.parse(horaInicioText);
        DateTime horaFim = DateTime.parse(horaFimText);
        String id = widget.reserva?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

        final novaReserva = Reserva(
          id: id,
          data: data,
          horaInicio: horaInicio,
          horaFim: horaFim,
          status: status,
        );

        if (widget.reserva == null) {
          await widget.repository.createReserva(novaReserva);
        } else {
          await widget.repository.updateReserva(novaReserva);
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
        title: Text(widget.reserva == null ? 'Nova Reserva' : 'Editar Reserva'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo para Data
              TextFormField(
                initialValue: dataText,
                decoration: const InputDecoration(
                  labelText: 'Data (ISO8601)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a data';
                  }
                  try {
                    DateTime.parse(value);
                  } catch (e) {
                    return 'Formato inválido';
                  }
                  return null;
                },
                onSaved: (value) => dataText = value!.trim(),
              ),
              const SizedBox(height: 16),
              // Campo para Hora de Início
              TextFormField(
                initialValue: horaInicioText,
                decoration: const InputDecoration(
                  labelText: 'Hora de Início (ISO8601)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a hora de início';
                  }
                  try {
                    DateTime.parse(value);
                  } catch (e) {
                    return 'Formato inválido';
                  }
                  return null;
                },
                onSaved: (value) => horaInicioText = value!.trim(),
              ),
              const SizedBox(height: 16),
              // Campo para Hora de Fim
              TextFormField(
                initialValue: horaFimText,
                decoration: const InputDecoration(
                  labelText: 'Hora de Fim (ISO8601)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a hora de fim';
                  }
                  try {
                    DateTime.parse(value);
                  } catch (e) {
                    return 'Formato inválido';
                  }
                  return null;
                },
                onSaved: (value) => horaFimText = value!.trim(),
              ),
              const SizedBox(height: 16),
              // Campo para Status
              TextFormField(
                initialValue: status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o status';
                  }
                  return null;
                },
                onSaved: (value) => status = value!.trim(),
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
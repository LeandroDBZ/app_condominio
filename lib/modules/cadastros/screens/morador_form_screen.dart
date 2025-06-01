import 'package:flutter/material.dart';
import 'package:app_condominio/modules/cadastros/models/morador.dart';
import 'package:app_condominio/modules/cadastros/repositories/morador_repository.dart';

class MoradorFormScreen extends StatefulWidget {
  final Morador? morador;
  final MoradorRepository repository;

  const MoradorFormScreen({Key? key, this.morador, required this.repository})
      : super(key: key);

  @override
  _MoradorFormScreenState createState() => _MoradorFormScreenState();
}

class _MoradorFormScreenState extends State<MoradorFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late String nome;
  late String telefone;
  late String cpf;
  
  // Exemplo de dropdown para um campo fictício "Grupo" (opcional)
  String? grupo;
  final List<String> grupos = ['A', 'B', 'C'];

  @override
  void initState() {
    super.initState();
    nome = widget.morador?.nome ?? '';
    telefone = widget.morador?.telefone ?? '';
    cpf = widget.morador?.cpf ?? '';
    grupo = grupos.first; // caso queira adicionar algum grupo fictício
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Gera um ID simples se for um novo registro
      final String id = widget.morador?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

      // Cria a instância do morador
      final morador = Morador(
        id: id,
        nome: nome,
        telefone: telefone,
        cpf: cpf,
      );

      try {
        if (widget.morador == null) {
          await widget.repository.createMorador(morador);
        } else {
          await widget.repository.updateMorador(morador);
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
        title:
            Text(widget.morador == null ? 'Novo Morador' : 'Editar Morador'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Campo para nome
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
                // Campo para telefone
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
                // Exemplo de DropdownButton, por exemplo para escolher um grupo
                DropdownButtonFormField<String>(
                  value: grupo,
                  decoration: const InputDecoration(labelText: 'Grupo'),
                  items: grupos
                      .map((g) => DropdownMenuItem(
                            value: g,
                            child: Text(g),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      grupo = value;
                    });
                  },
                  onSaved: (value) {
                    // Se você precisar salvar essa propriedade, adicione-a ao modelo
                  },
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
// lib/main.dart
import 'package:flutter/material.dart';
import 'modules/cadastros/models/unidade.dart';
import 'modules/cadastros/repositories/unidade_repository.dart';
import 'modules/cadastros/screens/unidade_form_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Instância do repositório. Se sua API não estiver disponível
  // para testes, você pode criar uma implementação fake.
  final UnidadeRepository repository = UnidadeRepository();

  @override
  Widget build(BuildContext context) {
    // Para testar o comportamento de edição, você pode criar uma Unidade dummy.
    // Para testar o "novo cadastro", deixe a variável como null.
    Unidade? dummyUnidade;
    // Descomente a linha abaixo para testar a edição de uma Unidade existente:
    // dummyUnidade = Unidade(id: '1', bloco: 'A', apartamento: '101');

    return MaterialApp(
      title: 'Teste de Unidade Form',
      // ignore: unnecessary_null_comparison
      home: dummyUnidade == null 
          ? UnidadeFormScreen(repository: repository)
          : UnidadeFormScreen(repository: repository, unidade: dummyUnidade),
    );
  }
}
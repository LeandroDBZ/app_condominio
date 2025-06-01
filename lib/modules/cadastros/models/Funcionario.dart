// lib/modules/cadastros/models/funcionario.dart

import 'encomenda.dart'; // Certifique-se de que existe a classe Encomenda com fromJson/toJson

class Funcionario {
  final String id;
  final String nome;
  final String telefone;
  final String cpf;
  final String funcao;

  Funcionario({
    required this.id,
    required this.nome,
    required this.telefone,
    required this.cpf,
    required this.funcao,
  });

  /// Registra uma encomenda e exibe uma mensagem (pode ser expandido conforme a lógica do seu app)
  void registrarEncomenda(Encomenda e) {
    print("Funcionário $nome registrou a encomenda ${e.id}.");
    // Aqui você pode implementar a lógica de registrar a encomenda na API ou realizar outras operações.
  }

  /// Valida o QR Code recebido (neste exemplo, considera válido se não estiver vazio)
  bool validarQRCode(String qr) {
    final isValid = qr.isNotEmpty;
    print("QR Code '$qr' é ${isValid ? "válido" : "inválido"} pelo funcionário $nome.");
    return isValid;
  }

  /// Cria uma instância de Funcionario a partir de um JSON
  factory Funcionario.fromJson(Map<String, dynamic> json) {
    return Funcionario(
      id: json['id'] as String,
      nome: json['nome'] as String,
      telefone: json['telefone'] as String,
      cpf: json['cpf'] as String,
      funcao: json['funcao'] as String,
    );
  }

  /// Converte esta instância em um Map compatível com JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'cpf': cpf,
      'funcao': funcao,
    };
  }
}
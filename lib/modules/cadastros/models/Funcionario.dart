import 'Encomenda.dart';

/// Representa um funcionário responsável por registrar encomendas e validar QR Codes.
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

  void registrarEncomenda(Encomenda e) {
    print("Funcionário $nome registrou a encomenda ${e.id}.");
  }

  bool validarQRCode(String qr) {
    bool valido = qr.isNotEmpty;
    print("QR Code '$qr' é ${valido ? "válido" : "inválido"} pelo funcionário $nome.");
    return valido;
  }
}
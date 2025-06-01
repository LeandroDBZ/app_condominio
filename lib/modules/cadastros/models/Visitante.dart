import 'dart:math';

class Visitante {
  final String id;
  final String nome;
  final String documento;
  String qrCode;
  DateTime validade;

  Visitante({
    required this.id,
    required this.nome,
    required this.documento,
    this.qrCode = '',
    required this.validade,
  });

  /// Gera um QR Code simples de exemplo para o visitante.
  void gerarQRCode() {
    qrCode = "QR${Random().nextInt(100000).toString().padLeft(5, '0')}";
    print("QR Code gerado para o visitante $nome: $qrCode.");
  }

  /// Verifica se o QR Code ainda é válido com base na data atual.
  bool isQRCodeValido(DateTime now) {
    bool valido = now.isBefore(validade);
    print("QR Code do visitante $nome é ${valido ? "válido" : "inválido"}.");
    return valido;
  }

  /// Cria uma instância de Visitante a partir de um Map (JSON).
  factory Visitante.fromJson(Map<String, dynamic> json) {
    return Visitante(
      id: json['id'] as String,
      nome: json['nome'] as String,
      documento: json['documento'] as String,
      qrCode: json['qrCode'] as String? ?? '',
      validade: DateTime.parse(json['validade'] as String),
    );
  }

  /// Converte essa instância em um Map compatível com JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'documento': documento,
      'qrCode': qrCode,
      'validade': validade.toIso8601String(),
    };
  }
}
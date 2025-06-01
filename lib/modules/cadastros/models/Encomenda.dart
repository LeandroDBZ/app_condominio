// lib/modules/cadastros/models/encomenda.dart

class Encomenda {
  final String id;
  String foto;
  String qrCode;
  String status;
  DateTime dataHoraRegistro;
  DateTime? dataHoraRetirada;

  Encomenda({
    required this.id,
    required this.foto,
    this.qrCode = '',
    this.status = 'Pendente',
    required this.dataHoraRegistro,
    this.dataHoraRetirada,
  });

  /// Gera um QR Code para retirada (exemplo simples)
  void gerarQRCodeParaRetirada() {
    qrCode = "EC${DateTime.now().millisecondsSinceEpoch}";
    print("QR Code para retirada gerado: $qrCode");
  }

  /// Notifica o morador sobre a encomenda, ex.: por meio de push notification
  void notificarMorador() {
    print("Morador notificado sobre a encomenda $id.");
  }

  /// Atualiza o status da encomenda
  void atualizarStatus(String novoStatus) {
    status = novoStatus;
    print("Status da encomenda $id atualizado para $status.");
  }

  /// Cria uma instância de Encomenda a partir de um Map (JSON)
  factory Encomenda.fromJson(Map<String, dynamic> json) {
    return Encomenda(
      id: json['id'] as String,
      foto: json['foto'] as String,
      qrCode: json['qrCode'] as String? ?? '',
      status: json['status'] as String? ?? 'Pendente',
      dataHoraRegistro: DateTime.parse(json['dataHoraRegistro'] as String),
      dataHoraRetirada: json['dataHoraRetirada'] != null
          ? DateTime.parse(json['dataHoraRetirada'] as String)
          : null,
    );
  }

  /// Converte esta instância em um Map compatível com JSON
  Map<String, dynamic> toJson() {
    return {
      'foto': foto,
      'qrCode': qrCode,
      'status': status,
      'dataHoraRegistro': dataHoraRegistro.toIso8601String(),
      'dataHoraRetirada': dataHoraRetirada?.toIso8601String(),
    };
  }
}
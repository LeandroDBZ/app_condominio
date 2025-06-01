/// Representa uma encomenda associada à unidade e que notifica o morador.
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

  void gerarQRCodeParaRetirada() {
    qrCode = "EC${DateTime.now().millisecondsSinceEpoch}";
    print("QR Code para retirada gerado para a encomenda $id: $qrCode.");
  }

  void notificarMorador() {
    print("Morador notificado sobre a encomenda $id.");
  }

  void atualizarStatus(String novoStatus) {
    status = novoStatus;
    print("Status da encomenda $id atualizado para $status.");
  }
}
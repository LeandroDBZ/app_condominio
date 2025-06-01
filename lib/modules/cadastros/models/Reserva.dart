// lib/modules/cadastros/models/reserva.dart

class Reserva {
  final String id;
  DateTime data;
  DateTime horaInicio;
  DateTime horaFim;
  String status;

  Reserva({
    required this.id,
    required this.data,
    required this.horaInicio,
    required this.horaFim,
    this.status = 'Pendente',
  });

  /// Envia a solicitação de reserva (exemplo de ação).
  void enviarSolicitacao() {
    print("Reserva $id: solicitação enviada.");
  }

  /// Atualiza o status da reserva.
  void atualizarStatus(String novoStatus) {
    status = novoStatus;
    print("Reserva $id atualizada para: $status");
  }

  /// Notifica o morador sobre o status da reserva.
  void notificarMoradorSobreStatus() {
    print("Morador notificado sobre reserva $id com status $status.");
  }

  /// Cria uma instância de Reserva a partir de um Map (JSON).
  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      id: json['id'] as String,
      data: DateTime.parse(json['data'] as String),
      horaInicio: DateTime.parse(json['horaInicio'] as String),
      horaFim: DateTime.parse(json['horaFim'] as String),
      status: json['status'] as String? ?? 'Pendente',
    );
  }

  /// Converte esta instância em um Map compatível com JSON.
  Map<String, dynamic> toJson() {
    return {
      'data': data.toIso8601String(),
      'horaInicio': horaInicio.toIso8601String(),
      'horaFim': horaFim.toIso8601String(),
      'status': status,
    };
  }
}
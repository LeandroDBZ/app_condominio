// lib/modules/cadastros/models/ocorrencia.dart

class Ocorrencia {
  final String id;
  final String titulo;
  final String descricao;
  final String tipo;
  DateTime dataHoraRegistro;

  Ocorrencia({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.tipo,
    required this.dataHoraRegistro,
  });

  /// Exemplo de ação: registra a ocorrência.
  void registrarOcorrencia() {
    print("Ocorrência '$titulo' registrada em $dataHoraRegistro.");
  }

  /// Exemplo de ação: notifica a administração.
  void notificarAdministracao() {
    print("Administração notificada sobre a ocorrência '$titulo'.");
  }

  /// Cria uma instância de Ocorrencia a partir de um Map (JSON).
  factory Ocorrencia.fromJson(Map<String, dynamic> json) {
    return Ocorrencia(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      descricao: json['descricao'] as String,
      tipo: json['tipo'] as String,
      dataHoraRegistro: DateTime.parse(json['dataHoraRegistro'] as String),
    );
  }

  /// Converte esta instância em um Map compatível com JSON.
  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'tipo': tipo,
      'dataHoraRegistro': dataHoraRegistro.toIso8601String(),
    };
  }
}
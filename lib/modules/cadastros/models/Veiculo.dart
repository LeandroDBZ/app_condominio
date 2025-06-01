class Veiculo {
  final String id;
  String cor;
  String placa;
  String marca;
  String foto;

  Veiculo({
    required this.id,
    required this.cor,
    required this.placa,
    required this.marca,
    required this.foto,
  });

  /// Atualiza os dados do veículo.
  void atualizarDados(String nCor, String nPlaca, String nMarca, String nFoto) {
    cor = nCor;
    placa = nPlaca;
    marca = nMarca;
    foto = nFoto;
    print("Dados do veículo $id atualizados.");
  }

  /// Cria uma instância de Veiculo a partir de um Map (JSON).
  factory Veiculo.fromJson(Map<String, dynamic> json) {
    return Veiculo(
      id: json['id'] as String,
      cor: json['cor'] as String,
      placa: json['placa'] as String,
      marca: json['marca'] as String,
      foto: json['foto'] as String,
    );
  }

  /// Converte essa instância em um Map compatível com JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cor': cor,
      'placa': placa,
      'marca': marca,
      'foto': foto,
    };
  }
}
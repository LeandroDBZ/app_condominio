// lib/modules/cadastros/models/morador.dart

import 'veiculo.dart';
import 'reserva.dart';
import 'ocorrencia.dart';
import 'visitante.dart';

class Morador {
  final String id;
  final String nome;
  final String telefone;
  final String cpf;
  // Outras listas que relacionam o morador com outras entidades:
  final List<Veiculo> veiculos;
  final List<Reserva> reservas;
  final List<Ocorrencia> ocorrencias;
  final List<Visitante> visitantes;

  Morador({
    required this.id,
    required this.nome,
    required this.telefone,
    required this.cpf,
    List<Veiculo>? veiculos,
    List<Reserva>? reservas,
    List<Ocorrencia>? ocorrencias,
    List<Visitante>? visitantes,
  })  : veiculos = veiculos ?? [],
        reservas = reservas ?? [],
        ocorrencias = ocorrencias ?? [],
        visitantes = visitantes ?? [];

  /// Exemplo de criação (os métodos de ação já podem ser definidos aqui se necessário)
  void solicitarLiberacaoVisitante(Visitante v) {
    visitantes.add(v);
    print('Visitante ${v.nome} liberado pelo morador $nome.');
  }
  void registrarOcorrencia(Ocorrencia o) {
    ocorrencias.add(o);
    print('Ocorrência "${o.titulo}" registrada pelo morador $nome.');
  }
  void reservarAreaComum(Reserva r) {
    reservas.add(r);
    print('Reserva ${r.id} realizada pelo morador $nome.');
  }
  void cadastrarVeiculo(Veiculo v) {
    veiculos.add(v);
    print('Veículo ${v.placa} cadastrado pelo morador $nome.');
  }

  factory Morador.fromJson(Map<String, dynamic> json) {
    return Morador(
      id: json['id'] as String,
      nome: json['nome'] as String,
      telefone: json['telefone'] as String,
      cpf: json['cpf'] as String,
      veiculos: json['veiculos'] != null
          ? (json['veiculos'] as List)
              .map((v) => Veiculo.fromJson(v))
              .toList()
          : [],
      reservas: json['reservas'] != null
          ? (json['reservas'] as List)
              .map((r) => Reserva.fromJson(r))
              .toList()
          : [],
      ocorrencias: json['ocorrencias'] != null
          ? (json['ocorrencias'] as List)
              .map((o) => Ocorrencia.fromJson(o))
              .toList()
          : [],
      visitantes: json['visitantes'] != null
          ? (json['visitantes'] as List)
              .map((v) => Visitante.fromJson(v))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'cpf': cpf,
      'veiculos': veiculos.map((v) => v.toJson()).toList(),
      'reservas': reservas.map((r) => r.toJson()).toList(),
      'ocorrencias': ocorrencias.map((o) => o.toJson()).toList(),
      'visitantes': visitantes.map((v) => v.toJson()).toList(),
    };
  }
}
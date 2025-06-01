// lib/modules/cadastros/models/unidade.dart
import 'morador.dart';

class Unidade {
  final String id;
  final String bloco;
  final String apartamento;
  final List<Morador> moradores;

  Unidade({
    required this.id,
    required this.bloco,
    required this.apartamento,
    List<Morador>? moradores,
  }) : this.moradores = moradores ?? [];

  void addMorador(Morador m) => moradores.add(m);
  void removeMorador(Morador m) => moradores.remove(m);

  factory Unidade.fromJson(Map<String, dynamic> json) {
    return Unidade(
      id: json['id'] as String,
      bloco: json['bloco'] as String,
      apartamento: json['apartamento'] as String,
      moradores: json['moradores'] != null
          ? (json['moradores'] as List)
              .map((item) => Morador.fromJson(item))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'bloco': bloco,
        'apartamento': apartamento,
        'moradores': moradores.map((m) => m.toJson()).toList(),
      };
}
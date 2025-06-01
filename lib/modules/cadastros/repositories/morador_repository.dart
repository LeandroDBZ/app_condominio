import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/morador.dart';

class MoradorRepository {
  // URL base da API para a entidade Morador – ajuste conforme sua API.
  final String baseUrl = 'https://api.example.com/moradores';

  // Retorna a lista de moradores
  Future<List<Morador>> getMoradores() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Morador.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar moradores');
    }
  }

  // Cria um novo morador (POST)
  Future<Morador> createMorador(Morador morador) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(morador.toJson()),
    );
    if (response.statusCode == 201) {
      return Morador.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erro ao criar morador');
    }
  }

  // Atualiza um morador existente (PUT)
  Future<Morador> updateMorador(Morador morador) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${morador.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(morador.toJson()),
    );
    if (response.statusCode == 200) {
      return Morador.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erro ao atualizar morador');
    }
  }

  // Remove um morador (DELETE)
  Future<void> deleteMorador(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Erro ao remover morador');
    }
  }
}
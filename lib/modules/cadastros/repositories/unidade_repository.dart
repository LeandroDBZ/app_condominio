// lib/modules/cadastros/repositories/unidade_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/unidade.dart';

class UnidadeRepository {
  // URL base da API para operações com Unidade – ajuste conforme sua API.
  final String baseUrl = 'https://api.example.com/unidades';

  // Retorna a lista de unidades
  Future<List<Unidade>> getUnidades() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Unidade.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar unidades');
    }
  }

  // Cria uma nova unidade (POST)
  Future<Unidade> createUnidade(Unidade unidade) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(unidade.toJson()),
    );
    if (response.statusCode == 201) {
      return Unidade.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erro ao criar unidade');
    }
  }

  // Atualiza uma unidade existente (PUT)
  Future<Unidade> updateUnidade(Unidade unidade) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${unidade.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(unidade.toJson()),
    );
    if (response.statusCode == 200) {
      return Unidade.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erro ao atualizar unidade');
    }
  }

  // Remove uma unidade (DELETE)
  Future<void> deleteUnidade(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Erro ao remover unidade');
    }
  }
}
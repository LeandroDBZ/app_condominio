// lib/modules/cadastros/repositories/veiculo_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/veiculo.dart';

class VeiculoRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String collectionPath = 'veiculos';

  /// Retorna a lista de veículos do Firestore.
  Future<List<Veiculo>> getVeiculos() async {
    QuerySnapshot snapshot = await firestore.collection(collectionPath).get();
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // Adiciona o ID do documento
      return Veiculo.fromJson(data);
    }).toList();
  }

  /// Cria um novo veículo no Firestore.
  Future<Veiculo> createVeiculo(Veiculo veiculo) async {
    DocumentReference docRef =
        await firestore.collection(collectionPath).add(veiculo.toJson());
    DocumentSnapshot docSnapshot = await docRef.get();
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    data['id'] = docSnapshot.id;
    return Veiculo.fromJson(data);
  }

  /// Atualiza um veículo existente no Firestore.
  Future<Veiculo> updateVeiculo(Veiculo veiculo) async {
    await firestore.collection(collectionPath).doc(veiculo.id).update(veiculo.toJson());
    DocumentSnapshot docSnapshot = await firestore.collection(collectionPath).doc(veiculo.id).get();
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    data['id'] = docSnapshot.id;
    return Veiculo.fromJson(data);
  }

  /// Remove um veículo do Firestore.
  Future<void> deleteVeiculo(String id) async {
    await firestore.collection(collectionPath).doc(id).delete();
  }
}
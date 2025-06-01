// lib/modules/cadastros/repositories/encomenda_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/encomenda.dart';

class EncomendaRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String collectionPath = 'encomendas';

  /// Retorna a lista de encomendas da coleção Firestore.
  Future<List<Encomenda>> getEncomendas() async {
    QuerySnapshot snapshot = await firestore.collection(collectionPath).get();
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      // Adiciona o ID do documento aos dados.
      data['id'] = doc.id;
      return Encomenda.fromJson(data);
    }).toList();
  }

  /// Cria uma nova encomenda no Firestore.
  Future<Encomenda> createEncomenda(Encomenda encomenda) async {
    DocumentReference docRef =
        await firestore.collection(collectionPath).add(encomenda.toJson());
    DocumentSnapshot docSnapshot = await docRef.get();
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    data['id'] = docSnapshot.id;
    return Encomenda.fromJson(data);
  }

  /// Atualiza uma encomenda existente no Firestore.
  Future<Encomenda> updateEncomenda(Encomenda encomenda) async {
    await firestore
        .collection(collectionPath)
        .doc(encomenda.id)
        .update(encomenda.toJson());
    DocumentSnapshot docSnapshot =
        await firestore.collection(collectionPath).doc(encomenda.id).get();
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    data['id'] = docSnapshot.id;
    return Encomenda.fromJson(data);
  }

  /// Remove uma encomenda (documento) do Firestore.
  Future<void> deleteEncomenda(String id) async {
    await firestore.collection(collectionPath).doc(id).delete();
  }
}
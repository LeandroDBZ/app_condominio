// lib/modules/cadastros/repositories/ocorrencia_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ocorrencia.dart';

class OcorrenciaRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String collectionPath = 'ocorrencias';

  /// Recupera a lista de ocorrências da coleção Firestore.
  Future<List<Ocorrencia>> getOcorrencias() async {
    QuerySnapshot snapshot = await firestore.collection(collectionPath).get();
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      // Adiciona o ID do documento aos dados.
      data['id'] = doc.id;
      return Ocorrencia.fromJson(data);
    }).toList();
  }

  /// Cria uma nova ocorrência adicionando um documento na coleção.
  Future<Ocorrencia> createOcorrencia(Ocorrencia ocorrencia) async {
    DocumentReference docRef =
        await firestore.collection(collectionPath).add(ocorrencia.toJson());
    DocumentSnapshot docSnapshot = await docRef.get();
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    data['id'] = docSnapshot.id;
    return Ocorrencia.fromJson(data);
  }

  /// Atualiza uma ocorrência existente no Firestore.
  Future<Ocorrencia> updateOcorrencia(Ocorrencia ocorrencia) async {
    await firestore
        .collection(collectionPath)
        .doc(ocorrencia.id)
        .update(ocorrencia.toJson());
    DocumentSnapshot docSnapshot =
        await firestore.collection(collectionPath).doc(ocorrencia.id).get();
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    data['id'] = docSnapshot.id;
    return Ocorrencia.fromJson(data);
  }

  /// Remove uma ocorrência (exclui o documento) do Firestore.
  Future<void> deleteOcorrencia(String id) async {
    await firestore.collection(collectionPath).doc(id).delete();
  }
}
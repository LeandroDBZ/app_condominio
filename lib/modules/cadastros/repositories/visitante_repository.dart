import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/visitante.dart';

class VisitanteRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String collectionPath = 'visitantes';

  /// Recupera a lista de visitantes do Firestore.
  Future<List<Visitante>> getVisitantes() async {
    QuerySnapshot snapshot = await firestore.collection(collectionPath).get();
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // Adiciona o ID do documento aos dados.
      return Visitante.fromJson(data);
    }).toList();
  }

  /// Cria um novo visitante no Firestore.
  Future<Visitante> createVisitante(Visitante visitante) async {
    DocumentReference docRef = await firestore
        .collection(collectionPath)
        .add(visitante.toJson());
    DocumentSnapshot docSnapshot = await docRef.get();
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    data['id'] = docSnapshot.id;
    return Visitante.fromJson(data);
  }

  /// Atualiza um visitante existente no Firestore.
  Future<Visitante> updateVisitante(Visitante visitante) async {
    await firestore
        .collection(collectionPath)
        .doc(visitante.id)
        .update(visitante.toJson());
    DocumentSnapshot docSnapshot =
        await firestore.collection(collectionPath).doc(visitante.id).get();
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    data['id'] = docSnapshot.id;
    return Visitante.fromJson(data);
  }

  /// Remove um visitante do Firestore.
  Future<void> deleteVisitante(String id) async {
    await firestore.collection(collectionPath).doc(id).delete();
  }
}
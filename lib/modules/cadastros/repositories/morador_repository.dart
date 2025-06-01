// lib/modules/cadastros/repositories/morador_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/morador.dart';

class MoradorRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String collectionPath = 'moradores';

  // Retorna a lista de moradores
  Future<List<Morador>> getMoradores() async {
    QuerySnapshot snapshot = await firestore.collection(collectionPath).get();

    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      // Considere incluir o ID do documento no objeto
      data['id'] = doc.id;
      return Morador.fromJson(data);
    }).toList();
  }

  // Cria um novo morador (adiciona um documento)
  Future<Morador> createMorador(Morador morador) async {
    DocumentReference docRef =
        await firestore.collection(collectionPath).add(morador.toJson());
    
    // Após a criação, recupera os dados para retornar o objeto atualizado
    DocumentSnapshot docSnapshot = await docRef.get();
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    data['id'] = docSnapshot.id;
    return Morador.fromJson(data);
  }

  // Atualiza um morador existente (atualiza o documento)
  Future<Morador> updateMorador(Morador morador) async {
    await firestore.collection(collectionPath).doc(morador.id).update(morador.toJson());
    DocumentSnapshot docSnapshot = await firestore.collection(collectionPath).doc(morador.id).get();
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    data['id'] = docSnapshot.id;
    return Morador.fromJson(data);
  }

  // Remove um morador (deleta o documento)
  Future<void> deleteMorador(String id) async {
    await firestore.collection(collectionPath).doc(id).delete();
  }
}
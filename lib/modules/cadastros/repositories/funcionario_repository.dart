// lib/modules/cadastros/repositories/funcionario_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/funcionario.dart';

class FuncionarioRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String collectionPath = 'funcionarios';

  /// Recupera a lista de funcionários a partir da coleção Firestore.
  Future<List<Funcionario>> getFuncionarios() async {
    QuerySnapshot snapshot =
        await firestore.collection(collectionPath).get();

    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      // Adiciona o ID do documento aos dados.
      data['id'] = doc.id;
      return Funcionario.fromJson(data);
    }).toList();
  }

  /// Cria um novo funcionário adicionando um documento na coleção.
  Future<Funcionario> createFuncionario(Funcionario funcionario) async {
    DocumentReference docRef = await firestore
        .collection(collectionPath)
        .add(funcionario.toJson());

    // Recupera o documento recém-criado para retornar os dados completos
    DocumentSnapshot docSnapshot = await docRef.get();
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    data['id'] = docSnapshot.id;
    return Funcionario.fromJson(data);
  }

  /// Atualiza um funcionário existente no Firestore.
  Future<Funcionario> updateFuncionario(Funcionario funcionario) async {
    await firestore
        .collection(collectionPath)
        .doc(funcionario.id)
        .update(funcionario.toJson());

    DocumentSnapshot docSnapshot =
        await firestore.collection(collectionPath).doc(funcionario.id).get();
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    data['id'] = docSnapshot.id;
    return Funcionario.fromJson(data);
  }

  /// Remove um funcionário (exclui o documento) no Firestore.
  Future<void> deleteFuncionario(String id) async {
    await firestore.collection(collectionPath).doc(id).delete();
  }
}
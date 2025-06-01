// lib/modules/cadastros/repositories/reserva_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reserva.dart';

class ReservaRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String collectionPath = 'reservas';

  /// Recupera a lista de reservas do Firestore.
  Future<List<Reserva>> getReservas() async {
    QuerySnapshot snapshot = await firestore.collection(collectionPath).get();
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return Reserva.fromJson(data);
    }).toList();
  }

  /// Cria uma nova reserva adicionando um documento no Firestore.
  Future<Reserva> createReserva(Reserva reserva) async {
    DocumentReference docRef =
        await firestore.collection(collectionPath).add(reserva.toJson());
    DocumentSnapshot docSnapshot = await docRef.get();
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    data['id'] = docSnapshot.id;
    return Reserva.fromJson(data);
  }

  /// Atualiza uma reserva existente no Firestore.
  Future<Reserva> updateReserva(Reserva reserva) async {
    await firestore.collection(collectionPath).doc(reserva.id).update(reserva.toJson());
    DocumentSnapshot docSnapshot =
        await firestore.collection(collectionPath).doc(reserva.id).get();
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    data['id'] = docSnapshot.id;
    return Reserva.fromJson(data);
  }

  /// Remove uma reserva do Firestore.
  Future<void> deleteReserva(String id) async {
    await firestore.collection(collectionPath).doc(id).delete();
  }
}
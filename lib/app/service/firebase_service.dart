import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FirebaseService extends GetxService {
  final participantsRef = FirebaseFirestore.instance.collection('participants');
  final confirmadosRef = FirebaseFirestore.instance.collection('confirmados');

  var confirmadosCount = 0.obs;

  void listenDocs() {
    confirmadosRef.snapshots().listen((QuerySnapshot snapshot) {
      confirmadosCount.value = snapshot.size;
    });
  }

  Future<bool> alreadyConfirmed({required String documentId}) async {
    var doc = await confirmadosRef.doc(documentId).get();
    return doc.exists;
  }

  Future<Map<String, dynamic>> findUser({required String documentId}) async {
    try {
      var doc = await participantsRef.doc(documentId).get();
      if (!doc.exists) {
        throw "CPF NÃO CADASTRADO.";
      }
      return doc.data() as Map<String, dynamic>;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> confirm(String documentId, Map<String, dynamic> data) async {
    try {
      if (data.isEmpty) {
        throw "PESQUISE UM CPF PRIMEIRO!";
      }
      var doc = await confirmadosRef.doc(documentId).get();
      if (doc.exists) {
        throw "CPF JÁ CONFIRMADO";
      }
      await confirmadosRef.doc(documentId).set({
        'nome': data['nome'],
        'telefone': data['telefone'],
        'item': data['item'],
      });
    } catch (e) {
      throw e.toString();
    }
  }
}

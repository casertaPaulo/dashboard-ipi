import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FirebaseService extends GetxService {
  final firestoreRef = FirebaseFirestore.instance.collection('develop-test');

  Future<Map<String, dynamic>> findUser({required String documentId}) async {
    try {
      var doc = await firestoreRef.doc(documentId).get();
      if (!doc.exists) {
        throw "CPF NÃO CADASTRADO.";
      }
      return doc.data() as Map<String, dynamic>;
    } catch (e) {
      throw e.toString();
    }
  }
}

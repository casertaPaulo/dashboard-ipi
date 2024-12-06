import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart' as rtdb;
import 'package:get/get.dart';

class FirebaseService extends GetxService {
  final _participantsRef =
      FirebaseFirestore.instance.collection('participants');
  final _confirmadosRef = FirebaseFirestore.instance.collection('confirmados');
  final _rdRef = rtdb.FirebaseDatabase.instance.ref('restante');
  late StreamSubscription<rtdb.DatabaseEvent> remainSubscription;

  var confirmadosCount = 0.obs;
  var participantsCount = 0.obs;
  var remain = 0.obs;

  // Escuta alterações no FireStore - Atualiza a variável da quantidade de documentos
  void listenDocs() {
    _confirmadosRef.snapshots().listen((QuerySnapshot snapshot) {
      confirmadosCount.value = snapshot.size;
    });
    _participantsRef.snapshots().listen((QuerySnapshot snapshot) {
      participantsCount.value = snapshot.size;
    });
  }

  // Verifica se o usuário já foi confirmado e está na coleção de confirmados
  Future<bool> alreadyConfirmed({required String documentId}) async {
    var doc = await _confirmadosRef.doc(documentId).get();
    return doc.exists;
  }

  // Encontra o usuário na coleção de participantes e retorna um Map com os dados
  Future<Map<String, dynamic>> findUser({required String documentId}) async {
    try {
      var doc = await _participantsRef.doc(documentId).get();
      if (!doc.exists) {
        throw "CPF NÃO CADASTRADO";
      }
      return doc.data() as Map<String, dynamic>;
    } catch (e) {
      throw e.toString();
    }
  }

  // Confirma o usuário adicionando o documento na coleção de confirmados
  Future<void> confirm(String documentId, Map<String, dynamic> data) async {
    try {
      if (data.isEmpty) {
        throw "PESQUISE UM CPF PRIMEIRO";
      }
      if (await alreadyConfirmed(documentId: documentId)) {
        throw "CPF JÁ CONFIRMADO";
      }
      await _confirmadosRef.doc(documentId).set({
        'nome': data['nome'],
        'telefone': data['telefone'],
        'item': data['item'],
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw e.toString();
    }
  }

  // Atualiza o número de vagas restantes
  Future<void> updateVagas(int quantidade) async {
    await _rdRef.runTransaction((vagasRestantes) {
      return rtdb.Transaction.success((vagasRestantes as int) + quantidade);
    });
  }

  // Inicializa o escutador no nó de vagas restantes do Realtime Database
  initializeData() async {
    remainSubscription = _rdRef.onValue.listen(
      (event) {
        remain((event.snapshot.value ?? 0) as int);
      },
    );
  }
}

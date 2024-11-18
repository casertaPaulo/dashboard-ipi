import 'package:dashboard_ipi/app/service/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class DashboardController extends GetxController {
  // Form Controller
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var textFieldController = MaskedTextController(mask: '000.000.000-00').obs;

  // Firebase Service
  FirebaseService databaseService = Get.find();

  // Variáveis reativas
  var nome = ''.obs;
  var telefone = 0.obs;
  var item = ''.obs;

  void handleSubmit() async {
    if (formKey.currentState!.validate()) {
      try {
        Map<String, dynamic> data = await databaseService.findUser(
          documentId: _cleanText(textFieldController.value.value.text),
        );
        nome(data['nome']);
        telefone(data['telefone']);
        item(data['item']);
      } catch (e) {
        Get.snackbar("Erro", e.toString());
      }
    }
  }

  void cleanData() {
    nome("");
    telefone(0);
    item('');
    textFieldController.value.text = '';
  }

  String _cleanText(String text) {
    return text.replaceAll(RegExp(r'[^0-9]'), '');
  }
}

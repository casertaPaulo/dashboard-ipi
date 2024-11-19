import 'package:dashboard_ipi/app/service/firebase_service.dart';
import 'package:dashboard_ipi/util/util.dart';
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
  var reativeData = <String, dynamic>{}.obs;
  var alreadyConfirmed = false.obs;

  var confirmados = 0.obs;

  @override
  void onInit() {
    super.onInit();
    databaseService.listenDocs();

    // Atualiza localmente, se necessário
    ever<int>(databaseService.confirmadosCount, (count) {
      confirmados.value = count;
    });

    // Escuta alterações no Texto do TextEditingController
    textFieldController.value.addListener(() {
      String cpf = Util.cleanText(textFieldController.value.text);
      if (cpf.isEmpty || cpf.length < 14) {
        reativeData({}); // Limpa dados se CPF for apagado ou incompleto
        alreadyConfirmed(false); // Reseta confirmação
      }
    });
  }

  void handleSearch() async {
    if (formKey.currentState!.validate()) {
      try {
        String cpf = Util.cleanText(textFieldController.value.value.text);
        alreadyConfirmed(false);
        Map<String, dynamic> data = await databaseService.findUser(
          documentId: cpf,
        );
        if (await databaseService.alreadyConfirmed(documentId: cpf)) {
          alreadyConfirmed(true);
        }
        reativeData(data);
      } catch (e) {
        Util.errorSnackbar(e.toString());
      }
    }
  }

  void handleConfirmation() async {
    try {
      await databaseService.confirm(
        Util.cleanText(textFieldController.value.text),
        reativeData,
      );
      Util.successSnackbar(
        const Icon(Icons.check_circle),
      );
      cleanData();
    } catch (e) {
      Util.errorSnackbar(e.toString());
    }
  }

  void cleanData() {
    reativeData({});
    textFieldController.value.text = '';
  }
}

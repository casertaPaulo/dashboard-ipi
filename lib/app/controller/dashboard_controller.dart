import 'package:dashboard_ipi/app/service/firebase_service.dart';
import 'package:dashboard_ipi/util/util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class DashboardController extends GetxController {
  // Controllers
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var textFieldController = MaskedTextController(mask: '000.000.000-00').obs;
  var vagasFieldController = TextEditingController().obs;
  // Firebase Service
  FirebaseService databaseService = Get.find();

  // Variáveis reativas
  var reativeData = <String, dynamic>{}.obs;
  var alreadyConfirmed = false.obs;

  var isSearching = false.obs;
  var isSubmiting = false.obs;

  var confirmados = 0.obs;
  var participants = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Inicializando
    databaseService.listenDocs();
    databaseService.initializeData();

    // Atualiza localmente, se necessário
    ever<int>(databaseService.confirmadosCount, (count) {
      confirmados.value = count;
    });
    ever<int>(databaseService.participantsCount, (count) {
      participants.value = count;
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
      isSearching(true);
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
      } finally {
        isSearching(false);
      }
    }
  }

  void handleConfirmation() async {
    isSubmiting(true);
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
    } finally {
      isSubmiting(false);
    }
  }

  void cleanData() {
    reativeData({});
    textFieldController.value.text = '';
  }

  void showMyDialog() {
    Get.dialog(
      AlertDialog(
        icon: const Icon(Icons.edit),
        title: const Text('Editar vagas'),
        content: SizedBox(
          width: Get.width,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        "VAGAS\nRESTANTES",
                        style: TextStyle(
                          color: Get.theme.colorScheme.primary,
                          fontFamily: "ROBOTOCONDENSED",
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        databaseService.remain.value.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "ROBOTOCONDENSED",
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        "STATUS\nDAS INCRIÇÕES",
                        style: TextStyle(
                          color: Get.theme.colorScheme.primary,
                          fontFamily: "ROBOTOCONDENSED",
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                      const Text(
                        "CORRENDO",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "ROBOTOCONDENSED",
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Get.width * .1,
                    vertical: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Abrir\nVagas",
                        style: TextStyle(
                          fontFamily: "ROBOTOCONDENSED",
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: Colors.green[200],
                        ),
                      ),
                      SizedBox(
                        width: Get.width * .25,
                        child: TextField(
                          controller: vagasFieldController.value,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Get.width * .1,
                    vertical: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Fechar\nVagas",
                        style: TextStyle(
                          fontFamily: "ROBOTOCONDENSED",
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: Get.theme.colorScheme.error,
                        ),
                      ),
                      SizedBox(
                        width: Get.width * .25,
                        child: TextField(
                          controller: vagasFieldController.value,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: Get.width,
                height: Get.height * .08,
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text("PAUSAR INCRIÇÕES"),
                ),
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // int quantidade = int.parse(vagasFieldController.value.text);
              // databaseService.updateVagas(quantidade);
              Get.back(); // Fecha o diálogo
            },
            child: const Text('SALVAR'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Fecha o diálogo
            },
            child: const Text('CANCELAR'),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
      ),
    );
  }
}

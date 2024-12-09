import 'package:dashboard_ipi/app/controller/dashboard_controller.dart';
import 'package:dashboard_ipi/util/util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogController extends GetxController {
  final GlobalKey<FormState> abrirKey = GlobalKey<FormState>();
  final GlobalKey<FormState> fecharKey = GlobalKey<FormState>();
  var abrirVagasFieldController = TextEditingController().obs;
  var fecharVagasFieldController = TextEditingController().obs;
  DashboardController controller = Get.find();

  Future<void> abrirVagaDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.edit),
          title: const Text('Abrir vagas'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: Get.width,
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                "DIGITE\nA QUANTIDADE",
                                style: TextStyle(
                                  color: Get.theme.colorScheme.primary,
                                  fontFamily: "ROBOTOCONDENSED",
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                textAlign: TextAlign.center,
                                "VAGAS\nRESTANTES",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "ROBOTOCONDENSED",
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                              Obx(() {
                                return Text(
                                  controller.databaseService.remain.value
                                      .toString(),
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontFamily: "ROBOTOCONDENSED",
                                    fontWeight: FontWeight.w900,
                                    fontSize: 22,
                                  ),
                                );
                              })
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Form(
                    key: abrirKey,
                    child: SizedBox(
                      width: Get.width * .4,
                      child: TextFormField(
                        controller: abrirVagasFieldController.value,
                        keyboardType: TextInputType.number,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Insira um valor";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          prefixIcon: Icon(Icons.add),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                abrirVagasFieldController.value.text = '';
                Get.back(); // Fecha o diálogo
              },
              child: const Icon(
                Icons.close,
                color: Colors.red,
              ),
            ),
            TextButton(
                onPressed: () async {
                  // Se o form estiver válido, adiciona as vagas
                  if (abrirKey.currentState!.validate()) {
                    try {
                      // Castando o texto do input pra inteiro
                      int quantidade = int.parse(
                        abrirVagasFieldController.value.text,
                      );
                      await controller.databaseService.abrirVagas(quantidade);
                      abrirVagasFieldController.value.text = '';
                      Util.successSnackbar(const Icon(Icons.check));
                    } catch (e) {
                      Util.errorSnackbar(e.toString());
                    }
                  }
                },
                child: const Icon(
                  Icons.check,
                  color: Colors.green,
                )),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
  }

  Future<void> fecharVagaDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.edit),
          title: const Text('Fechar vagas'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: Get.width,
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                "DIGITE\nA QUANTIDADE",
                                style: TextStyle(
                                  color: Get.theme.colorScheme.primary,
                                  fontFamily: "ROBOTOCONDENSED",
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                textAlign: TextAlign.center,
                                "VAGAS\nRESTANTES",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "ROBOTOCONDENSED",
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                              Obx(() {
                                return Text(
                                  controller.databaseService.remain.value
                                      .toString(),
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontFamily: "ROBOTOCONDENSED",
                                    fontWeight: FontWeight.w900,
                                    fontSize: 22,
                                  ),
                                );
                              })
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Form(
                    key: fecharKey,
                    child: SizedBox(
                      width: Get.width * .4,
                      child: TextFormField(
                        controller: fecharVagasFieldController.value,
                        keyboardType: TextInputType.number,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Insira um valor";
                          }
                          if (int.parse(value) <= 0) {
                            return "Insira um valor maior que 0";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          prefixIcon: Icon(Icons.remove),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  fecharVagasFieldController.value.text = '';
                  Get.back(); // Fecha o diálogo
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.red,
                )),
            TextButton(
              onPressed: () async {
                if (fecharKey.currentState!.validate()) {
                  try {
                    int quantidade = int.parse(
                      fecharVagasFieldController.value.text,
                    );
                    await controller.databaseService.fecharVagas(quantidade);
                    fecharVagasFieldController.value.text = '';
                    Util.successSnackbar(const Icon(Icons.check));
                  } catch (e) {
                    Util.errorSnackbar(e.toString());
                  }
                }
              },
              child: const Icon(
                Icons.check,
                color: Colors.green,
              ),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
  }
}

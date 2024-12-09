import 'package:dashboard_ipi/animation/fade_animation.dart';
import 'package:dashboard_ipi/app/controller/dashboard_controller.dart';
import 'package:dashboard_ipi/app/controller/dialog_controller.dart';
import 'package:dashboard_ipi/util/util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    DashboardController controller = Get.find();
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Get.width * .08,
            vertical: Get.height * .03,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPageHeader(controller),
              _buildButtonAlterarVagas(context),
              _buildFormHeader(context, controller),
              const SizedBox(height: 20),
              _buildBodyReturn(controller),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Obx(() {
                    bool hasData = controller.reativeData.isNotEmpty;
                    final bool canHandle = hasData &&
                        !controller.alreadyConfirmed.value &&
                        !controller.isSearching.value;
                    return SizedBox(
                      height: Util.height(context) * .08,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                        ),
                        onPressed:
                            canHandle ? controller.handleConfirmation : null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (controller.isSubmiting.value)
                              const Center(
                                child: CircularProgressIndicator(),
                              )
                            else if (hasData)
                              const Row(
                                children: [
                                  FittedBox(
                                    child: Text(
                                      "CONFIRMAR PRESENÇA",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Icon(Icons.check)
                                ],
                              )
                            else
                              const Icon(Icons.check),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageHeader(DashboardController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: Get.width * .4,
          child: FittedBox(
            child: Text(
              "DASHBOARD\nDE CONTROLE",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontFamily: "LEMONMILK-BOLD",
                color: Get.theme.colorScheme.primary,
              ),
            ),
          ),
        ),
        SizedBox(
          width: Get.width * .3,
          child: FittedBox(
            child: Obx(() {
              return RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Get.theme.colorScheme.primary,
                  ),
                  children: [
                    TextSpan(
                      text: 'PARTICIPANTES\nPRESENTES\n',
                      style: TextStyle(
                        color: Get.theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontFamily: "ROBOTOCONDENSED",
                      ),
                    ),
                    TextSpan(
                      text: "${controller.confirmados} ",
                      style: TextStyle(
                        color: Colors.green[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "/ ${controller.participants}",
                      style: TextStyle(
                        color: Get.theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildFormHeader(
      BuildContext context, DashboardController controller) {
    return Form(
      key: controller.formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * .65,
            child: TextFormField(
              autofocus: false,
              controller: controller.textFieldController.value,
              onFieldSubmitted: (value) {
                controller.handleSearch();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Insira o CPF!";
                }
                if (value.isEmpty) {
                  return "Formato de CPF inválido!";
                }
                return null;
              },
              keyboardType: TextInputType.number,
              maxLength: 14,
              buildCounter: (
                context, {
                required currentLength,
                required isFocused,
                required maxLength,
              }) {
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.credit_card),
                labelText: "Número do CPF",
              ),
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              controller.handleSearch();
            },
            shape: const CircleBorder(),
            child: const Icon(Icons.search_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonAlterarVagas(BuildContext context) {
    DialogController dialogController = Get.find();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: Get.height * .06,
              child: OutlinedButton(
                onPressed: () {
                  dialogController.abrirVagaDialog(context);
                },
                child: SizedBox(
                  width: Get.width * .25,
                  child: const FittedBox(
                    child: Text(
                      "ABRIR VAGAS",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: SizedBox(
              height: Get.height * .06,
              child: OutlinedButton(
                onPressed: () {
                  dialogController.fecharVagaDialog(context);
                },
                child: SizedBox(
                  width: Get.width * .3,
                  child: const FittedBox(
                    child: Text(
                      "FECHAR VAGAS",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyReturn(DashboardController controller) {
    return Obx(() {
      final hasData = controller.reativeData.isNotEmpty;
      final confirmed = controller.alreadyConfirmed.value;
      final isLoading = controller.isSearching.value;
      // Retornando os estados
      if (isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (hasData) {
        return Column(
          children: [
            FadeInUp(
              duration: 600,
              child: _buildCards(
                "NOME",
                Icons.person,
                controller.reativeData['nome'],
              ),
            ),
            FadeInUp(
              duration: 1000,
              child: _buildCards(
                "TELEFONE",
                Icons.phone,
                Util.formatPhoneNumber(controller.reativeData['telefone']),
              ),
            ),
            FadeInUp(
              duration: 1400,
              child: _buildCards(
                "DATA DE INSCRIÇÃO",
                Icons.date_range,
                controller.reativeData['createdAt'].toUpperCase(),
              ),
            ),
            _statusButton(confirmed)
          ],
        );
      }
      return RichText(
        text: TextSpan(
          style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Get.theme.colorScheme.primary,
              fontSize: 25,
              fontFamily: "ROBOTOCONDENSED"),
          children: const [
            TextSpan(
              text: 'INSIRA O NÚMERO\n',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: "DO DOCUMENTO\n",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: "E PESQUISE",
            ),
          ],
        ),
      );
    });
  }

  Widget _statusButton(bool confirmed) {
    return OutlinedButton(
      onPressed: () {},
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Get.theme.colorScheme.primary,
          ),
          children: [
            TextSpan(
              text: 'STATUS:  ',
              style: TextStyle(
                color: Get.theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontFamily: "ROBOTOCONDENSED",
              ),
            ),
            TextSpan(
              text: confirmed ? "CONFIRMADO" : "NÃO CONFIRMADO",
              style: TextStyle(
                fontFamily: "ROBOTOCONDENSED",
                color: confirmed ? Colors.green[600] : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCards(String nome, IconData icon, String data) {
    DashboardController controller = Get.find();
    bool isEmpty = controller.reativeData.isEmpty;
    return Card(
        child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Get.width * .05,
        vertical: Get.height * .020,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nome,
                style: const TextStyle(
                  fontFamily: "RobotoCondensed",
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              !isEmpty ? const SizedBox(height: 10) : const SizedBox(),
              if (!isEmpty)
                SizedBox(
                  width: Get.width * .6,
                  child: Text(
                    data,
                    style: const TextStyle(
                      fontFamily: "RobotoCondensed",
                      fontSize: 16,
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
    ));
  }
}

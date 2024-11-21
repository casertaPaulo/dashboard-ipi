import 'package:dashboard_ipi/animation/fade_animation.dart';
import 'package:dashboard_ipi/app/controller/dashboard_controller.dart';
import 'package:dashboard_ipi/util/util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    DashboardController controller = Get.find();
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * .08,
            vertical: size.height * .03,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: size.width * .4,
                    child: FittedBox(
                      child: Text(
                        "DASHBOARD\nDE CONTROLE",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontFamily: "LEMONMILK-BOLD",
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width * .3,
                    child: FittedBox(
                      child: Obx(() {
                        return RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            children: [
                              TextSpan(
                                text: 'PARTICIPANTES\nPRESENTES\n',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
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
                                text: "/ 450",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * .05),
              _buildFormHeader(context, controller),
              const SizedBox(height: 30),
              Obx(() {
                final isEmpty = controller.reativeData.isEmpty;
                final confirmed = controller.alreadyConfirmed.value;
                if (controller.isSearching.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!isEmpty) {
                  return Column(
                    children: [
                      FadeInUp(
                        duration: 600,
                        child: _buildCards(
                          "NOME",
                          Icons.person,
                          controller.reativeData['nome'],
                          context,
                        ),
                      ),
                      FadeInUp(
                        duration: 1000,
                        child: _buildCards(
                          "TELEFONE",
                          Icons.phone,
                          Util.formatPhoneNumber(
                              controller.reativeData['telefone']),
                          context,
                        ),
                      ),
                      FadeInUp(
                        duration: 1400,
                        child: _buildCards(
                          "ITEM",
                          Icons.food_bank_outlined,
                          controller.reativeData['item'].toUpperCase(),
                          context,
                        ),
                      ),
                      _statusButton(context, confirmed)
                    ],
                  );
                }
                return RichText(
                  text: TextSpan(
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.primary,
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
              }),
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

  Widget _statusButton(BuildContext context, bool confirmed) {
    return OutlinedButton(
      onPressed: () {},
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.primary,
          ),
          children: [
            TextSpan(
              text: 'STATUS:  ',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
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

  Widget _buildCards(
    String nome,
    IconData icon,
    String data,
    BuildContext context,
  ) {
    DashboardController controller = Get.find();
    bool isEmpty = controller.reativeData.isEmpty;
    return Card(
        child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Util.width(context) * .05,
        vertical: Util.height(context) * .020,
      ),
      child: Row(
        mainAxisAlignment:
            isEmpty ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon),
          !isEmpty ? const SizedBox() : const SizedBox(width: 15),
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
                  width: Util.width(context) * .6,
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

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
                          fontFamily: "LEMONMILD-BOLD",
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width * .3,
                    child: FittedBox(
                      child: RichText(
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
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                                fontFamily: "ROBOTOCONDENSED",
                              ),
                            ),
                            TextSpan(
                              text: "0 /",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: " 359",
                              style: TextStyle(
                                color: Colors.green[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * .05),
              Form(
                key: controller.formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .65,
                      child: TextFormField(
                        controller: controller.textFieldController.value,
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
                        controller.handleSubmit();
                      },
                      shape: const CircleBorder(),
                      child: const Icon(Icons.search_rounded),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Obx(
                () {
                  final isEmpty = controller.nome.isEmpty;
                  if (!isEmpty) {
                    return Column(
                      children: [
                        FadeInUp(
                          duration: 600,
                          child: _buildCards(
                            "NOME",
                            Icons.person,
                            controller.nome.value,
                            context,
                          ),
                        ),
                        FadeInUp(
                          duration: 1000,
                          child: _buildCards(
                            "TELEFONE",
                            Icons.phone,
                            controller.telefone.value.toString(),
                            context,
                          ),
                        ),
                        FadeInUp(
                          duration: 1400,
                          child: _buildCards(
                            "ITEM",
                            Icons.food_bank_outlined,
                            controller.item.value.toUpperCase(),
                            context,
                          ),
                        ),
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
                          text: 'INSIRA O DOCUMENTO\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: "O DOCUMENTO\n",
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
                },
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                      ),
                      onPressed: () {
                        controller.cleanData();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: Util.width(context) * .5,
                            height: Util.height(context) * .03,
                            child: const FittedBox(
                              child: Text(
                                "CONFIRMAR PRESENÇA",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                          const Icon(Icons.check)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
    bool isEmpty = controller.nome.value.isEmpty;
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
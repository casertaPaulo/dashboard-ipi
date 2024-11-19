import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Util {
  static double width(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  static double height(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }

  static String formatPhoneNumber(int number) {
    String rawNumber = number.toString().padLeft(11, '0'); // Garante 11 dígitos
    String ddd = rawNumber.substring(0, 2);
    String firstPart = rawNumber.substring(2, 7);
    String secondPart = rawNumber.substring(7, 11);
    return '($ddd) $firstPart-$secondPart';
  }

  static String cleanText(String text) {
    return text.replaceAll(RegExp(r'[^0-9]'), '');
  }

  static successSnackbar(Widget message) {
    Get.snackbar(
      '',
      '',
      titleText: const Center(
        child: Text(
          "SUCESSO",
          style: TextStyle(
            fontFamily: "ROBOTOCONDENSED",
          ),
        ),
      ),
      messageText: message,
      backgroundColor: Colors.green[600],
      forwardAnimationCurve: Curves.fastEaseInToSlowEaseOut,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
      margin: EdgeInsets.symmetric(
        horizontal: Get.size.width < 600 ? 30 : Get.size.width * .4,
        vertical: 30,
      ),
    );
  }

  static errorSnackbar(String error) {
    Get.snackbar(
      '',
      '',
      titleText: const Center(
        child: Text(
          "ERRO",
          style: TextStyle(
            fontFamily: "ROBOTOCONDENSED",
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
      ),
      messageText: Center(
        child: Text(
          error,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      backgroundColor: Colors.red[600],
      forwardAnimationCurve: Curves.fastEaseInToSlowEaseOut,
      duration: const Duration(seconds: 2),
      margin: EdgeInsets.symmetric(
        horizontal: Get.size.width < 600 ? 30 : Get.size.width * .3,
        vertical: 30,
      ),
    );
  }
}

import 'package:dashboard_ipi/app/controller/dashboard_controller.dart';
import 'package:dashboard_ipi/app/pages/dashboard_page.dart';
import 'package:dashboard_ipi/app/pages/responsive_layout.dart';
import 'package:dashboard_ipi/app/service/firebase_service.dart';
import 'package:dashboard_ipi/firebase_options.dart';
import 'package:dashboard_ipi/theme.dart';
import 'package:dashboard_ipi/util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(FirebaseService());
  Get.put(DashboardController());
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    //final brightness = View.of(context).platformDispatcher.platformBrightness;

    // Retrieves the default theme for the platform
    //TextTheme textTheme = Theme.of(context).textTheme;

    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme =
        createTextTheme(context, "Roboto", "Roboto Condensed");

    MaterialTheme theme = MaterialTheme(textTheme);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: theme.dark(),
      home: const ResponsiveLayout(),
    );
  }
}

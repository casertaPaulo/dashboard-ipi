import 'package:dashboard_ipi/app/pages/dashboard_page.dart';
import 'package:dashboard_ipi/app/pages/desktop_page.dart';
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return const DashboardPage();
        } else {
          return const DesktopPage();
        }
      },
    );
  }
}

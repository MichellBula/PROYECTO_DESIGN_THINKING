import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/features/home/controllers/main_controller.dart';
import 'package:uncampusconnet/features/home/home_page.dart';
import 'package:uncampusconnet/ui/widgets/widgets_resumidos/banner_botones.dart';
import 'package:uncampusconnet/ui/widgets/widgets_resumidos/header_banner.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainController());

    final pages = const [
      HomePage(),
      // BuscarPage(),
      // MisProyectosPage(),
      // SolicitudesPage(),
    ];

    return Scaffold(
      // HEADER FIJO
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Obx(
          () => HeaderBanner(
            isDarkMode: controller.isDarkMode.value,
            onThemeChanged: controller.toggleTheme,
          ),
        ),
      ),

      // CONTENIDO + BARRA INFERIOR
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => IndexedStack(
                index: controller.currentIndex.value,
                children: pages,
              ),
            ),
          ),
          const BottomNavBar(),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/features/create_project/pages/new_proyect_page.dart';
import 'package:uncampusconnet/features/home/controllers/main_controller.dart';
import 'package:uncampusconnet/features/home/home_page.dart';
import 'package:uncampusconnet/features/mis_proyectos/pages/avances_page.dart';
import 'package:uncampusconnet/features/mis_proyectos/pages/eventos_proyecto_page.dart';
import 'package:uncampusconnet/features/mis_proyectos/pages/informacion_proyecto.dart';
import 'package:uncampusconnet/features/mis_proyectos/pages/mis_proyectos_page.dart';
import 'package:uncampusconnet/features/mis_proyectos/pages/participantes_page.dart';
import 'package:uncampusconnet/features/profile/pages/profile_page.dart';
import 'package:uncampusconnet/features/solicitudes/pages/chat_page.dart';
import 'package:uncampusconnet/features/solicitudes/pages/solicitud_detail_page.dart';
import 'package:uncampusconnet/features/buscar/pages/buscar_page.dart';
import 'package:uncampusconnet/features/solicitudes/pages/solicitudes_page.dart';

import 'package:uncampusconnet/ui/widgets/banner_buttons.dart';
import 'package:uncampusconnet/ui/widgets/header_banner.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainController());

    const pages = [
      HomePage(), // 0
      BuscarPage(), // 1
      NuevoProyectoPage(), // 2
      MisProyectosPage(), // 3
      SolicitudesPage(), // 4
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Obx(
          () => HeaderBanner(
            isDarkMode: controller.isDarkMode.value,
            onThemeChanged: controller.toggleTheme,
            onProfileTap: () => Get.to(() => const ProfilePage()),
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final index = controller.currentIndex.value;
              final solicitud = controller.selectedSolicitud.value;
              final project = controller.selectedProject.value;
              final projectParticipantes =
                  controller.selectedProjectForParticipantes.value;
              final projectAvances =
                  controller.selectedProjectForAvances.value;
              final projectEventos =
                  controller.selectedProjectForEventos.value;

              if (index == 5 && solicitud != null) {
                return SolicitudDetallePage(solicitud: solicitud);
              }

              if (index == 6 && solicitud != null) {
                return ChatSolicitudPage(solicitud: solicitud);
              }

              if (index == 7 && project != null) {
                return ProjectDetailPage(project: project);
              }

              if (index == 8 && projectParticipantes != null) {
                return ParticipantesPage(project: projectParticipantes);
              }

              if (index == 9 && projectAvances != null) {
                return AvancesPage(project: projectAvances);
              }

              if (index == 10 && projectEventos != null) {
                return EventosProyectoPage(project: projectEventos);
              }

              return IndexedStack(
                index: index.clamp(0, pages.length - 1),
                children: pages,
              );
            }),
          ),

          Obx(() {
            final index = controller.currentIndex.value;

            if (index == 6) {
              return const SizedBox.shrink();
            }

            return const BottomNavBar();
          }),
        ],
      ),
    );
  }
}
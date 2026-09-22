import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/features/home/controllers/main_controller.dart';
import 'package:uncampusconnet/features/mis_proyectos/controllers/mis_proyectos_controller.dart';
import 'package:uncampusconnet/features/mis_proyectos/widgets/project_card.dart';
import 'package:uncampusconnet/ui/widgets/screen_title.dart';
import 'package:uncampusconnet/ui/widgets/search_bar.dart';

/// Pantalla principal de "Mis proyectos".
///
/// Muestra el listado de proyectos y permite:
/// - Cambiar entre las dos categorías.
/// - Buscar proyectos por categoría.
/// - Abrir un proyecto al tocar su tarjeta.
class MisProyectosPage extends StatelessWidget {
  const MisProyectosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put<MyProjectsController>(MyProjectsController());

    final mainController = Get.find<MainController>();

    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,

      body: SafeArea(
        child: Column(
          children: [
            // ==========================================
            // TÍTULO
            // ==========================================

            AppScreenTitle(
              title: 'Mis proyectos',

              onBack: () {
                mainController.changeTab(0);
              },
            ),

            // ==========================================
            // CONTENIDO
            // ==========================================
            Expanded(
              child: Obx(() {
                final projects = controller.filteredProjects;

                return ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,

                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),

                  children: [
                    const SizedBox(height: 18),

                    // ==================================
                    // BÚSQUEDA
                    // ==================================
                    AppSearchBar(
                      hintText: 'Buscar proyecto',

                      onChanged: controller.search,
                    ),

                    const SizedBox(height: 25),

                    // ==================================
                    // LISTA
                    // ==================================
                    if (projects.isEmpty)
                      _EmptyProjectsMessage()
                    else
                      ...projects.map((project) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 18),

                          child: ProjectCard(
                            title: project.title,

                            members: project.members,

                            role: project.role,

                            progress: project.progress,

                            onTap: () {
                              Get.find<MainController>().openProjectDetail(
                                project,
                              );
                            },
                          ),
                        );
                      }),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mensaje que se muestra cuando la búsqueda
/// no encuentra proyectos.
class _EmptyProjectsMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),

      child: Center(
        child: Text(
          'No se encontraron proyectos.',
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ),
    );
  }
}

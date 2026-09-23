import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/features/home/controllers/main_controller.dart';
import 'package:uncampusconnet/features/mis_proyectos/controllers/mis_proyectos_controller.dart';
import 'package:uncampusconnet/features/mis_proyectos/widgets/project_card.dart';
import 'package:uncampusconnet/ui/widgets/screen_title.dart';
import 'package:uncampusconnet/ui/widgets/search_bar.dart';

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
            //Titulo
            AppScreenTitle(
              title: 'Mis proyectos',
              onBack: () {
                mainController.changeTab(0);
              },
            ),

            Expanded(
              child: Obx(() {
                return ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,

                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),

                  children: [
                    const SizedBox(height: 18),

                    //Busqueda
                    AppSearchBar(
                      hintText: 'Buscar proyecto',
                      onChanged: controller.search,
                    ),

                    const SizedBox(height: 25),

                    //Contenido
                    // CARGANDO
                    if (controller.cargando.value)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )

                    // VACÍO
                    else if (controller.filteredProjects.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            'No tienes proyectos aún.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                          ),
                        ),
                      )

                    // LISTA
                    else
                      ...controller.filteredProjects.map((project) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: ProjectCard(
                            title: project.title,
                            members: project.members,
                            role: project.role,
                            progress: project.progress,
                            onTap: () {
                              mainController.openProjectDetail(project);
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
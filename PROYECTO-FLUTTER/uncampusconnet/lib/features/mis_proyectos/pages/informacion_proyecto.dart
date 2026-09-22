import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/create_project/widgets/confirmaction_button.dart';

import 'package:uncampusconnet/features/home/controllers/main_controller.dart';
import 'package:uncampusconnet/features/mis_proyectos/data/proyect_data.dart';
import 'package:uncampusconnet/features/mis_proyectos/widgets/project_detail_header.dart';
import 'package:uncampusconnet/ui/widgets/info_field.dart';
import 'package:uncampusconnet/ui/widgets/screen_title.dart';

class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({super.key, ProjectData? project});

  @override
  Widget build(BuildContext context) {
    final mainController = Get.find<MainController>();

    return Obx(() {
      final project = mainController.selectedProject.value;

      // Mientras no haya un proyecto seleccionado
      if (project == null) {
        return const SizedBox.shrink();
      }

      final scheme = Theme.of(context).colorScheme;

      return SafeArea(
        child: Column(
          children: [
            // -------------------------
            // TÍTULO + BOTÓN REGRESAR
            // -------------------------
            AppScreenTitle(
              title: 'Mis proyectos',
              onBack: () {
                mainController.closeProjectDetail();
              },
            ),

            // -------------------------
            // CONTENIDO
            // -------------------------
            Expanded(
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,

                padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),

                children: [
                  // ==================================================
                  // CABECERA
                  // ==================================================

                  ProjectDetailHeader(project: project),

                  const SizedBox(height: 24),

                  // ==================================================
                  // DESCRIPCIÓN
                  // ==================================================
                  InfoField(
                    label: 'Descripción:',
                    value: project.description,
                    maxLines: 5,
                  ),

                  const SizedBox(height: 20),

                  // ==================================================
                  // REQUISITOS
                  // ==================================================
                  InfoField(
                    label: 'Requisitos:',
                    value: project.requirements,
                    maxLines: 6,
                  ),

                  const SizedBox(height: 20),

                  // ==================================================
                  // ROLES DISPONIBLES
                  // ==================================================
                  Text(
                    'Roles disponibles:',
                    style: AppTextStyles.fieldLabel.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: project.vacancyRoles.entries
                        .map(
                          (entry) => _RoleVacancy(
                            role: entry.key,
                            quantity: entry.value,
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 22),

                  // ==================================================
                  // FECHA DE CIERRE
                  // ==================================================
                  Text(
                    'Fecha cierre convocatoria:',
                    style: AppTextStyles.fieldLabel.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 35,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _formatDate(project.closingDate),
                          style: AppTextStyles.bodyText.copyWith(
                            color: scheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ==================================================
                  // ACCIONES
                  // ==================================================
                  Row(
                    children: [
                      // PARTICIPANTES
                      Expanded(
                        child: ConfirmationButton(
                          text: 'Participantes',
                          onPressed: () {
                            // Se implementará posteriormente.
                          },
                        ),
                      ),

                      const SizedBox(width: 12),

                      // EVENTOS
                      Expanded(
                        child: ConfirmationButton(
                          text: 'Eventos',
                          onPressed: () {
                            // Se implementará posteriormente.
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ==================================================
                  // AVANCES
                  // ==================================================
                  SizedBox(
                    width: double.infinity,
                    child: ConfirmationButton(
                      text: 'Avances',
                      onPressed: () {
                        // Se implementará posteriormente.
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'No especificada';
    }

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

class _RoleVacancy extends StatelessWidget {
  final String role;
  final int quantity;

  const _RoleVacancy({required this.role, required this.quantity});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.person_outline, color: scheme.primary),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                role,
                style: AppTextStyles.bodyText.copyWith(color: scheme.onSurface),
              ),
            ),

            Text(
              '$quantity',
              style: AppTextStyles.cardTitle.copyWith(color: scheme.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}

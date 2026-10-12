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
    final scheme = Theme.of(context).colorScheme;

    return Obx(() {
      final project = mainController.selectedProject.value;

      if (project == null) return const SizedBox.shrink();

      return SafeArea(
        child: Column(
          children: [
            AppScreenTitle(
              title: 'Mis proyectos',
              onBack: () => mainController.closeProjectDetail(),
            ),

            Expanded(
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
                children: [
                  ProjectDetailHeader(project: project),

                  const SizedBox(height: 24),

                  InfoField(
                    label: 'Descripción:',
                    value: project.description,
                    maxLines: 5,
                  ),

                  const SizedBox(height: 20),

                  InfoField(
                    label: 'Requisitos:',
                    value: project.requirements,
                    maxLines: 6,
                  ),

                  const SizedBox(height: 20),

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

                  Text(
                    'Fecha cierre convocatoria:',
                    style: AppTextStyles.fieldLabel.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
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

                  const SizedBox(height: 28),

                  Row(
                    children: [
                      Expanded(
                        child: ConfirmationButton(
                          text: 'Participantes',
                          onPressed: () =>
                              mainController.openParticipantes(project),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ConfirmationButton(
                          text: 'Eventos',
                          onPressed: () =>
                              mainController.openEventos(project),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ConfirmationButton(
                      text: 'Avances',
                      onPressed: () => mainController.openAvances(project),
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
    if (date == null) return 'No especificada';

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
                style: AppTextStyles.bodyText.copyWith(
                  color: scheme.onSurface,
                ),
              ),
            ),
            Text(
              '$quantity',
              style: AppTextStyles.cardTitle.copyWith(
                color: scheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
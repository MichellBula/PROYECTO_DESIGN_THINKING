import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';
import 'package:uncampusconnet/features/create_project/controllers/create_project_controller.dart';
import 'package:uncampusconnet/features/create_project/controllers/project_details_controller.dart';
import 'package:uncampusconnet/features/create_project/controllers/publish_project_controller.dart';
import 'package:uncampusconnet/features/create_project/widgets/confirmaction_button.dart';
import 'package:uncampusconnet/features/create_project/widgets/information_box.dart';
import 'package:uncampusconnet/features/home/controllers/main_controller.dart';

class ConfirmarProyectoPage extends StatelessWidget {
  final String nombreProyecto;
  final String descripcion;
  final String liderProyecto;
  final String categoria;
  final String objetivo;
  final String requisitos;

  final List<String> roles;
  final List<String> habilidades;

  final Map<String, int> cantidadesPorRol;

  final String? tipoProyecto;

  final DateTime? fechaInicio;
  final DateTime? fechaCierre;

  final bool deseaDocente;

  const ConfirmarProyectoPage({
    super.key,
    required this.nombreProyecto,
    required this.descripcion,
    required this.liderProyecto,
    required this.categoria,
    required this.objetivo,
    required this.roles,
    required this.cantidadesPorRol,
    required this.habilidades,
    required this.requisitos,
    required this.tipoProyecto,
    required this.fechaInicio,
    required this.fechaCierre,
    required this.deseaDocente,
  });

  Future<void> _publicarProyecto(BuildContext context) async {
    final controller = Get.find<PublishProjectController>();

    if (controller.isLoading.value) {
      return;
    }

    try {
      final resultado = await controller.publicar(
        nombreProyecto: nombreProyecto,
        descripcion: descripcion,
        objetivo: objetivo,
        categoria: categoria,
        roles: roles,
        cantidadesPorRol: cantidadesPorRol,
        habilidades: habilidades,
        requisitos: requisitos,
        tipoProyecto: tipoProyecto,
        fechaInicio: fechaInicio,
        fechaCierre: fechaCierre,
        deseaDocente: deseaDocente,
      );

      if (resultado == null) {
        return;
      }

      final idProyecto = resultado['id_proyecto'];

      if (!context.mounted) {
        return;
      }

      Get.snackbar(
        'Proyecto creado',
        'El proyecto $idProyecto fue creado correctamente.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      // Regresar a Inicio.
      Get.find<MainController>().changeTab(0);

      // Limpiar formularios.
      Get.find<CreateProjectController>().limpiarFormulario();

      Get.find<ProjectDetailsController>().limpiarFormulario();

      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (!context.mounted) {
        return;
      }

      Get.snackbar(
        'No se pudo crear el proyecto',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final controller = Get.put(PublishProjectController(), permanent: false);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 340),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                    boxShadow: [
                      BoxShadow(
                        color: scheme.shadow.withValues(alpha: 0.20),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Confirma tu información',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.screenTitle.copyWith(
                          color: scheme.onSurface,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Divider(),

                      const SizedBox(height: 12),

                      Text(
                        'Asegúrate de que toda la información '
                        'esté correcta antes de publicar el proyecto.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.smallText.copyWith(
                          color: scheme.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),

                      const SizedBox(height: 20),

                      ImportantInfoBox(
                        textColor: scheme.onSurface,
                        secondaryColor: scheme.onSurfaceVariant,
                      ),

                      const SizedBox(height: 28),

                      Text(
                        '¿Estás segur@ de publicar?',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyText.copyWith(
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Obx(
                        () => Row(
                          children: [
                            Expanded(
                              child: ConfirmationButton(
                                text: controller.isLoading.value
                                    ? '...'
                                    : 'Editar',
                                onPressed: controller.isLoading.value
                                    ? null
                                    : () => Navigator.pop(context),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: ConfirmationButton(
                                text: controller.isLoading.value
                                    ? 'Publicando...'
                                    : 'Publicar',
                                onPressed: controller.isLoading.value
                                    ? null
                                    : () => _publicarProyecto(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

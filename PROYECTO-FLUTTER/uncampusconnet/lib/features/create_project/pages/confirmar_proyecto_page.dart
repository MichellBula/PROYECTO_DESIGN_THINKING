import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';

import 'package:uncampusconnet/features/create_project/controllers/create_project_controller.dart';
import 'package:uncampusconnet/features/create_project/controllers/project_details_controller.dart';

import 'package:uncampusconnet/features/create_project/domain/entities/create_project_request.dart';

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

  // ======================================================
  // PUBLICAR
  // ======================================================

  Future<void> _publicarProyecto(BuildContext context) async {
    final controller = Get.find<CreateProjectController>();

    print('');
    print(
      '[CONFIRMAR_PROJECTO] '
      'Botón PUBLICAR presionado.',
    );

    // ----------------------------------------------------
    // Las fechas son obligatorias.
    // ----------------------------------------------------

    final inicio = fechaInicio;

    final cierre = fechaCierre;

    if (inicio == null || cierre == null) {
      print(
        '[CONFIRMAR_PROJECTO] '
        '❌ Faltan fechas.',
      );

      Get.snackbar(
        'Información incompleta',
        'Debes seleccionar la fecha de inicio y la fecha de cierre.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    // ----------------------------------------------------
    // Crear Request
    // ----------------------------------------------------

    final request = CreateProjectRequest(
      nombreProyecto: nombreProyecto,

      descripcion: descripcion,

      objetivo: objetivo,

      categoria: categoria,

      tipoProyecto: tipoProyecto,

      roles: List<String>.from(roles),

      cantidadesPorRol: Map<String, int>.from(cantidadesPorRol),

      habilidades: List<String>.from(habilidades),

      requisitos: requisitos,

      fechaInicio: inicio,

      fechaCierre: cierre,

      deseaDocente: deseaDocente,
    );

    print(
      '[CONFIRMAR_PROJECTO] '
      'Request construido correctamente.',
    );

    print(
      '[CONFIRMAR_PROJECTO] '
      'nombre=${request.nombreProyecto}',
    );

    print(
      '[CONFIRMAR_PROJECTO] '
      'categoría=${request.categoria}',
    );

    print(
      '[CONFIRMAR_PROJECTO] '
      'tipo=${request.tipoProyecto}',
    );

    print(
      '[CONFIRMAR_PROJECTO] '
      'roles=${request.roles}',
    );

    print(
      '[CONFIRMAR_PROJECTO] '
      'cantidades=${request.cantidadesPorRol}',
    );

    print(
      '[CONFIRMAR_PROJECTO] '
      'habilidades=${request.habilidades}',
    );

    print(
      '[CONFIRMAR_PROJECTO] '
      'fechaInicio=${request.fechaInicio}',
    );

    print(
      '[CONFIRMAR_PROJECTO] '
      'fechaCierre=${request.fechaCierre}',
    );

    // ----------------------------------------------------
    // Enviar al Controller
    // ----------------------------------------------------

    final creado = await controller.publicarProyecto(request);

    // ----------------------------------------------------
    // La página pudo cerrarse mientras Roble trabajaba.
    // ----------------------------------------------------

    if (!creado || !context.mounted) {
      print(
        '[CONFIRMAR_PROJECTO] '
        'No se continuará con la navegación.',
      );

      return;
    }

    print(
      '[CONFIRMAR_PROJECTO] '
      '✅ Proyecto guardado correctamente en Roble.',
    );

    // ----------------------------------------------------
    // Aviso
    // ----------------------------------------------------

    Get.snackbar(
      'Proyecto creado',
      'El proyecto se guardó correctamente en la base de datos.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );

    // ----------------------------------------------------
    // Limpiar
    // ----------------------------------------------------

    Get.find<MainController>().changeTab(0);

    Get.find<CreateProjectController>().limpiarFormulario();

    Get.find<ProjectDetailsController>().limpiarFormulario();

    // ----------------------------------------------------
    // Volver al inicio
    // ----------------------------------------------------

    Navigator.of(context).popUntil((route) => route.isFirst);

    print(
      '[CONFIRMAR_PROJECTO] '
      'Navegación finalizada.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final controller = Get.find<CreateProjectController>();

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
                                text: controller.cargando.value
                                    ? '...'
                                    : 'Editar',

                                onPressed: controller.cargando.value
                                    ? null
                                    : () => Navigator.pop(context),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: ConfirmationButton(
                                text: controller.cargando.value
                                    ? 'Publicando...'
                                    : 'Publicar',

                                onPressed: controller.cargando.value
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

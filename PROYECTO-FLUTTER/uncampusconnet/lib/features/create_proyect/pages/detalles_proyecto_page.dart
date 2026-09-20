import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/create_proyect/controllers/project_details_controller.dart';
import 'package:uncampusconnet/features/create_proyect/data/project_options.dart';
import 'package:uncampusconnet/features/create_proyect/widgets/advisor_toggle.dart';
import 'package:uncampusconnet/features/create_proyect/widgets/project_date_field.dart';
import 'package:uncampusconnet/features/create_proyect/widgets/project_dropdown_field.dart';
import 'package:uncampusconnet/features/create_proyect/widgets/project_form_actions.dart';
import 'package:uncampusconnet/features/create_proyect/widgets/project_text_field.dart';
import 'package:uncampusconnet/features/create_proyect/widgets/role_quantity_dropdown.dart';
import 'package:uncampusconnet/features/create_proyect/pages/confirmar_proyecto_page.dart';
import 'package:uncampusconnet/ui/widgets/widgets_resumidos/select_downdrop.dart';
import 'package:uncampusconnet/ui/widgets/widgets_resumidos/screen_title.dart';

/// Segunda pantalla del proceso de creación.
///
/// Aquí el usuario completa los detalles necesarios
/// para definir el proyecto.
class DetallesProyectoPage extends StatelessWidget {
  final String nombreProyecto;
  final String descripcion;
  final String liderProyecto;
  final String categoria;

  DetallesProyectoPage({
    super.key,
    required this.nombreProyecto,
    required this.descripcion,
    required this.liderProyecto,
    required this.categoria,
  });

  /// Controller que administra el estado del formulario.
  final ProjectDetailsController controller = Get.put(
    ProjectDetailsController(),
  );

  // ======================================================
  // FECHAS
  // ======================================================

  /// Abre el selector de fecha correspondiente.
  Future<void> seleccionarFecha(BuildContext context, int tipoFecha) async {
    final bool esInicio = tipoFecha == 1;

    // Para seleccionar el cierre primero debe existir
    // una fecha de inicio.
    if (!esInicio && controller.fechaInicio.value == null) {
      Get.snackbar(
        'Fecha',
        'Primero debes seleccionar la fecha de inicio.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    final DateTime firstDate = esInicio
        ? controller.today
        : controller.minimumClosingDate;

    DateTime initialDate = esInicio
        ? controller.fechaInicio.value ?? controller.today
        : controller.fechaCierre.value ?? firstDate;

    if (initialDate.isBefore(firstDate)) {
      initialDate = firstDate;
    }

    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2035),
    );

    if (date == null) {
      return;
    }

    if (esInicio) {
      controller.setFechaInicio(date);
    } else {
      controller.setFechaCierre(date);
    }
  }

  // ======================================================
  // CONTINUAR
  // ======================================================

  /// Valida la información y abre la pantalla
  /// de confirmación del proyecto.
  void continuarAConfirmacion(BuildContext context) {
    final String? error = controller.validate();

    if (error != null) {
      Get.snackbar(
        'Formulario incompleto',
        error,
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmarProyectoPage(
          nombreProyecto: nombreProyecto,
          descripcion: descripcion,
          liderProyecto: liderProyecto,
          categoria: categoria,

          objetivo: controller.objetivoController.text.trim(),

          roles: List<String>.from(controller.selectedRoles),

          cantidadesPorRol: Map<String, int>.from(controller.roleQuantities),

          habilidades: List<String>.from(controller.selectedSkills),

          requisitos: controller.requisitosController.text.trim(),

          tipoProyecto: controller.selectedProjectType.value,

          fechaInicio: controller.fechaInicio.value,

          fechaCierre: controller.fechaCierre.value,

          deseaDocente: controller.deseaDocente.value,
        ),
      ),
    );
  }

  // ======================================================
  // BUILD
  // ======================================================

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,

      body: SafeArea(
        child: Column(
          children: [
            // ==========================================
            // TÍTULO
            // ==========================================

            const AppScreenTitle(title: 'Nuevo proyecto'),

            // ==========================================
            // FORMULARIO
            // ==========================================
            Expanded(
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,

                padding: const EdgeInsets.fromLTRB(34, 10, 34, 30),

                children: [
                  // ======================================
                  // TÍTULO DE SECCIÓN
                  // ======================================

                  Center(
                    child: Text(
                      'Información general:',
                      style: AppTextStyles.formDescription.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ======================================
                  // OBJETIVO
                  // ======================================
                  ProjectTextField(
                    label: 'Objetivo general',
                    hint: 'El objetivo de mi proyecto es...',
                    controller: controller.objetivoController,
                    maxLength: 300,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                  ),

                  const SizedBox(height: 20),

                  // ======================================
                  // ROLES + CANTIDADES
                  // ======================================
                  Obx(
                    () => RoleQuantityDropdown(
                      roles: projectRoles,
                      quantities: controller.roleQuantities.value,
                      onChanged: controller.actualizarRoles,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ======================================
                  // HABILIDADES
                  // ======================================
                  Obx(
                    () => MultiSelectDropdown(
                      hintText: 'Puedes escoger más de una habilidad',
                      options: projectSkills,
                      selectedItems: controller.selectedSkills.value,
                      onChanged: controller.actualizarHabilidades,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ======================================
                  // REQUISITOS
                  // ======================================
                  ProjectTextField(
                    label: 'Requisitos',
                    hint: 'Los requisitos son...',
                    controller: controller.requisitosController,
                    maxLength: 300,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                  ),

                  const SizedBox(height: 20),

                  // ======================================
                  // TIPO DE PROYECTO
                  // ======================================
                  Obx(
                    () => ProjectDropdownField(
                      label: 'Tipo de proyecto',
                      hint: 'Selecciona el tipo de proyecto',
                      value: controller.selectedProjectType.value,
                      items: projectTypes,
                      onChanged: controller.cambiarTipoProyecto,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ======================================
                  // FECHA DE INICIO
                  // ======================================
                  Obx(
                    () => ProjectDateField(
                      label: 'Fecha de inicio',
                      date: controller.fechaInicio.value,
                      onTap: () => seleccionarFecha(context, 1),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // ======================================
                  // FECHA DE CIERRE
                  // ======================================
                  Obx(
                    () => ProjectDateField(
                      label: 'Fecha de cierre',
                      date: controller.fechaCierre.value,
                      onTap: () => seleccionarFecha(context, 2),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ======================================
                  // DOCENTE ASESOR
                  // ======================================
                  Obx(
                    () => AdvisorToggle(
                      wantsAdvisor: controller.deseaDocente.value,
                      onYes: () {
                        controller.cambiarDocente(true);
                      },
                      onNo: () {
                        controller.cambiarDocente(false);
                      },
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ======================================
                  // BOTONES
                  // ======================================
                  ProjectFormActions(
                    onCancel: () {
                      Navigator.pop(context);
                    },
                    onContinue: () {
                      continuarAConfirmacion(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

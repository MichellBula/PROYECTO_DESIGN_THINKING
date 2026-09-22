import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
<<<<<<< Updated upstream:PROYECTO-FLUTTER/uncampusconnet/lib/features/create_proyect/pages/detalles_proyecto_page.dart
import 'package:uncampusconnet/features/create_proyect/controllers/project_details_controller.dart';
import 'package:uncampusconnet/features/create_proyect/data/project_options.dart';
import 'package:uncampusconnet/features/create_proyect/pages/confirmar_proyecto_page.dart';
import 'package:uncampusconnet/features/create_proyect/widgets/advisor_toggle.dart';
import 'package:uncampusconnet/features/create_proyect/widgets/project_date_field.dart';
import 'package:uncampusconnet/features/create_proyect/widgets/project_form_actions.dart';
import 'package:uncampusconnet/features/create_proyect/widgets/role_quantity_dropdown.dart';
import 'package:uncampusconnet/ui/widgets/widgets_resumidos/dropdown_field.dart';
=======
import 'package:uncampusconnet/features/create_project/controllers/project_details_controller.dart';
import 'package:uncampusconnet/features/create_project/data/project_options.dart';
import 'package:uncampusconnet/features/create_project/widgets/advisor_toggle.dart';
import 'package:uncampusconnet/features/create_project/widgets/project_date_field.dart';
import 'package:uncampusconnet/features/create_project/widgets/project_dropdown_field.dart';
import 'package:uncampusconnet/features/create_project/widgets/project_form_actions.dart';
import 'package:uncampusconnet/features/create_project/widgets/project_text_field.dart';
import 'package:uncampusconnet/features/create_project/widgets/role_quantity_dropdown.dart';
import 'package:uncampusconnet/features/create_project/pages/confirmar_proyecto_page.dart';
import 'package:uncampusconnet/ui/widgets/widgets_resumidos/select_downdrop.dart';
>>>>>>> Stashed changes:PROYECTO-FLUTTER/uncampusconnet/lib/features/create_project/pages/detalles_proyecto_page.dart
import 'package:uncampusconnet/ui/widgets/widgets_resumidos/screen_title.dart';
import 'package:uncampusconnet/ui/widgets/widgets_resumidos/select_downdrop.dart';
import 'package:uncampusconnet/ui/widgets/widgets_resumidos/text_field.dart';


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

  //Fechas
  /// Abre el selector de fecha correspondiente.
  Future<void> seleccionarFecha(int tipoFecha) async {
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
      context: Get.context!,
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

  //Continuar
  /// Valida la información y abre la pantalla
  /// de confirmación del proyecto.
  void continuarAConfirmacion() {
    final String? error = controller.validate();

    if (error != null) {
      Get.snackbar(
        'Formulario incompleto',
        error,
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    Get.to(
      () => ConfirmarProyectoPage(
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
    );
  }

  //Build
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,

      body: SafeArea(
        child: Column(
          children: [
            // TÍTULO
            const AppScreenTitle(title: 'Nuevo proyecto'),

            // FORMULARIO
            Expanded(
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,

                padding: const EdgeInsets.fromLTRB(34, 10, 34, 30),

                children: [
                  // TÍTULO DE SECCIÓN
                  Center(
                    child: Text(
                      'Información general:',
                      style: AppTextStyles.formDescription.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // OBJETIVO
                  AppTextField(
                    label: 'Objetivo general',
                    hint: 'El objetivo de mi proyecto es...',
                    controller: controller.objetivoController,
                    maxLength: 300,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                  ),

                  const SizedBox(height: 25),

                  // ROLES
                  Text(
                    '¿Qué roles necesitas?',
                    style: AppTextStyles.fieldLabel.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Obx(
                    () => RoleQuantityDropdown(
                      roles: projectRoles,
                      quantities: controller.roleQuantities.value,
                      onChanged: controller.actualizarRoles,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // HABILIDADES
                  Text(
                    'Habilidades necesarias:',
                    style: AppTextStyles.fieldLabel.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Obx(
                    () => MultiSelectDropdown(
                      hintText: 'Puedes escoger más de una habilidad',
                      options: projectSkills,
                      selectedItems: controller.selectedSkills.value,
                      onChanged: controller.actualizarHabilidades,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // REQUISITOS
                  AppTextField(
                    label: 'Requisitos',
                    hint: 'Los requisitos son...',
                    controller: controller.requisitosController,
                    maxLength: 300,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                  ),

                  const SizedBox(height: 25),

                  // TIPO DE PROYECTO
                  Obx(
                    () => AppDropdownField(
                      label: 'Tipo de proyecto',
                      hint: 'Selecciona el tipo de proyecto',
                      value: controller.selectedProjectType.value,
                      items: projectTypes,
                      onChanged: controller.cambiarTipoProyecto,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // FECHA DE INICIO
                  Obx(
                    () => ProjectDateField(
                      label: 'Fecha de inicio',
                      date: controller.fechaInicio.value,
                      onTap: () => seleccionarFecha(1),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // FECHA DE CIERRE
                  Obx(
                    () => ProjectDateField(
                      label: 'Fecha de cierre',
                      date: controller.fechaCierre.value,
                      onTap: () => seleccionarFecha(2),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // DOCENTE ASESOR
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

                  const SizedBox(height: 32),

                  // BOTONES
                  ProjectFormActions(
                    onCancel: () {
                      Get.back();
                    },
                    onContinue: continuarAConfirmacion,
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

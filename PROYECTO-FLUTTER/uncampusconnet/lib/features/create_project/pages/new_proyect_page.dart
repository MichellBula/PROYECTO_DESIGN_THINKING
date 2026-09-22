import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/create_project/controllers/create_project_controller.dart';
import 'package:uncampusconnet/features/create_project/data/project_options.dart';
import 'package:uncampusconnet/features/create_project/pages/detalles_proyecto_page.dart';
import 'package:uncampusconnet/features/create_project/widgets/project_form_actions.dart';

import 'package:uncampusconnet/ui/widgets/dropdown_field.dart';
import 'package:uncampusconnet/features/home/controllers/main_controller.dart';
import 'package:uncampusconnet/ui/widgets/text_field.dart';
import 'package:uncampusconnet/ui/widgets/screen_title.dart';

class NuevoProyectoPage extends StatelessWidget {
  const NuevoProyectoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateProjectController());
    final mainController = Get.find<MainController>();
    final scheme = Theme.of(context).colorScheme;

    /// Valida el formulario y continúa a detalles.
    void continuar() {
      final nombre = controller.nombreController.text.trim();
      final descripcion = controller.descripcionController.text.trim();
      final lider = controller.liderController.text.trim();
      final categoria = controller.categoriaSeleccionada.value;

      if (nombre.isEmpty ||
          descripcion.isEmpty ||
          lider.isEmpty ||
          categoria == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Completa todos los campos antes de continuar.'),
          ),
        );

        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetallesProyectoPage(
            nombreProyecto: nombre,
            descripcion: descripcion,
            liderProyecto: lider,
            categoria: categoria,
          ),
        ),
      );
    }

    /// Regresa a la pestaña Inicio.
    void volverInicio() {
      mainController.changeTab(0);
    }

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Título de la pantalla.
            AppScreenTitle(title: 'Nuevo proyecto', onBack: volverInicio),

            // Formulario.
            Expanded(
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                children: [
                  // Introducción.
                  Text(
                    'Crea tu nuevo proyecto',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.formDescription.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    'compartiendo tus ideas y encuentra',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.formDescription.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    'compañeros para ejecutarlas.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.formDescription.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Nombre.
                  AppTextField(
                    label: 'Nombre del proyecto',
                    hint: 'Tu proyecto',
                    controller: controller.nombreController,
                    maxLength: 50,
                  ),

                  const SizedBox(height: 18),

                  // Descripción.
                  AppTextField(
                    label: 'Descripción',
                    hint: 'Mi proyecto se basa en...',
                    controller: controller.descripcionController,
                    maxLength: 400,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                  ),

                  const SizedBox(height: 18),

                  // Líder.
                  AppTextField(
                    label: 'Líder del proyecto',
                    hint: 'Tu nombre',
                    controller: controller.liderController,
                    maxLength: 40,
                  ),

                  const SizedBox(height: 18),

                  // Categoría.
                  Obx(
                    () => AppDropdownField(
                      label: 'Categoría',
                      hint: 'Selecciona una categoría',
                      value: controller.categoriaSeleccionada.value,
                      items: projectCategories,
                      onChanged: (value) {
                        controller.categoriaSeleccionada.value = value;
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Botones.
                  ProjectFormActions(
                    onCancel: volverInicio,
                    onContinue: continuar,
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

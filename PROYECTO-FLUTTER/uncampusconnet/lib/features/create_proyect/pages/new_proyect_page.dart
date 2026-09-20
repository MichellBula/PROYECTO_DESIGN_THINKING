import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/create_proyect/data/project_options.dart';
import 'package:uncampusconnet/features/create_proyect/pages/detalles_proyecto_page.dart';
import 'package:uncampusconnet/features/create_proyect/widgets/project_dropdown_field.dart';
import 'package:uncampusconnet/features/create_proyect/widgets/project_form_actions.dart';
import 'package:uncampusconnet/features/create_proyect/widgets/project_text_field.dart';
import 'package:uncampusconnet/ui/widgets/widgets_resumidos/screen_title.dart';

/// Primera pantalla del proceso de creación de un proyecto.
///
/// Recoge la información básica del proyecto antes de pasar
/// a la pantalla de detalles.
class NuevoProyectoPage extends StatefulWidget {
  const NuevoProyectoPage({super.key});

  @override
  State<NuevoProyectoPage> createState() => _NuevoProyectoPageState();
}

class _NuevoProyectoPageState extends State<NuevoProyectoPage> {
  // ======================================================
  // CONTROLADORES
  // ======================================================

  /// Controla el nombre del proyecto.
  final TextEditingController nombreController = TextEditingController();

  /// Controla la descripción.
  final TextEditingController descripcionController = TextEditingController();

  /// Controla el nombre del líder.
  final TextEditingController liderController = TextEditingController();

  // ======================================================
  // ESTADO
  // ======================================================

  /// Categoría seleccionada.
  String? selectedCategory;

  // ======================================================
  // CICLO DE VIDA
  // ======================================================

  @override
  void dispose() {
    nombreController.dispose();
    descripcionController.dispose();
    liderController.dispose();

    super.dispose();
  }

  // ======================================================
  // CONTINUAR
  // ======================================================

  /// Valida los campos y navega hacia los detalles
  /// del proyecto.
  void continuar() {
    final nombre = nombreController.text.trim();
    final descripcion = descripcionController.text.trim();
    final lider = liderController.text.trim();

    if (nombre.isEmpty ||
        descripcion.isEmpty ||
        lider.isEmpty ||
        selectedCategory == null) {
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
          categoria: selectedCategory!,
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

            AppScreenTitle(
              title: 'Nuevo proyecto',
              onBack: () {
                Navigator.pop(context);
              },
            ),

            // ==========================================
            // FORMULARIO
            // ==========================================
            Expanded(
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,

                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),

                children: [
                  // ======================================
                  // INTRODUCCIÓN
                  // ======================================

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

                  // ======================================
                  // NOMBRE
                  // ======================================
                  ProjectTextField(
                    label: 'Nombre del proyecto',
                    hint: 'Tu proyecto',
                    controller: nombreController,
                    maxLength: 50,
                  ),

                  const SizedBox(height: 18),

                  // ======================================
                  // DESCRIPCIÓN
                  // ======================================
                  ProjectTextField(
                    label: 'Descripción',
                    hint: 'Mi proyecto se basa en...',
                    controller: descripcionController,
                    maxLength: 400,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                  ),

                  const SizedBox(height: 18),

                  // ======================================
                  // LÍDER
                  // ======================================
                  ProjectTextField(
                    label: 'Líder del proyecto',
                    hint: 'Tu nombre',
                    controller: liderController,
                    maxLength: 40,
                  ),

                  const SizedBox(height: 18),

                  // ======================================
                  // CATEGORÍA
                  // ======================================
                  ProjectDropdownField(
                    label: 'Categoría',
                    hint: 'Selecciona una categoría',
                    value: selectedCategory,
                    items: projectCategories,
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),

                  const SizedBox(height: 30),

                  // ======================================
                  // BOTONES
                  // ======================================
                  ProjectFormActions(
                    onCancel: () {
                      Navigator.pop(context);
                    },
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

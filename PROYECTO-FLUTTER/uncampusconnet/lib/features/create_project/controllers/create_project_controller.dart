import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uncampusconnet/features/create_project/domain/entities/create_project_request.dart';
import 'package:uncampusconnet/features/create_project/domain/usecases/create_complete_project.dart';

class CreateProjectController extends GetxController {
  CreateProjectController({CreateCompleteProject? createCompleteProject})
    : createCompleteProject = createCompleteProject ?? CreateCompleteProject();

  final CreateCompleteProject createCompleteProject;

  // ======================================================
  // CAMPOS DE LA PRIMERA PANTALLA
  // ======================================================

  final nombreController = TextEditingController();

  final descripcionController = TextEditingController();

  final liderController = TextEditingController();

  // ======================================================
  // CATEGORÍA
  // ======================================================

  final Rxn<String> categoriaSeleccionada = Rxn<String>();

  // ======================================================
  // ESTADO DE PUBLICACIÓN
  // ======================================================

  final RxBool cargando = false.obs;

  // ======================================================
  // PUBLICAR PROYECTO
  // ======================================================

  Future<bool> publicarProyecto(CreateProjectRequest request) async {
    // ----------------------------------------------------
    // Evitar doble click / doble petición.
    // ----------------------------------------------------

    if (cargando.value) {
      print(
        '[CREATE_PROJECT_CONTROLLER] '
        '⚠️ Ya existe una publicación en progreso.',
      );

      return false;
    }

    cargando.value = true;

    print('');
    print('==================================================');
    print(
      '[CREATE_PROJECT_CONTROLLER] '
      'INICIANDO PUBLICACIÓN',
    );
    print('==================================================');

    try {
      print(
        '[CREATE_PROJECT_CONTROLLER] '
        'Proyecto: ${request.nombreProyecto}',
      );

      print(
        '[CREATE_PROJECT_CONTROLLER] '
        'Categoría: ${request.categoria}',
      );

      print(
        '[CREATE_PROJECT_CONTROLLER] '
        'Tipo: ${request.tipoProyecto}',
      );

      print(
        '[CREATE_PROJECT_CONTROLLER] '
        'Roles: ${request.roles}',
      );

      print(
        '[CREATE_PROJECT_CONTROLLER] '
        'Habilidades: ${request.habilidades}',
      );

      print(
        '[CREATE_PROJECT_CONTROLLER] '
        'Llamando a CreateCompleteProject...',
      );

      final resultado = await createCompleteProject(request);

      print(
        '[CREATE_PROJECT_CONTROLLER] '
        '✅ Publicación completada.',
      );

      print(
        '[CREATE_PROJECT_CONTROLLER] '
        'Resultado: $resultado',
      );

      return true;
    } catch (e, stackTrace) {
      print('');
      print(
        '[CREATE_PROJECT_CONTROLLER] '
        '❌ ERROR AL PUBLICAR',
      );

      print('[CREATE_PROJECT_CONTROLLER] Error: $e');

      print('[CREATE_PROJECT_CONTROLLER] StackTrace:');

      print(stackTrace);

      Get.snackbar(
        'No se pudo crear el proyecto',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );

      return false;
    } finally {
      cargando.value = false;

      print(
        '[CREATE_PROJECT_CONTROLLER] '
        'Proceso de publicación finalizado.',
      );
    }
  }

  // ======================================================
  // LIMPIAR
  // ======================================================

  void limpiarFormulario() {
    nombreController.clear();
    descripcionController.clear();
    liderController.clear();

    categoriaSeleccionada.value = null;
  }

  @override
  void onClose() {
    nombreController.dispose();
    descripcionController.dispose();
    liderController.dispose();

    super.onClose();
  }
}

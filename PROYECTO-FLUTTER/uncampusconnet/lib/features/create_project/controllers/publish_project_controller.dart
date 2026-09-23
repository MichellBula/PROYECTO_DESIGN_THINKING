import 'package:get/get.dart';

import '../domain/entities/create_project_request.dart';
import '../domain/usecases/create_complete_project.dart';

class PublishProjectController extends GetxController {
  final CreateCompleteProject createCompleteProject;

  PublishProjectController({CreateCompleteProject? createCompleteProject})
    : createCompleteProject = createCompleteProject ?? CreateCompleteProject();

  final RxBool isLoading = false.obs;

  Future<Map<String, dynamic>?> publicar({
    required String nombreProyecto,
    required String descripcion,
    required String objetivo,
    required String categoria,
    required List<String> roles,
    required Map<String, int> cantidadesPorRol,
    required List<String> habilidades,
    required String requisitos,
    required String? tipoProyecto,
    required DateTime? fechaInicio,
    required DateTime? fechaCierre,
    required bool deseaDocente,
  }) async {
    if (isLoading.value) {
      return null;
    }

    if (fechaInicio == null || fechaCierre == null) {
      throw Exception('Faltan las fechas del proyecto.');
    }

    isLoading.value = true;

    try {
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
        fechaInicio: fechaInicio,
        fechaCierre: fechaCierre,
        deseaDocente: deseaDocente,
      );

      return await createCompleteProject(request);
    } finally {
      isLoading.value = false;
    }
  }
}

import 'package:roble/roble.dart';

import '../../../../core/database/roble_client.dart';
import '../../models/project_model.dart';

class ProjectRemoteDatasource {
  final RobleApiDataBase roble;

  ProjectRemoteDatasource({
    RobleApiDataBase? roble,
  }) : roble = roble ?? RobleClient.instance;

  static const int _maxIntentosCrearProyecto = 5;

  Future<int> _obtenerSiguienteIdProyecto() async {
    final proyectos = await roble.read('proyecto');

    if (proyectos.isEmpty) {
      return 1;
    }

    int mayorId = 0;

    for (final proyecto in proyectos) {
      final id = int.tryParse(
        proyecto['id_proyecto'].toString(),
      );

      if (id != null && id > mayorId) {
        mayorId = id;
      }
    }

    return mayorId + 1;
  }

  Future<bool> _idYaExiste(int idProyecto) async {
    final proyectos = await roble.read(
      'proyecto',
      filters: {
        'id_proyecto': idProyecto,
      },
    );

    return proyectos.isNotEmpty;
  }

  Future<Map<String, dynamic>> createProject(
    ProjectModel project,
  ) async {
    for (
      int intento = 1;
      intento <= _maxIntentosCrearProyecto;
      intento++
    ) {
      final idProyecto = await _obtenerSiguienteIdProyecto();

      try {
        final data = {
          'id_proyecto': idProyecto,
          ...project.toMap(),
        };

        return await roble.create(
          'proyecto',
          data,
        );
      } catch (e) {
        final existe = await _idYaExiste(idProyecto);

        if (!existe || intento == _maxIntentosCrearProyecto) {
          rethrow;
        }
      }
    }

    throw Exception(
      'No fue posible crear el proyecto.',
    );
  }
}
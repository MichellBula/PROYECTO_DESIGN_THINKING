import 'package:roble/roble.dart';

import '../../../../core/database/roble_client.dart';
import '../../models/project_skill_model.dart';

class ProjectSkillsRemoteDatasource {
  final RobleApiDataBase roble;

  ProjectSkillsRemoteDatasource({
    RobleApiDataBase? roble,
  }) : roble = roble ?? RobleClient.instance;

  static const int _maxIntentosCrearRelacion = 5;

  Future<int> _obtenerSiguienteId() async {
    final relaciones = await roble.read(
      'proyecto_habilidades',
    );

    int mayorId = 0;

    for (final relacion in relaciones) {
      final id = int.tryParse(
        relacion['id_proyecto_habilidad'].toString(),
      );

      if (id != null && id > mayorId) {
        mayorId = id;
      }
    }

    return mayorId + 1;
  }

  Future<bool> _relacionExiste({
    required int idProyecto,
    required int idHabilidad,
  }) async {
    final relaciones = await roble.read(
      'proyecto_habilidades',
      filters: {
        'id_proyecto': idProyecto,
        'id_habilidad': idHabilidad,
      },
    );

    return relaciones.isNotEmpty;
  }

  Future<bool> _idExiste(int idProyectoHabilidad) async {
    final relaciones = await roble.read(
      'proyecto_habilidades',
      filters: {
        'id_proyecto_habilidad': idProyectoHabilidad,
      },
    );

    return relaciones.isNotEmpty;
  }

  Future<Map<String, dynamic>> createProjectSkill(
    ProjectSkillModel projectSkill,
  ) async {
    // ------------------------------------------------------
    // Evitar que la misma habilidad quede dos veces
    // en el mismo proyecto.
    // ------------------------------------------------------

    final relacionExistente = await roble.read(
      'proyecto_habilidades',
      filters: {
        'id_proyecto': projectSkill.idProyecto,
        'id_habilidad': projectSkill.idHabilidad,
      },
    );

    if (relacionExistente.isNotEmpty) {
      return Map<String, dynamic>.from(
        relacionExistente.first,
      );
    }

    // ------------------------------------------------------
    // Generación del ID propio de la tabla intermedia.
    // ------------------------------------------------------

    for (
      int intento = 1;
      intento <= _maxIntentosCrearRelacion;
      intento++
    ) {
      final idProyectoHabilidad =
          await _obtenerSiguienteId();

      try {
        final resultado = await roble.create(
          'proyecto_habilidades',
          projectSkill.toMap(
            idProyectoHabilidad: idProyectoHabilidad,
          ),
        );

        return Map<String, dynamic>.from(
          resultado,
        );
      } catch (e) {
        // Otra inserción pudo haber ocupado ese ID
        // mientras nosotros intentábamos usarlo.
        final idFueOcupado = await _idExiste(
          idProyectoHabilidad,
        );

        if (
          !idFueOcupado ||
          intento == _maxIntentosCrearRelacion
        ) {
          rethrow;
        }
      }
    }

    throw Exception(
      'No fue posible crear la relación proyecto-habilidad.',
    );
  }

  Future<List<Map<String, dynamic>>> getSkillsByProject(
    int idProyecto,
  ) async {
    final resultado = await roble.read(
      'proyecto_habilidades',
      filters: {
        'id_proyecto': idProyecto,
      },
    );

    return resultado
        .map(
          (item) => Map<String, dynamic>.from(item),
        )
        .toList();
  }
}
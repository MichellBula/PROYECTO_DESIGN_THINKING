import 'package:roble/roble.dart';

import '../../../../core/database/roble_client.dart';
import '../../models/project_role_model.dart';

class ProjectRolesRemoteDatasource {
  final RobleApiDataBase roble;

  ProjectRolesRemoteDatasource({
    RobleApiDataBase? roble,
  }) : roble = roble ?? RobleClient.instance;

  static const int _maxIntentosCrearRelacion = 5;

  Future<int> _obtenerSiguienteId() async {
    final relaciones = await roble.read(
      'proyecto_roles',
    );

    int mayorId = 0;

    for (final relacion in relaciones) {
      final id = int.tryParse(
        relacion['id_proyecto_rol'].toString(),
      );

      if (id != null && id > mayorId) {
        mayorId = id;
      }
    }

    return mayorId + 1;
  }

  Future<bool> _relacionExiste({
    required int idProyecto,
    required int idRol,
  }) async {
    final relaciones = await roble.read(
      'proyecto_roles',
      filters: {
        'id_proyecto': idProyecto,
        'id_rol': idRol,
      },
    );

    return relaciones.isNotEmpty;
  }

  Future<bool> _idExiste(
    int idProyectoRol,
  ) async {
    final relaciones = await roble.read(
      'proyecto_roles',
      filters: {
        'id_proyecto_rol': idProyectoRol,
      },
    );

    return relaciones.isNotEmpty;
  }

  Future<Map<String, dynamic>> createProjectRole(
    ProjectRoleModel projectRole,
  ) async {
    if (projectRole.cantidad <= 0) {
      throw Exception(
        'La cantidad de integrantes debe ser mayor que 0.',
      );
    }

    final relacionExistente = await _relacionExiste(
      idProyecto: projectRole.idProyecto,
      idRol: projectRole.idRol,
    );

    if (relacionExistente) {
      final relaciones = await roble.read(
        'proyecto_roles',
        filters: {
          'id_proyecto': projectRole.idProyecto,
          'id_rol': projectRole.idRol,
        },
      );

      return Map<String, dynamic>.from(
        relaciones.first,
      );
    }

    for (
      int intento = 1;
      intento <= _maxIntentosCrearRelacion;
      intento++
    ) {
      final idProyectoRol =
          await _obtenerSiguienteId();

      try {
        final resultado = await roble.create(
          'proyecto_roles',
          projectRole.toMap(
            idProyectoRol: idProyectoRol,
          ),
        );

        return Map<String, dynamic>.from(
          resultado,
        );
      } catch (e) {
        final idFueOcupado = await _idExiste(
          idProyectoRol,
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
      'No fue posible crear la relación proyecto-rol.',
    );
  }

  Future<List<Map<String, dynamic>>> getRolesByProject(
    int idProyecto,
  ) async {
    final resultado = await roble.read(
      'proyecto_roles',
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
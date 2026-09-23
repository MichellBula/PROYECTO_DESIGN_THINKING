import 'package:roble/roble.dart';
import 'package:uncampusconnet/core/database/roble_client.dart';
import 'package:uncampusconnet/features/create_project/models/project_role_model.dart';

class ProjectRolesRemoteDatasource {
  final RobleApiDataBase roble;

  ProjectRolesRemoteDatasource({RobleApiDataBase? roble})
    : roble = roble ?? RobleClient.instance;

  static const int _maxIntentosCrearRelacion = 5;

  Future<int> _obtenerSiguienteId() async {
    final relaciones = await roble.read('proyecto_roles');

    int mayorId = 0;

    for (final relacion in relaciones) {
      final id = int.tryParse(relacion['id_proyecto_rol'].toString());

      if (id != null && id > mayorId) {
        mayorId = id;
      }
    }

    return mayorId + 1;
  }

  Future<Map<String, dynamic>?> _buscarRelacionExistente({
    required int idProyecto,
    required int idRol,
  }) async {
    final relaciones = await roble.read(
      'proyecto_roles',
      filters: {'id_proyecto': idProyecto, 'id_rol': idRol},
    );

    if (relaciones.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(relaciones.first);
  }

  Future<Map<String, dynamic>?> _buscarPorId(int idProyectoRol) async {
    final relaciones = await roble.read(
      'proyecto_roles',
      filters: {'id_proyecto_rol': idProyectoRol},
    );

    if (relaciones.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(relaciones.first);
  }

  Future<Map<String, dynamic>> createProjectRole(
    ProjectRoleModel projectRole,
  ) async {
    print(
      '[PROJECT_ROLE] Creando relación '
      'proyecto=${projectRole.idProyecto}, '
      'rol=${projectRole.idRol}, '
      'cantidad=${projectRole.cantidad}',
    );

    if (projectRole.cantidad <= 0) {
      throw Exception('La cantidad de integrantes debe ser mayor que 0.');
    }

    // -------------------------------------------------------
    // Verificar primero si ya existe
    // -------------------------------------------------------

    final existente = await _buscarRelacionExistente(
      idProyecto: projectRole.idProyecto,
      idRol: projectRole.idRol,
    );

    if (existente != null) {
      print(
        '[PROJECT_ROLE] ⚠️ La relación ya existe. '
        'Se reutiliza.',
      );

      return existente;
    }

    // -------------------------------------------------------
    // Crear
    // -------------------------------------------------------

    for (int intento = 1; intento <= _maxIntentosCrearRelacion; intento++) {
      final idProyectoRol = await _obtenerSiguienteId();

      print(
        '[PROJECT_ROLE] Intento $intento '
        '→ id_proyecto_rol=$idProyectoRol',
      );

      try {
        final resultado = await roble.create(
          'proyecto_roles',
          projectRole.toMap(idProyectoRol: idProyectoRol),
        );

        final mapa = Map<String, dynamic>.from(resultado);

        print('[PROJECT_ROLE] ✅ Relación creada.');

        print('[PROJECT_ROLE] Resultado: $mapa');

        return mapa;
      } catch (e) {
        print('[PROJECT_ROLE] ⚠️ Error: $e');

        // ---------------------------------------------------
        // Si la operación realmente alcanzó a crear la
        // relación pero la respuesta falló, la buscamos por
        // proyecto + rol antes de intentar otra vez.
        // ---------------------------------------------------

        final relacionAhora = await _buscarRelacionExistente(
          idProyecto: projectRole.idProyecto,
          idRol: projectRole.idRol,
        );

        if (relacionAhora != null) {
          print(
            '[PROJECT_ROLE] ⚠️ La relación apareció '
            'después del error.',
          );

          print('[PROJECT_ROLE] Se reutiliza para evitar duplicado.');

          return relacionAhora;
        }

        final registroPorId = await _buscarPorId(idProyectoRol);

        if (registroPorId == null) {
          rethrow;
        }

        print(
          '[PROJECT_ROLE] El ID ya estaba ocupado. '
          'Se intenta otro.',
        );
      }
    }

    throw Exception('No fue posible crear la relación proyecto-rol.');
  }

  Future<List<Map<String, dynamic>>> getRolesByProject(int idProyecto) async {
    final resultado = await roble.read(
      'proyecto_roles',
      filters: {'id_proyecto': idProyecto},
    );

    print(
      '[PROJECT_ROLE] '
      'Roles encontrados para proyecto '
      '$idProyecto: ${resultado.length}',
    );

    return resultado.map((item) => Map<String, dynamic>.from(item)).toList();
  }
}

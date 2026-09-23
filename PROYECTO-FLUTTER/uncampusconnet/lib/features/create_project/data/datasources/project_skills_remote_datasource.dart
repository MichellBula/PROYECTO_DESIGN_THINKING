import 'package:roble/roble.dart';
import 'package:uncampusconnet/core/database/roble_client.dart';
import 'package:uncampusconnet/features/create_project/models/project_skill_model.dart';

class ProjectSkillsRemoteDatasource {
  final RobleApiDataBase roble;

  ProjectSkillsRemoteDatasource({RobleApiDataBase? roble})
    : roble = roble ?? RobleClient.instance;

  static const int _maxIntentosCrearRelacion = 5;

  Future<int> _obtenerSiguienteId() async {
    final relaciones = await roble.read('proyecto_habilidades');

    int mayorId = 0;

    for (final relacion in relaciones) {
      final id = int.tryParse(relacion['id_proyecto_habilidad'].toString());

      if (id != null && id > mayorId) {
        mayorId = id;
      }
    }

    return mayorId + 1;
  }

  Future<Map<String, dynamic>?> _buscarRelacionExistente({
    required int idProyecto,
    required int idHabilidad,
  }) async {
    final relaciones = await roble.read(
      'proyecto_habilidades',
      filters: {'id_proyecto': idProyecto, 'id_habilidad': idHabilidad},
    );

    if (relaciones.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(relaciones.first);
  }

  Future<Map<String, dynamic>?> _buscarPorId(int idProyectoHabilidad) async {
    final relaciones = await roble.read(
      'proyecto_habilidades',
      filters: {'id_proyecto_habilidad': idProyectoHabilidad},
    );

    if (relaciones.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(relaciones.first);
  }

  Future<Map<String, dynamic>> createProjectSkill(
    ProjectSkillModel projectSkill,
  ) async {
    print(
      '[PROJECT_SKILL] Creando relación '
      'proyecto=${projectSkill.idProyecto}, '
      'habilidad=${projectSkill.idHabilidad}',
    );

    // -------------------------------------------------------
    // Evitar duplicado
    // -------------------------------------------------------

    final existente = await _buscarRelacionExistente(
      idProyecto: projectSkill.idProyecto,
      idHabilidad: projectSkill.idHabilidad,
    );

    if (existente != null) {
      print(
        '[PROJECT_SKILL] ⚠️ La relación ya existe. '
        'Se reutiliza.',
      );

      return existente;
    }

    // -------------------------------------------------------
    // Crear
    // -------------------------------------------------------

    for (int intento = 1; intento <= _maxIntentosCrearRelacion; intento++) {
      final idProyectoHabilidad = await _obtenerSiguienteId();

      print(
        '[PROJECT_SKILL] Intento $intento '
        '→ id_proyecto_habilidad='
        '$idProyectoHabilidad',
      );

      try {
        final resultado = await roble.create(
          'proyecto_habilidades',
          projectSkill.toMap(idProyectoHabilidad: idProyectoHabilidad),
        );

        final mapa = Map<String, dynamic>.from(resultado);

        print('[PROJECT_SKILL] ✅ Relación creada.');

        print('[PROJECT_SKILL] Resultado: $mapa');

        return mapa;
      } catch (e) {
        print('[PROJECT_SKILL] ⚠️ Error: $e');

        // ---------------------------------------------------
        // Comprobar si realmente se creó.
        // ---------------------------------------------------

        final relacionAhora = await _buscarRelacionExistente(
          idProyecto: projectSkill.idProyecto,
          idHabilidad: projectSkill.idHabilidad,
        );

        if (relacionAhora != null) {
          print(
            '[PROJECT_SKILL] ⚠️ La relación apareció '
            'después del error.',
          );

          print('[PROJECT_SKILL] Se reutiliza para evitar duplicado.');

          return relacionAhora;
        }

        final registroPorId = await _buscarPorId(idProyectoHabilidad);

        if (registroPorId == null) {
          rethrow;
        }

        print(
          '[PROJECT_SKILL] El ID ya estaba ocupado. '
          'Se intenta otro.',
        );
      }
    }

    throw Exception('No fue posible crear la relación proyecto-habilidad.');
  }

  Future<List<Map<String, dynamic>>> getSkillsByProject(int idProyecto) async {
    final resultado = await roble.read(
      'proyecto_habilidades',
      filters: {'id_proyecto': idProyecto},
    );

    print(
      '[PROJECT_SKILL] '
      'Habilidades encontradas para proyecto '
      '$idProyecto: ${resultado.length}',
    );

    return resultado.map((item) => Map<String, dynamic>.from(item)).toList();
  }
}

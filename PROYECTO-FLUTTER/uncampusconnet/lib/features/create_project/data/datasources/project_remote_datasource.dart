import 'package:roble/roble.dart';
import 'package:uncampusconnet/core/database/roble_client.dart';
import 'package:uncampusconnet/features/create_project/models/project_model.dart';

class ProjectRemoteDatasource {
  final RobleApiDataBase roble;

  ProjectRemoteDatasource({RobleApiDataBase? roble})
    : roble = roble ?? RobleClient.instance;

  static const int _maxIntentosCrearProyecto = 5;

  Future<int> _obtenerSiguienteIdProyecto() async {
    final proyectos = await roble.read('proyecto');

    if (proyectos.isEmpty) {
      print(
        '[PROJECT] No existen proyectos. '
        'Siguiente ID: 1',
      );

      return 1;
    }

    int mayorId = 0;

    for (final proyecto in proyectos) {
      final id = int.tryParse(proyecto['id_proyecto'].toString());

      if (id != null && id > mayorId) {
        mayorId = id;
      }
    }

    final siguienteId = mayorId + 1;

    print(
      '[PROJECT] Mayor ID encontrado: $mayorId '
      '→ siguiente ID: $siguienteId',
    );

    return siguienteId;
  }

  Future<Map<String, dynamic>?> _buscarProyectoPorId(int idProyecto) async {
    final proyectos = await roble.read(
      'proyecto',
      filters: {'id_proyecto': idProyecto},
    );

    if (proyectos.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(proyectos.first);
  }

  bool _proyectoCoincide(
    Map<String, dynamic> proyecto,
    Map<String, dynamic> data,
  ) {
    return proyecto['nombre']?.toString() == data['nombre']?.toString() &&
        proyecto['descripcion']?.toString() ==
            data['descripcion']?.toString() &&
        proyecto['id_creador']?.toString() == data['id_creador']?.toString() &&
        proyecto['id_categoria']?.toString() ==
            data['id_categoria']?.toString() &&
        proyecto['id_tipo_proyecto']?.toString() ==
            data['id_tipo_proyecto']?.toString() &&
        proyecto['objetivo']?.toString() == data['objetivo']?.toString() &&
        proyecto['requisitos']?.toString() == data['requisitos']?.toString() &&
        proyecto['num_integrantes']?.toString() ==
            data['num_integrantes']?.toString() &&
        proyecto['docente_asesor']?.toString() ==
            data['docente_asesor']?.toString() &&
        proyecto['estado']?.toString() == data['estado']?.toString();
  }

  Future<Map<String, dynamic>> createProject(ProjectModel project) async {
    print('');
    print('==================================================');
    print('[PROJECT] INICIANDO CREACIÓN DE PROYECTO');
    print('==================================================');

    print('[PROJECT] nombre: ${project.nombre}');

    print('[PROJECT] creador: ${project.idCreador}');

    print('[PROJECT] categoría: ${project.idCategoria}');

    print('[PROJECT] tipo: ${project.idTipoProyecto}');

    final data = <String, dynamic>{
      'nombre': project.nombre,
      'descripcion': project.descripcion,
      'id_creador': project.idCreador,
      'id_categoria': project.idCategoria,
      'id_tipo_proyecto': project.idTipoProyecto,
      'objetivo': project.objetivo,
      'requisitos': project.requisitos,
      'num_integrantes': project.numIntegrantes,
      'docente_asesor': project.docenteAsesor,
      'estado': project.estado,
    };

    for (int intento = 1; intento <= _maxIntentosCrearProyecto; intento++) {
      final idProyecto = await _obtenerSiguienteIdProyecto();

      final payload = {'id_proyecto': idProyecto, ...data};

      print(
        '[PROJECT] Intento $intento '
        '→ creando id_proyecto=$idProyecto',
      );

      try {
        final resultado = await roble.create('proyecto', payload);

        final mapa = Map<String, dynamic>.from(resultado);

        print('[PROJECT] ✅ Proyecto creado correctamente.');

        print('[PROJECT] Resultado: $mapa');

        print(
          '[PROJECT] id_proyecto generado: '
          '${mapa['id_proyecto']}',
        );

        return mapa;
      } catch (e) {
        print('[PROJECT] ⚠️ Error en intento $intento: $e');

        // ---------------------------------------------------
        // IMPORTANTE:
        // Si Roble alcanzó a crear el registro pero la
        // respuesta falló, recuperamos el mismo registro
        // en lugar de crear otro.
        // ---------------------------------------------------

        final proyectoExistente = await _buscarProyectoPorId(idProyecto);

        if (proyectoExistente != null) {
          if (_proyectoCoincide(proyectoExistente, payload)) {
            print(
              '[PROJECT] ⚠️ El registro ya existía '
              'y coincide con la petición.',
            );

            print(
              '[PROJECT] Se reutiliza el proyecto '
              'para evitar duplicarlo.',
            );

            return proyectoExistente;
          }

          print(
            '[PROJECT] El ID $idProyecto ya pertenece '
            'a otro proyecto. Se intentará otro ID.',
          );

          continue;
        }

        // Si el ID ni siquiera fue creado, significa que
        // el create falló realmente.
        print(
          '[PROJECT] El proyecto no fue creado. '
          'No se continuará para este error.',
        );

        rethrow;
      }
    }

    throw Exception('No fue posible crear el proyecto.');
  }
}

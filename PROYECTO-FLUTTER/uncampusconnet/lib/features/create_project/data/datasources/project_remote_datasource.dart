import 'package:roble/roble.dart';

import 'package:uncampusconnet/core/database/roble_client.dart';
import 'package:uncampusconnet/core/services/usuario_stats_service.dart';
import 'package:uncampusconnet/features/create_project/models/project_model.dart';

class ProjectRemoteDatasource {
  final RobleApiDataBase roble;

  ProjectRemoteDatasource({
    RobleApiDataBase? roble,
  }) : roble = roble ?? RobleClient.instance;

  static const int _maxIntentosCrearProyecto = 5;

  // ==========================================================
  // OBTENER SIGUIENTE ID
  // ==========================================================

  Future<int> _obtenerSiguienteIdProyecto() async {
    final proyectos = await roble.read(
      'proyecto',
    );

    if (proyectos.isEmpty) {
      print(
        '[PROJECT] No existen proyectos. '
        'Siguiente ID: 1',
      );

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

    final siguienteId = mayorId + 1;

    print(
      '[PROJECT] Mayor ID encontrado: '
      '$mayorId → siguiente ID: $siguienteId',
    );

    return siguienteId;
  }

  // ==========================================================
  // BUSCAR PROYECTO POR ID
  // ==========================================================

  Future<Map<String, dynamic>?> _buscarProyectoPorId(
    int idProyecto,
  ) async {
    final proyectos = await roble.read(
      'proyecto',
      filters: {
        'id_proyecto': idProyecto,
      },
    );

    if (proyectos.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(
      proyectos.first,
    );
  }

  // ==========================================================
  // COMPROBAR SI EL PROYECTO RECUPERADO COINCIDE
  // ==========================================================

  bool _proyectoCoincide(
    Map<String, dynamic> proyecto,
    Map<String, dynamic> data,
  ) {
    return proyecto['nombre']?.toString() ==
            data['nombre']?.toString() &&
        proyecto['descripcion']?.toString() ==
            data['descripcion']?.toString() &&
        proyecto['id_creador']?.toString() ==
            data['id_creador']?.toString() &&
        proyecto['id_categoria']?.toString() ==
            data['id_categoria']?.toString() &&
        proyecto['id_tipo_proyecto']?.toString() ==
            data['id_tipo_proyecto']?.toString() &&
        proyecto['objetivo']?.toString() ==
            data['objetivo']?.toString() &&
        proyecto['requisitos']?.toString() ==
            data['requisitos']?.toString() &&
        proyecto['num_integrantes']?.toString() ==
            data['num_integrantes']?.toString() &&
        proyecto['docente_asesor']?.toString() ==
            data['docente_asesor']?.toString() &&
        proyecto['estado']?.toString() ==
            data['estado']?.toString();
  }

  // ==========================================================
  // SINCRONIZAR ESTADISTICAS DEL CREADOR
  // ==========================================================

  Future<void> _sincronizarEstadisticasCreador(
    int idCreador,
  ) async {
    print(
      '[PROJECT] Sincronizando estadísticas del creador '
      'id_usuario=$idCreador...',
    );

    final servicio = UsuarioStatsService(
      roble: roble,
    );

    await servicio.sincronizarUsuario(
      idCreador,
    );

    print(
      '[PROJECT] ✅ Estadísticas del creador actualizadas.',
    );
  }

  // ==========================================================
  // CREAR PROYECTO
  // ==========================================================

  Future<Map<String, dynamic>> createProject(
    ProjectModel project,
  ) async {
    print('');
    print(
      '==================================================',
    );
    print(
      '[PROJECT] INICIANDO CREACIÓN DE PROYECTO',
    );
    print(
      '==================================================',
    );

    print(
      '[PROJECT] nombre: ${project.nombre}',
    );

    print(
      '[PROJECT] creador: ${project.idCreador}',
    );

    print(
      '[PROJECT] categoría: ${project.idCategoria}',
    );

    print(
      '[PROJECT] tipo: ${project.idTipoProyecto}',
    );

    // ========================================================
    // DATOS DEL PROYECTO
    // ========================================================

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

    // ========================================================
    // CREAR CON REINTENTOS
    // ========================================================

    for (
      int intento = 1;
      intento <= _maxIntentosCrearProyecto;
      intento++
    ) {
      final idProyecto =
          await _obtenerSiguienteIdProyecto();

      final payload = {
        'id_proyecto': idProyecto,
        ...data,
      };

      print(
        '[PROJECT] Intento $intento '
        '→ creando id_proyecto=$idProyecto',
      );

      try {
        final resultado = await roble.create(
          'proyecto',
          payload,
        );

        final mapa =
            Map<String, dynamic>.from(
          resultado,
        );

        print(
          '[PROJECT] ✅ Proyecto creado correctamente.',
        );

        print(
          '[PROJECT] Resultado: $mapa',
        );

        print(
          '[PROJECT] id_proyecto generado: '
          '${mapa['id_proyecto']}',
        );

        // ====================================================
        // ACTUALIZAR ESTADISTICAS DEL CREADOR
        // ====================================================

        await _sincronizarEstadisticasCreador(
          project.idCreador,
        );

        return mapa;
      } catch (e) {
        print(
          '[PROJECT] ⚠️ Error en intento '
          '$intento: $e',
        );

        final proyectoExistente =
            await _buscarProyectoPorId(
          idProyecto,
        );

        if (proyectoExistente != null) {
          if (_proyectoCoincide(
            proyectoExistente,
            payload,
          )) {
            print(
              '[PROJECT] ⚠️ El registro ya existía '
              'y coincide con la petición.',
            );

            print(
              '[PROJECT] Se reutiliza el proyecto '
              'para evitar duplicarlo.',
            );

            await _sincronizarEstadisticasCreador(
              project.idCreador,
            );

            return proyectoExistente;
          }

          print(
            '[PROJECT] El ID $idProyecto ya pertenece '
            'a otro proyecto. Se intentará otro ID.',
          );

          continue;
        }

        print(
          '[PROJECT] El proyecto no fue creado. '
          'No se continuará para este error.',
        );

        rethrow;
      }
    }

    throw Exception(
      'No fue posible crear el proyecto.',
    );
  }

  // ==========================================================
  // OBTENER ID DEL USUARIO AUTENTICADO
  // ==========================================================

  Future<int> _obtenerIdUsuarioAutenticado() async {
    final user =
        await roble.currentUser();

    final userId =
        user['userId']?.toString();

    if (userId == null ||
        userId.isEmpty) {
      throw Exception(
        'No fue posible obtener el usuario autenticado.',
      );
    }

    final usuarios =
        await roble.read(
      'usuario',
      filters: {
        'id_autenticador': userId,
      },
    );

    if (usuarios.isEmpty) {
      throw Exception(
        'La cuenta autenticada no tiene '
        'un perfil registrado.',
      );
    }

    final idUsuario =
        int.tryParse(
      usuarios.first['id_usuario']
          .toString(),
    );

    if (idUsuario == null) {
      throw Exception(
        'El perfil autenticado no tiene '
        'un id_usuario válido.',
      );
    }

    return idUsuario;
  }

  // ==========================================================
  // CALIFICAR PROYECTO
  // ==========================================================

  Future<Map<String, dynamic>> calificarProyecto({
    required int idProyecto,
    required double calificacion,
  }) async {
    // ========================================================
    // VALIDAR CALIFICACION
    // ========================================================

    if (calificacion < 1.0 ||
        calificacion > 5.0) {
      throw Exception(
        'La calificación debe estar '
        'entre 1.0 y 5.0.',
      );
    }

    // ========================================================
    // BUSCAR PROYECTO
    // ========================================================

    final proyectos =
        await roble.read(
      'proyecto',
      filters: {
        'id_proyecto': idProyecto,
      },
    );

    if (proyectos.isEmpty) {
      throw Exception(
        'No existe el proyecto con id '
        '$idProyecto.',
      );
    }

    final proyecto =
        Map<String, dynamic>.from(
      proyectos.first,
    );

    // ========================================================
    // OBTENER CREADOR
    // ========================================================

    final idCreador =
        int.tryParse(
      proyecto['id_creador']
          .toString(),
    );

    if (idCreador == null) {
      throw Exception(
        'El proyecto no tiene un '
        'id_creador válido.',
      );
    }

    // ========================================================
    // OBTENER USUARIO AUTENTICADO
    // ========================================================

    final idUsuarioAutenticado =
        await _obtenerIdUsuarioAutenticado();

    // ========================================================
    // VALIDAR QUE SEA EL CREADOR
    // ========================================================

    if (idUsuarioAutenticado !=
        idCreador) {
      throw Exception(
        'Solo el creador del proyecto '
        'puede calificarlo.',
      );
    }

    // ========================================================
    // OBTENER UUID DE ROBLE
    // ========================================================

    final robleId =
        proyecto['_id']?.toString();

    if (robleId == null ||
        robleId.isEmpty) {
      throw Exception(
        'El proyecto no tiene un '
        '_id válido de Roble.',
      );
    }

    // ========================================================
    // ACTUALIZAR CALIFICACION DEL PROYECTO
    // ========================================================

    final resultado =
        await roble.update(
      'proyecto',
      robleId,
      {
        'calificacion':
            calificacion,
      },
    );

    print(
      '[PROJECT] ✅ Calificación del proyecto actualizada.',
    );

    print(
      '[PROJECT] id_proyecto=$idProyecto '
      '→ calificación=$calificacion',
    );

    // ========================================================
    // ACTUALIZAR ESTADISTICAS DE LOS PARTICIPANTES
    // ========================================================
    //
    // Esto recalcula:
    //
    // - creador
    // - todos los integrantes
    //
    // y actualiza su calificacion_usuario.
    //
    // ========================================================

    print(
      '[PROJECT] Sincronizando estadísticas '
      'de los participantes...',
    );

    final statsService =
        UsuarioStatsService(
      roble: roble,
    );

    await statsService
        .sincronizarPorProyecto(
      idProyecto,
    );

    print(
      '[PROJECT] ✅ Estadísticas de los participantes actualizadas.',
    );

    return Map<String, dynamic>.from(
      resultado,
    );
  }
}
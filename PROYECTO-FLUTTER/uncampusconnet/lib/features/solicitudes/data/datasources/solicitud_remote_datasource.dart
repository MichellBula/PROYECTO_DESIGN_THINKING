import 'package:roble/roble.dart';

import '../../../../core/database/roble_client.dart';
import '../../models/solicitud_model.dart';

class SolicitudRemoteDatasource {
  final RobleApiDataBase roble;

  SolicitudRemoteDatasource({
    RobleApiDataBase? roble,
  }) : roble = roble ?? RobleClient.instance;

  static const int _maxIntentosCrearSolicitud = 5;

  Future<int> _obtenerSiguienteId() async {
    final solicitudes = await roble.read(
      'solicitudes',
    );

    int mayorId = 0;

    for (final solicitud in solicitudes) {
      final id = int.tryParse(
        solicitud['id_solicitud'].toString(),
      );

      if (id != null && id > mayorId) {
        mayorId = id;
      }
    }

    return mayorId + 1;
  }

  Future<bool> _idExiste(
    int idSolicitud,
  ) async {
    final solicitudes = await roble.read(
      'solicitudes',
      filters: {
        'id_solicitud': idSolicitud,
      },
    );

    return solicitudes.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>>
      _buscarSolicitudesExistentes({
    required int idUsuario,
    required int idProyectoRol,
  }) async {
    final solicitudes = await roble.read(
      'solicitudes',
      filters: {
        'id_usuario': idUsuario,
        'id_proyecto_rol': idProyectoRol,
      },
    );

    return solicitudes
        .map(
          (item) => Map<String, dynamic>.from(item),
        )
        .toList();
  }

  Future<Map<String, dynamic>> createSolicitud(
    SolicitudModel solicitud,
  ) async {
    if (solicitud.estado != 'pendiente') {
      throw Exception(
        'Una solicitud nueva debe comenzar en estado pendiente.',
      );
    }

    final existentes =
        await _buscarSolicitudesExistentes(
      idUsuario: solicitud.idUsuario,
      idProyectoRol: solicitud.idProyectoRol,
    );

    final tienePendiente = existentes.any(
      (item) =>
          item['estado']?.toString().toLowerCase() ==
          'pendiente',
    );

    if (tienePendiente) {
      throw Exception(
        'Ya existe una solicitud pendiente para este usuario y este rol.',
      );
    }

    final tieneAceptada = existentes.any(
      (item) =>
          item['estado']?.toString().toLowerCase() ==
          'aceptado',
    );

    if (tieneAceptada) {
      throw Exception(
        'Este usuario ya tiene una solicitud aceptada para este rol.',
      );
    }

    for (
      int intento = 1;
      intento <= _maxIntentosCrearSolicitud;
      intento++
    ) {
      final idSolicitud =
          await _obtenerSiguienteId();

      try {
        final resultado = await roble.create(
          'solicitudes',
          solicitud.toMap(
            idSolicitud: idSolicitud,
          ),
        );

        return Map<String, dynamic>.from(
          resultado,
        );
      } catch (e) {
        final idFueOcupado =
            await _idExiste(idSolicitud);

        if (
          !idFueOcupado ||
          intento == _maxIntentosCrearSolicitud
        ) {
          rethrow;
        }
      }
    }

    throw Exception(
      'No fue posible crear la solicitud.',
    );
  }

  Future<List<Map<String, dynamic>>> getMisSolicitudes(
    int idUsuario,
  ) async {
    final solicitudes = await roble.read(
      'solicitudes',
      filters: {
        'id_usuario': idUsuario,
      },
    );

    return solicitudes
        .map(
          (item) => Map<String, dynamic>.from(item),
        )
        .toList();
  }

  Future<List<Map<String, dynamic>>>
      getSolicitudesPendientesDeMisProyectos(
    int idUsuario,
  ) async {
    final proyectos = await roble.read(
      'proyecto',
      filters: {
        'id_creador': idUsuario,
      },
    );

    final resultado =
        <Map<String, dynamic>>[];

    for (final proyecto in proyectos) {
      final idProyecto = int.tryParse(
        proyecto['id_proyecto'].toString(),
      );

      if (idProyecto == null) {
        continue;
      }

      final solicitudes = await roble.read(
        'solicitudes',
        filters: {
          'id_proyecto': idProyecto,
          'estado': 'pendiente',
        },
      );

      for (final solicitud in solicitudes) {
        resultado.add(
          Map<String, dynamic>.from(
            solicitud,
          ),
        );
      }
    }

    return resultado;
  }

  Future<Map<String, dynamic>?> getSolicitudById(
    int idSolicitud,
  ) async {
    final solicitudes = await roble.read(
      'solicitudes',
      filters: {
        'id_solicitud': idSolicitud,
      },
    );

    if (solicitudes.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(
      solicitudes.first,
    );
  }

  Future<int> getIdUsuarioAutenticado() async {
    final user = await roble.currentUser();

    final userId = user['userId']?.toString();

    if (userId == null || userId.isEmpty) {
      throw Exception(
        'No fue posible obtener el usuario autenticado.',
      );
    }

    final usuarios = await roble.read(
      'usuario',
      filters: {
        'id_autenticador': userId,
      },
    );

    if (usuarios.isEmpty) {
      throw Exception(
        'No existe un perfil de usuario asociado a la cuenta autenticada.',
      );
    }

    final idUsuario = int.tryParse(
      usuarios.first['id_usuario'].toString(),
    );

    if (idUsuario == null) {
      throw Exception(
        'El perfil no tiene un id_usuario válido.',
      );
    }

    return idUsuario;
  }

  Future<int> getIdCreadorDelProyecto(
    int idProyecto,
  ) async {
    final proyectos = await roble.read(
      'proyecto',
      filters: {
        'id_proyecto': idProyecto,
      },
    );

    if (proyectos.isEmpty) {
      throw Exception(
        'No existe el proyecto con id $idProyecto.',
      );
    }

    final idCreador = int.tryParse(
      proyectos.first['id_creador'].toString(),
    );

    if (idCreador == null) {
      throw Exception(
        'El proyecto no tiene un id_creador válido.',
      );
    }

    return idCreador;
  }

  Future<Map<String, dynamic>?> getProyectoRolById(
    int idProyectoRol,
  ) async {
    final resultado = await roble.read(
      'proyecto_roles',
      filters: {
        'id_proyecto_rol': idProyectoRol,
      },
    );

    if (resultado.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(
      resultado.first,
    );
  }

  Future<Map<String, dynamic>> responderSolicitud({
    required int idSolicitud,
    required String nuevoEstado,
  }) async {
    final estado =
        nuevoEstado.toLowerCase().trim();

    if (
      estado != 'aceptado' &&
      estado != 'rechazado'
    ) {
      throw Exception(
        'El estado debe ser aceptado o rechazado.',
      );
    }

    final solicitud =
        await getSolicitudById(
      idSolicitud,
    );

    if (solicitud == null) {
      throw Exception(
        'No existe la solicitud con id $idSolicitud.',
      );
    }

    final estadoActual =
        solicitud['estado']
            ?.toString()
            .toLowerCase();

    if (estadoActual != 'pendiente') {
      throw Exception(
        'Solo se pueden responder solicitudes pendientes.',
      );
    }

    final idProyecto = int.tryParse(
      solicitud['id_proyecto'].toString(),
    );

    if (idProyecto == null) {
      throw Exception(
        'La solicitud no tiene un id_proyecto válido.',
      );
    }

    final idUsuarioAutenticado =
        await getIdUsuarioAutenticado();

    final idCreador =
        await getIdCreadorDelProyecto(
      idProyecto,
    );

    if (idUsuarioAutenticado != idCreador) {
      throw Exception(
        'Solo el creador del proyecto puede responder esta solicitud.',
      );
    }

    final idInternoRoble =
        solicitud['_id']?.toString();

    if (
      idInternoRoble == null ||
      idInternoRoble.isEmpty
    ) {
      throw Exception(
        'La solicitud no tiene un _id válido de Roble.',
      );
    }

    final resultado = await roble.update(
      'solicitudes',
      idInternoRoble,
      {
        'estado': estado,
        'fecha_respuesta':
            DateTime.now()
                .toUtc()
                .toIso8601String(),
      },
    );

    return Map<String, dynamic>.from(
      resultado,
    );
  }
}
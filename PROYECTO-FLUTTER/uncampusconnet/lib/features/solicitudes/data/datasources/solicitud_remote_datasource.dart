import 'package:roble/roble.dart';

import 'package:uncampusconnet/core/database/roble_client.dart';
import 'package:uncampusconnet/features/solicitudes/models/solicitud_model.dart';

class SolicitudRemoteDatasource {
  final RobleApiDataBase roble;

  SolicitudRemoteDatasource({RobleApiDataBase? roble})
    : roble = roble ?? RobleClient.instance;

  static const int _maxIntentosCrearSolicitud = 5;

  // ==========================================================
  // GENERAR SIGUIENTE ID
  // ==========================================================

  Future<int> _obtenerSiguienteId() async {
    final solicitudes = await roble.read('solicitudes');

    int mayorId = 0;

    for (final solicitud in solicitudes) {
      final id = int.tryParse(solicitud['id_solicitud'].toString());

      if (id != null && id > mayorId) {
        mayorId = id;
      }
    }

    return mayorId + 1;
  }

  // ==========================================================
  // COMPROBAR SI EL ID EXISTE
  // ==========================================================

  Future<bool> _idExiste(int idSolicitud) async {
    final solicitudes = await roble.read(
      'solicitudes',
      filters: {'id_solicitud': idSolicitud},
    );

    return solicitudes.isNotEmpty;
  }

  // ==========================================================
  // BUSCAR SOLICITUDES DE USUARIO Y PROYECTO
  // ==========================================================

  Future<List<Map<String, dynamic>>> _buscarSolicitudesExistentes({
    required int idUsuario,
    required int idProyecto,
  }) async {
    final solicitudes = await roble.read(
      'solicitudes',
      filters: {'id_usuario': idUsuario, 'id_proyecto': idProyecto},
    );

    return solicitudes.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  // ==========================================================
  // SABER SI YA TIENE SOLICITUD EN EL PROYECTO
  // ==========================================================

  Future<bool> tieneSolicitudEnProyecto({
    required int idUsuario,
    required int idProyecto,
  }) async {
    final solicitudes = await _buscarSolicitudesExistentes(
      idUsuario: idUsuario,
      idProyecto: idProyecto,
    );

    return solicitudes.isNotEmpty;
  }

  // ==========================================================
  // CREAR SOLICITUD
  // ==========================================================

  Future<Map<String, dynamic>> createSolicitud(SolicitudModel solicitud) async {
    if (solicitud.estado != 'pendiente') {
      throw Exception(
        'Una solicitud nueva debe comenzar '
        'en estado pendiente.',
      );
    }

    print('[SOLICITUD] Iniciando creación de solicitud...');

    print('[SOLICITUD] Proyecto: ${solicitud.idProyecto}');

    print('[SOLICITUD] Usuario recibido: ${solicitud.idUsuario}');

    // ========================================================
    // 1. OBTENER USUARIO AUTENTICADO
    // ========================================================

    final idUsuarioAutenticado = await getIdUsuarioAutenticado();

    print(
      '[SOLICITUD] Usuario autenticado: '
      '$idUsuarioAutenticado',
    );

    if (solicitud.idUsuario != idUsuarioAutenticado) {
      throw Exception(
        'El usuario de la solicitud no coincide '
        'con el usuario autenticado.',
      );
    }

    // ========================================================
    // 2. VERIFICAR QUE NO SEA EL CREADOR
    // ========================================================

    final idCreador = await getIdCreadorDelProyecto(solicitud.idProyecto);

    print('[SOLICITUD] Creador del proyecto: $idCreador');

    if (idCreador == idUsuarioAutenticado) {
      throw Exception(
        'No puedes postularte a un proyecto '
        'que tú mismo creaste.',
      );
    }

    // ========================================================
    // 3. EVITAR SOLICITUDES DUPLICADAS
    // ========================================================

    final existentes = await _buscarSolicitudesExistentes(
      idUsuario: idUsuarioAutenticado,
      idProyecto: solicitud.idProyecto,
    );

    print(
      '[SOLICITUD] Solicitudes existentes para este '
      'usuario/proyecto: ${existentes.length}',
    );

    if (existentes.isNotEmpty) {
      final estados = existentes
          .map(
            (item) =>
                item['estado']?.toString().toLowerCase().trim() ??
                'desconocido',
          )
          .toList();

      print('[SOLICITUD] Estados existentes: $estados');

      throw Exception(
        'Ya te postulaste a este proyecto. '
        'No puedes enviar otra solicitud al mismo proyecto.',
      );
    }

    // ========================================================
    // 4. CREAR SOLICITUD CON REINTENTOS
    // ========================================================

    for (int intento = 1; intento <= _maxIntentosCrearSolicitud; intento++) {
      print(
        '[SOLICITUD] Intento $intento de '
        '$_maxIntentosCrearSolicitud',
      );

      final idSolicitud = await _obtenerSiguienteId();

      print('[SOLICITUD] ID generado: $idSolicitud');

      try {
        final resultado = await roble.create(
          'solicitudes',
          solicitud.toMap(idSolicitud: idSolicitud),
        );

        print('[SOLICITUD] Solicitud creada correctamente.');

        print(
          '[SOLICITUD] comentario guardado: '
          '${resultado['comentario']}',
        );

        return Map<String, dynamic>.from(resultado);
      } catch (e) {
        print('[SOLICITUD] Error creando solicitud: $e');

        final idFueOcupado = await _idExiste(idSolicitud);

        if (!idFueOcupado || intento == _maxIntentosCrearSolicitud) {
          rethrow;
        }

        print(
          '[SOLICITUD] El ID $idSolicitud ya estaba ocupado. '
          'Se intentará nuevamente.',
        );
      }
    }

    throw Exception('No fue posible crear la solicitud.');
  }

  // ==========================================================
  // OBTENER SOLICITUDES DE UN USUARIO
  // ==========================================================
  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  String _texto(dynamic value, {String fallback = 'No disponible'}) {
    final texto = value?.toString().trim() ?? '';
    return texto.isEmpty ? fallback : texto;
  }

  Future<Map<String, dynamic>> _agregarDatosDePresentacion(
    Map<String, dynamic> solicitud,
  ) async {
    final idProyecto = _toInt(solicitud['id_proyecto']);
    final idUsuario = _toInt(solicitud['id_usuario']);
    final idProyectoRol = _toInt(solicitud['id_proyecto_rol']);

    Map<String, dynamic>? proyecto;
    Map<String, dynamic>? usuario;
    Map<String, dynamic>? proyectoRol;
    Map<String, dynamic>? rol;

    // Obtener proyecto.
    if (idProyecto != null) {
      final registros = await roble.read(
        'proyecto',
        filters: {'id_proyecto': idProyecto},
      );

      if (registros.isNotEmpty) {
        proyecto = Map<String, dynamic>.from(registros.first);
      }
    }

    // Obtener perfil del postulante.
    if (idUsuario != null) {
      final registros = await roble.read(
        'usuario',
        filters: {'id_usuario': idUsuario},
      );

      if (registros.isNotEmpty) {
        usuario = Map<String, dynamic>.from(registros.first);
      }
    }

    // Obtener la relación proyecto-rol.
    if (idProyectoRol != null) {
      final registros = await roble.read(
        'proyecto_roles',
        filters: {'id_proyecto_rol': idProyectoRol},
      );

      if (registros.isNotEmpty) {
        proyectoRol = Map<String, dynamic>.from(registros.first);
      }
    }

    // Obtener el nombre del rol a partir de id_rol.
    final idRol = _toInt(proyectoRol?['id_rol']);

    if (idRol != null) {
      final registros = await roble.read('rol', filters: {'id_rol': idRol});

      if (registros.isNotEmpty) {
        rol = Map<String, dynamic>.from(registros.first);
      }
    }

    final semestreRaw = usuario?['semestre']?.toString().trim() ?? '';

    final semestre = semestreRaw.isEmpty
        ? 'No disponible'
        : '$semestreRaw semestre';

    // Conservamos todos los campos originales de la solicitud
    // y añadimos los que necesita la interfaz.
    return {
      ...solicitud,
      'nombre_proyecto': _texto(
        proyecto?['nombre'],
        fallback: 'Proyecto no disponible',
      ),
      'nombre_usuario': _texto(
        usuario?['nombre_usuario'],
        fallback: 'Usuario no disponible',
      ),
      'correo_institucional': _texto(
        usuario?['correo_institucional'],
        fallback: '',
      ),
      'carrera': _texto(usuario?['carrera']),
      'semestre_presentacion': semestre,
      'nombre_rol': _texto(rol?['nombre_rol'], fallback: 'Rol no disponible'),
    };
  }

  Future<List<Map<String, dynamic>>> getMisSolicitudes(int idUsuario) async {
    final solicitudes = await roble.read(
      'solicitudes',
      filters: {'id_usuario': idUsuario},
    );

    final resultado = <Map<String, dynamic>>[];

    for (final item in solicitudes) {
      final enriquecida = await _agregarDatosDePresentacion(
        Map<String, dynamic>.from(item),
      );

      resultado.add(enriquecida);
    }

    return resultado;
  }
  // ==========================================================
  // OBTENER SOLICITUDES PENDIENTES DE MIS PROYECTOS
  // ==========================================================

  Future<List<Map<String, dynamic>>> getSolicitudesPendientesDeMisProyectos(
    int idUsuario,
  ) async {
    final proyectos = await roble.read(
      'proyecto',
      filters: {'id_creador': idUsuario},
    );

    final resultado = <Map<String, dynamic>>[];

    for (final proyecto in proyectos) {
      final idProyecto = _toInt(proyecto['id_proyecto']);

      if (idProyecto == null) {
        continue;
      }

      final solicitudes = await roble.read(
        'solicitudes',
        filters: {'id_proyecto': idProyecto, 'estado': 'pendiente'},
      );

      for (final item in solicitudes) {
        final enriquecida = await _agregarDatosDePresentacion(
          Map<String, dynamic>.from(item),
        );

        resultado.add(enriquecida);
      }
    }

    return resultado;
  }

  // ==========================================================
  // OBTENER SOLICITUD POR ID
  // ==========================================================

  Future<Map<String, dynamic>?> getSolicitudById(int idSolicitud) async {
    final solicitudes = await roble.read(
      'solicitudes',
      filters: {'id_solicitud': idSolicitud},
    );

    if (solicitudes.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(solicitudes.first);
  }

  // ==========================================================
  // OBTENER ID DEL USUARIO AUTENTICADO
  // ==========================================================

  Future<int> getIdUsuarioAutenticado() async {
    final user = await roble.currentUser();

    final userId = user['userId']?.toString();

    if (userId == null || userId.isEmpty) {
      throw Exception('No fue posible obtener el usuario autenticado.');
    }

    final usuarios = await roble.read(
      'usuario',
      filters: {'id_autenticador': userId},
    );

    if (usuarios.isEmpty) {
      throw Exception(
        'No existe un perfil de usuario asociado '
        'a la cuenta autenticada.',
      );
    }

    final idUsuario = int.tryParse(usuarios.first['id_usuario'].toString());

    if (idUsuario == null) {
      throw Exception('El perfil no tiene un id_usuario válido.');
    }

    return idUsuario;
  }

  // ==========================================================
  // OBTENER CREADOR DEL PROYECTO
  // ==========================================================

  Future<int> getIdCreadorDelProyecto(int idProyecto) async {
    final proyectos = await roble.read(
      'proyecto',
      filters: {'id_proyecto': idProyecto},
    );

    if (proyectos.isEmpty) {
      throw Exception('No existe el proyecto con id $idProyecto.');
    }

    final idCreador = int.tryParse(proyectos.first['id_creador'].toString());

    if (idCreador == null) {
      throw Exception('El proyecto no tiene un id_creador válido.');
    }

    return idCreador;
  }

  // ==========================================================
  // OBTENER PROYECTO_ROL
  // ==========================================================

  Future<Map<String, dynamic>?> getProyectoRolById(int idProyectoRol) async {
    final resultado = await roble.read(
      'proyecto_roles',
      filters: {'id_proyecto_rol': idProyectoRol},
    );

    if (resultado.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(resultado.first);
  }

  // ==========================================================
  // RESPONDER SOLICITUD
  // ==========================================================

  Future<Map<String, dynamic>> responderSolicitud({
    required int idSolicitud,
    required String nuevoEstado,
  }) async {
    final estado = nuevoEstado.toLowerCase().trim();

    if (estado != 'aceptado' && estado != 'rechazado') {
      throw Exception('El estado debe ser aceptado o rechazado.');
    }

    final solicitud = await getSolicitudById(idSolicitud);

    if (solicitud == null) {
      throw Exception('No existe la solicitud con id $idSolicitud.');
    }

    final estadoActual = solicitud['estado']?.toString().toLowerCase().trim();

    if (estadoActual != 'pendiente') {
      throw Exception('Solo se pueden responder solicitudes pendientes.');
    }

    final idProyecto = int.tryParse(solicitud['id_proyecto'].toString());

    if (idProyecto == null) {
      throw Exception('La solicitud no tiene un id_proyecto válido.');
    }

    // Verificar que el usuario autenticado
    // sea el creador del proyecto.
    final idUsuarioAutenticado = await getIdUsuarioAutenticado();

    final idCreador = await getIdCreadorDelProyecto(idProyecto);

    if (idUsuarioAutenticado != idCreador) {
      throw Exception(
        'Solo el creador del proyecto puede '
        'responder esta solicitud.',
      );
    }

    final idInternoRoble = solicitud['_id']?.toString();

    if (idInternoRoble == null || idInternoRoble.isEmpty) {
      throw Exception('La solicitud no tiene un _id válido de Roble.');
    }

    final resultado = await roble.update('solicitudes', idInternoRoble, {
      'estado': estado,
      'fecha_respuesta': DateTime.now().toUtc().toIso8601String(),
    });

    return Map<String, dynamic>.from(resultado);
  }
}

import 'package:roble/roble.dart';

import '../../../../core/database/roble_client.dart';
import '../../models/avance_model.dart';

class AvanceRemoteDatasource {
  final RobleApiDataBase roble;

  AvanceRemoteDatasource({
    RobleApiDataBase? roble,
  }) : roble = roble ?? RobleClient.instance;

  static const int _maxIntentosCrearAvance = 5;

  static const int _maxAvancesPorEtapa = 5;
  static const int _porcentajePorAvance = 20;

  // ==========================================================
  // GENERAR SIGUIENTE ID
  // ==========================================================

  Future<int> _obtenerSiguienteId() async {
    final registros = await roble.read(
      'avance',
    );

    int mayorId = 0;

    for (final registro in registros) {
      final id = int.tryParse(
        registro['id_avance'].toString(),
      );

      if (id != null && id > mayorId) {
        mayorId = id;
      }
    }

    return mayorId + 1;
  }

  // ==========================================================
  // BUSCAR AVANCE POR ID
  // ==========================================================

  Future<Map<String, dynamic>?> _buscarAvancePorId(
    int idAvance,
  ) async {
    final registros = await roble.read(
      'avance',
      filters: {
        'id_avance': idAvance,
      },
    );

    if (registros.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(
      registros.first,
    );
  }

  // ==========================================================
  // COMPROBAR SI EL ID EXISTE
  // ==========================================================

  Future<bool> _idExiste(
    int idAvance,
  ) async {
    final registro = await _buscarAvancePorId(
      idAvance,
    );

    return registro != null;
  }

  // ==========================================================
  // COMPROBAR SI EL REGISTRO RECUPERADO COINCIDE
  // ==========================================================

  bool _avanceCoincide(
    Map<String, dynamic> existente,
    Map<String, dynamic> data,
  ) {
    return existente['id_etapa']?.toString() ==
            data['id_etapa']?.toString() &&
        existente['comentario']?.toString() ==
            data['comentario']?.toString();
  }

  // ==========================================================
  // OBTENER USUARIO AUTENTICADO
  // ==========================================================

  Future<int> _obtenerIdUsuarioAutenticado() async {
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
        'La cuenta autenticada no tiene un perfil registrado.',
      );
    }

    final idUsuario = int.tryParse(
      usuarios.first['id_usuario'].toString(),
    );

    if (idUsuario == null) {
      throw Exception(
        'El perfil del usuario no tiene un id_usuario válido.',
      );
    }

    return idUsuario;
  }

  // ==========================================================
  // OBTENER ETAPA
  // ==========================================================

  Future<Map<String, dynamic>> _obtenerEtapa(
    int idEtapa,
  ) async {
    final etapas = await roble.read(
      'etapa_proyecto',
      filters: {
        'id_etapa': idEtapa,
      },
    );

    if (etapas.isEmpty) {
      throw Exception(
        'No existe la etapa con id $idEtapa.',
      );
    }

    return Map<String, dynamic>.from(
      etapas.first,
    );
  }

  // ==========================================================
  // OBTENER PROYECTO DE LA ETAPA
  // ==========================================================

  Future<Map<String, dynamic>> _obtenerProyectoDeEtapa(
    int idEtapa,
  ) async {
    final etapa = await _obtenerEtapa(
      idEtapa,
    );

    final idProyecto = int.tryParse(
      etapa['id_proyecto'].toString(),
    );

    if (idProyecto == null) {
      throw Exception(
        'La etapa no tiene un id_proyecto válido.',
      );
    }

    final proyectos = await roble.read(
      'proyecto',
      filters: {
        'id_proyecto': idProyecto,
      },
    );

    if (proyectos.isEmpty) {
      throw Exception(
        'No existe el proyecto asociado a la etapa.',
      );
    }

    return Map<String, dynamic>.from(
      proyectos.first,
    );
  }

  // ==========================================================
  // VALIDAR PERTENENCIA AL PROYECTO
  // ==========================================================

  Future<void> _verificarPertenenciaAlProyecto(
    int idEtapa,
  ) async {
    final proyecto = await _obtenerProyectoDeEtapa(
      idEtapa,
    );

    final idProyecto = int.parse(
      proyecto['id_proyecto'].toString(),
    );

    final idCreador = int.tryParse(
      proyecto['id_creador'].toString(),
    );

    if (idCreador == null) {
      throw Exception(
        'El proyecto no tiene un id_creador válido.',
      );
    }

    final idUsuario =
        await _obtenerIdUsuarioAutenticado();

    // El creador pertenece al proyecto aunque
    // no tenga una relación propia en integrantes.
    if (idUsuario == idCreador) {
      return;
    }

    // Comprobar si el usuario es integrante.
    final integrantes = await roble.read(
      'integrantes',
      filters: {
        'id_usuario': idUsuario,
        'id_proyecto': idProyecto,
      },
    );

    if (integrantes.isEmpty) {
      throw Exception(
        'Solo los usuarios que pertenecen al proyecto '
        'pueden registrar avances.',
      );
    }
  }

  // ==========================================================
  // CONSULTAR AVANCES DE UNA ETAPA
  // ==========================================================

  Future<List<Map<String, dynamic>>> getAvancesByEtapa(
    int idEtapa,
  ) async {
    await _obtenerEtapa(
      idEtapa,
    );

    final registros = await roble.read(
      'avance',
      filters: {
        'id_etapa': idEtapa,
      },
    );

    final avances = registros
        .map(
          (item) => Map<String, dynamic>.from(
            item,
          ),
        )
        .toList();

    // Ordenar cronológicamente.
    avances.sort((a, b) {
      final fechaA = _parsearFecha(
        a['fecha'],
      );

      final fechaB = _parsearFecha(
        b['fecha'],
      );

      return fechaA.compareTo(fechaB);
    });

    return avances;
  }

  // ==========================================================
  // CONSULTAR AVANCES DE UN PROYECTO
  // ==========================================================

  Future<List<Map<String, dynamic>>> getAvancesByProject(
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

    final etapas = await roble.read(
      'etapa_proyecto',
      filters: {
        'id_proyecto': idProyecto,
      },
    );

    final List<Map<String, dynamic>> resultado = [];

    for (final etapa in etapas) {
      final idEtapa = int.tryParse(
        etapa['id_etapa'].toString(),
      );

      if (idEtapa == null) {
        continue;
      }

      final avancesEtapa = await getAvancesByEtapa(
        idEtapa,
      );

      resultado.addAll(
        avancesEtapa,
      );
    }

    return resultado;
  }

  // ==========================================================
  // CONSULTAR AVANCE POR ID
  // ==========================================================

  Future<Map<String, dynamic>?> getAvanceById(
    int idAvance,
  ) async {
    return _buscarAvancePorId(
      idAvance,
    );
  }

  // ==========================================================
  // CALCULAR PORCENTAJE DE UNA ETAPA
  // ==========================================================

  Future<int> getPorcentajeByEtapa(
    int idEtapa,
  ) async {
    final avances = await getAvancesByEtapa(
      idEtapa,
    );

    final porcentaje =
        avances.length * _porcentajePorAvance;

    return porcentaje.clamp(0, 100);
  }

  // ==========================================================
  // CREAR AVANCE
  // ==========================================================

  Future<Map<String, dynamic>> createAvance(
    AvanceModel avance,
  ) async {
    final comentario = avance.comentario.trim();

    if (comentario.isEmpty) {
      throw Exception(
        'El comentario del avance no puede estar vacío.',
      );
    }

    if (avance.idEtapa <= 0) {
      throw Exception(
        'El id_etapa debe ser válido.',
      );
    }

    // --------------------------------------------------------
    // VALIDAR QUE EL USUARIO PERTENEZCA AL PROYECTO
    // --------------------------------------------------------

    await _verificarPertenenciaAlProyecto(
      avance.idEtapa,
    );

    // --------------------------------------------------------
    // CONSULTAR AVANCES EXISTENTES
    // --------------------------------------------------------

    final avancesExistentes = await getAvancesByEtapa(
      avance.idEtapa,
    );

    if (avancesExistentes.length >=
        _maxAvancesPorEtapa) {
      throw Exception(
        'Esta etapa ya tiene 5 avances y alcanzó el 100%. '
        'No se pueden registrar más avances.',
      );
    }

    final modelo = AvanceModel(
      idEtapa: avance.idEtapa,
      comentario: comentario,
      fecha: avance.fecha,
    );

    // --------------------------------------------------------
    // CREAR CON REINTENTOS
    // --------------------------------------------------------

    for (
      int intento = 1;
      intento <= _maxIntentosCrearAvance;
      intento++
    ) {
      final idAvance = await _obtenerSiguienteId();

      final payload = modelo.toMap(
        idAvance: idAvance,
      );

      try {
        final resultado = await roble.create(
          'avance',
          payload,
        );

        print(
          '[AVANCE] ✅ Avance creado correctamente.',
        );

        print(
          '[AVANCE] id_avance: '
          '${resultado['id_avance']}',
        );

        print(
          '[AVANCE] id_etapa: '
          '${resultado['id_etapa']}',
        );

        print(
          '[AVANCE] porcentaje de etapa después del registro: '
          '${(avancesExistentes.length + 1) * 20}%',
        );

        return Map<String, dynamic>.from(
          resultado,
        );
      } catch (e) {
        print(
          '[AVANCE] Error en intento $intento: $e',
        );

        final existente = await _buscarAvancePorId(
          idAvance,
        );

        if (existente != null) {
          if (_avanceCoincide(
            existente,
            payload,
          )) {
            print(
              '[AVANCE] El registro ya existía '
              'y coincide con la petición.',
            );

            return existente;
          }

          // El identificador ya pertenece a otro avance.
          continue;
        }

        rethrow;
      }
    }

    throw Exception(
      'No fue posible crear el avance.',
    );
  }

  // ==========================================================
  // PARSEAR FECHA
  // ==========================================================

  DateTime _parsearFecha(
    dynamic valor,
  ) {
    if (valor is DateTime) {
      return valor;
    }

    if (valor is int) {
      return DateTime.fromMillisecondsSinceEpoch(
        valor,
      );
    }

    return DateTime.tryParse(
          valor?.toString() ?? '',
        ) ??
        DateTime.fromMillisecondsSinceEpoch(0);
  }
}
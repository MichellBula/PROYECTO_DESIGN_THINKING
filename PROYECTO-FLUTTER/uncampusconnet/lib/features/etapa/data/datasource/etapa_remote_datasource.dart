import 'package:roble/roble.dart';

import '../../../../core/database/roble_client.dart';
import '../../models/etapa_model.dart';

class EtapaRemoteDatasource {
  final RobleApiDataBase roble;

  EtapaRemoteDatasource({
    RobleApiDataBase? roble,
  }) : roble = roble ?? RobleClient.instance;

  static const int _maxIntentosCrearEtapa = 5;

  // ==========================================================
  // OBTENER SIGUIENTE ID
  // ==========================================================

  Future<int> _obtenerSiguienteId() async {
    final etapas = await roble.read(
      'etapa_proyecto',
    );

    int mayorId = 0;

    for (final etapa in etapas) {
      final id = int.tryParse(
        etapa['id_etapa'].toString(),
      );

      if (id != null && id > mayorId) {
        mayorId = id;
      }
    }

    return mayorId + 1;
  }

  // ==========================================================
  // BUSCAR ETAPA POR ID
  // ==========================================================

  Future<Map<String, dynamic>?> _buscarEtapaPorId(
    int idEtapa,
  ) async {
    final etapas = await roble.read(
      'etapa_proyecto',
      filters: {
        'id_etapa': idEtapa,
      },
    );

    if (etapas.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(
      etapas.first,
    );
  }

  // ==========================================================
  // COMPROBAR SI EL ID EXISTE
  // ==========================================================

  Future<bool> _idExiste(
    int idEtapa,
  ) async {
    final etapa = await _buscarEtapaPorId(
      idEtapa,
    );

    return etapa != null;
  }

  // ==========================================================
  // COMPROBAR SI EL REGISTRO RECUPERADO COINCIDE
  // ==========================================================

  bool _etapaCoincide(
    Map<String, dynamic> etapa,
    Map<String, dynamic> data,
  ) {
    return etapa['id_proyecto']?.toString() ==
            data['id_proyecto']?.toString() &&
        etapa['nombre_etapa']?.toString() ==
            data['nombre_etapa']?.toString() &&
        etapa['orden']?.toString() ==
            data['orden']?.toString();
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
        'El perfil no tiene un id_usuario válido.',
      );
    }

    return idUsuario;
  }

  // ==========================================================
  // OBTENER PROYECTO
  // ==========================================================

  Future<Map<String, dynamic>> _obtenerProyecto(
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

    return Map<String, dynamic>.from(
      proyectos.first,
    );
  }

  // ==========================================================
  // VALIDAR QUE EL USUARIO SEA EL CREADOR
  // ==========================================================

  Future<void> _verificarCreador(
    int idProyecto,
  ) async {
    final proyecto = await _obtenerProyecto(
      idProyecto,
    );

    final idCreador = int.tryParse(
      proyecto['id_creador'].toString(),
    );

    if (idCreador == null) {
      throw Exception(
        'El proyecto no tiene un id_creador válido.',
      );
    }

    final idUsuarioAutenticado =
        await _obtenerIdUsuarioAutenticado();

    if (idUsuarioAutenticado != idCreador) {
      throw Exception(
        'Solo el creador del proyecto puede crear sus etapas.',
      );
    }
  }

  // ==========================================================
  // VALIDAR NOMBRE Y ORDEN DENTRO DEL PROYECTO
  // ==========================================================

  Future<void> _validarNombreYOrden(
    EtapaModel etapa,
  ) async {
    final etapas = await roble.read(
      'etapa_proyecto',
      filters: {
        'id_proyecto': etapa.idProyecto,
      },
    );

    final nombreBuscado =
        etapa.nombreEtapa.trim().toLowerCase();

    for (final existente in etapas) {
      final nombreExistente =
          existente['nombre_etapa']
                  ?.toString()
                  .trim()
                  .toLowerCase() ??
              '';

      final ordenExistente = int.tryParse(
        existente['orden'].toString(),
      );

      if (nombreExistente == nombreBuscado) {
        throw Exception(
          'Ya existe una etapa con ese nombre en este proyecto.',
        );
      }

      if (ordenExistente == etapa.orden) {
        throw Exception(
          'Ya existe una etapa con ese orden en este proyecto.',
        );
      }
    }
  }

  // ==========================================================
  // CREAR ETAPA
  // ==========================================================

  Future<Map<String, dynamic>> createEtapa(
    EtapaModel etapa,
  ) async {
    final nombre = etapa.nombreEtapa.trim();

    if (nombre.isEmpty) {
      throw Exception(
        'El nombre de la etapa no puede estar vacío.',
      );
    }

    if (etapa.orden < 1) {
      throw Exception(
        'El orden de la etapa debe ser mayor que cero.',
      );
    }

    // Validar proyecto y creador.
    await _verificarCreador(
      etapa.idProyecto,
    );

    // Validar que el proyecto no tenga
    // otra etapa con el mismo nombre u orden.
    await _validarNombreYOrden(
      etapa,
    );

    final modelo = EtapaModel(
      idProyecto: etapa.idProyecto,
      nombreEtapa: nombre,
      orden: etapa.orden,
    );

    for (
      int intento = 1;
      intento <= _maxIntentosCrearEtapa;
      intento++
    ) {
      final idEtapa = await _obtenerSiguienteId();

      final payload = modelo.toMap(
        idEtapa: idEtapa,
      );

      try {
        final resultado = await roble.create(
          'etapa_proyecto',
          payload,
        );

        print(
          '[ETAPA] Etapa creada correctamente.',
        );

        print(
          '[ETAPA] id_etapa: '
          '${resultado['id_etapa']}',
        );

        print(
          '[ETAPA] id_proyecto: '
          '${resultado['id_proyecto']}',
        );

        print(
          '[ETAPA] nombre_etapa: '
          '${resultado['nombre_etapa']}',
        );

        print(
          '[ETAPA] orden: '
          '${resultado['orden']}',
        );

        return Map<String, dynamic>.from(
          resultado,
        );
      } catch (e) {
        print(
          '[ETAPA] Error en intento $intento: $e',
        );

        // Si Roble creó el registro pero falló
        // la respuesta, lo recuperamos.
        final existente = await _buscarEtapaPorId(
          idEtapa,
        );

        if (existente != null) {
          if (_etapaCoincide(
            existente,
            payload,
          )) {
            print(
              '[ETAPA] El registro ya existía '
              'y coincide con la petición.',
            );

            return existente;
          }

          // El identificador ya pertenece
          // a otra etapa. Reintentamos.
          continue;
        }

        rethrow;
      }
    }

    throw Exception(
      'No fue posible crear la etapa.',
    );
  }

  // ==========================================================
  // CONSULTAR ETAPA POR ID
  // ==========================================================

  Future<Map<String, dynamic>?> getEtapaById(
    int idEtapa,
  ) async {
    return _buscarEtapaPorId(
      idEtapa,
    );
  }

  // ==========================================================
  // CONSULTAR ETAPAS DE UN PROYECTO
  // ==========================================================

  Future<List<Map<String, dynamic>>> getEtapasByProject(
    int idProyecto,
  ) async {
    // Comprobar que el proyecto exista.
    await _obtenerProyecto(
      idProyecto,
    );

    final registros = await roble.read(
      'etapa_proyecto',
      filters: {
        'id_proyecto': idProyecto,
      },
    );

    final etapas = registros
        .map(
          (item) => Map<String, dynamic>.from(
            item,
          ),
        )
        .toList();

    // Ordenar por el campo "orden".
    etapas.sort((a, b) {
      final ordenA = int.tryParse(
            a['orden'].toString(),
          ) ??
          0;

      final ordenB = int.tryParse(
            b['orden'].toString(),
          ) ??
          0;

      if (ordenA != ordenB) {
        return ordenA.compareTo(ordenB);
      }

      final idA = int.tryParse(
            a['id_etapa'].toString(),
          ) ??
          0;

      final idB = int.tryParse(
            b['id_etapa'].toString(),
          ) ??
          0;

      return idA.compareTo(idB);
    });

    return etapas;
  }
}
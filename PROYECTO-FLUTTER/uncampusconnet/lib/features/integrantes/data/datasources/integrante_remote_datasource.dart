import 'package:roble/roble.dart';

import '../../../../core/database/roble_client.dart';
import '../../models/integrante_model.dart';

class IntegranteRemoteDatasource {
  final RobleApiDataBase roble;

  IntegranteRemoteDatasource({
    RobleApiDataBase? roble,
  }) : roble = roble ?? RobleClient.instance;

  static const int _maxIntentosCrearIntegrante = 5;

  Future<int> _obtenerSiguienteId() async {
    final integrantes = await roble.read(
      'integrantes',
    );

    int mayorId = 0;

    for (final integrante in integrantes) {
      final id = int.tryParse(
        integrante['id_usuario_integrante'].toString(),
      );

      if (id != null && id > mayorId) {
        mayorId = id;
      }
    }

    return mayorId + 1;
  }

  Future<bool> _idExiste(
    int idUsuarioIntegrante,
  ) async {
    final integrantes = await roble.read(
      'integrantes',
      filters: {
        'id_usuario_integrante':
            idUsuarioIntegrante,
      },
    );

    return integrantes.isNotEmpty;
  }

  Future<Map<String, dynamic>?> _buscarIntegranteExistente({
    required int idUsuario,
    required int idProyecto,
  }) async {
    final integrantes = await roble.read(
      'integrantes',
      filters: {
        'id_usuario': idUsuario,
        'id_proyecto': idProyecto,
      },
    );

    if (integrantes.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(
      integrantes.first,
    );
  }

  Future<Map<String, dynamic>> createIntegrante(
    IntegranteModel integrante,
  ) async {
    final existente =
        await _buscarIntegranteExistente(
      idUsuario: integrante.idUsuario,
      idProyecto: integrante.idProyecto,
    );

    if (existente != null) {
      throw Exception(
        'El usuario ya es integrante de este proyecto.',
      );
    }

    for (
      int intento = 1;
      intento <= _maxIntentosCrearIntegrante;
      intento++
    ) {
      final idUsuarioIntegrante =
          await _obtenerSiguienteId();

      try {
        final resultado = await roble.create(
          'integrantes',
          integrante.toMap(
            idUsuarioIntegrante:
                idUsuarioIntegrante,
          ),
        );

        return Map<String, dynamic>.from(
          resultado,
        );
      } catch (e) {
        final idFueOcupado =
            await _idExiste(
          idUsuarioIntegrante,
        );

        if (
          !idFueOcupado ||
          intento == _maxIntentosCrearIntegrante
        ) {
          rethrow;
        }
      }
    }

    throw Exception(
      'No fue posible crear el integrante.',
    );
  }

  Future<List<Map<String, dynamic>>>
      getIntegrantesByProject(
    int idProyecto,
  ) async {
    final integrantes = await roble.read(
      'integrantes',
      filters: {
        'id_proyecto': idProyecto,
      },
    );

    return integrantes
        .map(
          (item) => Map<String, dynamic>.from(item),
        )
        .toList();
  }

  Future<Map<String, dynamic>?>
      getIntegranteByUserAndProject({
    required int idUsuario,
    required int idProyecto,
  }) async {
    return _buscarIntegranteExistente(
      idUsuario: idUsuario,
      idProyecto: idProyecto,
    );
  }
}
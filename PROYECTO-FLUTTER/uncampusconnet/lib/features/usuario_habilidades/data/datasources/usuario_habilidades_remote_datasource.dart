import 'package:roble/roble.dart';

import '../../../../core/database/roble_client.dart';
import '../../models/usuario_habilidad_model.dart';

class UsuarioHabilidadesRemoteDatasource {
  final RobleApiDataBase roble;

  UsuarioHabilidadesRemoteDatasource({
    RobleApiDataBase? roble,
  }) : roble = roble ?? RobleClient.instance;

  static const int _maxIntentosCrearRelacion = 5;

  Future<int> _obtenerSiguienteId() async {
    final relaciones = await roble.read(
      'usuario_habilidades',
    );

    int mayorId = 0;

    for (final relacion in relaciones) {
      final id = int.tryParse(
        relacion['id_usuario_habilidades'].toString(),
      );

      if (id != null && id > mayorId) {
        mayorId = id;
      }
    }

    return mayorId + 1;
  }

  Future<bool> _idExiste(
    int idUsuarioHabilidades,
  ) async {
    final relaciones = await roble.read(
      'usuario_habilidades',
      filters: {
        'id_usuario_habilidades':
            idUsuarioHabilidades,
      },
    );

    return relaciones.isNotEmpty;
  }

  Future<Map<String, dynamic>?>
      _buscarRelacionExistente({
    required int idUsuario,
    required int idHabilidad,
  }) async {
    final relaciones = await roble.read(
      'usuario_habilidades',
      filters: {
        'id_usuario': idUsuario,
        'id_habilidad': idHabilidad,
      },
    );

    if (relaciones.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(
      relaciones.first,
    );
  }

  Future<Map<String, dynamic>>
      createUsuarioHabilidad(
    UsuarioHabilidadModel usuarioHabilidad,
  ) async {
    final existente =
        await _buscarRelacionExistente(
      idUsuario: usuarioHabilidad.idUsuario,
      idHabilidad:
          usuarioHabilidad.idHabilidad,
    );

    if (existente != null) {
      return existente;
    }

    for (
      int intento = 1;
      intento <= _maxIntentosCrearRelacion;
      intento++
    ) {
      final idUsuarioHabilidades =
          await _obtenerSiguienteId();

      try {
        final resultado = await roble.create(
          'usuario_habilidades',
          usuarioHabilidad.toMap(
            idUsuarioHabilidades:
                idUsuarioHabilidades,
          ),
        );

        return Map<String, dynamic>.from(
          resultado,
        );
      } catch (e) {
        final idFueOcupado =
            await _idExiste(
          idUsuarioHabilidades,
        );

        if (
          !idFueOcupado ||
          intento ==
              _maxIntentosCrearRelacion
        ) {
          rethrow;
        }
      }
    }

    throw Exception(
      'No fue posible crear la relación usuario-habilidad.',
    );
  }

  Future<List<Map<String, dynamic>>>
      getHabilidadesByUser(
    int idUsuario,
  ) async {
    final relaciones = await roble.read(
      'usuario_habilidades',
      filters: {
        'id_usuario': idUsuario,
      },
    );

    return relaciones
        .map(
          (item) => Map<String, dynamic>.from(item),
        )
        .toList();
  }

  Future<Map<String, dynamic>?>
      getUsuarioHabilidadByUserAndSkill({
    required int idUsuario,
    required int idHabilidad,
  }) async {
    return _buscarRelacionExistente(
      idUsuario: idUsuario,
      idHabilidad: idHabilidad,
    );
  }
}
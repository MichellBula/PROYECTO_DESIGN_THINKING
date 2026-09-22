import 'package:roble/roble.dart';

import '../../../../core/database/roble_client.dart';
import '../../models/publicacion_like_model.dart';

class PublicacionLikesRemoteDatasource {
  final RobleApiDataBase roble;

  PublicacionLikesRemoteDatasource({
    RobleApiDataBase? roble,
  }) : roble = roble ?? RobleClient.instance;

  static const int _maxIntentosCrearLike = 5;

  Future<int> _obtenerSiguienteId() async {
    final likes = await roble.read(
      'publicacion_likes',
    );

    int mayorId = 0;

    for (final like in likes) {
      final id = int.tryParse(
        like['id_publicacion_likes'].toString(),
      );

      if (id != null && id > mayorId) {
        mayorId = id;
      }
    }

    return mayorId + 1;
  }

  Future<bool> _idExiste(
    int idPublicacionLikes,
  ) async {
    final likes = await roble.read(
      'publicacion_likes',
      filters: {
        'id_publicacion_likes':
            idPublicacionLikes,
      },
    );

    return likes.isNotEmpty;
  }

  Future<Map<String, dynamic>?> _buscarLikeExistente({
    required int idUsuario,
    required int idPublicacion,
  }) async {
    final likes = await roble.read(
      'publicacion_likes',
      filters: {
        'id_usuario': idUsuario,
        'id_publicacion': idPublicacion,
      },
    );

    if (likes.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(
      likes.first,
    );
  }

  Future<Map<String, dynamic>> createPublicacionLike(
    PublicacionLikeModel like,
  ) async {
    // -------------------------------------------------------
    // Verificar usuario
    // -------------------------------------------------------

    final usuario = await roble.read(
      'usuario',
      filters: {
        'id_usuario': like.idUsuario,
      },
    );

    if (usuario.isEmpty) {
      throw Exception(
        'No existe el usuario ${like.idUsuario}.',
      );
    }

    // -------------------------------------------------------
    // Verificar publicación
    // -------------------------------------------------------

    final publicacion = await roble.read(
      'publicacion',
      filters: {
        'id_publicacion': like.idPublicacion,
      },
    );

    if (publicacion.isEmpty) {
      throw Exception(
        'No existe la publicación ${like.idPublicacion}.',
      );
    }

    // -------------------------------------------------------
    // Evitar like duplicado
    // -------------------------------------------------------

    final existente =
        await _buscarLikeExistente(
      idUsuario: like.idUsuario,
      idPublicacion: like.idPublicacion,
    );

    if (existente != null) {
      throw Exception(
        'El usuario ya dio like a esta publicación.',
      );
    }

    // -------------------------------------------------------
    // Crear like
    // -------------------------------------------------------

    for (
      int intento = 1;
      intento <= _maxIntentosCrearLike;
      intento++
    ) {
      final idPublicacionLikes =
          await _obtenerSiguienteId();

      try {
        final resultado = await roble.create(
          'publicacion_likes',
          like.toMap(
            idPublicacionLikes:
                idPublicacionLikes,
          ),
        );

        return Map<String, dynamic>.from(
          resultado,
        );
      } catch (e) {
        final idFueOcupado =
            await _idExiste(
          idPublicacionLikes,
        );

        if (
          !idFueOcupado ||
          intento == _maxIntentosCrearLike
        ) {
          rethrow;
        }
      }
    }

    throw Exception(
      'No fue posible crear el like.',
    );
  }

  Future<List<Map<String, dynamic>>>
      getLikesByPublicacion(
    int idPublicacion,
  ) async {
    final likes = await roble.read(
      'publicacion_likes',
      filters: {
        'id_publicacion': idPublicacion,
      },
    );

    return likes
        .map(
          (item) => Map<String, dynamic>.from(
            item,
          ),
        )
        .toList();
  }

  Future<Map<String, dynamic>?>
      getPublicacionLikeByUserAndPublicacion({
    required int idUsuario,
    required int idPublicacion,
  }) async {
    return _buscarLikeExistente(
      idUsuario: idUsuario,
      idPublicacion: idPublicacion,
    );
  }
}
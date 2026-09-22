import 'package:roble/roble.dart';

import '../../../../core/database/roble_client.dart';
import '../../models/comentario_model.dart';

class ComentarioRemoteDatasource {
  final RobleApiDataBase roble;

  ComentarioRemoteDatasource({
    RobleApiDataBase? roble,
  }) : roble = roble ?? RobleClient.instance;

  static const int _maxIntentosCrearComentario = 5;

  Future<int> _obtenerSiguienteId() async {
    final comentarios = await roble.read(
      'comentario',
    );

    int mayorId = 0;

    for (final comentario in comentarios) {
      final id = int.tryParse(
        comentario['id_comentario'].toString(),
      );

      if (id != null && id > mayorId) {
        mayorId = id;
      }
    }

    return mayorId + 1;
  }

  Future<bool> _idExiste(
    int idComentario,
  ) async {
    final comentarios = await roble.read(
      'comentario',
      filters: {
        'id_comentario': idComentario,
      },
    );

    return comentarios.isNotEmpty;
  }

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
        'No existe un perfil de usuario asociado a la cuenta autenticada.',
      );
    }

    final idUsuario = int.tryParse(
      usuarios.first['id_usuario'].toString(),
    );

    if (idUsuario == null) {
      throw Exception(
        'El perfil de usuario no tiene un id_usuario válido.',
      );
    }

    return idUsuario;
  }

  Future<void> _verificarPublicacion(
    int idPublicacion,
  ) async {
    final publicaciones = await roble.read(
      'publicacion',
      filters: {
        'id_publicacion': idPublicacion,
      },
    );

    if (publicaciones.isEmpty) {
      throw Exception(
        'No existe la publicación $idPublicacion.',
      );
    }
  }

  Future<Map<String, dynamic>> createComentario(
    ComentarioModel comentario,
  ) async {
    if (comentario.contenido.trim().isEmpty) {
      throw Exception(
        'El contenido del comentario no puede estar vacío.',
      );
    }

    // Verificar que exista la publicación.
    await _verificarPublicacion(
      comentario.idPublicacion,
    );

    // Verificar al usuario autenticado.
    final idUsuarioAutenticado =
        await _obtenerIdUsuarioAutenticado();

    if (idUsuarioAutenticado != comentario.idUsuario) {
      throw Exception(
        'El comentario debe pertenecer al usuario autenticado.',
      );
    }

    for (
      int intento = 1;
      intento <= _maxIntentosCrearComentario;
      intento++
    ) {
      final idComentario =
          await _obtenerSiguienteId();

      try {
        final resultado = await roble.create(
          'comentario',
          comentario.toMap(
            idComentario: idComentario,
          ),
        );

        return Map<String, dynamic>.from(
          resultado,
        );
      } catch (e) {
        final idFueOcupado =
            await _idExiste(
          idComentario,
        );

        if (
          !idFueOcupado ||
          intento ==
              _maxIntentosCrearComentario
        ) {
          rethrow;
        }
      }
    }

    throw Exception(
      'No fue posible crear el comentario.',
    );
  }

  Future<List<Map<String, dynamic>>>
      getComentariosByPublicacion(
    int idPublicacion,
  ) async {
    await _verificarPublicacion(
      idPublicacion,
    );

    final comentarios = await roble.read(
      'comentario',
      filters: {
        'id_publicacion': idPublicacion,
      },
    );

    return comentarios
        .map(
          (item) => Map<String, dynamic>.from(
            item,
          ),
        )
        .toList();
  }

  Future<Map<String, dynamic>?>
      getComentarioById(
    int idComentario,
  ) async {
    final comentarios = await roble.read(
      'comentario',
      filters: {
        'id_comentario': idComentario,
      },
    );

    if (comentarios.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(
      comentarios.first,
    );
  }
}
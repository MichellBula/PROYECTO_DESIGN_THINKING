import 'package:roble/roble.dart';

import '../../../../core/database/roble_client.dart';
import '../../models/publicacion_model.dart';

class PublicacionRemoteDatasource {
  final RobleApiDataBase roble;

  PublicacionRemoteDatasource({
    RobleApiDataBase? roble,
  }) : roble = roble ?? RobleClient.instance;

  static const int _maxIntentosCrearPublicacion = 5;

  Future<int> _obtenerSiguienteId() async {
    final publicaciones = await roble.read(
      'publicacion',
    );

    int mayorId = 0;

    for (final publicacion in publicaciones) {
      final id = int.tryParse(
        publicacion['id_publicacion'].toString(),
      );

      if (id != null && id > mayorId) {
        mayorId = id;
      }
    }

    return mayorId + 1;
  }

  Future<bool> _idExiste(
    int idPublicacion,
  ) async {
    final publicaciones = await roble.read(
      'publicacion',
      filters: {
        'id_publicacion': idPublicacion,
      },
    );

    return publicaciones.isNotEmpty;
  }

  Future<int> _obtenerIdUsuarioAutenticado() async {
    final user = await roble.currentUser();

    final userId =
        user['userId']?.toString();

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

  Future<int> _obtenerIdCreadorDelProyecto(
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

  Future<Map<String, dynamic>> createPublicacion(
    PublicacionModel publicacion,
  ) async {
    if (publicacion.titulo.trim().isEmpty) {
      throw Exception(
        'El título de la publicación no puede estar vacío.',
      );
    }

    if (publicacion.contenido.trim().isEmpty) {
      throw Exception(
        'El contenido de la publicación no puede estar vacío.',
      );
    }

    // -------------------------------------------------------
    // Verificar que exista el proyecto
    // -------------------------------------------------------

    await _obtenerIdCreadorDelProyecto(
      publicacion.idProyecto,
    );

    // -------------------------------------------------------
    // Verificar que el usuario autenticado sea el creador
    // -------------------------------------------------------

    final idUsuarioAutenticado =
        await _obtenerIdUsuarioAutenticado();

    final idCreador =
        await _obtenerIdCreadorDelProyecto(
      publicacion.idProyecto,
    );

    if (idUsuarioAutenticado != idCreador) {
      throw Exception(
        'Solo el creador del proyecto puede crear publicaciones.',
      );
    }

    // -------------------------------------------------------
    // Generar ID de publicación y crear
    // -------------------------------------------------------

    for (
      int intento = 1;
      intento <= _maxIntentosCrearPublicacion;
      intento++
    ) {
      final idPublicacion =
          await _obtenerSiguienteId();

      try {
        final resultado = await roble.create(
          'publicacion',
          publicacion.toMap(
            idPublicacion: idPublicacion,
          ),
        );

        return Map<String, dynamic>.from(
          resultado,
        );
      } catch (e) {
        final idFueOcupado =
            await _idExiste(idPublicacion);

        if (
          !idFueOcupado ||
          intento == _maxIntentosCrearPublicacion
        ) {
          rethrow;
        }
      }
    }

    throw Exception(
      'No fue posible crear la publicación.',
    );
  }

  Future<List<Map<String, dynamic>>>
      getPublicacionesByProject(
    int idProyecto,
  ) async {
    final publicaciones = await roble.read(
      'publicacion',
      filters: {
        'id_proyecto': idProyecto,
      },
    );

    return publicaciones
        .map(
          (item) => Map<String, dynamic>.from(item),
        )
        .toList();
  }

  Future<Map<String, dynamic>?>
      getPublicacionById(
    int idPublicacion,
  ) async {
    final publicaciones = await roble.read(
      'publicacion',
      filters: {
        'id_publicacion': idPublicacion,
      },
    );

    if (publicaciones.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(
      publicaciones.first,
    );
  }
}
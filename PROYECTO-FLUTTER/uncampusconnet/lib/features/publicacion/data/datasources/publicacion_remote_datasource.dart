import 'package:roble/roble.dart';

import '../../../../core/database/roble_client.dart';
import '../../models/publicacion_model.dart';

class PublicacionRemoteDatasource {
  final RobleApiDataBase roble;

  PublicacionRemoteDatasource({
    RobleApiDataBase? roble,
  }) : roble = roble ?? RobleClient.instance;

  static const int _maxIntentosCrearPublicacion = 5;

  // =========================================================
  // OBTENER SIGUIENTE ID
  // =========================================================

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

  // =========================================================
  // COMPROBAR SI EXISTE ID
  // =========================================================

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

  // =========================================================
  // OBTENER USUARIO AUTENTICADO
  // =========================================================

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

  // =========================================================
  // OBTENER CREADOR DEL PROYECTO
  // =========================================================

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

  // =========================================================
  // CREAR PUBLICACIÓN
  // =========================================================

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

    // Verificar que exista el proyecto.
    await _obtenerIdCreadorDelProyecto(
      publicacion.idProyecto,
    );

    // Verificar usuario autenticado.
    final idUsuarioAutenticado =
        await _obtenerIdUsuarioAutenticado();

    // Obtener creador.
    final idCreador =
        await _obtenerIdCreadorDelProyecto(
      publicacion.idProyecto,
    );

    // Solo el creador puede publicar.
    if (idUsuarioAutenticado != idCreador) {
      throw Exception(
        'Solo el creador del proyecto puede crear publicaciones.',
      );
    }

    // Crear publicación.
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

  // =========================================================
  // OBTENER PUBLICACIONES DE UN PROYECTO
  // =========================================================

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

  // =========================================================
  // OBTENER PUBLICACIÓN POR ID
  // =========================================================

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

  // =========================================================
  // OBTENER TODAS LAS PUBLICACIONES
  // =========================================================
  //
  // ESTA ES LA NUEVA FUNCIÓN PARA EL HOME.
  //
  // No filtra por usuario.
  // No filtra por proyecto.
  //
  // Devuelve todas las publicaciones existentes.
  // =========================================================

  Future<List<Map<String, dynamic>>>
      getTodasLasPublicaciones() async {
    final publicaciones = await roble.read(
      'publicacion',
    );

    final resultado = publicaciones
        .map(
          (item) => Map<String, dynamic>.from(item),
        )
        .toList();

    // Ordenar de más reciente a más antigua.
    resultado.sort((a, b) {
      final fechaA = DateTime.tryParse(
        a['fecha_publicacion']?.toString() ?? '',
      );

      final fechaB = DateTime.tryParse(
        b['fecha_publicacion']?.toString() ?? '',
      );

      if (fechaA == null && fechaB == null) {
        return 0;
      }

      if (fechaA == null) {
        return 1;
      }

      if (fechaB == null) {
        return -1;
      }

      return fechaB.compareTo(fechaA);
    });

    return resultado;
  }
}
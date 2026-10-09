import 'package:get/get.dart';
import 'package:roble/roble.dart';

import '../../../core/database/roble_client.dart';
import '../../publicacion_likes/data/datasources/publicacion_likes_remote_datasource.dart';
import '../../publicacion_likes/data/repositories/publicacion_likes_repository_impl.dart';
import '../../publicacion_likes/domain/entities/publicacion_like.dart';
import '../../publicacion_likes/domain/repositories/publicacion_likes_repository.dart';
import '../data/post_data.dart';

class PostInteractionController {
  final PostData post;
  final RobleApiDataBase roble;

  late final PublicacionLikesRepository _likesRepository;

  final RxInt likesCount = 0.obs;
  final RxInt commentsCount = 0.obs;

  final RxBool likedByCurrentUser = false.obs;
  final RxBool loading = true.obs;
  final RxBool changingLike = false.obs;

  int? _idUsuario;
  Future<void>? _initialization;

  PostInteractionController({
    required this.post,
    RobleApiDataBase? roble,
  }) : roble = roble ?? RobleClient.instance {
    likesCount.value = post.likes;
    commentsCount.value = post.comentarios;

    final datasource = PublicacionLikesRemoteDatasource(
      roble: this.roble,
    );

    _likesRepository = PublicacionLikesRepositoryImpl(
      datasource: datasource,
    );
  }

  // ==========================================================
  // INICIALIZAR CONTADORES Y ESTADO DEL LIKE
  // ==========================================================

  Future<void> initialize() async {
    if (_initialization != null) {
      await _initialization;
      return;
    }

    final future = _cargarEstadoInicial();
    _initialization = future;

    try {
      await future;
    } catch (_) {
      _initialization = null;
      rethrow;
    }
  }

  Future<void> _cargarEstadoInicial() async {
    loading.value = true;

    try {
      _idUsuario = await _obtenerIdUsuarioAutenticado();

      await _actualizarLikesDesdeRoble();
    } finally {
      loading.value = false;
    }
  }

  // ==========================================================
  // OBTENER ID DEL USUARIO AUTENTICADO
  // ==========================================================

  Future<int> _obtenerIdUsuarioAutenticado() async {
    final authUser = await roble.currentUser();

    final idAutenticador =
        authUser['userId']?.toString();

    if (idAutenticador == null || idAutenticador.isEmpty) {
      throw Exception(
        'No se pudo identificar al usuario autenticado.',
      );
    }

    final usuarios = await roble.read(
      'usuario',
      filters: {
        'id_autenticador': idAutenticador,
      },
    );

    if (usuarios.isEmpty) {
      throw Exception(
        'La cuenta autenticada no tiene un perfil de usuario.',
      );
    }

    final idUsuario = int.tryParse(
      usuarios.first['id_usuario'].toString(),
    );

    if (idUsuario == null) {
      throw Exception(
        'El perfil del usuario tiene un id_usuario inválido.',
      );
    }

    return idUsuario;
  }

  // ==========================================================
  // RECARGAR LIKES REALES
  // ==========================================================

  Future<void> _actualizarLikesDesdeRoble() async {
    final idUsuario = _idUsuario;

    if (idUsuario == null) {
      throw Exception(
        'No se ha identificado el usuario actual.',
      );
    }

    final likes = await _likesRepository.getLikesByPublicacion(
      post.idPublicacion,
    );

    likesCount.value = likes.length;

    likedByCurrentUser.value = likes.any(
      (like) =>
          int.tryParse(like['id_usuario'].toString()) ==
          idUsuario,
    );
  }

  // ==========================================================
  // DAR O QUITAR LIKE
  // ==========================================================

  Future<void> toggleLike() async {
    await initialize();

    if (changingLike.value) {
      return;
    }

    final idUsuario = _idUsuario;

    if (idUsuario == null) {
      throw Exception(
        'No se pudo identificar al usuario actual.',
      );
    }

    changingLike.value = true;

    try {
      if (likedByCurrentUser.value) {
        // Eliminar el registro real del like.
        await _likesRepository.deletePublicacionLikeByUserAndPublicacion(
          idUsuario: idUsuario,
          idPublicacion: post.idPublicacion,
        );
      } else {
        // Crear el registro real del like.
        await _likesRepository.createPublicacionLike(
          PublicacionLike(
            idUsuario: idUsuario,
            idPublicacion: post.idPublicacion,
          ),
        );
      }

      // Volver a consultar Roble.
      // El número y el corazón reflejarán el resultado guardado.
      await _actualizarLikesDesdeRoble();
    } finally {
      changingLike.value = false;
    }
  }

  // ==========================================================
  // ACTUALIZAR CONTADOR DE COMENTARIOS
  // ==========================================================

  void actualizarCantidadComentarios(int cantidad) {
    commentsCount.value = cantidad;
  }
}